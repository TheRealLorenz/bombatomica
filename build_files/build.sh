#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Remove unwanted packages

dnf5 -y remove foot

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 -y install tmux neovim ripgrep fd zsh just

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable scottames/ghostty
dnf5 -y copr enable atim/starship

dnf -y install ghostty starship

dnf5 -y copr disable scottames/ghostty
dnf5 -y copr disable atim/starship

### Patch files

sed -i 's/foot/ghostty/g' /etc/sway/config

#### Example for enabling a System Unit File

systemctl enable podman.socket
