# Arch configuration files

These dotfiles are meant to be installed on a fresh arch linux installation with btrfs filesystem.
The only required packages are listed below.

### Dependencies

- base-devel
- btrfs-progs
- grub
- grub-btrfs
- efibootmgr
- openssh
- git
- networkmanager
- zsh (has to be your default shell)
- neovim

### Installation

- Clone the repo in your home folder
- Change the values inside ```.config/git/config``` to reflect your github username and email
- Change the values inside ```resources/texlive/texlive.profile``` to reflect the actual name of
your local user
- Change the "btrfs_dev" variable in the ```base-install.sh``` script to the name
of the device partition where the top level btrfs subvolume resides in your machine
- Run ```base-install.sh``` to install the base system (no desktop environment), THEN
run ```graphical-install.sh``` to install the desktop environment (niri + noctalia)
