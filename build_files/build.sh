#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Install packages from fedora repo
dnf5 -y install distrobox

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable scottames/ghostty
dnf5 -y copr enable errornointernet/walker

dnf5 -y install ghostty walker elephant

dnf5 -y copr disable scottames/ghostty
dnf5 -y copr disable errornointernet/walker

### Patch files

sed -i 's/^set \$term .*/set $term ghostty/' /etc/sway/config
# fail the build if the patch missed
grep -q '^set \$term ghostty' /etc/sway/config

### Enable systemd units

systemctl --global enable elephant.service
