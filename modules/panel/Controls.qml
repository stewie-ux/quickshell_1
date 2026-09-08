import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.service
import qs.modules.common
import qs.modules.panel.controls
import qs.modules.common.widgets

PanelWindow {
    id: root

    readonly property int panelWidth: 360
    readonly property int panelHeight: 460

    property bool showWifiDetail: false
    property bool showBluetoothDetail: false

    visible: GlobalStates.controlsVisible

    anchors {
        top: true
        right: true
        left: false
        bottom: false
    }

    implicitWidth: root.panelWidth
    implicitHeight: root.panelHeight

    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:Controls"
    WlrLayershell.keyboardFocus: GlobalStates.controlsVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        radius: 16
        color: Qt.alpha(Colors.md3.background, 0.9)

        ColumnLayout {
            anchors.fill: parent
            visible: !root.showBluetoothDetail && !root.showWifiDetail
            anchors.margins: 12
            spacing: 2

            GridLayout {
                Layout.fillWidth: true

                columns: 3           // Set maximum number of columns
                columnSpacing: 10     // Horizontal gap between items
                rowSpacing: 10        // Vertical gap between items

                QuickToggle {
                    Layout.fillWidth: true
                    materialSymbolOn: "wifi"
                    materialSymbolOff: "wifi"
                    checked: NetworkService.wifiEnabled
                    showArrow: true

                    onToggled: value => {
                        NetworkService.setWifiEnabled(value);
                    }
                    onArrowClicked: {
                        root.showWifiDetail = true;
                    }
                }

                QuickToggle {
                    Layout.fillWidth: true
                    materialSymbolOn: "bluetooth"
                    materialSymbolOff: "bluetooth"
                    checked: BluetoothService.enabled
                    showArrow: true

                    onToggled: value => {
                        if (BluetoothService.adapter)
                            BluetoothService.adapter.enabled = value;
                    }
                    onArrowClicked: {
                        root.showBluetoothDetail = true;
                    }
                }

                QuickToggle {
                    Layout.fillWidth: true
                    materialSymbolOn: "mic"
                    materialSymbolOff: "mic"
                    checked: false
                    showArrow: false

                    onToggled: value => {
                        console.log("Mic");
                    }
                }
            }

            QuickSlider {
                id: brightnessSlider
                Layout.fillWidth: true
                materialSymbol: "brightness_medium"

                onMoved: Brightness.setBrightness(value)

                Connections {
                    target: Brightness
                    function onBrightnessChanged() {
                        if (!brightnessSlider.pressed)
                            brightnessSlider.value = Brightness.brightness;
                    }
                }

                Component.onCompleted: value = Brightness.brightness
            }

            QuickSlider {
                id: volumeSlider
                Layout.fillWidth: true
                materialSymbol: "volume_up"

                onMoved: Audio.setVolume(Math.round(value * 100))

                Connections {
                    target: Audio
                    function onVolumeChanged() {
                        if (!volumeSlider.pressed)
                            volumeSlider.value = Audio.volume;
                    }
                }

                Component.onCompleted: value = Audio.volume
            }

            QuickSlider {
                id: micSlider
                Layout.fillWidth: true
                materialSymbol: "mic"
            }
        }

        WifiDetail {
            id: wifiPage
            visible: root.showWifiDetail
            anchors.fill: parent
            anchors.margins: 12
            onBackClicked: root.showWifiDetail = false
        }

        BluetoothDetail {
            id: bluetoothPage
            visible: root.showBluetoothDetail
            anchors.fill: parent
            anchors.margins: 12
            onBackClicked: root.showBluetoothDetail = false
        }
    }
}
