#!/bin/sh

usage(){
echo "$0 loop_count test_count threads"
}
if [ $# = 0 ];then
	usage
	exit 0
fi
lptime=$1
iperftime=$2
dir=iperf_log
threads=$3
i=0
loop(){
sleep 1
iperf -c 192.168.10.14 -t $2 -i 1 -P $threads >$dir/loop_$(($1))_$(($threads)).log

}
while [ $i -lt $lptime ]
do 
loop $i $iperftime
i=$(($i+1))
done
