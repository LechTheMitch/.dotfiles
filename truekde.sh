#!/bin/bash

echo -e "Welcome to true kde"

cd /tmp
APDATVER=2.9.2
KROHNVER=0.9.8.3
TEMPVIRTDESK=0.3.2
VIRTONLYPRI=0.4.5
KZONESVER=0.9
INVOKINGUSER=$(whoami)
CHROMEFLAGS="--ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation,VaapiVideoDecoder,VaapiVideoEncoder --no-default-browser-check"
CHROMEFLAGS_DIR="~/.var/app/com.google.Chrome/config/"
git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si


echo -e "\nSetting up Chaotic AUR\n"
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo -e "\nInstalling System Packages\n"
paru -S --needed --noconfirm flatpak flatpak-kcm falkon xdg-desktop-portal-gtk plymouth kdeconnect xwaylandvideobridge nix virt-manager unrar 7zip unarchiver lzop lrzip arj okular packagekit-qt6 snapd qemu-desktop ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra acer-wmi-battery-dkms vmware-workstation power-profiles-daemon supergfxctl plasma6-applets-supergfxctl looking-glass dnsmasq swtpm waydroid distrobox podman kio-admin sbctl spectacle cups system-config-printer fwupd pacutils pacman-contrib appmenu-gtk-module gwenview filelight sshfs nbfc-linux kcalc zsh xmlstarlet jq unzip local-by-flywheel-bin kdepim-addons vulkan-intel partitionmanager kdegraphics-thumbnailers ffmpegthumbs qt6-imageformats kimageformats switcheroo-control fzf cryfs encfs gocryptfs lsb-release klassy-bin kf6-servicemenus-reimage jhead firewalld dracut dracut-ukify sbsigntools tpm2-tools libpwquality luksmeta nmap clevis kclock libheif scrcpy python-pyclip btop ntfs-3g exfat-utils libdbusmenu-gtk3

paru -Rsc --noconfirm linux qt5-tools mkinitcpio

echo -e "\nInstalling Flatpaks\n"
flatpak install org.onlyoffice.desktopeditors org.kde.kdenlive org.kde.krita com.discordapp.Discord com.google.Chrome com.obsproject.Studio it.mijorus.gearlever io.github.giantpinkrobots.flatsweep us.zoom.Zoom io.github._0xzer0x.qurancompanion com.usebottles.bottles org.kde.skanpage com.anydesk.Anydesk com.github.unrud.VideoDownloader org.inkscape.Inkscape org.gnome.Epiphany com.boxy_svg.BoxySVG org.gnome.World.PikaBackup md.obsidian.Obsidian io.missioncenter.MissionCenter org.mozilla.Thunderbird org.gimp.GIMP org.kde.ktorrent app.zen_browser.zen io.github.celluloid_player.Celluloid org.gaphor.Gaphor io.github.giantpinkrobots.varia

echo -e "\nSetting Important Flatpak overrides\n"
flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications
flatpak override app.zen_browser.zen --user --talk-name=org.kde.plasma.browser.integration
flatpak override --user --env=XDG_SESSION_TYPE=x11 com.discordapp.Discord
flatpak override --user --talk-name=com.canonical.AppMenu.Registrar app.zen_browser.zen com.google.Chrome
flatpak override --user --unset-env=LIBVA_DRIVERS_PATH
flatpak override --user --env=QT_SCALE_FACTOR=1.5 us.zoom.Zoom


cp ~/.dotfiles/TrueKDE/kglobalshortcutsrc ~/.config/
cp ~/.dotfiles/TrueKDE/kwinrulesrc ~/.config/
mkdir -p ~/.var/app/com.google.Chrome/config/
cp ~/.dotfiles/TrueKDE/chrome-flags.conf ~/.var/app/com.google.Chrome/config/

echo -e "\nInstalling Plasmoids, Kwin Scripts and Desktop Effects\n"
wget https://github.com/exequtic/apdatifier/releases/download/$APDATVER/apdatifier_$APDATVER.plasmoid
kpackagetool6 -t Plasma/Applet -i apdatifier_$APDATVER.plasmoid
git clone https://github.com/dhruv8sh/plasma6-desktopindicator-gnome.git
mkdir ~/.local/share/plasma/plasmoids/org.kde.plasma.ginti
cp -r ./plasma6-desktopindicator-gnome/. ~/.local/share/plasma/plasmoids/org.kde.plasma.ginti
wget https://github.com/anametologin/krohnkite/releases/download/$KROHNVER/krohnkite-$KROHNVER.kwinscript
kpackagetool6 --type=KWin/Script -i krohnkite-$KROHNVER.kwinscript
wget https://github.com/gerritdevriese/kzones/releases/download/v$KZONESVER/kzones.kwinscript
kpackagetool6 --type=KWin/Script -i kzones.kwinscript
wget https://github.com/Ubiquitine/temporary-virtual-desktops/releases/download/v$TEMPVIRTDESK/temporary-virtual-desktops-$TEMPVIRTDESK.kwinscript
kpackagetool6 --type=KWin/Script -i temporary-virtual-desktops-$TEMPVIRTDESK.kwinscript
wget https://github.com/Ubiquitine/virtual-desktops-only-on-primary/releases/download/v$VIRTONLYPRI/virtual-desktops-only-on-primary-$VIRTONLYPRI.kwinscript
kpackagetool6 --type=KWin/Script -i virtual-desktops-only-on-primary-$VIRTONLYPRI.kwinscript
git clone https://github.com/micha4w/kde-alt-f4-desktop.git
kpackagetool6 --type=KWin/Script -i kde-alt-f4-desktop

echo -e "\nEnabling Services\n"
sudo systemctl enable libvirtd
sudo usermod -aG libvirt gamal
sudo systemctl enable nix-daemon.service
sudo usermod -aG nix-users gamal
sudo systemctl enable apparmor.service
sudo systemctl start vmware-networks-configuration.service
sudo systemctl enable vmware-networks.service
sudo systemctl enable vmware-usbarbitrator.service
sudo systemctl enable bluetooth
sudo systemctl enable supergfxd
sudo systemctl enable firewalld
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
sudo sbctl verify | sudo sed 's/✗ /sbctl sign -s /e'

echo -e "\nEnabling classic snap support"
sudo ln -s /var/lib/snapd/snap /snap

echo -e "\nInstalling Snaps"
sudo snap install chromium snapd-desktop-integration
sudo snap install blender --classic
sudo snap install android-studio --classic

echo -e "\nSetting Chromium Snap Flags\n"
touch ~/.chromium-browser.init
echo "CHROMIUM_FLAGS=\"$CHROMEFLAGS\"" > ~/.chromium-browser.init

echo -e "setting wayland as SDDM default"
sudo mkdir /etc/sddm.conf.d/
sudo cp ~/.dotfiles/TrueKDE/10-wayland.conf /etc/sddm.conf.d/
sudo cp ~/.dotfiles/TrueKDE/kde_settings.conf /etc/sddm.conf.d/ #Setting breeze theme
sudo cp ~/.dotfiles/TrueKDE/index.theme /usr/share/icons/default/ #Setting breeze cursor theme

mkdir ~/.config/home-manager
ln -s ~/.dotfiles/home.nix ~/.config/home-manager/
ln -s ~/.dotfiles/flake.nix ~/.config/home-manager/

echo -e "\nEnabling Acer RGB and Fan Control\n"
sudo nbfc config --set "Acer Predator PH315-54"
cd ~/.dotfiles/acer-rgb-linux/
makepkg -si

echo -e "making swap file"
sudo cp ~/.dotfiles/TrueKDE/zram-generator.conf /etc/systemd/

echo -e "enabling vfio && looking-glass"
sudo echo "# Type Path               Mode UID  GID Age Argument

f /dev/shm/looking-glass 0660 $INVOKINGUSER kvm -" | sudo tee /etc/tmpfiles.d/10-looking-glass.conf

echo -e "configuring pacman"
sudo cp ~/.dotfiles/TrueKDE/pacman.conf /etc/

echo -e "\nSetting up firewall\n"
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --permanent --zone=trusted --add-interface=waydroid0
sudo firewall-cmd --reload

echo -e "\nSetting up Appimages\n"
mkdir ~/Applications
cd ~/Applications

echo -e "\nChanging Sell to Zsh\n"
sudo chsh -s /usr/bin/zsh gamal

echo -e "\nSetting Kernel Parameters\n"
#sudo cp ~/.dotfiles/TrueKDE/cmdline.conf /etc/kernel/
sudo cp ~/.dotfiles/TrueKDE/dracut-ukify.conf /etc/
sudo cp ~/.dotfiles/TrueKDE/dracutmodules.conf /etc/dracut.conf.d/
sudo dracut-ukify -a


exit
