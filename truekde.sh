#!/bin/bash

echo -e "Welcome to true kde"

cd /tmp

git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si

paru -S --needed --noconfirm flatpak flatpak-kcm xdg-desktop-portal-gtk plymouth kdeconnect xwaylandvideobridge nix virt-manager unrar p7zip unarchiver lzop lrzip arj firefox okular gimp packagekit-qt6 snapd qemu-desktop ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra acer-wmi-battery-dkms vmware-workstation power-profiles-daemon supergfxctl plasma6-applets-supergfxctl looking-glass dnsmasq swtpm waydroid distrobox podman kio-admin sbctl spectacle cups system-config-printer fwupd pacutils pacman-contrib appmenu-gtk-module kio-gdrive gwenview filelight sshfs nbfc-linux kcalc zsh xmlstarlet jq unzip local-by-flywheel-bin teamviewer kdepim-addons vulkan-intel partitionmanager kdegraphics-thumbnailers ffmpegthumbs qt6-imageformats kimageformats switcheroo-control fzf cryfs encfs gocryptfs lsb-release klassy-bin kf6-servicemenus-reimage proton-vpn-gtk-app davinci-resolve-studio opencl-nvidia jhead


echo -e "\nInstalling Flatpaks\n"
flatpak install org.kde.kdenlive org.kde.krita org.libreoffice.LibreOffice com.discordapp.Discord com.google.Chrome com.obsproject.Studio it.mijorus.gearlever io.github.giantpinkrobots.flatsweep us.zoom.Zoom io.github._0xzer0x.qurancompanion com.usebottles.bottles org.kde.skanpage com.anydesk.Anydesk com.github.unrud.VideoDownloader org.gnome.Epiphany com.boxy_svg.BoxySVG org.gnome.World.PikaBackup

echo -e "\nSetting Important Flatpak overrides\n"
flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications
flatpak override --user --env=XDG_SESSION_TYPE=x11 com.discordapp.Discord
flatpak override --user --env=QT_SCALE_FACTOR=1.5 us.zoom.Zoom


cp ~/.dotfiles/TrueKDE/kglobalshortcutsrc ~/.config/
cp ~/.dotfiles/TrueKDE/kwinrulesrc ~/.config/


echo -e "\nEnabling Services\n"
sudo systemctl enable libvirtd
sudo usermod -aG libvirt gamal
sudo systemctl enable nix-daemon.service
sudo usermod -aG nix-users gamal
sudo systemctl enable apparmor.service
sudo systemctl start vmware-networks-configuration.service
sudo systemctl enable vmware-networks.service
sudo systemctl enable vmware-usbarbitrator.service
sudo systemctl enable nvidia-persistenced
sudo systemctl enable bluetooth
sudo systemctl enable supergfxd
sudo systemctl enable cups.socket
sudo systemctl enable snapd.socket
sudo systemctl enable snapd.apparmor.service
sudo systemctl enable nbfc_service
sudo systemctl enable switcheroo-control
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

echo -e "\nEnabling Secure Boot\n"
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl verify
sudo sbctl sign -s /boot/vmlinuz-linux-zen
sudo sbctl sign -s /boot/vmlinuz-linux-lts
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi

echo -e "\nEnabling classic snap support"
sudo ln -s /var/lib/snapd/snap /snap

echo -e "\nInstalling Snaps"
sudo snap install motrix chromium thunderbird todoist
sudo snap install blender --classic

echo -e "setting wayland as SDDM default"
sudo mkdir /etc/sddm.conf.d/
sudo cp ~/.dotfiles/TrueKDE/10-wayland.conf /etc/sddm.conf.d/
sudo cp ~/.dotfiles/TrueKDE/kde_settings.conf /etc/sddm.conf.d/ #Setting breeze theme
sudo cp ~/.dotfiles/TrueKDE/index.theme /usr/share/icons/default/ #Setting breeze cursor theme

echo -e "\nEnabling Acer RGB and Fan Control\n"
cd ~/.dotfiles/acer-rgb-linux/
makepkg -si

echo -e "making swap file"
sudo cp ~/.dotfiles/TrueKDE/zram-generator.conf /etc/systemd/

echo -e "enabling vfio"
sudo cp ~/.dotfiles/TrueKDE/supergfxd.conf /etc/

echo -e "configuring pacman"
sudo cp ~/.dotfiles/TrueKDE/pacman.conf /etc/

echo -e "\nChanging Sell to Zsh\n"
sudo chsh -s /usr/bin/zsh gamal

exit
