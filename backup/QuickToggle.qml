import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    required property string materialSymbol
    required property string label
    property bool checked: false
    property bool available: true   // "unavailable" tile state (e.g. adapter missing)

    signal toggled(bool checked)

    implicitWidth: 90
    implicitHeight: 72
    enabled: available
    opacity: available ? 1.0 : 0.38

    // Inactive = pill (fully rounded). Active = blockier rounded rect.
    // This corner-radius morph is the actual M3 Expressive tile behavior.
    radius: checked ? 20 : height / 2

    color: !available ? Colors.md3.surface_container_high : checked ? Colors.md3.primary : Colors.md3.surface_container_highest

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
    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 90
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 6

        MaterialSymbol {
            Layout.alignment: Qt.AlignHCenter
            iconSize: 22
            color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface
            text: root.materialSymbol

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.label
            font.pixelSize: 11
            font.weight: root.checked ? Font.DemiBold : Font.Medium
            color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface_variant

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.scale = 0.95
        onReleased: root.scale = 1.0
        onCanceled: root.scale = 1.0
        onClicked: root.toggled(!root.checked)
    }
}
