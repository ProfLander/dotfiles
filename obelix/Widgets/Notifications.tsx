import AstalNotifd from "gi://AstalNotifd"

export default function Notifications() {
    const notifd = AstalNotifd.get_default()

    notifd.connect("notified", (_, id) => {
        const n = notifd.get_notification(id)
        console.log("notified:", id, n.summary, n.body)
        n.dismiss()
    })

    notifd.connect("resolved", (_, id) => {
        console.log("resolved:", id)
    })

    return {
        notifd
    }
}
