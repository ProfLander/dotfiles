import Quickshell
import QtQuick

Variants {
  model: Quickshell.screens
  Item {
    property var modelData

    PanelOuter {
      screen: modelData
      anchors.bottom: false

      TextStyled {
        anchors.centerIn: parent
        text: Time.time
      }
    }

    PanelOuter {
      screen: modelData
      anchors.top: false

      TextInput {
        id: input
        color: "white"
        text: "Default Text"
        anchors.centerIn: parent
        focus: true
      }
    }

    PanelOuter {
      screen: modelData
      anchors.right: false

      TextStyled {
        anchors.centerIn: parent
        text: "<L"
      }
    }

    PanelOuter {
      screen: modelData
      anchors.left: false

      TextStyled {
        anchors.centerIn: parent
        text: "R>"
      }
    }

    Viewport {
      screen: modelData

      Corners {}
    }

    PanelInner {
      id: innerTop
      screen: modelData
      anchors.bottom: false
      topMargin: -32
      leftMargin: innerLeft.width
      rightMargin: innerRight.width

      TextStyled {
        anchors.centerIn: parent
        text: Time.time
      }
    }

    PanelInner {
      id: innerBottom
      screen: modelData
      anchors.top: false
      bottomMargin: -32
      leftMargin: innerLeft.width
      rightMargin: innerRight.width

      TextStyled {
        anchors.centerIn: parent
        text: Time.time
      }
    }

    PanelInner {
      id: innerLeft
      screen: modelData
      anchors.right: false
      leftMargin: -32

      TextStyled {
        anchors.centerIn: parent
        text: "L>"
      }
    }

    PanelInner {
      id: innerRight
      screen: modelData
      anchors.left: false
      rightMargin: -32

      TextStyled {
        anchors.centerIn: parent
        text: "<R"
      }
    }
  }
}