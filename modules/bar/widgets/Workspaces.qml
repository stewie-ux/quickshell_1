import QtQuick
import Quickshell.Hyprland
import qs.modules.common

Row {
    spacing: 6

    Repeater {
        model: 10

        Rectangle {
            id: workspacesroot
            property bool hovered: false
            required property int index

            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property int wsID: index + 1
            color: isActive ? Appearance.bar.primary : (ws ? Appearance.bar.primary : Appearance.bar.on_primary) // change these colors, for now these are set to R, G, B
            width: isActive ? Appearance.workspace.activeWidth : Appearance.workspace.size // you can change the size here
            height: Appearance.workspace.size
            radius: Appearance.workspace.size / 2
            scale: hovered ? (isActive ? 1.0 : 1.2) : 1.0

            HoverHandler {
                onHoveredChanged: parent.hovered = hovered
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                onTapped: {
                    Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspacesroot.wsID} })`);
                }
            }

            // Animation
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                }
            }

            Behavior on width {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }
}
