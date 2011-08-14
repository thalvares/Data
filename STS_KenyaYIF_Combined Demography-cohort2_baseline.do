version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined Demography-cohort2_baseline
log using "${rawname}", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	This do-file insheet the data from excel to STATA
	and labels the dataset.
	It converts 99 in the strings and numeric vars to 
	missing value.
	It saves the new dataset.
*/


// Edit 01:		Thomaz Alvares
//	Date:		05-24-2011
/*
	Added categorical var for age
*/

// 1. INSHEET
insheet using "${rawname}.csv", clear

// 2. MISSING VALUES
* CONVERTING STRING "99" TO MISSING VALUE ""
foreach var of varlist  date-q46qualifications1notconfident2c {
	capture: replace `var' = "" if `var' == "99"
}

* CONVERTING NUMERIC 99 TO MISSING VALUE
mvdecode 	date-othereducation											///
			q10previoustraining1computers2li-q18signedcontract0no1yes	///
			q21socialbenefitno0yes1-v50									///
			q24otherwork1familybusiness2volu-q27signedcontract0no1yes 	///
			q30benefitsno0yes1-v68 										///
			q33peopleinhousehold-q46qualifications1notconfident2c, 		///
			mv(99)
* q9yearssincecompletionofeducatio	=> 99 is an ambiguous value 
* q19hoursworked 					=> 99 is an ambiguous value
* q20weeklyincome 					=> 99 is an ambiguous value
* q23monthsunemployed 				=> 99 is an ambiguous value
* q28workhoursperweek 				=> 99 is an ambiguous value
* q29weeklyincome 					=> 99 is an ambiguous value
* q32highestweeklyincome 			=> 99 is an ambiguous value


/* Due to missing values, d13 is being treated as string instead of numeric */
tab q13jobapplications10526103111541, miss
destring q13jobapplications10526103111541, replace
tab q13jobapplications10526103111541, miss


// 3. RENAMING
rename s_no d_s_no
rename participantid resp_id 
rename date d_date
rename firstname d_name_f
rename middlename d_name_m
rename surname d_name_l
rename q2dateofbirth d2_birthdate
rename q3nationality0kenyan1other d3_nationality 
rename othernationality d3_nationality_other
rename q4maritalstatus1single2married3d d4_marital
rename othermaritalstatus d4_marital_other
rename q5children0no1yes d5_child_have
rename yeshowmany d5_child_number
rename q6live1korogocho2mukuru3mathare4 d6_location 
rename otherlivingspace d6_location_other
rename q7siblings d7_sibbling_number
rename q8formaleducation1primary2second d8_educ
rename othereducation d8_educ_other
rename q9yearssincecompletionofeducatio d9_educ_months
rename q10previoustraining1computers2li d10_train_previous
/* Note:	Should record all that apply but in template it was
				recorded as multiple choice (only one answer and
				combinations were given as categories). The cmd
				"Record all that apply" should be deleted	*/
rename q11currentothertraining0no1yes d11_train_currently
rename yesspecify d11_train_currently_other
rename q12lookingforemployment0no1yes d12_job_looking
rename q13jobapplications10526103111541 d13_job_applications
rename q14none d14_job_search_none
rename reviewedjobadvertisements0no1yes d14_job_search_advertised
rename submittedunad0no1yes d14_job_search_unadvertised
rename networked0no1yes d14_job_search_network
rename recruitingagencies0no1yes d14_job_search_agency
rename jobfairs0no1yes d14_job_search_fair
rename internship0no1yes d14_job_search_intern
rename collegeplacement0no1yes d14_job_search_placement
rename entrepreneur0no1yes d14_job_search_self
rename other0no1yes d14_job_search_other
/* Note:	Missing qs: If other, please specify:"	*/
rename q15yearsemployednever1lessthanon d15_employ_duration
rename q16employedno1yes1 d16_employ_currently
rename q17employmentstatus1selfemployed d17_employ_type
rename specifyother d17_employ_type_other
rename q18signedcontract0no1yes d18_employ_contract
rename q19hoursworked d19_employ_perweek
rename q20weeklyincome d20_employ_income
rename q21socialbenefitno0yes1 d21_employ_benef
rename q22paidleave0no1yes d22_employ_benef_pleave
rename retirementpension0no1yes d22_employ_benef_retire
rename healthinsurance0no1yes d22_employ_benef_health
rename unemploymentinsurance0no1yes d22_employ_benef_unploy
rename yearendbonus0no1yes d22_employ_benef_bonus
rename performancebonus0no1yes d22_employ_benef_perf
rename v49 d22_employ_benef_other
rename v50 d22_employ_benef_other_d
rename q23monthsunemployed d23_unploy_duration
rename q24otherwork1familybusiness2volu d24_unploy_act
rename v53 d24_unploy_act_other
rename q25previousemploymentno0yes1 d25_unploy_pemploy 
rename q26previousemployment1selfemploy d26_unploy_pemploy_type
rename otherspecify d26_unploy_pemploy_other
rename q27signedcontract0no1yes d27_unploy_pemploy_contract
rename q28workhoursperweek d28_unploy_pemploy_perweek
rename q29weeklyincome d29_unploy_pemploy_income
rename q30benefitsno0yes1 d30_unploy_pemploy_benef
rename q31paidleave0no1yes d31_unploy_pemploy_benef_pleave
rename v62 d31_unploy_pemploy_benef_retire
rename v63 d31_unploy_pemploy_benef_health
rename v64 d31_unploy_pemploy_benef_unploy
rename v65 d31_unploy_pemploy_benef_bonus
rename v66 d31_unploy_pemploy_benef_perf
rename v67 d31_unploy_pemploy_benef_other
rename v68 d31_unploy_pemploy_benef_other_d
rename q32highestweeklyincome d32_income_highest
rename q33peopleinhousehold d33_hh_num
rename q34nobodyno0yes1 d34_hh_alone
rename father0no1yes d34_hh_father
rename mother0no1yes d34_hh_mother
rename siblings0no1yes d34_hh_sibbling
rename children0no1yes d34_hh_child
rename spouse0no1yes d34_hh_spouse
rename auntuncle0no1yes d34_hh_aunt
rename cousinsno0yes1 d34_hh_cousin
rename neicesnephewsno0yes1 d34_hh_niece
rename grandparents0no1yes d34_hh_grandparent
rename friends0no1yes d34_hh_friend
rename v82 d34_hh_other
rename v83 d34_hh_other_d 
rename q35workingmembersofhousehold d35_hh_employ
rename q36primarywageearneryourself1fat d36_hh_head
/* Note:	Missing qs: If other, please specify:"	*/
rename q37knowweeklyincome0no1yes d37_hh_income
rename q380to100011001to200022001to3000 d38_hh_income_range
rename q39bankaccount0no1yes d39_fin_acc
rename q40appliedforcredit0no1yesindiv2 d40_fin_loan_applied
rename q41loansapproved0no1yesindividua d41_fin_loan_approved
rename q42ownabusiness0no1yesindiv2yesg d42_bus
rename q43registered0no1yes d43_bus_reg
rename q44haveemployees0no1yes d44_bus_staff
rename v94 d44_bus_staff_num
rename q45difficulty1notdifficult2diffi d45_job_search_difficulty
rename q46qualifications1notconfident2c d46_job_search_confidence

// 4. Labels
gen d_dataset = 1
label var d_dataset "Data Source"
label def dset 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Treat Group"
label val d_dataset dset
label var d_s_no "Serial Number in Demographics Dataset"
        
label def nat 0 "Kenyan" 1 "Other"
label val d3_nationality nat

label def marital 1 "Single" 2 "Married" 3 "Divorced/Separate" 4 "Living Together" 5 "Widowed" 6 "Other"
label val d4_marital marital

label def child 0 "Not Mother" 1 "Mother"
label val d5_child_have child

label def loc 1 "Korogocho" 2 "Mukuru" 3 "Mathare" 4 "Kangemi" 5 "Kibera" 6 "Kawangware" 7 "Other"
label val d6_location loc

label def educ 1 "Primary" 2 "Secondary" 3 "Technical" 4 "University" 5 "Other"
label val d8_educ educ

label def train 1 "Computers" 2 "Life-Skills" 3 "Both" 4 "Neither"
label val d10_train_previous train

label def job 1 "0-5" 2 "6-10" 3 "11-15" 4 "16-20" 5 "Over 20"
label val d13_job_applications job

label def yrsempl 1 "Never" 2 "Less than one year" 3 "1 to 5 years" 4 "Over 5 years"
label val d15_employ_duration yrsempl

label def empl 1 "Self-Employed" 2 "Employed permanent full-time" 3 "Employed temporary" 4 "Occasional work" 5 "Other" 
label val d17_employ_type empl      

label def unpl 1 "Family business" 2 "Volunteer" 3 "Both" 4 "Neither" 5 "Other"
label val d24_unploy_act unpl

label def pempl 1 "Self-Employed" 2 "Employed permanent full-time" 3 "Employed temporary" 4 "Occasional work" 5 "Other" 
label val d26_unploy_pemploy_type pempl

label def head 1 "Yourself" 2 "Father" 3 "Mother" 4 "Brother/Sister" 5 "Spouse" 6 "Aunt/Uncle" 7 "Cousin" 8 "Grandparent" 9 "Friend" 10 "Other"
label val d36_hh_head head

label def inc 1" 0 to 1000" 2 "1001 to 2000" 3 "2001 to 3000" 4 "Over 3000"
label val d38_hh_income_range inc

label def loan 0 "No" 1 "Yes, individual" 2 "Yes, group"
label val d40_fin_loan_applied loan

label def appr 0 "No" 1 "Yes, individual" 2 "Yes, group"
label val d41_fin_loan_approved appr

label def bus 0 "No" 1 "Yes, individual" 2 "Yes, group"
label val d42_bus bus

label def jdiff 1 "Not Difficult" 2 "Difficult" 3 "Very Difficult" 4 "Unsure"
label val d45_job_search_difficulty jdiff

label def jconf 1 "Not Confident" 2 "Confident" 3 "Very Confident" 4 "Unsure"
label val d46_job_search_confidence jconf

label def yesno 0 "No" 1 "Yes"
label 	val										///
			d14_job_search_advertised 			///
			d14_job_search_unadvertised 		///
			d14_job_search_network 				///
			d14_job_search_agency 				///
			d14_job_search_fair 				///
			d14_job_search_intern 				///
			d14_job_search_placement 			///
			d14_job_search_self 				///
			d16_employ_currently 				///
			d18_employ_contract 				///
			d21_employ_benef 					///
			d22_employ_benef_pleave 			///
			d22_employ_benef_retire 			///
			d22_employ_benef_health 			///
			d22_employ_benef_unploy  			///
			d22_employ_benef_bonus 				///
			d22_employ_benef_other 				///
			d25_unploy_pemploy 					///
			d27_unploy_pemploy_contract			/// 
			d30_unploy_pemploy_benef 			///
			d31_unploy_pemploy_benef_pleave 	///
			d31_unploy_pemploy_benef_retire 	///
			d31_unploy_pemploy_benef_health 	///
			d31_unploy_pemploy_benef_unploy 	///
			d31_unploy_pemploy_benef_bonus 		///
			d31_unploy_pemploy_benef_perf 		///
			d31_unploy_pemploy_benef_other 		///
			d34_hh_alone 						///
			d34_hh_father 						///
			d34_hh_mother 						///
			d34_hh_sibbling 					///
			d34_hh_child 						///
			d34_hh_spouse 						///
			d34_hh_aunt 						///
			d34_hh_cousin 						///
			d34_hh_niece 						///
			d34_hh_grandparent 					///
			d34_hh_friend 						///
			d34_hh_other 						///
			d37_hh_income 						///
			d39_fin_acc 						///
			d43_bus_reg 						///
			d44_bus_staff						///
		yesno
		
// 5. Creating "age" var
gen double  d2_birthdate_V2 = date(d2_birthdate, "DMY")
format d2_birthdate_V2 %td

generate double date_V2 = date("01-01-2011", "DMY")
format date_V2 %td

generate age= date_V2-d2_birthdate_V2
replace age = age/365
replace age = . if age > 100
replace age = . if age < 0
tab age

drop date_V2
label var d2_birthdate_V2 "Date of Birth (proper format)"
label var age "Respondent's age at the begining of 2011"

gen age_cat = .
replace age_cat = 1 if age < 18
replace age_cat = 2 if age >= 18 & age < 25
replace age_cat = 3 if age >= 25 & age < 30
replace age_cat = 4 if age >= 30 & age < 35
replace age_cat = 5 if age >= 35 & age < .
label var age_cat "Age Groups"
label def agecat 1 "< 18" 2 "18 - 24" 3 "25 - 29" 4 "30 - 34" 5 "> 34"
label val age_cat agecat

// 6. Data Cleaning
* Based on Charles Munene checking the hard copies
tab d15_employ_duration, miss
replace d15_employ_duration = 1 if resp_id == "4-2-052"
tab d15_employ_duration, miss

tab  d4_marital, miss
replace  d4_marital = 3 if resp_id == "5-2-036"
tab  d4_marital, miss

save "${rawname}.dta", replace

log close
exit
