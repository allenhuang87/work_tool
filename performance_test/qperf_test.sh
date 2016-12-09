#!/bin/sh

usage(){
echo "$0 loop_count options"
}
if [ $# = 0 ];then
	usage
	exit 0
fi
lptime=$1
dir=qperf_log
opts="$2"
i=0
loop(){
sleep 1
qperf  $opts >$dir/qperf_loop_$(($1)).log

}
while [ $i -lt $lptime ]
do 
loop $i
i=$(($i+1))
done
