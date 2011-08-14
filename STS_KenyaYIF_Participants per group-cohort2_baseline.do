version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Participants per group-cohort2_baseline
log using "${rawname}", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-16-2011

/*	
	This do-file insheet the data from excel to STATA
	and labels the dataset.
	It converts 99 in the strings and numeric vars to 
	missing value.
	It saves the new dataset.
*/


// Edit 01:
//	Date:	

// 1. INSHEET
insheet using "${rawname}.csv", clear

// 2. MISSING VALUES
* CONVERTING STRING "99" TO MISSING VALUE ""
tab date
foreach var of varlist   date-treatment {
	capture: replace `var' = "" if `var' == "99"
}

// 3. RENAMING
rename s_no r_s_no
rename participantid resp_id 
rename date r_date
rename firstname r_name_f
rename middlename r_name_m
rename surname r_name_l

gen r_dataset = 4
label var r_dataset "Data Source"
label def dset 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Treat Group"
label val r_dataset dset

label var r_s_no "Serial Number in Respondent Assignment"

label var treatment "Treatment Group"
label def treat 0 "C" 1 "T1" 2 "T2"
label val treatment treat

// 4. Fixing Dates
tab r_date, miss
replace r_date = "31/3/2011" if r_date == "31/03/2011" | r_date == "31/3/2012"
tab r_date, miss

// 5. Fix ID
replace resp_id = "1-1071" if resp_id == "1-1077"
save "${rawname}.dta", replace

log close
exit
