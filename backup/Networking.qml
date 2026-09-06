pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    // ------------------------------------------------------------------
    // Devices
    // ------------------------------------------------------------------

    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === 1)

    readonly property var activeDevice: Networking.devices.values.find(d => d.connected) ?? null

    // ------------------------------------------------------------------
    // Connection Type
    // ------------------------------------------------------------------

    readonly property bool wifiEnabled: Networking.wifiEnabled

    readonly property bool connected: activeDevice !== null

    readonly property bool usingWifi: activeDevice?.type === 1

    readonly property bool usingEthernet: activeDevice?.type === 2

    readonly property string connectionType: {
        if (!connected)
            return "none";

        return usingWifi ? "wifi" : "ethernet";
    }

    // ------------------------------------------------------------------
    // Active WiFi Network
    // ------------------------------------------------------------------

    readonly property var activeNetwork: {
        if (!usingWifi || !wifiDevice)
            return null;

        return wifiDevice.networks.values.find(n => n.connected) ?? null;
    }

    // ------------------------------------------------------------------
    // Information
    // ------------------------------------------------------------------

    readonly property string ssid: {
        if (usingWifi)
            return activeNetwork?.name ?? "";

        if (usingEthernet)
            return "Ethernet";

        return "Disconnected";
    }

    readonly property int signalStrength: {
        if (!usingWifi || !activeNetwork)
            return 0;

        return Math.round(activeNetwork.signalStrength * 100);
    }

    // ------------------------------------------------------------------
    // Debug
    // ------------------------------------------------------------------

    // Component.onCompleted: {
    //     console.log("------------- Network -------------");
    //     console.log("Connected:", connected);
    //     console.log("Type:", connectionType);
    //     console.log("SSID:", ssid);
    //     console.log("Signal:", signalStrength);
    //     console.log("Device:", activeDevice?.name);
    //     console.log("-----------------------------------");
    // }
}
