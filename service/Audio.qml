pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.ready ? sink.audio.muted : false
    readonly property real volume: sink?.ready ? sink.audio.volume : 0

    signal externalVolumeChanged

    function setVolume(percent: int): void {
        if (!sink?.ready || !sink?.audio)
            return;
        internalCooldown.restart();
        const clamped = Math.max(0, Math.min(100, percent));
        sink.audio.volume = clamped / 100;
        if (clamped > 0)
            sink.audio.muted = false;
    }

    function toggleMute(): void {
        if (!sink?.ready || !sink?.audio)
            return;
        internalCooldown.restart();
        sink.audio.muted = !sink.audio.muted;
    }

    // Same idea as Brightness's cooldown: our own writes trigger this
    // service's volume/muted signals too, so ignore changes shortly
    // after we caused them ourselves — only genuine external changes
    // (media keys, another app, pavucontrol) should reach the OSD.
    Timer {
        id: internalCooldown
        interval: 400
    }

    onVolumeChanged: {
        if (!internalCooldown.running)
            root.externalVolumeChanged();
    }
    onMutedChanged: {
        if (!internalCooldown.running)
            root.externalVolumeChanged();
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
