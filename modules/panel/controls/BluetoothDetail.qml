import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell.Bluetooth
import qs.service
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root

    signal backClicked

    spacing: 8

    function updateScanning() {
        BluetoothService.setScanning(root.visible && BluetoothService.enabled);
    }

    onVisibleChanged: updateScanning()

    Connections {
        target: BluetoothService
        function onEnabledChanged() {
            root.updateScanning();
        }
    }

    RowLayout {
        Layout.fillWidth: true

        MaterialSymbol {
            iconSize: 20
            color: "white"
            text: "arrow_back"

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: root.backClicked()
            }
        }

        Text {
            text: "Bluetooth"
            color: "white"
            font.pixelSize: 16
            Layout.leftMargin: 6
            Layout.fillWidth: true
        }

        MaterialSymbol {
            iconSize: 20
            color: "white"
            text: "settings_bluetooth"

            MouseArea {
                anchors.fill: parent
                // anchors.rightMargin: 6
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Settings")
            }
        }

        SimpleToggle {
            checked: BluetoothService.enabled
            onToggled: value => {
                if (BluetoothService.adapter)
                    BluetoothService.adapter.enabled = value;
            }
        }
    }

    // List area with a centered placeholder for off / empty states
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
            anchors.centerIn: parent
            visible: !BluetoothService.enabled || (BluetoothService.devices?.values.length ?? 0) === 0
            width: parent.width - 24
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: !BluetoothService.enabled ? "Bluetooth is off" : (BluetoothService.discovering ? "Searching for devices..." : "No devices found")
            color: Qt.rgba(1, 1, 1, 0.6)
            font.pixelSize: 12
        }

        ListView {
            id: deviceList
            anchors.fill: parent
            visible: BluetoothService.enabled && (BluetoothService.devices?.values.length ?? 0) > 0
            clip: true
            spacing: 4
            model: BluetoothService.devices ? BluetoothService.devices.values : []

            delegate: Item {
                id: deviceDelegate
                required property var modelData

                width: deviceList.width
                height: 44

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    MaterialSymbol {
                        iconSize: 20
                        color: "white"
                        text: deviceDelegate.modelData.state === BluetoothDeviceState.Connected ? "bluetooth_connected" : "bluetooth"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: deviceDelegate.modelData.name
                            color: "white"
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: {
                                const d = deviceDelegate.modelData;
                                if (d.state === BluetoothDeviceState.Connecting)
                                    return "Connecting...";
                                if (d.state === BluetoothDeviceState.Disconnecting)
                                    return "Disconnecting...";
                                if (d.state === BluetoothDeviceState.Connected)
                                    return d.batteryAvailable ? "Connected · " + Math.round(d.battery * 100) + "%" : "Connected";
                                return d.paired ? "Paired" : "Available";
                            }
                            color: Qt.rgba(1, 1, 1, 0.6)
                            font.pixelSize: 11
                        }
                    }

                    Text {
                        text: {
                            const d = deviceDelegate.modelData;
                            if (d.state === BluetoothDeviceState.Connected)
                                return "Disconnect";
                            if (d.state === BluetoothDeviceState.Connecting || d.state === BluetoothDeviceState.Disconnecting)
                                return "...";
                            return "Connect";
                        }
                        color: "#5c8bf5"
                        font.pixelSize: 12

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                const d = deviceDelegate.modelData;
                                if (d.state === BluetoothDeviceState.Connected) {
                                    BluetoothService.disconnectDevice(d);
                                } else {
                                    BluetoothService.connectDevice(d);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Footer: scan status/trigger on the left, "More settings" on the right
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 18
        visible: BluetoothService.enabled
        spacing: 8

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 18

            ProgressBar {
                anchors.fill: parent
                indeterminate: true
                Material.accent: "#5c8bf5"
                visible: BluetoothService.discovering
            }

            RowLayout {
                anchors.fill: parent
                visible: !BluetoothService.discovering
                spacing: 4

                MaterialSymbol {
                    iconSize: 14
                    color: Qt.rgba(1, 1, 1, 0.6)
                    text: "refresh"
                }

                Text {
                    text: "Scan again"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 11
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                visible: !BluetoothService.discovering
                enabled: !BluetoothService.discovering
                cursorShape: Qt.PointingHandCursor
                onClicked: BluetoothService.setScanning(true)
            }
        }

        // Text {
        //     text: "More settings"
        //     color: Qt.rgba(1, 1, 1, 0.6)
        //     font.pixelSize: 11

        //     MouseArea {
        //         anchors.fill: parent
        //         anchors.margins: -6
        //         cursorShape: Qt.PointingHandCursor
        //         onClicked: console.log("open more bluetooth settings")
        //     }
        // }
    }
}
