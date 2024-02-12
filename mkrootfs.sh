#!/usr/bin/env bash

if [ -z "$MMDEBSTRAP" ]
then
	MMDEBSTRAP=mmdebstrap
fi

mkdir build

set -eux

genrootfs() {
echo "
deb https://mirror.yandex.ru/debian/ testing main contrib non-free non-free-firmware
deb https://mirror.yandex.ru/debian/ testing-updates main contrib non-free non-free-firmware
deb https://mirror.yandex.ru/debian/ testing-backports main contrib non-free non-free-firmware
deb https://mirrors.bfsu.edu.cn/debian-security/ testing-security main contrib non-free non-free-firmware
" | $MMDEBSTRAP --architectures=arm64 -v -d \
	--include="ca-certificates locales dosfstools binutils file \
	tree sudo bash-completion memtester openssh-server wireless-regdb \
	wpasupplicant systemd-timesyncd usbutils parted systemd-sysv \
	iperf3 stress-ng avahi-daemon tmux screen i2c-tools net-tools \
	ethtool ckermit lrzsz minicom picocom btop neofetch iotop htop \
	bmon e2fsprogs nvi tcpdump alsa-utils squashfs-tools evtest \
	bluez bluez-hcidump bluez-tools btscanner bluez-alsa-utils \
	device-tree-compiler debian-archive-keyring wireguard-tools \
	linux-cpupower \
	pulseaudio-module-bluetooth" > ./build/rootfs.tar
}

# if you want skip debian rootfs build, please comment this line:
genrootfs
cd overlay
for i in *
do
tar --append --file=../build/rootfs.tar $i
done
cd ..
