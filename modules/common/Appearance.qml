pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property alias bar: configurationbar

    QtObject {
        id: configurationbar

        property bool enable: true // (currently not in use ) This is for bar background [if you want to do pill shape floating bar]
        property bool corners: true
        property int height: 28
        property int rounding: 16
    }
}
