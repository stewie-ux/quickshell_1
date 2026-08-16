import QtQuick
import QtQuick.Layouts
import qs.modules.common

Item {
    id: root
    implicitHeight: Appearance.bar.height
    width: parent.width

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: "black"

        RowLayout {

            anchors {
                fill: parent
                leftMargin: 10
                rightMargin: 10
            }

            // contents comes here
        }
    }
}
