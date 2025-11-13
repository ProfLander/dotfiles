import { createState } from "ags"

import { exec, execAsync } from "ags/process"

import { Model, Item } from './Model.tsx'

// Data model abstracting over a FZF search
export default function FzfModel({
    id,
    command,
    launch,
    modifyLine = (line) => line,
    modifyItem = (item) => item,
    count = 8
}): Model {
    const [items, setItems] = createState(new Array<Item>())

    return {
        id,
        items: () => items,
        search: (text) => {
            let cmd = "sh -c "
                    + '"'
                    + command
                    + " | fzf --no-sort --exact -f "
                    + "'" + text + "'"
                    + '"'

            let res: String;
            try {
                res = exec(cmd)
            }
            catch(e) {
                setItems([])
                return
            }

            setItems(
                res
                .split("\n")
                .slice(0, count)
                .map(s => s.trim())
                .map(modifyLine)
                .toReversed()
                .map((line) => ({
                    icon: "",
                    name: line,
                    launch: () => launch(line)
                }))
                .map(modifyItem)
            )
        },
        activate: (text) => launch(text),
    }
}
