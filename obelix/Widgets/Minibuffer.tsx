import { app, GLib, Gtk, Gdk, Astal } from "app"

import { jsx } from "gnim";
import { For, createState } from "ags"
import { Model } from "Data/Model.tsx"
import { Side, Edge } from "Widgets/Edge.tsx"

function item_button(item) {
    return (
        <button onClicked={() => {
            item.launch()
            hide()
        }}>
            <box>
                <image iconName={item.icon} />
            <label css="padding-left: 5px;" label={item.name} wrap />
            </box>
        </button>
    )
}

export function Minibuffer({monitor, model}) {
    let [gdkmonitor, setMonitor] = createState(monitor);
    let [prompt, setPrompt] = createState("");

    let window: Astal.Window
    let entry: Gtk.Entry

    let hide = () => {
        window.visible = false
    }

    model.search("")

    entry = jsx(Gtk.Entry, {
        hexpand: true,
        onActivate: (widget) => {
            model.activate(widget.text)
            hide()
        },
        onNotifyText: ({ text }) => model.search(text),
    })

    let box_horz = jsx(Gtk.Box, {
        orientation: Gtk.Orientation.HORIZONTAL,
        children: [
            entry,
        ]
    })

    let item_list = jsx(Gtk.Box, {
        vexpand: true,
        orientation: Gtk.Orientation.VERTICAL,
        children: [
            jsx(Gtk.Box, { vexpand: true }),
            (<For each={model.items()}>
                {item_button}
             </For>),
        ]
    })

    let box_vert = jsx(Gtk.Box, {
        orientation: Gtk.Orientation.VERTICAL,
        children: [
            item_list,
            box_horz
        ]
    })

    let controller_key = jsx(Gtk.EventControllerKey, {
        onKeyPressed: (
            { widget },
            keyval: number,
            keycode: number,
            state: Gdk.ModifierType
        ) => {
            if (state & Gdk.ModifierType.CONTROL_MASK) {
                if (keyval === Gdk.KEY_g) {
                    hide()
                }
            }
            else {
                if (keyval === Gdk.KEY_Escape) {
                    hide()
                }
            }
        }
    })

    let controller_focus = jsx(Gtk.EventControllerFocus, {
        onLeave: hide
    })

    window = jsx(Edge, {
        name:"minibuffer",
        cssClasses: ["Minibuffer", "docked"],
        side: Side.Bottom,
        gdkmonitor,
        exclusivity: Astal.Exclusivity.EXCLUSIVE,
        layer: Astal.Layer.BOTTOM,
        application: app,
        keymode: Astal.Keymode.ON_DEMAND,
        onNotifyVisible: (visible: bool) => {
            // Update entry text
            let text = prompt.get()
            if (text !== "") text += " "
            entry.text = text

            // Move caret to end
            entry.set_position(-1)

            // Grab focus
            if (visible) {
                entry.grab_focus_without_selecting()
            }
        },
        focusVisible: "false",
        children: [
            box_vert,
            controller_key,
            controller_focus,
        ]
    })

    window.setPrompt = setPrompt
    window.setMonitor = setMonitor

    return window
}
