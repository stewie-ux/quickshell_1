import QtQuick

Text {
    id: root
    property real iconSize: 20
    property real fill: 0
    property real resolvedFill: fill >= 0.5 ? 1.0 : 0.0

    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    color: "white"

    font {
        family: "Material Symbols Rounded"
        pixelSize: iconSize
        hintingPreference: Font.PreferNoHinting
        variableAxes: {
            "FILL": resolvedFill,
            "wght": resolvedFill > 0.5 ? 700 : 400,
            "opsz": iconSize
        }
    }
}
