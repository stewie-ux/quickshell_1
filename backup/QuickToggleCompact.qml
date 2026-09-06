import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    required property string materialSymbol
    property bool checked: false
    property bool available: true

    signal toggled(bool checked)

    implicitWidth: 64
    implicitHeight: 64
    enabled: available
    opacity: available ? 1.0 : 0.38

    radius: checked ? 20 : width / 2
    color: checked ? Colors.md3.primary : Colors.md3.surface_container_highest

    Behavior on radius {
        NumberAnimation {
            duration: 280
            easing.type: Easing.OutExpo
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 90
        }
    }

    MaterialSymbol {
        anchors.centerIn: parent
        iconSize: 22
        color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface
        text: root.materialSymbol

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.scale = 0.92
        onReleased: root.scale = 1.0
        onCanceled: root.scale = 1.0
        onClicked: root.toggled(!root.checked)
    }
}
