#!/bin/sh

usage(){
echo "$0 loop_count  suffix options"
}
if [ $# = 0 ];then
	usage
	exit 0
fi
lptime=$1
dir=netperf_log
opts="$3"
suffix=$2
i=0
echo $suffix
loop(){
sleep 1
netperf  $opts >$dir/netperf_loop_$(($1))_$suffix.log

}
while [ $i -lt $lptime ]
do 
loop $i
i=$(($i+1))
done
