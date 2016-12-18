#!/bin/bash
. config
copy_uefi()
{
	cd $UEFI_DIR
	case $board_type in 
	"d05")
		bin_dir=D05
		bin_file=D05.fd
	;;
	*)
		echo "unsupport board type $board_type"
		exit 1
	;;
	esac
	#check file is exist or not 
	SRC_FILE="`find ./ -name $bin_file`"
	if [ "$SRC_FILE"  = "" ];then
		echo "No $bin_file found, exit"
		exit 1
	fi
	#copy to remote server
	scp $SRC_FILE $USER_NAME@$REMOTE_IP:~/
}

copy_image()
{
	IMG_PATH=arch/arm64/boot
	DTB_PATH=dts/hisilicon
	SRC_IMG=Image
	cd $KERNEL_DIR
	case $board_type in

	"d02")
	DST_DTB=hip05-d02.dtb
	SRC_DTB=hip05-d02.dtb
	;;
	"d03")
	SRC_DTB=hip06-d03.dtb
	DST_DTB=hip06-d03.dtb
	;;
	*)
	echo "Don't copy DTB for board $board_type "
	;;
esac
DST_IMG=Image-$board_type
scp $IMG_PATH/$SRC_IMG $USER_NAME@$REMOTE_IP:~/tftp/$DST_IMG
if [ "$DST_DTB" != "" ];then
scp $IMG_PATH/$DTB_PATH/$SRC_DTB  $USER_NAME@$REMOTE_IP:~/tftp/$DST_DTB
fi
}

copy_rootfs()
{
	cd $ROOTFS_DIR
	if [ "$board_type" = "d01" ];then
		SRC_FILE="mini-rootfs-arm32.cpio.gz"
	else
		SRC_FILE="mini-rootfs-arm64.cpio.gz"
	fi
	scp $SRC_FILE $USER_NAME@$REMOTE_IP:~/tftp/
}

usage()
{
	echo "$0 board_type"
	echo "	Example:"
	echo "	$0 d01|d02|d03|d05"
	exit 0
}
if [ $# != 2 ];then
	usage
	exit 0
else
	copy_type=$1
	export board_type=$2
fi
case "$copy_type" in 
"all")
	copy_image
	copy_uefi
	copy_rootfs
;;
"image")
	copy_image
;;
"uefi")
	copy_uefi
;;
"rootfs")
	copy_rootfs
;;
*)
echo "Unsupport copy type $copy_type"
usage
;;
esac
