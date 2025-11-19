import GLib from "gi://GLib"
import Gio from "gi://Gio"
import AstalNotifd from "gi://AstalNotifd"

import app from "ags/gtk4/app"
import { Gtk, Gdk, Astal } from "ags/gtk4"

import { readFile, monitorFile } from "ags/file"
import { execAsync } from "ags/process"
import { createBinding, For, This } from "ags"

import style from "style.scss"
import { Model } from "Data/Model.tsx"
import FzfModel from "Data/FzfModel.tsx"
import AppModel from "Data/AppModel.tsx"
import SelectModel from "Data/SelectModel.tsx"

import Corners from "Widgets/Corners"
import { Minibuffer, Props } from "Widgets/Minibuffer"
import { Dock, Props } from "Widgets/Dock"
import Notifications from "Widgets/Notifications"
import Tray from "Widgets/Tray"

export {
    app,
    GLib,
    Gtk,
    Gdk,
    Astal,
}

const monitors = createBinding(app, "monitors")

let model: SelectModel
let minibuffer: Gtk.Window
let dock: Gtk.Window

function getMonitor(name) {
    return app.get_monitors().find((monitor) => {
        return monitor.connector == name
    })
}

let defaultConfig = {
    ["primary-monitor"]: "DP-1" 
}

let config = {}

function loadConfig(config) {
    let [res, contents] = config.load_contents(null)
    let decoder = new TextDecoder('utf-8')
    let text = decoder.decode(contents)
    try {
        config = JSON.parse(text)
    } catch(e) {
        console.error("Failed to parse config file:", e)
    }
}

function getConfig(key) {
    if (config[key] !== undefined) {
        return config[key]
    }

    return defaultConfig[key]
}

app.start({
    css: style,
    requestHandler(request, res) {
        switch (request[0]) {
            case "minibuffer":
                let monitor = getMonitor(request[1])

                if (!monitor) {
                    return res("unrecognized monitor")
                }

                let text = request[2] || ""
                minibuffer.setPrompt(text)
                minibuffer.setMonitor(monitor)
                minibuffer.visible = true
                return res("ok")
            case "dock:toggle":
                dock.toggle()
                return res("ok")
            default:
                return res("unknown command")
        }
    },
    main() {
        // Derive config file path
        let config_path = GLib.build_filenamev([
            GLib.get_home_dir(),
            ".config",
            "obelix",
            "obelix.json"
        ])

        // Fetch config file handle
        let config_file = Gio.File.new_for_path(config_path)

        // If the config file exists, load it
        if (config_file.query_exists(null)) {
            loadConfig(config_file)
        }

        // Setup config file monitoring
        let mon = config_file.monitor(0, null)
        mon.connect('changed', (_, file, otherFile, eventType) => {
            switch (eventType) {
                case Gio.FileMonitorEvent.CHANGED:
                    loadConfig(config_file)
                    break;
            }
        })

        // Compose application
        return [
            <Dock
            visible
            gdkmonitor={getMonitor(getConfig("primary-monitor"))}
            $={(ref) => (dock = ref)}/>,

            <SelectModel $={(ref) => (model = ref)}>
                <AppModel id="desktop"/>
                <FzfModel
                id="web"
                command="tac /home/lander/.search_history"
                launch={(text) => {
                    let cmd = "firefox --new-window 'https://www.google.com/search?q=" + text + "'"
                    execAsync(cmd)
                }}
                modifyItem={(item) => {
                    item.icon = "firefox"
                    return item
                }}/>
                <FzfModel
                id="shell"
                command="tac /home/lander/.zsh_history"
                launch={(text) => {
                    let cmd = "alacritty -e zsh -ic '" +
                        text +
                        "; echo; exec zsh'"
                    execAsync(cmd)
                }}
                modifyLine={(line) => line.startsWith(":") ? line.split(";")[1] : line}
                modifyItem={(item) => {
                    item.icon = "Alacritty"
                    return item
                }}/>
            </SelectModel>,

            <Notifications/>,

            <Tray/>,

            <Minibuffer
            gdkmonitor={getMonitor(getConfig("primary-monitor"))}
            model={model}
            $={(ref) => (minibuffer = ref)}/>,

            <For each={monitors}>
                {(monitor) => (
                    <This this={app}>
                        <Corners monitor={monitor}/>
                    </This>
                )}
            </For>
        ]
    },
})
