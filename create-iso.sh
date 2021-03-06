#!/bin/bash
set -e

echo "Deleting the build folder if one exists"
[ -d ./.tmp/ ] && sudo rm -rf ./.tmp/

echo "Coping files and folder to work folder"
sudo mkdir ./.tmp/
sudo cp -rf ./src/* ./.tmp/

echo "Checking if archiso is installed"
if ! paccheck archiso &> /dev/null; then
	echo "Installing archiso"
	yay -S --noconfirm archiso
fi

echo "Copying files and folder to ./build as root"

sudo chmod 750 ./.tmp/airootfs/etc/sudoers.d
sudo chmod 750 ./.tmp/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ./.tmp/airootfs/etc/polkit-1/rules.d

echo "In order to build an iso we need to clean your cache"
yes | sudo pacman -Scc

echo "Building the iso"
cd ./.tmp
sudo ./build.sh -v

echo "Moving the iso to ./iso"
cd ..
[ -d  ./iso ] || mkdir ./iso
cp -vRf ./.tmp/out/* ./iso/

echo "Deleting the .tmp folder"
[ -d ./.tmp/ ] && sudo rm -rf ./.tmp/
