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

    visible: GlobalStates.volumeOsdVisible

    anchors {
        top: false
        left: true
        right: true
        bottom: true
    }

    margins.bottom: 24

    implicitHeight: root.osdHeight
    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:VolumeOSD"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    color: "transparent"

    Connections {
        target: Audio
        function onExternalVolumeChanged() {
            GlobalStates.volumeOsdVisible = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: GlobalStates.volumeOsdVisible = false
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
                text: Audio.muted ? "volume_off" : "volume_up"
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
                    width: parent.width * (Audio.muted ? 0 : Audio.volume)
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
                text: Audio.muted ? "Muted" : Math.round(Audio.volume * 100)
                color: Colors.md3.on_surface
                font.pixelSize: 13
            }
        }
    }
}
