import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property int brightnessValue: 50
    property int maxBrightness: 1000

    Layout.fillWidth: true
    implicitHeight: 40

    // ── Detect backlight device once at startup ─────────────────────────────
    Process {
        id: backlightDeviceProc
        command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
        running: true
        stdout: StdioCollector {
            id: backlightDevice
            onStreamFinished: maxBrightnessProc.running = true
        }
    }

    // ── Read max brightness once ─────────────────────────────────────────────
    Process {
        id: maxBrightnessProc
        running: false
        command: ["cat", "/sys/class/backlight/" + backlightDevice.text.trim() + "/max_brightness"]
        stdout: StdioCollector {
            onStreamFinished: {
                const mx = parseInt(text.trim());
                if (!isNaN(mx) && mx > 0)
                    root.maxBrightness = mx;
                brightnessWatcher.reload();
            }
        }
    }

    // ── Live watcher (keybinds, brightnessctl from elsewhere, etc) ──────────
    FileView {
        id: brightnessWatcher
        path: backlightDevice.text.trim().length > 0 ? "/sys/class/backlight/" + backlightDevice.text.trim() + "/brightness" : ""
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const cur = parseInt(text().trim());
            if (!isNaN(cur) && root.maxBrightness > 0)
                root.brightnessValue = Math.round(cur / root.maxBrightness * 100);
        }
    }

    function setBrightness(percent) {
        root.brightnessValue = percent;
        const proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        proc.command = ["brightnessctl", "set", percent + "%"];
        proc.running = true;
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        MaterialSymbol {
            iconSize: 20
            color: Colors.md3.on_surface
            text: "brightness_medium"
        }

        Item {
            id: sliderItem
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            readonly property real fraction: Math.max(0, Math.min(1, root.brightnessValue / 100.0))
            readonly property int trackW: width - handle.width

            Rectangle {
                id: track
                height: 4
                width: sliderItem.trackW
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 2
                color: Colors.md3.surface_container_highest

                Rectangle {
                    height: parent.height
                    width: sliderItem.fraction * parent.width
                    radius: parent.radius
                    color: Colors.md3.primary
                    Behavior on width {
                        NumberAnimation {
                            duration: 40
                        }
                    }
                }
            }

            Rectangle {
                id: handle
                width: 16
                height: 16
                radius: 8
                anchors.verticalCenter: parent.verticalCenter
                x: sliderItem.fraction * sliderItem.trackW
                color: dragArea.pressed ? Colors.md3.tertiary : Colors.md3.primary
                scale: dragArea.pressed ? 1.2 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 90
                    }
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent

                function valueFromX(mx) {
                    const clamped = Math.max(handle.width / 2, Math.min(sliderItem.width - handle.width / 2, mx));
                    const ratio = (clamped - handle.width / 2) / sliderItem.trackW;
                    return Math.round(ratio * 100);
                }

                onPressed: mouse => root.setBrightness(valueFromX(mouse.x))
                onPositionChanged: mouse => {
                    if (pressed)
                        root.setBrightness(valueFromX(mouse.x));
                }
            }
        }

        Text {
            text: root.brightnessValue + "%"
            color: Colors.md3.on_surface
            font.pixelSize: 12
            Layout.preferredWidth: 32
        }
    }
}
