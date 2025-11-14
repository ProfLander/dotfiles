import { Gtk, Gdk, Astal } from "app"

import { jsx } from "gnim";
import { For } from "ags";

import { Edge, Side } from "Widgets/Edge";

import Free from "Data/Free";
import RocmSmi from "Data/RocmSmi";
import AmdSmi from "Data/AmdSmi";
import ProcStat from "Data/ProcStat";

import Clock from "Widgets/Dock/Clock";
import Cpu from "Widgets/Dock/Cpu";
import Ram from "Widgets/Dock/Ram";
import Gpu from "Widgets/Dock/Gpu";
import Vram from "Widgets/Dock/Vram";

const POLL_RATE = 300

export function Dock({monitor, visible}) {
    let amd_smi = jsx(AmdSmi, {
        interval: POLL_RATE
    })

    let free = Free({ interval: POLL_RATE })

    let ps = jsx(ProcStat, { interval: POLL_RATE })

    let clock: Gdk.Widget
    let cpu: Gdk.Widget
    let ram: Gdk.Widget
    let gpu: Gdk.Widget
    let vram: Gdk.Widget

    let gpus = amd_smi.cards.reduce((acc, card) => {
        acc.push(
            <Gpu
            fraction={card.gfx((t) => t !== undefined ? (t / 100) : 0)}
            label={card.gfx((t) => t !== undefined ? (t.toString() + "%") : "")}
            $={(ref) => (gpu = ref)}/>,

            <Vram
            fraction={card.vram_used((t) => t !== undefined ? (t / card.vram_total.get()) : 0)}
            label={card.vram_used((t) => t !== undefined ? (t / card.vram_total.get()).toFixed(2).toString() + "%" : "")}
            $={(ref) => (vram = ref)}/>
        )
        return acc
    }, [])

    let widget = (
        <Edge cssClasses={["Dock", "docked"]} side={Side.Right}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        visible={visible}
        gdkmonitor={monitor}>
            <box orientation={Gtk.Orientation.VERTICAL}
            spacing={10}>
                <Clock $={(ref) => (clock = ref)}/>

                <Cpu
                fraction={ps.stats}
                label={ps.stats((c) => (c * 100).toFixed(2).toString() + "%")}
                $={(ref) => (cpu = ref)}/>

                <Ram
                fraction={free.mem.used((used) => used / free.mem.total.get())}
                label={free.mem.used((used) => (used / free.mem.total.get()).toFixed(2).toString() + "%")}
                $={(ref) => (ram = ref)}/>

                {gpus}

		<box vexpand/>
            </box>
        </Edge>
    )

    widget.open = false
    widget.setOpen = (newOpen) => {
        widget.open = newOpen
        clock.setOpen(widget.open)
        cpu.setOpen(widget.open)
        ram.setOpen(widget.open)
        gpu.setOpen(widget.open)
        vram.setOpen(widget.open)
    }

    widget.toggle = () => widget.setOpen(!widget.open)

    return widget
}
