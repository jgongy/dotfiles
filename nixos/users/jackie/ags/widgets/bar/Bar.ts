import { date } from "widgets/variables";
import { VolumeIndicator } from "widgets/volumeIndicator/VolumeIndicator";

export const Bar = Widget.Window({
    name: "bar",
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
        centerWidget: VolumeIndicator,
        endWidget: Widget.Label({
            label: date.bind(),
        }),
    }),
});
