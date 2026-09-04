import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.service
import qs.modules.common
import qs.modules.common.widgets

PanelWindow {
    id: root

    readonly property int osdWidth: 240
    readonly property int osdHeight: 56

    visible: GlobalStates.brightnessOsdVisible

    anchors {
        top: false
        left: true
        right: true
        bottom: true
    }

    margins.bottom: 24

    implicitHeight: root.osdHeight
    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:BrightnessOSD"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    color: "transparent"

    // Fires whenever the target brightness changes (slider drag, keybind, etc.)
    Connections {
        target: Brightness
        function onExternalBrightnessChanged() {
            GlobalStates.brightnessOsdVisible = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: GlobalStates.brightnessOsdVisible = false
    }

    Rectangle {
        id: card
        width: root.osdWidth
        height: root.osdHeight
        radius: height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        color: Colors.md3.surface_container_high

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 16
            spacing: 12

            MaterialSymbol {
                iconSize: 22
                color: Colors.md3.on_surface
                text: "brightness_high"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 6

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Colors.md3.surface_container_highest
                }

                Rectangle {
                    height: parent.height
                    radius: height / 2
                    width: parent.width * Brightness.brightness // temp placeholder (it's not refering to anything)
                    color: Colors.md3.primary

                    Behavior on width {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Text {
                text: Math.round(Brightness.brightness * 100) // temp placeholder (it's not refering to anything)
                color: Colors.md3.on_surface
                font.pixelSize: 13
            }
        }
    }
}
