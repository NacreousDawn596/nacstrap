umount -a
lsblk
read -p "enter the boot partition\n/dev/" BOOT
read -p "enter the desired main partition\n/dev/" MAIN
echo "cleaning partitions..."
mkfs.vfat -F 32 /dev/$BOOT
mkfs.ext4 /dev/$MAIN
echo "mounting partitions..."
mount /dev/$MAIN /mnt
mkdir -p /mnt/boot/efi
mount /dev/$BOOT /mnt/boot/efi
echo "setting up the main partition..."
mkdir -m 0755 -p /mnt/var/{cache/pacman/pkg,lib/pacman,log} /mnt/{dev,run,etc/pacman.d}
mkdir -m 1777 -p /mnt/tmp
mkdir -m 0555 -p /mnt/{sys,proc}
cp -a /etc/pacman.d/gnupg "/mnt/etc/pacman.d/"
echo "updating and installing necessary packages..."
unshare --fork --pid pacman -r /mnt -Syu linux linux-firmware base base-devel python python-pip git vim neofetch grub efibootmgr
echo "done!!"
