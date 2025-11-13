import {GLib, Adw , Gtk} from "app"

import { createPoll } from "ags/time"

import Bubble from "Widgets/Bubble"

const POLL_RATE = 30

const USEC_DAY = 86400000000
const USEC_HALF_DAY = USEC_DAY / 2
const USEC_HOUR = 3600000000
const USEC_MINUTE = 60000000
const USEC_SECOND = 1000000

function Hand({factor, hand}) {
    const time = createPoll("", 1000 / POLL_RATE, () => {
        let now = GLib.DateTime.new_now_local()
        let usec = now.get_microsecond()
        let sec = now.get_second() * USEC_SECOND
        let min = now.get_minute() * USEC_MINUTE
        let hour = now.get_hour() * USEC_HOUR
        let total = usec + sec + min + hour
        let norm = total / factor
        let deg = norm * 360
        let css = "transform: rotateZ(" + deg + "deg);"
        return css
    })

    return (
        <box halign={Gtk.Align.CENTER} css={time}>
            <box orientation={Gtk.Orientation.VERTICAL}>
                <box class={"hand " + hand}/>
                <box/>
            </box>
        </box>
    )
}

export default function Clock({ format = "%_I:%M %p" }) {
    const time = createPoll("", 1000, () => {
        return GLib.DateTime.new_now_local().format(format)!
    })

    let hands = [Hand({hand: "hour", factor: USEC_HALF_DAY}),
                 Hand({hand: "minute", factor: USEC_HOUR}),
                 Hand({hand: "second", factor: USEC_MINUTE})]

    return (
        <Bubble class="Clock" label={time}>
            <box class="rim">
                <overlay $={(widget) => hands.map(
                    overlay => widget.add_overlay(overlay)
                )}>
                    <box class="face"/>
                </overlay>
            </box>
        </Bubble>
    )
}
