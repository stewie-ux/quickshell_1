import QtQuick
import qs.service
import qs.modules.common
import qs.modules.common.widgets

MaterialSymbol {
    fill: 0 // it could be 1 or 0 (true / false)
    iconSize: 16
    color: Appearance.bar.primary
    text: {
        if (NetworkService.connected) {
            if (NetworkService.connectionType === "wifi") {
                if (NetworkService.signalStrength >= 75)
                    return "signal_wifi_4_bar";
                if (NetworkService.signalStrength >= 50)
                    return "network_wifi_3_bar";
                if (NetworkService.signalStrength >= 25)
                    return "network_wifi_2_bar";
                return "network_wifi_1_bar";
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
