import QtQuick
import Quickshell

PanelWindow {
  property alias topMargin: rect.anchors.topMargin
  property alias bottomMargin: rect.anchors.bottomMargin
  property alias leftMargin: rect.anchors.leftMargin
  property alias rightMargin: rect.anchors.rightMargin

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  color: "transparent"

  implicitWidth: 64
  implicitHeight: 64
  
  Rectangle {
    id: rect
    anchors.fill: parent
    color: "#80000000"
    radius: 32
  }
}