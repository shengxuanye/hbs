#! /bin/bash

count=0
a=300

while [ "$a" -ge 0 ]
do
	echo "iteration $a started.."
	mkdir "itr_$a"
	cd "itr_$a"
	cp ../stata_logit_subsample_do_bootstrap.do ./stata_logit_subsample_do_bootstrap.do
	stata-se-30g -b do stata_logit_subsample_do_bootstrap.do 
	#let count+=1
	#[[ $((count%10)) -eq 0 ]] && wait
	a=`expr $a - 1`
	cd ..
done
