use "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/raw_data/basedata.dta"
keep if channel_code == 5 & !missing(channel_desc) & departmentdesc == "Handbags" & genderdesc == "Women" & !missing(style) &  !missing(store_code)
drop channel_desc store_name city state collectiondesc product_group departmentdesc department styledesc colordesc hardwarecolordesc signaturetypedesc lifetime_dollars original_purchase_date
export delimited using "/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHousehold_do.csv", replace
