import AstalTray from "gi://AstalTray"

export default function Tray() {
    let tray = AstalTray.get_default()

    tray.connect("item-added", (_, id) => {
        console.log("tray item added:", id)

        let item = tray.get_item(id)
        console.log("title:", item.title)
        console.log("category:", item.category)
        console.log("status:", item.status)
        console.log("tooltip:", item.tooltip)
        console.log("icon-name:", item["icon-name"])
        console.log("icon-pixbuf:", item["icon-pixbuf"])
        console.log("gicon:", item.gicon)
    })

    tray.connect("item-removed", (_, id) => {
        console.log("tray item removed:", id)
    })

    return {
        tray
    }
}
