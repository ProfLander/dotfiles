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
    let classes: [String] = ["Edge"]
    let namespace: String
    switch(args.side) {
        case Side.Top: {
            args.anchor = TOP | LEFT | RIGHT
            namespace = "edge-top"
            classes.push("top")
            break;
        }
        case Side.Bottom: {
            args.anchor = BOTTOM | LEFT | RIGHT
            namespace = "edge-bottom"
            classes.push("bottom")
            break;
        }
        case Side.Left: {
            args.anchor = TOP | BOTTOM | LEFT
            namespace = "edge-left"
            classes.push("left")
            break;
        }
        case Side.Right: {
            args.anchor = TOP | BOTTOM | RIGHT
            namespace = "edge-right"
            classes.push("right")
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
