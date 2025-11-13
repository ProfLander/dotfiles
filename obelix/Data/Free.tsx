import { createState } from "ags"
import { execAsync } from "ags/process"

export default function Free({ interval = 80 }) {
    let [stats, setStats] = createState(undefined)

    let update = () => {
        let cmd = `jc free`
        execAsync(cmd).then((json) => {
            let stats = JSON.parse(json)

            let mem = stats[0]
            mem.type = undefined

            let swap = stats[1]
            swap.type = undefined

            setStats({
                mem,
                swap
            })
            setTimeout(update, interval)
        })
    }

    update()

    return {
        mem: {
            total: stats((stats) => stats ? stats.mem.total : stats),
            used: stats((stats) => stats ? stats.mem.used : stats),
            free: stats((stats) => stats ? stats.mem.free : stats),
            shared: stats((stats) => stats ? stats.mem.shared : stats),
            buff_cache: stats((stats) => stats ? stats.mem.buff_cache : stats),
            available: stats((stats) => stats ? stats.mem.available : stats),
        },
        swap: {
            used: stats((stats) => stats ? stats.swap.used : stats),
            free: stats((stats) => stats ? stats.swap.free : stats),
            total: stats((stats) => stats ? stats.swap.total : stats),
        }
    }
}
