// Data item abstraction
export type Item = {
    icon: () => String
    name: () => String
    value: () => String
}

// Data model abstraction
export type Model = {
    items: () => Accessor<[Item]>,
    search: (Item) => void,
    activate: (String) => void,
}

