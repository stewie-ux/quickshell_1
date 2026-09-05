import QtQuick
import qs.service
import qs.modules.common
import qs.modules.common.widgets

Row {
    spacing: 6
    MaterialSymbol {
        fill: 0
        iconSize: 24
        color: Appearance.bar.primary

        text: {
            const percentage = Upower.percentage * 100;

            if (Upower.isPluggedIn) {
                return "battery_android_frame_bolt";
            }

            if (percentage >= 100)
                return "battery_android_frame_full";

            return "battery_android_frame_" + Math.max(1, Math.ceil(percentage / 100 * 6));
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(Upower.percentage * 100) + "%"
        color: Appearance.bar.primary
        font {
            weight: 600
            family: "JetBrainsMono Nerd Font Mono"
            pixelSize: 12
        }
    }
}
