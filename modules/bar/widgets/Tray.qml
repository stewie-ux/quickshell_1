import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.modules.bar.widgets.tray

RowLayout {
    id: root
    spacing: 10

    Repeater {
        model: SystemTray.items.values

        delegate: MouseArea {
            id: trayItem
            required property SystemTrayItem modelData

            implicitWidth: 18
            implicitHeight: 18
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    trayItem.modelData.activate();
                } else if (mouse.button === Qt.RightButton) {
                    if (trayItem.modelData.hasMenu)
                        menuLoader.active = true;
                }
            }

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
                asynchronous: true
            }

            Loader {
                id: menuLoader
                active: false
                sourceComponent: TrayMenu {
                    menuHandle: trayItem.modelData.menu
                    anchorItem: trayItem
                    Component.onCompleted: open()
                    onClosed: menuLoader.active = false
                }
            }
        }
    }
}
