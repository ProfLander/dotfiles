import { createState } from "ags"
import { exec, execAsync } from "ags/process"

export default function AmdSmi({ interval = 80 }) {
    let [stats, setStats] = createState(undefined)

    let update = () => {
        execAsync([
            "amd-smi",
            "monitor",
            "--json",
        ]).then((res) => {
            let stats = JSON.parse(res)
            setStats(stats)
            setTimeout(update, interval)
        }).catch((err) => {
            console.error(err)
        })
    }

    update()

    function makeCard(card) {
        return {
            power_usage: card((card) => card ? card.power_usage.value : card),
            hotspot_temperature: card((card) => card ? card.hotspot_temperature.value : card),
            memory_temperature: card((card) => card ? card.memory_temperature.value : card),
            gfx_clk: card((card) => card ? card.gfx_clk.value : card),
            gfx: card((card) => card ? card.gfx.value : card),
            mem: card((card) => card ? card.mem.value : card),
            encoder: card((card) => card ? card.encoder.value : card),
            vram_used: card((card) => card ? card.vram_used.value : card),
            vram_total: card((card) => card ? card.vram_total.value : card),
        }
    }

    let json = JSON.parse(
        exec(["amd-smi", "monitor", "--json"])
    )

    let out = []
    for (const [i, card] of json.entries()) {
        out[i] = makeCard(stats((stats) => stats ? stats[i] : stats))
    }

    return {
        cards: out
    }
}
