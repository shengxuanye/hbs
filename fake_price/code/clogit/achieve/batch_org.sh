#! /bin/bash
count=0
a=100
while [ "$a" -ge 0 ]
do
	echo "iteration $a started.."
#	mkdir "itr_$a"
#	cd "itr_$a"
#	cp ../stata_logit_subsample_do_bootstrap.do ./stata_logit_subsample_do_bootstrap.do
#	stata -b do stata_logit_subsample_do_bootstrap.do $a &
#	let count+=1
#	[[ $((count%15)) -eq 0 ]] && wait
	a=`expr $a - 1`
#	cd ..
done

