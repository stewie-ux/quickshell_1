import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    required property string materialSymbol
    required property string label
    property string sublabel: ""
    property bool checked: false
    property bool available: true

    signal toggled(bool checked)

    implicitHeight: 64
    enabled: available
    opacity: available ? 1.0 : 0.38

    radius: checked ? 20 : height / 2
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

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 14

        MaterialSymbol {
            iconSize: 22
            color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface
            text: root.materialSymbol

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

            Text {
                Layout.fillWidth: true
                text: root.label
                font.pixelSize: 14
                font.weight: Font.Medium
                color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface
                elide: Text.ElideRight

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: root.sublabel.length > 0
                text: root.sublabel
                font.pixelSize: 11
                color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                elide: Text.ElideRight

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.scale = 0.97
        onReleased: root.scale = 1.0
        onCanceled: root.scale = 1.0
        onClicked: root.toggled(!root.checked)
    }
}
