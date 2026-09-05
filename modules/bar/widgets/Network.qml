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
        if (Networking.connected) {
            if (Networking.connectionType === "wifi") {
                if (Networking.signalStrength >= 93)
                    return "signal_wifi_4_bar";
                return "signal_wifi_4_bar";
            }

            return "settings_ethernet";
        }

        return "globe_2_cancel";
    }

    Process {
        id: networkSettings
        command: ["kcmshell6", "kcm_networkmanagement"]
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
