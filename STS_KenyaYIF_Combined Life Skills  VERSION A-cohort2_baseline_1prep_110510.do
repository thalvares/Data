version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
global rawnameB STS_KenyaYIF_Combined Life Skills  VERSION  B-cohort2_baseline
log using "${rawname}_1prep", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	This do-file insheet the data from excel to STATA,
	labels the dataset for Version A and Version B. It fixes
	the variable names in Version B according to Version A.
	Finally, it appends Version B to Version A  and converts
	99 in the strings to missing value.
*/

// Edit 01: 
//		Date:


// 1. APPENDING FILES

//	1.1 Version B: Matching varnames to varnames in Version A
display "rawnameB is $rawnameB"
insheet using "${rawnameB}.csv", clear
gen l_version = 2

/*	ISSUE:	Several variables in Version B not only had different q# (as expected), 
		but also had different varnames following the q#
	NEED:	Check each of vars with varnames that don't match across the versions 
*/

rename  s_no l_s_no
rename  participantid resp_id
rename  date l_date
rename  firstname l_name_f
rename  middlename l_name_m
rename  lastname l_name_l
rename  q2emotionalintelligence l1_emoint
rename  q12maryslifeskill l2_lifeskillmary
rename  q13thinkingcritically l3_criticthink
rename  q3humanemotion l4_humanemo
rename  q4elizabethsemotion l5_emoeliz
rename  q5elizabethslifeskill l6_lifeskilleliz
rename  q14sadnessdefinition l7_sad
rename  q7controllinganger l8_anger
rename  q8williamsscenario l9_listen
rename  q10karenssocialmotive l10_motivekaren
rename  q11biologicalmotive l11_motivebio
rename  q6selfawareness l12_selfaware
rename  q1receivefeedback l13_feedback
rename  q9emotionandbehaviour l14_emobehavior
rename  q15educationgoal l15_educgoal
rename  q21typeofgoal l16_marriagegoal
rename  q23notamajorforce l17_workworld_forcenot
rename  q25worldofwork l18_workworld_force
rename  q18workplacedeviance l19_workplace_deviance
rename  q16formofwork l20_hhchorus
rename  q20resolvingaproblem l21_probsolving
rename  q24personalattributes l22_personalatt
rename  q19idealvssuitablejob l23_job_ideal
rename  q27goodjobsearchingstrategy l24_job_searchgood
rename  q17bestjobserchingstrategy l25_job_searchbest
rename  q26jobvaancyadvertisement l26_job_searchinfo
rename  q22carolsinterviewscenario l27_job_searchintv
rename  q28goodcv l28_job_searchresume
rename  q30personalvalues l29_personalvalues
rename  q29dealingwithemotions l30_emocontrol
rename  q35eggcellsproducer l31_pregnancy_system
rename  q38preventinfections l32_infections_genital
rename  q41unintendedpregnancy l33_pregnancy_unwanted
rename  q39contraceptivemethods l34_pregnancy_contraceptive
rename  q36protectionfromstisandhiv l35_infections_HIVprotec
rename  q37transmissionofhiv l36_infections_HIVtrans
rename  q31correctstatement l37_infections_HIVnAIDS
rename  q32consequenceoftobaccouse l38_smoking
rename  q34meaningofsexgender l39_sex_gnd
rename  q40preventingsexualthreatsandabu l40_sex_harassprotec
rename  q33typeofviolence l41_sex_harass
/*
Mismatch on names in Version A and B:

Version A					Version B
q7sadness					q14sadnessdefinition
q9improvinglisteningskills	q8williamsscenario
q13feedback					q1receivefeedback
q18majorforce				q25worldofwork
q27interviewscenario		q22carolsinterviewscenario
q29personalvaluesdefinition	q30personalvalues
q33leadtoriskybehaviors		q41unintendedpregnancy
q36hivtransmission			q37transmissionofhiv
q39meaningofsexandgender	q34meaningofsexgender
*/

quietly summarize l_s_no
display r(N) " cases in Version B"

save "${rawnameB}_1prep.dta", replace


//	1.2 Version A: Simplifying varname for combined dataset
display "rawname is $rawname"
insheet using "${rawname}.csv", clear
gen l_version = 1

rename  s_no l_s_no
rename  participantid resp_id
rename  date l_date
rename  firstname l_name_f
rename  middlename l_name_m
rename  lastname l_name_l
rename  q1emotionalintelligence l1_emoint
rename  q2marylifeskill l2_lifeskillmary
rename  q3thinkingcritically l3_criticthink
rename  q4humanemotion l4_humanemo
rename  q5elizabethsemotion l5_emoeliz
rename  q6elizabethslifeskill l6_lifeskilleliz
rename  q7sadness l7_sad
rename  q8controllinganger l8_anger
rename  q9improvinglisteningskills l9_listen
rename  q10karenssocialmotive l10_motivekaren
rename  q11biologicalmotive l11_motivebio
rename  q12selfawareness l12_selfaware
rename  q13feedback l13_feedback
rename  q14emotionandbehavior l14_emobehavior
rename  q15educationgoal l15_educgoal
rename  q16typeofgoal l16_marriagegoal
rename  q17notamajorforce l17_workworld_forcenot
rename  q18majorforce l18_workworld_force
rename  q19workplacedeviance l19_workplace_deviance
rename  q20formofwork l20_hhchorus
rename  q21resolvingaproblem l21_probsolving
rename  q22personalattributes l22_personalatt
rename  q23idealvssuitablejob l23_job_ideal
rename  q24goodjobsearchingstrategy l24_job_searchgood
rename  q25bestjobsearchingstrategy l25_job_searchbest
rename  q26jobvaancyadvertisement l26_job_searchinfo
rename  q27interviewscenario l27_job_searchintv
rename  q28goodcv l28_job_searchresume
rename  q29personalvaluesdefinition l29_personalvalues
rename  q30dealingwithemotions l30_emocontrol
rename  q31eggproducer l31_pregnancy_system
rename  q32preventinfections l32_infections_genital
rename  q33leadtoriskybehaviors l33_pregnancy_unwanted
rename  q34contraceptivemethods l34_pregnancy_contraceptive
rename  q35protectionfromstisandhiv l35_infections_HIVprotec
rename  q36hivtransmission l36_infections_HIVtrans
rename  q37correctstatement l37_infections_HIVnAIDS
rename  q38consequenceoftobaccouse l38_smoking
rename  q39meaningofsexandgender l39_sex_gnd
rename  q40preventingsexualthreatsandabu l40_sex_harassprotec
rename  q41typeofviolence l41_sex_harass

quietly summarize l_s_no
display r(N) " cases in Version A"

append using "${rawnameB}_1prep.dta", force
erase "${rawnameB}_1prep.dta"
label var l_s_no "Serial Number in Life Skills Dataset"
label var l_version "Life Skills Version (A or B)"
label def ver 1 "Version A" 2 "Version B"
label val l_version ver
table l_version

// 2. CONVERTING STRING "99" TO MISSING VALUE ""
foreach var of varlist  l1_emoint-l41_sex_harass {
	replace `var' = "" if `var' == "99"
}
destring _all, replace

quietly summarize l_s_no
display r(N)
display r(N) " cases should equal 123 (Ver A) + 98 (Ver B)"

save "${rawname}_1prep.dta", replace


log close
exit
