import { Label } from "./Label.js";
import { VolumeLabel } from "./VolumeLabel.js";

export const Bar = () => Widget.Window({
  name: 'Bar',
  anchor: ['top', 'left', 'right'],
  child: VolumeLabel(),
});