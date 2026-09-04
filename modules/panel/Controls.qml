import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.service
import qs.modules.common
import qs.modules.common.widgets

PanelWindow {
    id: root

    readonly property int panelWidth: 360
    readonly property int panelHeight: 360

    visible: GlobalStates.controlsVisible

    anchors {
        top: false
        right: true
        left: false
        bottom: true
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
            anchors.margins: 12
            spacing: 2

            GridLayout {
                Layout.fillWidth: true

                columns: 3           // Set maximum number of columns
                columnSpacing: 10     // Horizontal gap between items
                rowSpacing: 10        // Vertical gap between items

                QuickToggle {
                    Layout.fillWidth: true
                    materialSymbolOn: "bluetooth"
                    materialSymbolOff: "bluetooth_disabled"
                    checked: Bluetooth.enabled
                    showArrow: true

                    onToggled: value => {
                        if (Bluetooth.adapter)
                            Bluetooth.adapter.enabled = value;
                    }
                    onArrowClicked: {
                        console.log("open bluetooth details");
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
    }
}
