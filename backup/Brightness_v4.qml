pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string backlightDevice: ""
    property real brightness: 1.0 // normalized 0.0 - 1.0, single source of truth
    property int maxBrightness: 100

    function setBrightness(value: real): void {
        root.brightness = Math.max(0, Math.min(1, value));

        const percent = Math.max(1, Math.round(root.brightness * 100));
        const proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        proc.command = ["brightnessctl", "set", `${percent}%`, "--quiet"];
        proc.running = true;
    }

    function increase(step: real): void {
        setBrightness(root.brightness + (step > 0 ? step : 0.05));
    }

    function decrease(step: real): void {
        setBrightness(root.brightness - (step > 0 ? step : 0.05));
    }

    // Detect backlight device once at startup, e.g. "amdgpu_bl1"
    Process {
        id: detectDeviceProc
        command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
        running: true
        stdout: StdioCollector {
            id: deviceOut
            onStreamFinished: {
                root.backlightDevice = deviceOut.text.trim();
                maxBrightnessProc.running = true;
            }
        }
    }

    // Read max brightness once — it doesn't change at runtime
    Process {
        id: maxBrightnessProc
        running: false
        command: ["cat", `/sys/class/backlight/${root.backlightDevice}/max_brightness`]
        stdout: StdioCollector {
            onStreamFinished: {
                const mx = parseInt(text.trim());
                if (!isNaN(mx) && mx > 0)
                    root.maxBrightness = mx;

                brightnessWatcher.reload();
            }
        }
    }

    // Live watcher — updates whenever ANYTHING changes brightness:
    // keyboard function keys, other apps, or this shell itself.
    FileView {
        id: brightnessWatcher
        path: root.backlightDevice.length > 0 ? `/sys/class/backlight/${root.backlightDevice}/brightness` : ""
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const cur = parseInt(text().trim());
            if (!isNaN(cur) && root.maxBrightness > 0) {
                root.brightness = cur / root.maxBrightness;
            }
        }
    }
}
