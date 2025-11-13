import { GLib, Gtk } from "app"

import { createState } from "ags"
import { createPoll } from "ags/time"

import Bubble from "Widgets/Bubble"
import CircularProgress from "Widgets/CircularProgress"

const POLL_RATE = 144

function RollingWindow(size = 8) {
    return {
        size: size,
        samples: [],
        push: function(sample) {
            this.samples.push(sample)
            while (this.samples.length > this.size) {
                this.samples.shift()
            }
        },
        reduce: function(f, init) {
            return this.samples.reduce(f, init)
        }
    }
}

export default function Meter({
    icon,
    iconX,
    iconY,
    cssClasses,
    fraction,
    label
}) {
    let progress: Gtk.Widget

    let iconLabel = (
        <label class="icon"
        xalign={iconX}
        yalign={iconY}
        label={icon}/>
    )

    let [text, setText] = createState("")

    let prev = 0
    let prev_ts = GLib.DateTime.new_now_local()

    let next = prev
    let next_ts = prev_ts

    fraction.subscribe(() => {
        prev = next
        prev_ts = next_ts

        next = fraction.get()
        next_ts = GLib.DateTime.new_now_local()
    })

    const fract = createPoll("", 1000 / POLL_RATE, () => {
        let t = GLib.DateTime.new_now_local()
        let dt = t.difference(next_ts)
        let tt = next_ts.difference(prev_ts)
        let nt = Math.min(dt / tt, 1)
        return prev + (next - prev) * nt
    })

    return (
        <Bubble class={"Meter " + cssClasses} label={label}>
            <overlay
            $={(ref) => ref.add_overlay(iconLabel)}>
                <box hexpand={false} class="progress">
                    <CircularProgress
                    fraction={fract}/>
                </box>
            </overlay>
        </Bubble>
    )
}
