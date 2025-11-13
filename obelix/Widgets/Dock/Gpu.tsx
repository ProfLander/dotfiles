import { jsx } from "gnim"
import Meter from "../Meter"

export default function Gpu({
    smi,
    icon = "",
    iconX = 0.4,
    iconY = 0.55,
    cssClasses = "Gpu",
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
