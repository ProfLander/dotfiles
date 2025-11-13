import { createState } from "ags"
import { exec, execAsync } from "ags/process"

export default function RocmSmi({ interval = 80 }) {
    let [stats, setStats] = createState(undefined)

    let update = () => {
        execAsync([
            "rocm-smi",
            "--showuse",
            "--showmemuse",
            "--showtemp",
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
            use: card((card) => card ? Number(card["GPU use (%)"]) : card),
            temps: {
                edge: card((card) => (
                    card ? Number(card["Temperature (Sensor edge) (C)"]) : card
                )),
                junction: card((card) => (
                    card ? Number(card["Temperature (Sensor junction) (C)"]) : card
                )),
                memory: card((card) => (
                    card ? Number(card["Temperature (Sensor memory) (C)"]) : card
                )),
            } ,
            memory: {
                allocated: card((card) => (
                    card ? Number(card["GPU Memory Allocated (VRAM%)"]) : card
                )),
                readWrite: card((card) => (
                    card ? Number(card["GPU Memory Read/Write Activity (%)"]) : card
                )),
                activity: card((card) => (
                    card ? Number(card["Memory Activity"]) : card
                )),
                avgBandwidth: card((card) => (
                    card ? Number(card["Avg. Memory Bandwidth"]) : card
                )),
            },
        }
    }

    let cards = JSON.parse(exec(["rocm-smi", "--showproductname", "--json"]))
    return Object.keys(
        JSON.parse(
            exec(["rocm-smi", "--showproductname", "--json"])
        )
    ).map(
        (k) => makeCard(stats((stats) => stats ? stats[k] : stats))
    )
}
