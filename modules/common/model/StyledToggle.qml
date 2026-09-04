import QtQuick

Rectangle {
    id: root

    property bool checked: false
    property real toggleWidth: 120
    property real toggleHeight: 60
    property real knobMargin: 3

    property bool showArrow: false
    property real arrowZoneWidth: 36

    signal toggled(bool checked)
    signal arrowClicked

    implicitWidth: toggleWidth
    implicitHeight: toggleHeight
    radius: toggleHeight / 5
    color: checked ? "#5c8bf5" : '#5b3a3a3a'

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
    Behavior on radius {
        NumberAnimation {
            duration: 150
        }
    }

    // Exposed so QuickToggle can center its icon within just the main
    // region, and the arrow icon within just the arrow region.
    property alias mainZone: mainZoneItem
    property alias arrowZone: arrowZoneItem

    Item {
        id: mainZoneItem
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            right: root.showArrow ? separator.left : parent.right
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.checked = !root.checked;
                root.toggled(root.checked);
            }
        }
    }

    Rectangle {
        id: separator
        visible: root.showArrow
        width: root.showArrow ? 1 : 0
        color: Qt.rgba(1, 1, 1, 0.18)
        anchors {
            right: arrowZoneItem.left
            top: parent.top
            bottom: parent.bottom
            topMargin: 8
            bottomMargin: 8
        }
    }

    Item {
        id: arrowZoneItem
        visible: root.showArrow
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: root.showArrow ? root.arrowZoneWidth : 0

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.arrowClicked()
        }
    }
}
