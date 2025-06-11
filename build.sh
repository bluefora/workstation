#!/bin/bash

set -ouex pipefail

# Update release file
sed -i -e 's/ID=silverblue/ID=workstation/g' /usr/lib/os-release
sed -i -e 's/Silverblue/Bluefora/g' /usr/lib/os-release
sed -i -e 's/Fedora Linux 42 (Workstation Edition)/Bluefora Linux 42 (Workstation Edition)/g' /usr/lib/os-release
sed -i -e 's/DEFAULT_HOSTNAME="fedora"/DEFAULT_HOSTNAME="bluefora"/g' /usr/lib/os-release

rpm-ostree ex rebuild

# Cleanup
dnf5 -y remove \
    firefox firefox-langpacks \
    f42-backgrounds-gnome \
    desktop-backgrounds-gnome \
    nvtop htop


files=(flight futurecity glasscurtains mermaid montclair petals)
for file in "${files[@]}"; do
    rm /usr/share/gnome-background-properties/${file}.xml
done

# Set timezone
ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime


# Install Apps
dnf5 -y install gnome-tweaks gnome-extensions-app unrar nmap adb

# Install Gnome Extensions
dnf5 -y install gnome-shell-extension-appindicator \
              gnome-shell-extension-blur-my-shell \
              gnome-shell-extension-caffeine \
              gnome-shell-extension-dash-to-panel \
              gnome-shell-extension-just-perfection

# Disable welcome screen
cat > /etc/dconf/db/local.d/00-disable-gnome-tour <<EOF
[org/gnome/shell]
welcome-dialog-last-shown-version='$(rpm -qv gnome-shell | cut -d- -f3)'
EOF


# Grab the modules
typeset modules=(quicksetup wallpapers wallpaper-cycler)
for module in "${modules[@]}"; do
    git clone https://github.com/bluefora/${module} /tmp/${module}
    rsync -av --keep-dirlinks /tmp/${module}/rootcopy/* /
    if [[ -f /tmp/${module}/build.sh ]]; then
        cd /tmp/${module}
        bash ./build.sh
        cd -
    fi
done


# Update dconf
dconf update

# Install codecs
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing


# Swap flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --no-filter --enable flathub


# Install uupd
dnf5 -y copr enable ublue-os/packages
dnf5 -y install uupd

# Install zerotier
curl -s https://install.zerotier.com | sudo bash
