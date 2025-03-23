# image-template

# Rebase Instructions
To rebase an existing atomic Fedora installation to the latest build:

First rebase to the unsigned image, to get the proper signing keys and policies installed:

`rpm-ostree rebase ostree-unverified-registry:ghcr.io/carbonux/workstation:latest`

Reboot to complete the rebase:

`systemctl reboot`

Then rebase to the signed image, like so:

`rpm-ostree rebase ostree-image-signed:docker://ghcr.io/carbonux/workstation:latest`

Reboot again to complete the installation

`systemctl reboot`

# NVidia version
`rpm-ostree rebase ostree-unverified-registry:ghcr.io/carbonux/workstation-nvidia:latest`
`systemctl reboot`

# Developer version
`rpm-ostree rebase ostree-unverified-registry:ghcr.io/carbonux/developer:latest`
`systemctl reboot`

