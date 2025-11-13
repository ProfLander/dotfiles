import { Gtk , Gdk, GLib } from "app"
import Cairo from "gi://cairo"

import { jsx } from "gnim"
import { createState } from "ags"

export default function CircularProgress({
    fraction = createState(0)[0],
    interval = 1000 / 30
}) {
    let value = 0
    fraction.subscribe(() => value = fraction.get())
    let draw = (area, cr, width, height) => {
        let center_x = width / 2
        let center_y = height / 2
        let stroke = 2.5
        let radius = (width - stroke * 0.5) * 0.5 
        let offset = -Math.PI * 0.5

        let rgba = area.get_color()

        cr.setSourceRGBA(rgba.red, rgba.green, rgba.blue, rgba.alpha)
        cr.setLineCap(Cairo.LineCap.ROUND)
        cr.setLineWidth(stroke)
        cr.moveTo(center_x, center_y)
        cr.newPath()
        cr.arc(
            center_x,
            center_y,
            radius - (stroke * 0.5),
            offset,
            offset + Math.PI * 2 * value
        )
        cr.stroke()
    }

    let area = jsx(Gtk.DrawingArea, {
        hexpand: true,
        vexpand: true,
    })
    area.set_draw_func(draw)
    let upd = () => {
        area.queue_draw()
        setTimeout(upd, 1000 / 30)
    }
    upd()

    return area
}
