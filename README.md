
### Post-Windows Installation Steps
1. Change directories from using OneDrive

2. Configure Windows to use UTC instead of localtime. Open a `Command Prompt`
as administrator and run:
    ```
    reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
    ```

**AFTER GETTING TO ARCH LINUX ISO TERMINAL, REMOVE INSTALLATION MEDIA**

### Connect to internet if not on Ethernet
1. ??? (using `iwctl` utility)

### Create Arch Linux partition
1. Identify the disk you want to install Arch Linux on:
    ```fdisk -l```
    Each disk is identified by a label of the form `/dev/<label>`. For a SATA SSD
    or HDD, this is usually some form of `/dev/sd[a-z]` and for NVMe SSDs it can
    be labeled `/dev/nvme0n[0-9]`.

2. After identifying the disk (`/dev/<disk>`), begin partitioning it with
    ```
    fdisk /dev/<disk>
    ```

3. For the installation we will be using the EFI partition created by the
Windows installation, so we only need to format a root partition. Delete
any unnecessary partitions with `d` and create a new partition with `p`. The
default settings will partition the remainder of the disk for Arch Linux,
which works fine unless additional partitions are needed for other
reasons. Press `w` to write the changes. Now, `fdisk -l` will usually list the
newly created partition as `/dev/<nvme_disk>p[0-9]` or `/dev/<sata_disk>[0-9]`.

4. Format the new partition (`/dev/<partition>`):
    ```
    mkfs.ext4 /dev/<partition>
    ```

5. Label the partition, needed by the `refind` boot loader to discover Arch Linux:
    ```
    e2label /dev/<partition> "Arch Linux"
    ```

### Mount the Arch Linux and EFI partition
1. Identify the EFI partition, which is used to determine which OSes are
available to boot at startup. The EFI can be identified by running
    ```
    fdisk -l
    ```
    and finding the partition with `Type` set as `EFI System`.

2. Mount the Arch Linux partition at `/mnt`:
    ```
    mount /dev/<partition> /mnt
    ```

3. Mount the EFI partition into the Arch Linux partition at `/mnt/boot/efi`:
    ```
    mount --mkdir /dev/<efi_partition> /mnt/boot/efi
    ```

### Install Arch Linux onto partition
1. Install Arch Linux and other essential packages into the Arch Linux
partition:
    * `base`, `linux`, `linux-firmware`: essential Arch Linux packages
    * `amd-ucode`: microcode updates for AMD cpu
    * `vim`: text editor, can be replaced with another editor like `emacs`
    * `refind`: boot loader, needed to discover and register Arch Linux; can
    be omitted if `refind` has already been set up in the EFI partition previously
    ```
    pacstrap -K /mnt base linux linux-firmware amd-ucode vim refind
    ```

2. Generate an `fstab` file, which automatically identifies which partitions
to mount into the filesystem on startup and where to mount them:
    ```
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
    Recommended: `cat /mnt/etc/fstab` to check that there should is one entry
    per `mount` performed on the `/mnt` directory in prior steps.

### Set up Arch Linux
1. Change root into the newly installed Arch Linux system:
    ```
    arch-chroot /mnt
    ```

2. Make Arch Linux discoverable by `refind` boot loader.
    - Initialize `refind` in EFI partition:
        ```
        refind-install
        ```
    - `refind` autogenerates a configuration file in `/boot/refind_linux.conf`
      that has incorrect system information. Remove the file:
        ```
        rm /boot/refind_linux.conf
        ```
    - Run `blkid` and identify the the `PARTUUID` of the Arch Linux
      partition. This identifier is necessary for `refind` to identify the
      partition on which Arch Linux is installed.
    - Modify the `refind.conf` with the correct system information. Open
      `/boot/efi/EFI/refind/refind.conf` with an editor. If one isn't
      installed, install it with `pacman -S <editor>`. Add the following
      lines:
        ```
        dont_scan_volumes "Arch Linux"
        menuentry "Arch Linux" {
            icon     /EFI/refind/icons/os_arch.png
            volume   "Arch Linux"
            loader   /boot/vmlinuz-linux
            initrd   /boot/initramfs-linux.img
            options  "root=PARTUUID=<PARTUUID> rw initrd=boot\amd-ucode.img"
            submenuentry "Boot using fallback initramfs" {
                initrd /boot/initramfs-linux-fallback.img
            }
            submenuentry "Boot to terminal" {
                add_options "systemd.unit=multi-user.target"
            }
        }
        ```
    - Optionally: Decrease the time before autoloading an operating system by
      modifying the `timeout` value.
    - Close the editor.

3. Set up time and locale settings:
    - Set up time zone:
        ```
        ln -sf /usr/share/zoneinfo/*Region*/*City* /etc/localtime
        ```
    - Sync hardware clock with system clock:
        ```
        hwclock --systohc
        ```
    - Set up an NTP daemon to sync clock automatically:
        * `chrony`: network time protocol daemon recommended for maintaining
        system time
        ```
        pacman -S chrony
        systemctl enable chronyd
        ```
    - Open `/etc/locale.gen` with editor and uncomment `en_US.UTF-8 UTF-8`
      and, if necessary, other locales. Generate the locales:
        ```
        locale-gen
        ```
    - Create `/etc/locale.conf` with editor and add the `LANG` variable, which
      is used for setting the locale:
        ```
        LANG=en_US.UTF-8
        ```
4. Set up network configuration:
    - Create `/etc/hostname` with editor and add a hostname, which is used to
      identify your machine:
        ```
        echo "<hostname>" > /etc/hostname
        ```

    - Install and enable network management for connecting via Ethernet or Wifi:
        * `networkmanager`: fully functioning out of the box network manager
        ```
        pacman -S networkmanager
        systemctl enable NetworkManager
        ```

5. Create a swapfile. While not strictly necessary, is useful if using
   hibernation. The recommended size is RAM size + two Gib
    - Create the swapfile:
        ```
        dd if=/dev/zero of=/swapfile bs=1M count=<swap_size>k status=progress
        chmod 0600 /swapfile
        mkswap -U clear /swapfile
        swapon /swapfile
        ```
    - Add the following lines to `/etc/fstab`
        ```
        # /swapfile
        /swapfile none swap defaults 0 0
        ```

6. Set up users:
    - Set the root password:
        ```
        passwd
        ```
    - Install `sudo`:
        * `sudo`: allows non-root users to run commands as root or other users
        ```
        pacman -S sudo
        ```
    - Create a non-root user with sudo privileges. This username is likely the
      one identifying your user session:
        ```
        useradd -m -G wheel <username>
        passwd <username>
        ```
    - Allow users in the wheel group to execute root privilege commands:
        ```
        EDITOR=<editor> visudo
        ```
      Uncomment the line to let wheel group users run any command:
        ```
        %wheel ALL=(ALL:ALL) ALL
        ```
7. 
    - Reboot
        ```
        exit
        umount -R /mnt
        reboot
        ```
      and enter UEFI BIOS. Verify that `refind` will load before the Windows
      loader, otherwise you won't have the option to boot Arch Linux. Complete
      the reboot and login as the user created in prior steps.

### Install `yay` for community-driven packages
1. Download and install yay
```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
yay -Y --devel --save
```

### Set up display manager and desktop environment
1. Install desktop environment or window manager. Can install one or many:
    - Installing KDE Plasma:
        * `plasma-desktop`: minimal installation of KDE Plasma
        ```
        sudo pacman -S plasma-desktop sddm-kcm
        ```
    - Installing hyprland:
        ```
        sudo pacman -S hyprland
        ```
      If installing a fresh install of `hyprland` additionally install the
      `foot` terminal emulator and `wofi` program launcher:
        ```
        sudo pacman -S foot wofi
        ```

2. Setting up audio
    - **Only necessary if running a window manager instead of a desktop
      environment**
        * `pipewire`: base package for audio support
        * `wireplumber`: session manager that connects audio streams to appropriate
        outputs
        * `pipewire-audio`: additional packages for handling Bluetooth audio devices
        * `pipewire-alsa`: route all applications using ALSA (a different audio
        package) through PipeWire
        * `pipewire-pulse`: drop-in replacement for `pulseaudio` package
        ```
        sudo pacman -S pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse
        # systemctl --user enable pipewire
        systemctl --user enable wireplumber
        systemctl --user enable pipewire-pulse
        ```

3. Install fonts
    * `noto-fonts`, `noto-fonts-cjk`, `noto-fonts-emoji`: comprehensive font
      family with full Unicode support
    ```
    sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
    ```
    
4. Install and enable display manager:
    * `sddm`: display manager that lets users choose which desktop
      environment or window manager to open.
    ```
    sudo pacman -S sddm
    sudo systemctl enable sddm
    ```

5. Install file manager:
    * `dolphin`: file manager; can be replaced with alternatives
    ```
    sudo pacman -S dolphin
    ```

6. (Optional) Install additional programs
    - Alternative terminal emulator
        * `alacritty`: terminal emulator
        ```
        sudo pacman -S alacritty
        ```
    - Alternative program launcher
        * `anyrun`: alternative program launcher
        ```
        sudo pacman -S rustup
        rustup update stable
        yay -S anyrun-git
        ```
    - Terminal multiplexer
        * `tmux`: terminal multiplexer to switch between programs
        ```
        sudo pacman -S tmux
        yay -S tmux-plugin-manager
        ```
        If `tmux` plugins are already added in `.tmux.conf`, install by
        running `C-<mod> + I` in `tmux`.

**Installation is complete, reboot to start all services**
