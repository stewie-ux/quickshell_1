import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules.common.widgets

PopupWindow {
    id: root

    required property QsMenuHandle menuHandle
    required property Item anchorItem

    signal closed

    readonly property int gap: 6

    property var menuStack: [root.menuHandle]
    readonly property var currentMenu: menuStack[menuStack.length - 1]

    anchor.window: anchorItem.QsWindow.window
    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    grabFocus: true
    color: "transparent"
    implicitWidth: 200
    implicitHeight: column.implicitHeight + 16 + root.gap

    onVisibleChanged: {
        if (!root.visible)
            root.closed();
    }

    function open() {
        root.visible = true;
    }
    function close() {
        root.visible = false;
        root.menuStack = [root.menuHandle];
    }
    function pushSubmenu(entry) {
        root.menuStack = [...root.menuStack, entry];
    }
    function popSubmenu() {
        if (root.menuStack.length > 1)
            root.menuStack = root.menuStack.slice(0, -1);
    }

    QsMenuOpener {
        id: opener
        menu: root.currentMenu
    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: root.gap
        }
        radius: 12
        color: Qt.alpha(Colors.md3.background, 0.95)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.08)

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            // Back button, only when inside a submenu
            Rectangle {
                id: backRow
                visible: root.menuStack.length > 1
                Layout.fillWidth: true
                implicitHeight: 30
                radius: 8
                color: backHover.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 6
                    spacing: 6

                    MaterialSymbol {
                        iconSize: 16
                        color: "white"
                        text: "chevron_left"
                    }
                    Text {
                        text: "Back"
                        color: "white"
                        font.pixelSize: 12
                    }
                }

                MouseArea {
                    id: backHover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.popSubmenu()
                }
            }

            Repeater {
                model: opener.children

                delegate: Item {
                    id: entryDelegate
                    required property QsMenuEntry modelData

                    Layout.fillWidth: true
                    implicitHeight: entryDelegate.modelData.isSeparator ? 9 : 30

                    Rectangle {
                        visible: entryDelegate.modelData.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 1
                        color: Qt.rgba(1, 1, 1, 0.1)
                    }

                    Rectangle {
                        id: entryBg
                        visible: !entryDelegate.modelData.isSeparator
                        anchors.fill: parent
                        radius: 8
                        color: entryHover.containsMouse && entryDelegate.modelData.enabled ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 8

                            Text {
                                text: entryDelegate.modelData.text
                                color: entryDelegate.modelData.enabled ? "white" : Qt.rgba(1, 1, 1, 0.4)
                                font.pixelSize: 12
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            MaterialSymbol {
                                visible: entryDelegate.modelData.hasChildren
                                iconSize: 14
                                color: "white"
                                text: "chevron_right"
                            }
                        }
                    }

                    MouseArea {
                        id: entryHover
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !entryDelegate.modelData.isSeparator && entryDelegate.modelData.enabled
                        cursorShape: Qt.PointingHandCursor

                        scale: pressed ? 0.97 : 1.0
                        Behavior on scale {
                            NumberAnimation {
                                duration: 80
                            }
                        }

                        onClicked: {
                            if (entryDelegate.modelData.hasChildren) {
                                root.pushSubmenu(entryDelegate.modelData);
                            } else {
                                entryDelegate.modelData.triggered();
                                root.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
