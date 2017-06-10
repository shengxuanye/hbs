use "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/raw_data/basedata.dta"
keep if (channel_code == 5 | channel_code == 3 | channel_code == 1) & !missing(style)
keep channel_code store_code store_zip cust_zip transaction_date original_purchase style amount household_id
export delimited using "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHouseholdAllChn_do_150601.csv", replace
