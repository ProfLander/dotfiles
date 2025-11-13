import { createPoll } from "ags/time"
import { readFile } from "ags/file"

const FIELDS = [
    "user",
    "nice",
    "system",
    "idle",
    "iowait",
    "irq",
    "softirq",
    "steal",
    "guest",
    "guest_nice",
]

function sampleTotal(sample) {
    let total = 0
    for (let k in sample) {
        total += sample[k]
    }
    return total
}

function sampleIdles(sample) {
    return sample.idle + sample.iowait
}

function deltaSample(prev, next) {
    let out = {}
    for (const k in prev) {
        let v0 = prev[k]
        let v1 = next[k]
        out[k] = v1 - v0
    }
    return out
}

function procStat() {
    let res = readFile("/proc/stat")
    return res.split("\n").reduce(
        (acc, next) => {
            let segs = next.trim().split(/\s+/)
            let name = segs[0]
            if (name.startsWith("cpu")) {
                let out = {}
                for (const [i, k] of FIELDS.entries()) {
                    out[k] = parseInt(segs[i + 1])
                }
                out.total = sampleTotal(out)
                out.idles = sampleIdles(out)
                out.usage = out.total - out.idles
                acc[name] = out
            }
            return acc
        },
        {}
    )
}

export default function ProcStat({
    interval = 80,
    ...params
}) {
    let usage = createPoll(undefined, interval, procStat)
    let stats = usage((c) => c ? c.cpu : undefined)

    let prev = undefined
    stats = stats((next) => {
        let out = 0
        if (prev && next) {
            let delta = deltaSample(prev, next)
            out = delta.usage / delta.total
        }
        prev = next
        return out
    })

    return {
        stats
    }
}
