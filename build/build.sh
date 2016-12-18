#!/bin/bash
usage()
{
	echo "	$0 Usage:"
	echo "	This build tool is used to build Image, uefi and minirootfs"
	echo "	please specify the build type and board_type"
	echo "	"
	echo "		Example:"
	echo "			$0 all|image|uefi|rootfs d02|d03|d05"
}
TOP_DIR=`pwd`

. config
if [ $# != 2 ];then
	usage
	exit 0
else
	build_type=$1
	export board_type=$2
fi
check_config()
{
	if [ ! -e .config ];then
		if [ "$board_type" = "d01" ];then
			make hisi_defconfig
		else
			make defconfig
		fi
	fi
}

build_kernel()
{
	echo "Building kernel ...."
	cd $KERNEL_DIR

if [ "$board_type" = "d01" ];then
	export ARCH=arm
	export CROSS_COMPILE=arm-linux-gnueabihf-
	check_config
	make -j14 zImage
	make hip04-d01.dtb
	cat arch/arm/boot/zImage arch/arm/boot/dts/hip04-d01.dtb >.kernel
	exit 0
else 
	export ARCH=arm64
	export CROSS_COMPILE=aarch64-linux-gnu-
	check_config
fi
#build the kernel
make -j16
echo "Building dtb ..."
case $board_type in 
"d02")
	make hisilicon/hip05-d02.dtb
;;
"d03")
	make hisilicon/hip06-d03.dtb
;;
*)
	echo "Unsupported dtb for borad $board_type"
;;
esac
	cd - >/dev/null
#	./build.sh $board_type
}

build_uefi()
{
	echo "Building UEFI ...."
	cd $UEFI_DIR
	./build.sh $board_type
	cd - >/dev/null
}
build_rootfs()
{
	echo "Building rootfs ...."
	cd $ROOTFS_DIR
	./build.sh $board_type
	cd - >/dev/null
}

case "$build_type" in 
"all")
	build_kernel
	build_uefi
	build_rootfs
	exit 0
;;
"image")
	build_kernel
;;
"uefi")
	build_uefi
;;
"rootfs")
	build_rootfs
;;
*)
	echo "Unsupport build type $build_type"
	usage
	exit 0
;;
esac
