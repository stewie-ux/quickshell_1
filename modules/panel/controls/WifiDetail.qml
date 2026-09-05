import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root

    signal backClicked

    spacing: 8

    RowLayout {
        Layout.fillWidth: true

        MaterialSymbol {
            iconSize: 20
            color: "white"
            text: "arrow_back"

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: root.backClicked()
            }
        }

        Text {
            text: "Wi-Fi"
            color: "white"
            font.pixelSize: 16
            Layout.leftMargin: 6
        }
    }

    Text {
        text: "Network list goes here"
        color: "white"
    }
}
