pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property var activeDevice: Bluetooth.devices.values.find(device => device.connected) ?? null
    readonly property bool connected: activeDevice !== null
    readonly property string deviceName: activeDevice?.name ?? ""
    readonly property real battery: activeDevice?.batteryAvailable ? activeDevice.battery : -1

    // Component.onCompleted: {
    //     console.log("Adapter:", adapter);
    //     console.log("Bluetooth Enable:", enabled);
    //     console.log("Connected:", connected);
    //     console.log("Device:", activeDevice);
    //     console.log("Name:", deviceName);
    //     console.log("Connected:", connected);
    //     console.log("Battery:", battery);
    // }
}
