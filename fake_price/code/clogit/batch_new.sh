#! /bin/bash

export _JAVA_OPTIONS="-XX:ParallelGCThreads=2"

date
starttime=$(date)

count=0
a=200
maxproc=120

while [ "$a" -ge 0 ]
do
	num_proc=$(ps ax | grep stata | wc -l | awk '{print $1}')
	if [ $num_proc -lt $maxproc ]; then
		echo "iteration $a started, $num_proc / $maxproc.."
		mkdir "itr_$a"
		cd "itr_$a"
		cp ../stata_logit_subsample_do_bootstrap.do ./stata_logit_subsample_do_bootstrap.do
		timeout 75m stata-se -b do stata_logit_subsample_do_bootstrap.do $a &
		let count+=1
		a=`expr $a - 1`
		cd ..
	else
		echo "reach max procs, $num_proc / $maxproc"	
	fi
	sleep 30
done

echo "all processes started, waiting to finish... "
num_proc=$(ps ax | grep stata | wc -l | awk '{print $1}')
while [ $num_proc -ge 2 ]
do
	sleep 30
	num_proc=$(ps ax | grep stata | wc -l | awk '{print $1}')
	echo "left process $num_proc"
done

echo "start time: $starttime"
endtime=$(date)
echo "end time: $endtime" 

