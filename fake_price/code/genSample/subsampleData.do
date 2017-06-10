use "D:\users\jerry\data\raw\basedata.dta"
keep if channel_code == 5 & !missing(channel_desc) & departmentdesc == "Handbags" & genderdesc == "Women" & !missing(style) &  !missing(store_code)
sort household_id
quietly by household_id: gen count = cond(_N<=2,0,1)
keep if count == 1
drop count
drop channel_desc store_name city state collectiondesc product_group departmentdesc department styledesc colordesc hardwarecolordesc signaturetypedesc lifetime_dollars original_purchase_date
egen gid = group(household_id transaction_date store_code)
export delimited using "D:\users\jerry\data\subsampled_subsampleData_do.csv", replace
