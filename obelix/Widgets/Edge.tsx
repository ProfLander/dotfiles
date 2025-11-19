import { Astal } from "app"

import { jsx } from "gnim";

export enum Side {
    Top,
    Bottom,
    Left,
    Right,
}

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

export function Edge(args) {
    let classes: [String] = args.cssClasses ? args.cssClasses.concat(["Edge"]) : ["Edge"]
    let namespace: String

    args.resizable = args.resizable ? args.resizable : false
    switch(args.side) {
        case Side.Top: {
            args.anchor = TOP | LEFT | RIGHT
            namespace = "edge-top"
            classes.push("top")
            if (args.gdkmonitor && args.resizable === false) {
                args["width-request"] = args.gdkmonitor.get_geometry().width
            }
            break;
        }
        case Side.Bottom: {
            args.anchor = BOTTOM | LEFT | RIGHT
            namespace = "edge-bottom"
            classes.push("bottom")
            if (args.gdkmonitor && args.resizable === false) {
                args["width-request"] = args.gdkmonitor.get_geometry().width
            }
            break;
        }
        case Side.Left: {
            args.anchor = TOP | BOTTOM | LEFT
            namespace = "edge-left"
            classes.push("left")
            if (args.gdkmonitor && args.resizable === false) {
                args["height-request"] = args.gdkmonitor.get_geometry().height
            }
            break;
        }
        case Side.Right: {
            args.anchor = TOP | BOTTOM | RIGHT
            namespace = "edge-right"
            classes.push("right")
            if (args.gdkmonitor && args.resizable === false) {
                args["height-request"] = args.gdkmonitor.get_geometry().height
            }
            break;
        }
        default: {
            console.error("Invalid side")
            return
        }
    }
    args.namespace = args.namespace ? args.namespace : namespace
    args.side = undefined

    if (args.cssClasses) {
        args.cssClasses = args.cssClasses.concat(classes)
    }
    else {
        args.cssClasses = classes
    }

    return jsx(Astal.Window, args)
}
