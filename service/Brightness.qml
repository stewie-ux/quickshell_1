pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string device: ""
    property int maxBrightness: 0
    property int currentBrightness: 0
    readonly property real brightness: maxBrightness > 0 ? currentBrightness / maxBrightness : 0

    signal externalBrightnessChanged

    function setBrightness(value: real): void {
        const clamped = Math.max(0, Math.min(1, value));
        const target = Math.round(clamped * root.maxBrightness);
        root.currentBrightness = target;
        internalCooldown.restart();

        const proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        proc.command = ["brightnessctl", "-d", root.device, "set", target + ""];
        proc.running = true;
    }

    // Any file-watcher event within this window after a manual setBrightness()
    // is almost certainly a straggling write from our own rapid drag, not a
    // genuine external change (keybind, another app, etc).
    Timer {
        id: internalCooldown
        interval: 400
    }

    Process {
        id: detectDeviceProc
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim().split("\n")[0];
                if (!line)
                    return;
                const parts = line.split(",");
                root.device = parts[0];
                root.maxBrightness = parseInt(parts[4]);
                root.currentBrightness = parseInt(parts[2]);
            }
        }
    }

    FileView {
        id: brightnessFile
        path: root.device.length > 0 ? "/sys/class/backlight/" + root.device + "/brightness" : ""
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const cur = parseInt(text().trim());
            if (cur !== root.currentBrightness) {
                root.currentBrightness = cur;
                if (!internalCooldown.running)
                    root.externalBrightnessChanged();
            }
        }
    }

    Component.onCompleted: detectDeviceProc.running = true
}
