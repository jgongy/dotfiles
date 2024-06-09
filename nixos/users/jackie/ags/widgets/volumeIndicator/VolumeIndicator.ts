import audio from "resource:///com/github/Aylur/ags/service/audio.js";

export const VolumeIndicator = Widget.Button({
    on_clicked: () => {
        audio.speaker.is_muted = !audio.speaker.is_muted;
    },
    child: Widget.Icon().hook(audio.speaker, self => {
        const volume = audio.speaker.volume * 100;
        const thresholds = [
            [0, "muted"],
            [1, "low"],
            [33, "medium"],
            [66, "high"],
            [101, "overamplified"],
        ] as const;
        const icon = thresholds.find(([threshold]) => volume <= threshold)?.[1];
        self.icon = audio.speaker.is_muted
            ? "audio-volume-muted-symbolic"
            : `audio-volume-${icon}-symbolic`;
        self.tooltip_text = `Volume ${Math.floor(volume)}%`;
    }),
});
