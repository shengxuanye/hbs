local seed = clock( c(current_time), "hms" ) 
set seed  `seed' 

import delimited /dev/shm/full_logitTable2_3000_5000_2.csv, clear

//timer clear 100
//timer on 100
//clogit choice price item_age, group(gid)
//timer off 100
//timer list


tabulate silhouettedesc , generate(silhouettedesc_dummy)
tabulate collection , generate(collection_dummy)
tabulate materialdesc , generate(material_dummy)

gen logrprice = log(rprice)
gen logprice = log(price)
gen rpricefactory = rprice * factory
gen rpriceminusprice = rprice - price
gen pricedevrprice = price / rprice

timer clear 99
timer on 99
clogit choice rprice price factory age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
clogit choice logrprice logprice factory age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
clogit choice rpricefactory rprice price factory age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
clogit choice rpriceminusprice price factory age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
clogit choice pricedevrprice price factory age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)

timer off 99
timer list
