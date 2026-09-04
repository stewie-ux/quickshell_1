import QtQuick

import qs.modules.common.model
import qs.modules.common

StyledSlider {
    id: root
    required property string materialSymbol
    property string secondaryMaterialSymbol: ""
    property real secondaryIconLocation: 0.3

    trackWidth: 30
    stopIndicatorValues: secondaryMaterialSymbol.length > 0 ? [secondaryIconLocation] : []

    MaterialSymbol {
        id: icon
        property bool nearFull: root.value >= 0.9
        anchors {
            verticalCenter: root.verticalCenter
            right: nearFull ? root.handle.right : root.right
            rightMargin: nearFull ? 14 : 8
        }
        iconSize: 20
        color: nearFull ? "pink" : "white" // these colors are temp
        text: root.materialSymbol

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 150
            }
        }
    }

    MaterialSymbol {
        id: secondaryIcon
        visible: root.secondaryMaterialSymbol.length > 0
        property bool nearIcon: Math.abs(root.secondaryIconLocation - root.value) < 0.06
        anchors {
            verticalCenter: root.verticalCenter
            right: nearIcon ? root.handle.right : root.right
            rightMargin: nearIcon ? 14 : (1 - root.secondaryIconLocation) * root.effectiveDraggingWidth + root.rightPadding + 8
        }
        iconSize: 20
        color: root.value >= root.secondaryIconLocation - 0.1 ? "yellow" : "black"
        text: root.secondaryMaterialSymbol

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}
