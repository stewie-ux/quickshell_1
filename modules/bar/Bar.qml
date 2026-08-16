pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets

Scope {
    id: bar

    // property int barHeight: 28
    // property int screenRounding: 16

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barRoot

            required property ShellScreen modelData
            screen: modelData

            WlrLayershell.namespace: "quickshell:bar"
            WlrLayershell.layer: WlrLayer.Top
            exclusionMode: ExclusionMode.Auto
            color: "transparent"

            implicitHeight: Appearance.bar.height + (Appearance.bar.corners ? Appearance.bar.rounding : 0) // replace these with Actual config

            anchors {
                top: true
                left: true
                right: true
            }

            exclusiveZone: Appearance.bar.height

            BarContent {
                id: barContent

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
            }

            Item {
                id: roundDecorators

                anchors {
                    left: parent.left
                    right: parent.right
                    top: barContent.bottom
                }

                height: Appearance.bar.rounding
                visible: Appearance.bar.corners

                RoundCorner {

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }

                    implicitSize: Appearance.bar.rounding
                    color: "black" // Replace with bar color
                    corner: RoundCorner.CornerEnum.TopLeft
                }

                RoundCorner {

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                    }

                    implicitSize: Appearance.bar.rounding
                    color: "black" // Replace with bar color
                    corner: RoundCorner.CornerEnum.TopRight
                }
            }
        }
    }
}
