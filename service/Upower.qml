pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root
    readonly property var battery: UPower.displayDevice
    readonly property real percentage: battery?.percentage ?? 0
    readonly property bool isCharging: battery?.state === UPowerDeviceState.Charging
    readonly property bool isFullyCharged: battery?.state === UPowerDeviceState.FullyCharged
    readonly property bool isPluggedIn: isCharging || isFullyCharged

    property real health: (function () {
            const devList = UPower.devices.values;
            for (let i = 0; i < devList.length; ++i) {
                const dev = devList[i];
                if (dev.isLaptopBattery && dev.healthSupported) {
                    const health = dev.healthPercentage;
                    if (health === 0) {
                        return 0.01;
                    } else if (health < 1) {
                        return health * 100;
                    } else {
                        return health;
                    }
                }
            }
            return 0;
        })()

    // Logs for debuging
    // Component.onCompleted: {
    //     console.log("------------------");
    //     console.log("Percentage =", percentage);
    //     console.log("Pluged-in =", isPluggedIn);
    //     console.log("Health =", health);
    // }
}
