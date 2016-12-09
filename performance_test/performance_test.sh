#!/bin/sh
if [ $# = 0 ];then
test=all;
else
test="$1"
fi
usage()
{
	echo "$0 all | iperf | qperf | netperf"
}

. conf/performance.conf

 case $test in 
"all")
	echo "test iperf"
	./iperf_test $IP_LOOP_NUM $IP_TEST_DURATION $IP_THREADS 
	echo "test qperf"
	./qperf_test.sh 2 -H $NP_SRV_IP $QP_OPTS
	echo "test netperf"
	./netperf_test.sh 2 tcp_stream "-t TCP_STREAM -H 192.168.10.14 -l 60 -- -m 2048"
	./netperf_test.sh 2 udp_stream "-t UDP_STREAM -H 192.168.10.14 -l 60 -- -m 2048"
	./netperf_test.sh 2 tcp_rr "-t TCP_RR -H 192.168.10.14 -l 60 -- -r 64,1024"
	./netperf_test.sh 2 tcp_crr "-t TCP_CRR -H 192.168.10.14 -l 60 -- -r 64,1024"
	./netperf_test.sh 2 udp_rr "-t UDP_RR -H 192.168.10.14 -l 60 -- -r 64,1024"
;;
"iperf")
	echo "test iperf"
	./iperf_test 5 100 1 
;;
"qperf")
	echo "test qperf"
	./qperf_test.sh 2 "-oo msg_size:1:64K:*2 192.168.10.14 tcp_bw tcp_lat"
;;
"netperf")
	echo "test netperf"
	./netperf_test.sh 2 tcp_stream "-t TCP_STREAM -H 192.168.10.14 -l 60 -- -m 2048"
	./netperf_test.sh 2 udp_stream "-t UDP_STREAM -H 192.168.10.14 -l 60 -- -m 2048"
	./netperf_test.sh 2 tcp_rr "-t TCP_RR -H 192.168.10.14 -l 60 -- -r 64,1024"
	./netperf_test.sh 2 tcp_crr "-t TCP_CRR -H 192.168.10.14 -l 60 -- -r 64,1024"
	./netperf_test.sh 2 udp_rr "-t UDP_RR -H 192.168.10.14 -l 60 -- -r 64,1024"
;;
?)
	echo "Unknow argument"
	usage()
	exit
;;
esac

