pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string backlightDevice: ""
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

    Component.onCompleted: detectDeviceProc.running = true

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

    // Finds which backlight device to use, e.g. "intel_backlight" or "amdgpu_bl0"
    Process {
        id: detectDeviceProc
        command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
        stdout: SplitParser {
            onRead: data => {
                root.backlightDevice = data.trim();

                // Read current + max brightness once, atomically, on one line
                initProc.command = ["sh", "-c",
                    `echo $(cat /sys/class/backlight/${root.backlightDevice}/brightness) $(cat /sys/class/backlight/${root.backlightDevice}/max_brightness)`];
                initProc.running = true;
            }
        }
    }

    Process {
        id: initProc
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

    // Watches the hardware brightness file directly, so ANY external change
    // (keyboard function keys, other apps, etc.) syncs back into our state
    FileView {
        id: brightnessFile
        path: root.backlightDevice.length > 0 ? `/sys/class/backlight/${root.backlightDevice}/brightness` : ""
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            if (!root.ready || root.maxBrightness <= 0)
                return;

            const raw = parseInt(text());
            if (isNaN(raw))
                return;

            const normalized = raw / root.maxBrightness;
            // Small threshold avoids feedback loops from our own writes / rounding
            if (Math.abs(normalized - root.brightness) > 0.005) {
                root.brightness = normalized;
            }
        }
    }

    // Applies the brightness via brightnessctl
    Process {
        id: setProc
    }
}
