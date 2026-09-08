pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    // ------------------------------------------------------------------
    // Devices
    // ------------------------------------------------------------------

    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null

    readonly property var activeDevice: Networking.devices.values.find(d => d.connected) ?? null

    // ------------------------------------------------------------------
    // Connection Type
    // ------------------------------------------------------------------

    readonly property bool wifiEnabled: Networking.wifiEnabled

    readonly property bool connected: activeDevice !== null

    readonly property bool usingWifi: activeDevice?.type === DeviceType.Wifi

    readonly property bool usingEthernet: activeDevice?.type === DeviceType.Wired

    readonly property string connectionType: {
        if (!connected)
            return "none";

        return usingWifi ? "wifi" : "ethernet";
    }

    // ------------------------------------------------------------------
    // WiFi Networks (available + connected)
    // ------------------------------------------------------------------

    readonly property bool scanning: wifiDevice?.scannerEnabled ?? false

    readonly property var networks: wifiDevice?.networks ?? null

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
    // Controls
    // ------------------------------------------------------------------

    function setWifiEnabled(enabled) {
        Networking.wifiEnabled = enabled;
    }

    function setScanning(scan) {
        if (wifiDevice)
            wifiDevice.scannerEnabled = scan;
    }

    function connectNetwork(network) {
        if (network)
            network.connect();
    }

    function connectWithPassword(network, password) {
        if (network)
            network.connectWithPsk(password);
    }

    function disconnectNetwork(network) {
        if (network)
            network.disconnect();
    }

    function forgetNetwork(network) {
        if (network)
            network.forget();
    }

    // ------------------------------------------------------------------
    // Debug
    // ------------------------------------------------------------------

    Component.onCompleted: {
        console.log("------------- Network -------------");
        console.log("Connected:", connected);
        console.log("Type:", connectionType);
        console.log("SSID:", ssid);
        console.log("Signal:", signalStrength);
        console.log("Device:", activeDevice?.name);
        console.log("-----------------------------------");
        console.log("Scaning:", scanning);
        console.log("Networks:", wifiDevice?.networks);
        console.log("Active Network:", activeNetwork);
        console.log("-----------------------------------");
    }
}
