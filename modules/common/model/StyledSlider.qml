pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import QtQuick.Controls

Slider {
    id: root

    property list<real> stopIndicatorValues: []

    property real trackWidth: 30
    property real trackRadius: 9
    property real handleHeight: Math.max(33, trackWidth + 9)
    property real handleWidth: 0
    property real handleMargins: 2

    property color highlightColor: "red" // these colors are temporary
    property color trackColor: "green"
    property color handleColor: "blue"

    leftPadding: handleMargins
    rightPadding: handleMargins
    property real effectiveDraggingWidth: width - leftPadding - rightPadding

    from: 0
    to: 1
    implicitHeight: handleHeight

    Behavior on value {
        SmoothedAnimation {
            velocity: 3
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: mouse => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
    }

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2

        width: root.availableWidth
        height: 30

        radius: 3
        color: Colors.md3.on_primary // track color

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height

            radius: 3
            color: Colors.md3.primary // tracker color
        }

        Repeater {
            model: root.stopIndicatorValues
            Rectangle {
                required property real modelData
                property real normalizedValue: (modelData - root.from) / (root.to - root.from)
                anchors.verticalCenter: parent.verticalCenter
                x: root.handleMargins + normalizedValue * root.effectiveDraggingWidth - 1.5
                width: 3
                height: 3
                radius: 3
                color: normalizedValue > root.visualPosition ? "blue" : "green"
            }
        }
    }

    handle: Item {
        implicitWidth: 0
        implicitHeight: root.handleHeight
        x: root.leftPadding + root.visualPosition * root.effectiveDraggingWidth
        anchors.verticalCenter: parent.verticalCenter
    }
}
