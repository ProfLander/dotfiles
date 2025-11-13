import {app, Astal, Gtk, Gdk} from "app"

function Corner({monitor, anchor, cls}) {
    return (
        <window
        visible
        name="corner"
        class={"Corner " + cls}
        namespace="corner"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.IGNORE}
        layer={Astal.Layer.TOP}
        anchor={anchor}
        application={app}
        />
    )
}

export default function Corners({monitor}) : [
    Astal.Window,
    Astal.Window,
    Astal.Window,
    Astal.Window
]
{
    const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

    return [
        {cls: "tl", anchor: TOP | LEFT},
        {cls: "tr", anchor: TOP | RIGHT},
        {cls: "bl", anchor: BOTTOM | LEFT},
        {cls: "br", anchor: BOTTOM | RIGHT},
    ].map(
        ({anchor, cls}) => {
            return (
                <Corner monitor={monitor}
                anchor={anchor}
                cls={cls}
                />
            )
        }
    )
}
