#! /bin/bash

export _JAVA_OPTIONS="-XX:ParallelGCThreads=2"

date

count=0
a=200

while [ "$a" -ge 0 ]
do
	echo "iteration $a started.."
	mkdir "itr_$a"
	cd "itr_$a"
	cp ../stata_logit_subsample_do_bootstrap.do ./stata_logit_subsample_do_bootstrap.do
	timeout 45m stata-se -b do stata_logit_subsample_do_bootstrap.do $a &
	let count+=1
	[[ $((count%60)) -eq 0 ]] && wait
	a=`expr $a - 1`
	cd ..
	sleep 30
done

num_proc=$(ps ax | grep stata | wc -l | awk '{print $1}')
echo $num_proc
while [ $num_proc -ge 2 ]
do
	sleep 3
	num_proc=$(ps ax | grep stata | wc -l | awk '{print $1}')
done

date 

