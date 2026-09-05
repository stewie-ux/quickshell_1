import QtQuick

Rectangle {
    id: root

    property bool checked: false
    property real toggleWidth: 46
    property real toggleHeight: 26
    property real knobMargin: 3

    signal toggled(bool checked)

    implicitWidth: toggleWidth
    implicitHeight: toggleHeight
    radius: height / 2
    color: checked ? "#5c8bf5" : "#3a3a3a"

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Rectangle {
        id: knob
        width: root.height - root.knobMargin * 2
        height: width
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? root.width - width - root.knobMargin : root.knobMargin
        color: "#ffffff"

        Behavior on x {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
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
