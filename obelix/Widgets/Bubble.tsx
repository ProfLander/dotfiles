import { Gtk } from "app"

import { createState } from "ags"

export default function Bubble(params) {
    let [showLabel, setShowLabel] = createState(false);

    let widget = (
        <box vexpand={false}>
            <box hexpand/>
            <box class={"Bubble " + params.class}>
                {params.children}
                <Gtk.Revealer
                reveal-child={showLabel}
                transition-type={Gtk.RevealerTransitionType.SLIDE_LEFT}
                transition-duration={300}
                >
            <label width-request={78} class="label" label={params.label}/>
                </Gtk.Revealer>
            </box>
        </box>
    )

    widget.open = false
    widget.updateOpen = () => {
        if (widget.open) {
            setShowLabel(true)
        }
        else {
            setShowLabel(false)
        }
    }

    widget.setOpen = (open) => {
        widget.open = open
        widget.updateOpen()
    }

    widget.toggle = () => widget.setOpen(!widget.open)

    return widget
}
