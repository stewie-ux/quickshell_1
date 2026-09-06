import qs.service
import qs.modules.common
import qs.modules.common.widgets

MaterialSymbol {
    fill: 1
    iconSize: 16
    color: Appearance.bar.primary

    text: {
        const percentage = Upower.percentage * 100;

        if (Upower.isPluggedIn) {
            if (percentage <= 20)
                return "battery_charging_20";

            if (percentage <= 30)
                return "battery_charging_30";

            if (percentage <= 50)
                return "battery_charging_50";

            if (percentage <= 60)
                return "battery_charging_60";

            if (percentage <= 90)
                return "battery_charging_90";

            return "battery_charging_full";
        }

        if (percentage >= 100)
            return "battery_full";

        return "battery_" + Math.max(1, Math.ceil(percentage / 100 * 6)) + "_bar";
    }
}
