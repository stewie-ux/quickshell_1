import QtQuick
import Quickshell
import qs.modules.common

Text {
    id: timeText

    // text: Qt.formatDateTime(clock.date, "ddd MMM d  hh:mm")
    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: Appearance.bar.primary

    font {
        pixelSize: 16
        family: "SF Compact Rounded"
        weight: 600
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
