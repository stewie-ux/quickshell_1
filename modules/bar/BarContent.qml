import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.bar.widgets

Item {
    id: root
    implicitHeight: Appearance.bar.height
    width: parent.width

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: Appearance.bar.background

        RowLayout {

            anchors {
                fill: parent
                leftMargin: 10
                rightMargin: 10
            }

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

                Item {
                    anchors.fill: parent

                    Battery {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        width: content.implicitWidth + 16
                        height: content.implicitHeight - 2
                        radius: (content.implicitHeight - 2) / 2
                        // color: Appearance.bar.on_primary
                        color: "transparent"

                        Behavior on width {
                            NumberAnimation {
                                duration: 150
                            }
                        }

                        Row {
                            id: content
                            anchors.centerIn: parent

                            spacing: 12

                            Tray {}

                            Network {}

                            Bluetooth {}
                        }
                    }
                }
            }
        }
    }
}
