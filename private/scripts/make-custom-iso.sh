#!/bin/bash
apt-get install genisoimage
cd /tmp
mkdir original-iso custom-iso
if [ ! -f /tmp/ubuntu-12.04.3-server-amd64.iso ]; then
    echo "Iso image not found, downloading"
    wget http://releases.ubuntu.com/12.04/ubuntu-12.04.3-server-amd64.iso
fi
mount -o loop ubuntu-12.04.3-server-amd64.iso ./original-iso
cp -r ./original-iso/* ./custom-iso/
cp -r ./original-iso/.disk/ ./custom-iso/
umount ./original-iso/

cat > ./custom-iso/isolinux/menu.cfg << EOF
label custom1
menu label ^Install Ubuntu 12.04, apply puppet manifest 'puppetdev'
kernel /install/vmlinuz
append url=http://devops2.googlecode.com/git/files/preseed-ubuntu-puppetdev.seed initrd=/install/initrd.gz locale=en_US auto=true netcfg/get_hostname=puppetdev console-setup/ask_detect=false keyboard-configuration/layoutcode=us

label custom2
menu label ^Install Ubuntu 12.04, apply puppet manifest 'base'
kernel /install/vmlinuz
append url=http://devops2.googlecode.com/git/files/preseed-ubuntu-base.seed initrd=/install/initrd.gz locale=en_US auto=true netcfg/get_hostname=base console-setup/ask_detect=false keyboard-configuration/layoutcode=us

label custom3
menu label ^Install Ubuntu 12.04, apply puppet manifest 'monophylizer'
kernel /install/vmlinuz
append url=http://devops2.googlecode.com/git/files/preseed-ubuntu-monophylizer.seed initrd=/install/initrd.gz locale=en_US auto=true netcfg/get_hostname=monophylizer console-setup/ask_detect=false keyboard-configuration/layoutcode=us
EOF

mkisofs -R -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o ubuntu-12.04.3-custom-amd64.iso custom-iso/
rm -rf original-iso custom-iso
echo "The custom iso image: /tmp/ubuntu-12.04.3-custom-amd64.iso"
cd -
