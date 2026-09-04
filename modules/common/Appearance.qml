pragma Singleton

import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    property alias bar: barconf
    property alias workspace: workspaceconf

    QtObject {
        id: barconf

        property color background: Qt.alpha(Colors.md3.background, 0.9)
        property color primary: Colors.md3.primary
        property color on_primary: Colors.md3.on_primary

        property bool enable: true // (currently not in use ) This is for bar background [if you want to do pill shape floating bar]
        property bool corners: true
        property int height: 28
        property int rounding: 16
    }

    QtObject {
        id: workspaceconf

        property int size: 16
        property int activeWidth: 36
    }
}
