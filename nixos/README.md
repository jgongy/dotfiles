### Steps for installing NixOS
mount -t btrfs /dev/nvme0n1p2 /mnt
mkfs.btrfs -L "NixOS" /dev/nvme0n1p2
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

mount -o subvol=root /dev/nvme0n1p2 /mnt
mount -o subvol=nix /dev/nvme0n1p2 /mnt/nix --mkdir
mount -o subvol=persist /dev/nvme0n1p2 /mnt/persist --mkdir
mount -o subvol=log /dev/nvme0n1p2 /mnt/var/log --mkdir
mount /dev/nvme0n1p2 /mnt/boot/efi --mkdir
