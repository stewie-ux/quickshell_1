import QtQuick
import Quickshell.Io
import qs.service
import qs.modules.common
import qs.modules.common.widgets

MaterialSymbol {
    fill: 0
    iconSize: 16
    color: Qt.alpha(Appearance.bar.primary, 0.3)
    text: {
        if (NetworkService.connected) {
            if (NetworkService.connectionType === "wifi") {
                return "wifi";
            }

            return "settings_ethernet";
        }

        return "globe_2_cancel";
    }

    MaterialSymbol {
        fill: 0 // it could be 1 or 0 (true / false)
        iconSize: 16
        color: Appearance.bar.primary
        text: {
            if (NetworkService.connected) {
                if (NetworkService.connectionType === "wifi") {
                    if (NetworkService.signalStrength >= 93)
                        return "wifi";
                    if (NetworkService.signalStrength < 93)
                        return "wifi_2_bar";
                    return "wifi_1_bar";
                }

                return "settings_ethernet";
            }

            return "globe_2_cancel";
        }

        // Process {
        //     id: networkSettings
        //     command: ["kcmshell6", "kcm_networkmanagement"]
        //     running: false
        // }

        // MouseArea {
        //     anchors.fill: parent

        //     HoverHandler {
        //         cursorShape: Qt.PointingHandCursor
        //     }

        //     onClicked: networkSettings.running = true
        // }
    }
}
