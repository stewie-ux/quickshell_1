pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string wallpaperDir: "/home/diego/.local/share/wallpapers/"

    property var wallpapers: []
    property int selectedIndex: 0
    property string currentWallpaper: ""

    function scan() {
        scanProcess.running = false;
        scanProcess.running = true;
    }

    Process {
        id: scanProcess
        command: ["bash", "-c", "find '" + root.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \\) | sort"]
        stdout: StdioCollector {
            onStreamFinished: {
                const list = text.trim().length > 0 ? text.trim().split("\n") : [];
                root.wallpapers = list;
                const idx = list.indexOf(root.currentWallpaper);
                root.selectedIndex = idx >= 0 ? idx : 0;
            }
        }
    }

    Process {
        id: applyProcess
        command: ["bash", "-c", ""]
    }

    function applyWallpaper(path) {
        if (!path)
            return;
        root.currentWallpaper = path;

        const script = "awww img '" + path + "' " + "--transition-type wipe " + "--transition-fps 60 " + "--transition-duration 1.2 && " + "matugen image '" + path + "' -m dark --source-color-index 1";

        applyProcess.command = ["bash", "-c", script];
        applyProcess.running = false;
        applyProcess.running = true;
    }

    function selectAndApply() {
        if (wallpapers.length === 0)
            return;
        applyWallpaper(wallpapers[selectedIndex]);
    }

    Component.onCompleted: scan()
}
