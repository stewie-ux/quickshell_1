import QtQuick
import qs.modules.common.model

StyledToggle {
    id: root

    required property string label
    property string materialSymbol: ""
    property string materialSymbolOn: ""
    property string materialSymbolOff: ""
    property string arrowMaterialSymbol: "chevron_right"

    readonly property string effectiveSymbol: root.checked ? (root.materialSymbolOn.length > 0 ? root.materialSymbolOn : root.materialSymbol) : (root.materialSymbolOff.length > 0 ? root.materialSymbolOff : root.materialSymbol)

    MaterialSymbol {
        anchors.centerIn: root.mainZone
        fill: 0
        iconSize: 20
        color: "white"
        text: root.effectiveSymbol

        Behavior on text {
            // no direct text animation in QML, but keeping this here
            // documents intent if you later switch to an opacity-crossfade
        }
    }

    MaterialSymbol {
        visible: root.showArrow
        anchors.centerIn: root.arrowZone
        iconSize: 18
        color: "white"
        text: root.arrowMaterialSymbol
    }
}
