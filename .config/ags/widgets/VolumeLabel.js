export const VolumeLabel = () => {
  const pactlListener = Variable({ msg: '' }, {
    listen: ['pactl subscribe', (msg) => ({
        msg: msg,
    })],
  });

  pactlListener.connect('changed', ({ value }) => {
    print(value.msg)
  });

  const label = Widget.Label({
    label: pactlListener.bind().as(({ msg }) => {
      return `${msg}`;
    }),
  });

  label.connect('notify::label', ({ label }) => {
    print('label changed to ', label);
  });

  return label;
};