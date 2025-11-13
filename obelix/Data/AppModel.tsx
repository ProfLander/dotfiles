import AstalApps from "gi://AstalApps"

import { createState } from "ags"

import { Model } from './Model.tsx'



// Data model abstracting over desktop files
export default function AppModel({id}): Model {
    const apps = new AstalApps.Apps()
    const [items, setItems] = createState(new Array<AstalApps.Application>())
    return {
        id,
        items: () => items,
        search: (text) => {
            setItems(
                apps.fuzzy_query(text)
                    .slice(0, 8)
                    .toReversed()
                    .map((app) => ({
                        icon: app.iconName,
                        name: app.name,
                        launch: () => app.launch()
                    }))
            )
        },
        activate: () => {
            console.log(items)
            let arr = items.get()
            let item = arr[arr.length - 1]
            console.log(item)
            if (item) {
                item.launch()
            }
        }
    }
}
