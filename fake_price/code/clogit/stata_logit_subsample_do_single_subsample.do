local seed = clock( c(current_time), "hms" ) 
set seed  `seed' 

import delimited /scratch/choicesets/full_logitTable2_1_100.csv

gen double RAND = runiform()
replace RAND = 1 if choice == 1
drop if RAND < 0.9

timer clear 98
timer on 98

clogit choice price item_age, group(gid)

timer off 98
timer list
