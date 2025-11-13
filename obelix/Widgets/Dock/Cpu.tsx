import { jsx } from "gnim"
import { createState } from "ags"
import { readFile } from "ags/file"
import { createPoll } from "ags/time"
import { exec, execAsync } from "ags/process"

import Meter from "../Meter"

export default function Cpu({
    icon = "",
    iconX = 0.4,
    iconY = 0.55,
    cssClasses = "Cpu",
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
