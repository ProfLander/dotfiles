import { createState } from "ags"

import { Model } from './Model.tsx'

// Model implementing prefix-based selection between other models
export default function SelectModel({children, ...params}): Model {
    const [items, setItems] = createState(new Array<Item>())

    let model: Model
    let updateModel = (text) => {
        for (let i in children) {
            let child = children[i]
            let k = child.id
            let prefix = ":" + k + " "
            if (text.startsWith(prefix)) {
                model = child
                return
            }
        }
        model = undefined
    }

    return {
        items: () => items,
        search: (text) => {
            updateModel(text)

            if (!model) {
                setItems([])
                return
            }

            let search = text.slice(model.id.length + 2)
            model.search(search)
            setItems(model.items().get())
        },
        activate: (text) => {
            if (model) {
                model.activate(text.slice(model.id.length + 2))
            }
        }
    }
}
