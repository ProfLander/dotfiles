import QtQuick
import QtQuick.Effects

Item {
  anchors.fill: parent

  Rectangle {
    id: rect
    anchors.fill: parent
    visible: false
    color: "black"
  }

  Rectangle {
    id: mask
    anchors.fill: rect
    visible: false
    radius: 32
    layer.enabled: true
  }

  MultiEffect {
    source: rect
    anchors.fill: rect
    maskEnabled: true
    maskInverted: true
    maskSource: mask

    maskSpreadAtMin: 0.4
    maskThresholdMin: 0.6
  }
}