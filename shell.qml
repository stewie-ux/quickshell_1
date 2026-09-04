import "modules/bar"
import "modules/panel"
import "modules/osd"

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {

    IpcHandler {
        target: "controls"

        function toggle(): void {
            GlobalStates.controlsVisible = !GlobalStates.controlsVisible;
        }

        function open(): void {
            GlobalStates.controlsVisible = true;
        }

        function close(): void {
            GlobalStates.controlsVisible = false;
        }
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            GlobalStates.wallpaperSwitcherVisible = !GlobalStates.wallpaperSwitcherVisible;
        }

        function open(): void {
            GlobalStates.wallpaperSwitcherVisible = true;
        }

        function close(): void {
            GlobalStates.wallpaperSwitcherVisible = false;
        }
    }

    Bar {}

    Controls {}
    BrightnessOsd {}
    VolumeOsd {}
    WallpaperSwitcher {}
}
