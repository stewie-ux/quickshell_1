import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.service
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root

    signal backClicked

    spacing: 8

    onVisibleChanged: BluetoothService.setScanning(root.visible)

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

        SimpleToggle {
            checked: BluetoothService.enabled
            onToggled: value => {
                if (BluetoothService.adapter)
                    BluetoothService.adapter.enabled = value;
            }
        }

        // MaterialSymbol {
        //     iconSize: 20
        //     color: "white"
        //     text: BluetoothService.discovering ? "bluetooth_searching" : "refresh"

        //     MouseArea {
        //         anchors.fill: parent
        //         anchors.margins: -6
        //         cursorShape: Qt.PointingHandCursor
        //         onClicked: BluetoothService.setScanning(!BluetoothService.discovering)
        //     }
        // }
    }

    Text {
        visible: !BluetoothService.devices || BluetoothService.devices.values.length === 0
        text: BluetoothService.discovering ? "Searching for devices..." : "No devices found"
        color: Qt.rgba(1, 1, 1, 0.6)
        font.pixelSize: 12
    }

    ListView {
        id: deviceList
        Layout.fillWidth: true
        Layout.fillHeight: true
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
