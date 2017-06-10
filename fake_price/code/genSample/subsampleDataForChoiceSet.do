use "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/raw_data/basedata.dta", clear

replace channel_code = 3 if channel_code == 5 & channel_desc == "Coach Retail"
keep if !missing(channel_desc) & genderdesc == "Women" & !missing(style) &  !missing(store_code)
keep if channel_code == 3 | channel_code == 5

drop channel_desc
drop store_name
drop product_group department
drop item_size hardwarecolordesc
drop genderdesc

gen purchase = departmentdesc == "Handbags"
drop departmentdesc

gen price = amount / item_quantity
drop if item_quantity == 0
gen perdisc = discount_amount / item_quantity
replace retail_price = price + perdisc if retail_price == .
replace retail_price = price if retail_price == .
bys style: egen rprice = median(retail_price)
drop if price == 0
gen portion = price / rprice
drop if portion > 1

*Identify made-for-factory bags, introduction dates
merge style item_color using "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/raw_data/introdates", uniqusing sort
keep if _merge == 3
drop _merge
gen factory = introdate2 == .
gen introdate = introdate2
replace introdate = fsintrodate if introdate2 == .
replace introdate = fsintrodate if fsintrodate < introdate2
bys style item_color: egen mindate = min(transaction_date)
gen diff = mindate-introdate
*replace introdate=mindate if mindate<introdate
gen age = transaction_date - introdate


keep if channel_code == 5 & !missing(style) &  !missing(store_code)
drop city state household_id collectiondesc styledesc colordesc signaturetypedesc lifetime_dollars original_purchase_date cust_zip item_quantity
export delimited using "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHousehold_do.csv", replace
