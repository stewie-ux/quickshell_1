import QtQuick
import Quickshell.Io
import qs.service
import qs.modules.common
import qs.modules.common.widgets

MaterialSymbol {
    fill: 1 // it could be 1 or 0 (true / false)
    iconSize: 16
    color: Appearance.bar.primary
    text: {
        if (Bluetooth.enabled) {
            if (!Bluetooth.connected) {
                return "bluetooth";
            }

            return "bluetooth_connected";
        }
        return "bluetooth_disabled";
    }

    Process {
        id: networkSettings
        command: ["kcmshell6", "kcm_bluetooth"]
        running: false
    }

    MouseArea {
        anchors.fill: parent

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }

        onClicked: networkSettings.running = true
    }
}
