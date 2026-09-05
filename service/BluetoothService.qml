pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property bool discovering: adapter?.discovering ?? false

    readonly property var devices: adapter?.devices ?? null

    readonly property var activeDevice: Bluetooth.devices.values.find(device => device.connected) ?? null
    readonly property bool connected: activeDevice !== null
    readonly property string deviceName: activeDevice?.name ?? ""
    readonly property real battery: activeDevice?.batteryAvailable ? activeDevice.battery : -1

    function setScanning(scanning) {
        if (adapter)
            adapter.discovering = scanning;
    }

    function connectDevice(device) {
        if (device)
            device.connect();
    }

    function disconnectDevice(device) {
        if (device)
            device.disconnect();
    }

    function forgetDevice(device) {
        if (device)
            device.forget();
    }
}
