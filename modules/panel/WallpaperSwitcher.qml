import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.service
import qs.modules.common

PanelWindow {
    id: root

    readonly property int thumbWidth: 160

    visible: GlobalStates.wallpaperSwitcherVisible

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: 220
    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:WallpaperSwitcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: GlobalStates.wallpaperSwitcherVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    color: "red"

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.wallpaperSwitcherVisible = false
    }

    Rectangle {
        id: card
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(1200, root.width - 40)
        height: 200
        radius: 16
        color: Qt.alpha(Colors.md3.background, 0.9)
        border.color: Qt.alpha(Colors.md3.on_primary, 0.08)
        border.width: 1

        // transform: Translate {
        //     id: slide
        //     y: GlobalStates.wallpaperSwitcherVisible ? 0 : card.height + 40

        //     Behavior on y {
        //         NumberAnimation {
        //             duration: 400
        //             easing.type: Easing.OutCubic
        //             onFinished: {
        //                 if (!GlobalStates.wallpaperSwitcherVisible)
        //                     root.reallyVisible = false;
        //             }
        //         }
        //     }
        // }

        focus: true
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Right) {
                Wallpaper.selectedIndex = Math.min(Wallpaper.selectedIndex + 1, Wallpaper.wallpapers.length - 1);
                event.accepted = true;
            } else if (event.key === Qt.Key_Left) {
                Wallpaper.selectedIndex = Math.max(Wallpaper.selectedIndex - 1, 0);
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                Wallpaper.selectAndApply();
                GlobalStates.wallpaperSwitcherVisible = false;
                event.accepted = true;
            } else if (event.key === Qt.Key_Escape) {
                GlobalStates.wallpaperSwitcherVisible = false;
                event.accepted = true;
            }
        }

        Component.onCompleted: forceActiveFocus()
        onVisibleChanged: if (visible)
            forceActiveFocus()

        ListView {
            id: strip
            anchors.fill: parent
            anchors.margins: 16
            orientation: ListView.Horizontal
            spacing: 12
            model: Wallpaper.wallpapers
            currentIndex: Wallpaper.selectedIndex
            highlightMoveDuration: 200
            onCurrentIndexChanged: strip.positionViewAtIndex(currentIndex, ListView.Contain)

            delegate: Item {
                id: thumb
                width: root.thumbWidth
                height: strip.height
                property bool isSelected: index === Wallpaper.selectedIndex
                scale: isSelected ? 1.0 : 0.9
                opacity: isSelected ? 1.0 : 0.6

                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutSine
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutSine
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: "transparent"
                    border.width: thumb.isSelected ? 3 : 0
                    border.color: Colors.md3.primary

                    Image {
                        anchors.fill: parent
                        anchors.margins: 3
                        source: "file://" + modelData
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: false
                        sourceSize.width: 320
                        sourceSize.height: 200
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Wallpaper.selectedIndex = index;
                        Wallpaper.selectAndApply();
                        GlobalStates.wallpaperSwitcherVisible = false;
                    }
                }
            }
        }

        MouseArea {
            id: wheelOverlay
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: function (wheel) {
                if (wheel.angleDelta.y < 0)
                    Wallpaper.selectedIndex = Math.min(Wallpaper.selectedIndex + 1, Wallpaper.wallpapers.length - 1);
                else if (wheel.angleDelta.y > 0)
                    Wallpaper.selectedIndex = Math.max(Wallpaper.selectedIndex - 1, 0);
                wheel.accepted = true;
            }
        }
    }
}
