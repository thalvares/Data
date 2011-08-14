version 11
clear all
macro drop _all
label drop _all
set linesize 80

//	Project:	STS_NigeraiaSTAT_Report_2010
//	Author:		Thomaz Alvares
// 		Date:		06-21-2011

/*	
*	This do-file insheets the student data and creates school avgs
*/

// Edit 01: 	
//		Date:		
/*	
*/

capture log close
global rawname STS_Nigeria2010_report_001_schavgs
global source STS_NigeriaSTAT2010_STAT_PUP
log using "${rawname}", replace text


// Source
insheet using "${source}.csv", clear case

// Generate School Averages before combining data with head teacher and teacher data
bysort Schoolname: egen schavg_literacy = mean(TOT_LITERACY)
bysort Schoolname: egen schavg_numeracy = mean(TOT_NUMERACY)
bysort Schoolname: egen schavg_lifeskills = mean(TOT_LIFESKILLS)

label var schavg_lit "Literacy: school avg"
label var schavg_num "Numeracy: school avg"
label var schavg_lif "Life Skills: school avg"

list Schoolname TOT_LITERACY schavg_literacy in 1/20
list Schoolname TOT_NUMERACY schavg_numeracy in 1/20
list Schoolname TOT_LIFESKILLS schavg_lifeskills in 1/20

// Save
save "STS_NigeriaSTAT2010_report_001_schavgs.dta", replace

exit
