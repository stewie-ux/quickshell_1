import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell.Networking
import qs.service
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root

    signal backClicked

    spacing: 8

    // Which network's password row is currently open / showing an error
    property string expandedNetwork: ""
    property string passwordErrorNetwork: ""

    function updateScanning() {
        NetworkService.setScanning(root.visible && NetworkService.wifiEnabled);
    }

    onVisibleChanged: updateScanning()

    Connections {
        target: NetworkService
        function onWifiEnabledChanged() {
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
            text: "Wi-Fi"
            color: "white"
            font.pixelSize: 16
            Layout.leftMargin: 6
            Layout.fillWidth: true
        }

        SimpleToggle {
            checked: NetworkService.wifiEnabled
            onToggled: value => NetworkService.setWifiEnabled(value)
        }
    }

    // List area with centered placeholder for off / empty states
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
            anchors.centerIn: parent
            visible: !NetworkService.wifiEnabled || (NetworkService.networks?.values.length ?? 0) === 0
            width: parent.width - 24
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: !NetworkService.wifiEnabled ? "Wi-Fi is off" : (NetworkService.scanning ? "Searching for networks..." : "No networks found")
            color: Qt.rgba(1, 1, 1, 0.6)
            font.pixelSize: 12
        }

        ListView {
            id: networkList
            anchors.fill: parent
            visible: NetworkService.wifiEnabled && (NetworkService.networks?.values.length ?? 0) > 0
            clip: true
            spacing: 4
            model: NetworkService.networks ? NetworkService.networks.values : []

            delegate: ColumnLayout {
                id: netDelegate
                required property var modelData

                width: networkList.width
                height: implicitHeight
                spacing: 4

                Connections {
                    target: netDelegate.modelData
                    function onConnectionFailed(reason) {
                        if (reason === ConnectionFailReason.NoSecrets) {
                            root.passwordErrorNetwork = netDelegate.modelData.name;
                            root.expandedNetwork = netDelegate.modelData.name;
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    MaterialSymbol {
                        iconSize: 20
                        color: "white"
                        text: "wifi"
                    }

                    MaterialSymbol {
                        visible: netDelegate.modelData.security !== WifiSecurityType.Open
                        iconSize: 12
                        color: Qt.rgba(1, 0, 0, 0.7)
                        text: "lock"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: netDelegate.modelData.name
                            color: "white"
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: {
                                const n = netDelegate.modelData;
                                if (n.stateChanging)
                                    return "Connecting...";
                                if (n.connected)
                                    return "Connected";
                                return n.known ? "Saved" : "Available";
                            }
                            color: Qt.rgba(1, 1, 1, 0.6)
                            font.pixelSize: 11
                        }
                    }

                    MaterialSymbol {
                        visible: netDelegate.modelData.known && !netDelegate.modelData.connected
                        iconSize: 16
                        color: Qt.rgba(1, 1, 1, 0.5)
                        text: "close"

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            cursorShape: Qt.PointingHandCursor
                            onClicked: NetworkService.forgetNetwork(netDelegate.modelData)
                        }
                    }

                    Text {
                        text: {
                            const n = netDelegate.modelData;
                            if (n.connected)
                                return "Disconnect";
                            if (n.stateChanging)
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
                                const n = netDelegate.modelData;
                                if (n.connected) {
                                    NetworkService.disconnectNetwork(n);
                                } else if (n.known || n.security === WifiSecurityType.Open) {
                                    NetworkService.connectNetwork(n);
                                } else {
                                    root.passwordErrorNetwork = "";
                                    root.expandedNetwork = (root.expandedNetwork === n.name) ? "" : n.name;
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    visible: root.expandedNetwork === netDelegate.modelData.name
                    spacing: 6

                    TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholderText: "Password"
                        echoMode: TextInput.Password
                        font.pixelSize: 12
                        Layout.preferredHeight: 30
                    }

                    Text {
                        text: "Join"
                        color: "#5c8bf5"
                        font.pixelSize: 12

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                NetworkService.connectWithPassword(netDelegate.modelData, passwordField.text);
                                passwordField.text = "";
                            }
                        }
                    }
                }

                Text {
                    Layout.leftMargin: 28
                    visible: root.passwordErrorNetwork === netDelegate.modelData.name
                    text: "Incorrect password, try again"
                    color: "#ff6b6b"
                    font.pixelSize: 10
                }
            }
        }
    }

    // Footer: scan status/trigger on the left, "More settings" on the right
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 18
        visible: NetworkService.wifiEnabled
        spacing: 8

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 18

            ProgressBar {
                anchors.fill: parent
                indeterminate: true
                Material.accent: "#5c8bf5"
                visible: NetworkService.scanning
            }

            RowLayout {
                anchors.fill: parent
                visible: !NetworkService.scanning
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
                visible: !NetworkService.scanning
                enabled: !NetworkService.scanning
                cursorShape: Qt.PointingHandCursor
                onClicked: NetworkService.setScanning(true)
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
        //         onClicked: console.log("open more wifi settings")
        //     }
        // }
    }
}
