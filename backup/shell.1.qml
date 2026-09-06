import "widgets"

import QtQuick
import Quickshell
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 36 // Bar height
        color: "black" // Bar color

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true

                Workspaces {
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                Layout.fillWidth: true

                Clock {
                    anchors.centerIn: parent
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
