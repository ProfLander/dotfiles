import GLib from "gi://GLib"
import AstalNotifd from "gi://AstalNotifd"

import app from "ags/gtk4/app"
import { Gtk, Gdk, Astal } from "ags/gtk4"

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

app.start({
    css: style,
    requestHandler(request, res) {
        switch (request[0]) {
            case "minibuffer":
                let id = parseInt(request[1])
                if (Number.isNaN(id)) return res ("ID is not a number")
                let text = request[2] || ""
                minibuffer.setPrompt(text)
                minibuffer.setMonitor(app.get_monitors()[id])
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
        return [
            <Dock
            visible
            monitor={app.get_monitors()[0]}
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
            monitor={app.get_monitors()[0]}
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
