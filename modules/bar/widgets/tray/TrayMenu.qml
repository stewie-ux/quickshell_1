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

    anchor.window: anchorItem.QsWindow.window
    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    grabFocus: true
    color: "transparent"
    implicitWidth: 200
    implicitHeight: column.implicitHeight + 16

    onVisibleChanged: {
        if (!root.visible)
            root.closed();
    }

    function open() {
        root.visible = true;
    }
    function close() {
        root.visible = false;
    }

    QsMenuOpener {
        id: opener
        menu: root.menuHandle
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Qt.alpha(Colors.md3.background, 0.95)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.08)

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

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

                    RowLayout {
                        visible: !entryDelegate.modelData.isSeparator
                        anchors.fill: parent
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

                    MouseArea {
                        anchors.fill: parent
                        enabled: !entryDelegate.modelData.isSeparator && entryDelegate.modelData.enabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!entryDelegate.modelData.hasChildren) {
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
