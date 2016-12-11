#!/bin/sh
if [ $# = 0 ];then
	test_type=all;
else
	test_type="$1"
fi
usage()
{
	echo "$0 all | iperf | qperf | netperf"
}

prepare_log_dir()
{
	if [ ! -d $LOG_DIR ]; then
		mkdir $LOG_DIR
	fi
	for log_type in iperf_log qperf_log netperf_log
	do
		if [ ! -d $LOG_DIR/$log_type ]; then 
			mkdir $LOG_DIR/$log_type
		fi
	done
}

. conf/performance.conf

#check the log directory is existed or not.
#if not, create it
prepare_log_dir

 case $test_type in 
"all")
	echo "testing  iperf ..."
	./iperf_test $IP_LOOP_NUM $IP_TEST_DURATION $IP_THREADS 
	echo "testing  qperf ..."
	./qperf_test.sh $NP_LOOP_NUM $QP_SRV_IP $QP_OPTS
	echo "testing  netperf ..."
	for type in TCP_STREAM UDP_STREAM
	do
	./netperf_test.sh $QP_LOOP_NUM tcp_stream "-t $type -H $NP_SRV_IP -l 60 -- -m 2048"
	done
	for type in TCP_RR TCP_CRR UDP_RR
	do
	./netperf_test.sh $QP_LOOP_NUM $type "-t $type -H $NP_SRV_IP -l 60 -- -r 64,1024"
	done
	echo "performance test is finished!"
;;
"iperf")
	echo "testing  iperf ..."
	./iperf_test $IP_LOOP_NUM $IP_TEST_DURATION $IP_THREADS 
;;
"qperf")
	echo "test qperf"
	./qperf_test.sh $NP_LOOP_NUM $QP_SRV_IP $QP_OPTS
;;
"netperf")
	echo "test netperf"
	for type in TCP_STREAM UDP_STREAM
	do
		./netperf_test.sh $QP_LOOP_NUM $type "-t $type -H $NP_SRV_IP -l 60 -- -m 2048"
	done
	for type in TCP_RR TCP_CRR UDP_RR
	do
		./netperf_test.sh $QP_LOOP_NUM $type "-t $type -H $NP_SRV_IP -l 60 -- -r 64,1024"
	done
;;
?)
	echo "Unknow argument"
	usage()
	exit
;;
esac

