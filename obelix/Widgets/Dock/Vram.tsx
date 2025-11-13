import { jsx } from "gnim"
import Meter from "../Meter"

export default function Vram({
    icon = "",
    iconX = 0.35,
    iconY = 0.55,
    cssClasses = "Vram",
    ...params
}) {
    return jsx(Meter, {
        icon,
        iconX,
        iconY,
        cssClasses,
        ...params
    })
}
