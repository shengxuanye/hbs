local seed = clock( c(current_time), "hms" ) 
set seed  `seed' 
//set processors 2

// subsampling 
import delimited /n/home12/sye/ngwe_hbs_lab/Lab/fake_price/code/clogit/logitTable.csv
gen long order = _n
egen select = tag(gid)
gen rnd = runiform()
sort select rnd
sum(select)
replace select = _n > (_N - 1000)
bysort gid (select): replace select = select[_N]
sort order
drop order rnd
keep if select

// process clogit data
gen price = amount/item_quantity
tabulate silhouettedesc , generate(silhouettedesc_dummy)
tabulate collection , generate(collection_dummy)
tabulate materialdesc , generate(material_dummy)
merge m:1 style using "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/code/clogit/first_purchase_by_style.dta", nogenerate
gen item_age = transaction_date - start_date

//bootstrap reps(200), size(1000): clogit purchased price item_age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
clogit purchased price item_age material_dummy* collection_dummy* silhouettedesc_dummy* , group(gid)
