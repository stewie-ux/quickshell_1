pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real brightness: 1.0        // target value, updates instantly (drives the slider UI)
    property real animatedBrightness: 1.0 // smoothed value, this is what actually gets sent to brightnessctl
    property int maxBrightness: 100
    property bool ready: false

    Behavior on animatedBrightness {
        enabled: root.ready
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    onBrightnessChanged: root.animatedBrightness = root.brightness
    onAnimatedBrightnessChanged: root.syncBrightness()

    Component.onCompleted: initProc.running = true

    function setBrightness(value: real): void {
        root.brightness = Math.max(0, Math.min(1, value));
    }

    function increase(step: real): void {
        setBrightness(root.brightness + (step > 0 ? step : 0.05));
    }

    function decrease(step: real): void {
        setBrightness(root.brightness - (step > 0 ? step : 0.05));
    }

    function syncBrightness(): void {
        if (!root.ready)
            return;

        const percentNumber = Math.max(1, Math.round(root.animatedBrightness * 100));
        setProc.exec(["brightnessctl", "set", `${percentNumber}%`, "--quiet"]);
    }

    // Reads current + max brightness in one call on startup
    Process {
        id: initProc
        command: ["sh", "-c", "echo $(brightnessctl g) $(brightnessctl m)"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ").map(Number);
                const current = parts[0];
                const max = parts[1];
                if (max > 0) {
                    root.maxBrightness = max;
                    root.brightness = current / max; // ready is still false here, so this jumps instantly, no flash
                }
                root.ready = true;
            }
        }
    }

    // Applies the brightness via brightnessctl
    Process {
        id: setProc
    }
}
