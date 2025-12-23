import Quickshell
import QtQuick

Variants {
  model: Quickshell.screens
  Item {
    property var modelData

    Viewport {
      screen: modelData

      Corners {}
    }
  }
}
