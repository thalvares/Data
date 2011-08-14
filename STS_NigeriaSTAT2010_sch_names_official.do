version 11
clear all
macro drop _all
set linesize 120

capture log close

//	Project:	STS_NigeriaSTAT_2010
//	Author:		Thomaz Alvares
// 		Date:	05-05-2011
/*	
	1. This do-file insheets the file in which we matched the
	schools names and uses it as the official school name file.
	- official school name file: STS_NigeriaSTAT2010_SchoolNames
	
	2. Compare the school group (if treatment or control)
	- school group from: List_schools_EGRA&STAT
	- school group from: EGRA_Nigeria_chool_list_questions_updated_Dec2011
	
	3. Compare the school type (if urban, semi-urban or rural)
	- school type from: List_schools_EGRA&STAT
	- school type from: 2010-2011-SCHOOL_DATA-_ENROLMENT(1)(1)
	
	4. Then it selects the demographic info from the
	official school name file.
	- school demographic vars: 
		s_no, 
		State, 
		LGA, 
		SchoolName, 
		SchoolType, 
		ProjectorControl
	
	5. Then it selects the School IDs and number of sampled stundets
	from the EGRA file
	- EGRA file: EGRA_Nigeria_chool_list_questions_updated_Dec2011
	- school ID var: School Code
	
	6. Then it selects the school location (if rural
	or urban) for the schools this info is available from
	the enrollment file.
	- enrollment file: 2010-2011-SCHOOL_DATA-_ENROLMENT(1)(1)
	- school location var: LOCATION
	
	7. It renames all the vars as sch_[varname], relabel and
	saves the file as the official school name file.
	- filename: STS_NigeriaSTAT2010_sch_names_official
	
	8. It combines STS_NigeriaSTAT2010_sch_names_official
	with all the remaining data sets and add the suffix
	_official after their filename.
	- remaining data sets:
		d2:  2010-2011-SCHOOL_DATA-_ENROLMENT(1)(1)
		d3:  table_pupil_rosters
		d4:  Corrected Complete File-P4_Jan12_2011
		d5:  EGRA_Nigeria_chool_list_questions_updated_Dec2011
		d6:  SCHOOL_DATA-_TEXT(2010-2011- 3-may-2011)
		d7:  controlschool_enrolment._2_xlsx(2)
		d8:  Codes for Nigeria EGRA in Hausa_V5
		d9:  Head Teacher Questionnaire_mathching25May
		d10: STAT_PUP (I included the avg test 
				results per school in this file)
		d11: TEACHER_NEI_STAT_2010_May19_2011
*/

// Edit 01: 
//	Date:
/*
	No edits
*/

log using "STS_NigeriaSTAT2010_SchoolNames.txt" , replace text


// Steps 1-7: prep official
*1. Insheet
insheet using "STS_NigeriaSTAT2010_SchoolNames.csv", clear

*2-3. Compare group and type
list s_no schoolname group group_d5, noobs table string(8)
list s_no schoolname schooltype schooltype_d2, noobs table string(8)

notes schooltype: sno 127 "Dandin Mahe Islamiyya Pri. School" was PUBLIC in 2010-2011_enrollment
*S.No 127 "Dandin Mahe Islamiyya Pri. School"
*In dataset1 (EGRA&STAT): 			Public/Islamiyya
*In dataset2 (2010-2011Enrollment):	PUBLIC

notes schooltype: sno 130 "Magaji Bello Model Pri. Sch." was PUBLIC/NIZ in 2010-2011_enrollment
*S.No 130 "Magaji Bello Model Pri. Sch."
*In dataset1 (EGRA&STAT): 			Public
*In dataset2 (2010-2011Enrollment):	PUBLIC/NIZ

*4-6. Select vars
drop	dataset1	  			dataset2	state_d2 		lga_d2		///
		schooltype_d2			dataset3 	state_d3 		lga_d3		///
		lga_d4					dataset4	state_d4 		dataset5	///
		schoolliststs			state_d5 	lga_d5 			group_d5	///
		schooltype_d5			dataset6 	state_d6 		lga_d6 		///
		schooltype_d6			dataset7	state_d7		lga_d7		///
		dataset8				state_d8	lga_d8			dataset9	///
		state_d9				lga_d9		notes_d9		dataset10	///	
		statebauchisokoto_d10	lga_d10 	dataset11		state_d11	///
		lga_d11					notes_d11

*7. Rename
foreach var of varlist s_no-schoolname_d11 	{
	rename `var' sch_`var'
}

label var sch_s_no "School Serial Number"
label var sch_schooltype "School Type (Public or Islamiyya)"
label var sch_group "School Group (Treatment or Control)"
label var sch_location "School Location (Urban, Semi-Urban or Rural)"
label var sch_schoolcode "EGRA Code"

label var sch_schavg_lit "Literacy: school avg"
label var sch_schavg_num "Numeracy: school avg"
label var sch_schavg_lif "Life Skills: school avg"

save "STS_NigeriaSTAT2010_sch_names_official.dta", replace

// Step 8: merge
insheet using "STS_NigeriaSTAT2010_2010-2011-SCHOOL_DATA-_ENROLMENT(1)(1).csv", names clear
clonevar sch_schoolname_d2 = nameofschool
joinby	sch_schoolname_d2 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5 sch_schoolname_d6	///
		sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d2 // var used for combining with sch_names_official data set
list nameofschool sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_2010-2011-SCHOOL_DATA-_ENROLMENT(1)(1)_official.dta", replace

insheet using "STS_NigeriaSTAT2010_table_pupil_rosters.csv", names clear
clonevar sch_schoolname_d3 = nameofschool
joinby	sch_schoolname_d3 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d4 sch_schoolname_d5 sch_schoolname_d6	///
		sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d3 // var used for combining with sch_names_official data set
list nameofschool sch_schoolcode sch_schoolname, string(8)
*Schools for which we don't have pupil information
list nameofschool sch_schoolcode sch_schoolname if nameofpupil == "-333", string(8) 
save "STS_NigeriaSTAT2010_table_pupil_rosters_official.dta", replace

insheet using "STS_NigeriaSTAT2010_Corrected Complete File-P4_Jan12_2011_checked_by_ML.csv", names clear
clonevar sch_schoolname_d4 = schoolname
joinby	sch_schoolname_d4 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d5 sch_schoolname_d6	///
		sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d4 // var used for combining with sch_names_official data set
list schoolname sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_Corrected Complete File-P4_Jan12_2011_checked_by_ML_official.dta", replace

insheet using "STS_NigeriaSTAT2010_EGRA_Nigeria_chool_list_questions_updated_Dec2011.csv", names clear
clonevar sch_schoolname_d5 = schoolnamefromdatabase
joinby	sch_schoolname_d5 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d6	///
		sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d5 // var used for combining with sch_names_official data set
list schoolnamefromdatabase sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_EGRA_Nigeria_chool_list_questions_updated_Dec2011_official.dta", replace

insheet using "STS_NigeriaSTAT2010_SCHOOL_DATA-_TEXT(2010-2011- 3-may-2011).csv", names clear
clonevar sch_schoolname_d6 = nameofschool
joinby sch_schoolname_d6 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d6 // var used for combining with sch_names_official data set
list nameofschool sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_SCHOOL_DATA-_TEXT(2010-2011- 3-may-2011)_official.dta", replace

insheet using "STS_NigeriaSTAT2010_controlschool_enrolment._2_xlsx(2).csv", names clear
clonevar sch_schoolname_d7 = nameofschool
joinby sch_schoolname_d7 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d6 sch_schoolname_d8 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d7 // var used for combining with sch_names_official data set
list nameofschool sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_controlschool_enrolment._2_xlsx(2)_official.dta", replace

insheet using "STS_NigeriaSTAT2010_Codes for Nigeria EGRA in Hausa_V5.csv", names clear
clonevar sch_schoolname_d8 = schoolname
joinby sch_schoolname_d8 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d6 sch_schoolname_d7 sch_schoolname_d9 sch_schoolname_d10
drop	sch_schoolname_d8 // var used for combining with sch_names_official data set
list schoolname sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_Codes for Nigeria EGRA in Hausa_V5_official.dta", replace

insheet using "STS_NigeriaSTAT2010_Head Teacher Questionnaire_mathching25May.csv", names clear
clonevar sch_schoolname_d9 = school
joinby sch_schoolname_d9 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d6 sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d10
drop	sch_schoolname_d9 // var used for combining with sch_names_official data set
list school sch_schoolcode sch_schoolname, string(8)
/* Note: pilot school; long ago was informed that it wouldn't be included in the final data */
drop if school == "Sardauna Primary School Isa"
save "STS_NigeriaSTAT2010_Head Teacher Questionnaire_mathching25May_official.dta", replace

insheet using "STS_NigeriaSTAT2010_STAT_PUP.csv", names clear
clonevar sch_schoolname_d10 = schoolname
joinby sch_schoolname_d10 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d6 sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9
drop	sch_schoolname_d10 // var used for combining with sch_names_official data set
list schoolname sch_schoolcode sch_schoolname, string(8)
save "STS_NigeriaSTAT2010_STAT_PUP_official.dta", replace

insheet using "STS_NigeriaSTAT2010_TEACHER_NEI_STAT_2010_May19_2011.csv", names clear
/* Issues of typos on Teachers' schools */
replace school = "Maimadi" if school == "Maimadi PS"
replace school = "Sheikh Ja'afar Mahmood Asam Jahun" if school == "Sheikj Ja'afar Mahmood Adam Jahun"
replace school = "Kofar Buri" if school == "K/Buru Primary School"
replace school = "Hidayatul Islamiyya" if school == "Hadayatul Islamiyya Kofar Fada"
replace school = "Bakoshi" if school == "Bakoshi Primary School"
replace school = "Madara Primary School" if school == "Central Primary School Madara"
replace school = "Nurul Islam Cheledi" if school == "Rurul Islamic Cheldi"
replace school = "MNI S/G Araba" if school == "BAJ JNI"
replace school = "MPS Illela" if school == "Nizzamiyya School Illela"
replace school = "Sagen MPS Gatawa" if school == "Sagen Model Primary School"
replace school = "MPS Gande" if school == "MPS gande"
replace school = "Yakubu Muazu Science MPS" if school == "Y. M."
replace school = "Nurul Islam Cheledi" if school == "Nurul Islam"
clonevar sch_schoolname_d11 = school
joinby sch_schoolname_d11 using "STS_NigeriaSTAT2010_sch_names_official.dta"
drop	sch_schoolname_d2 sch_schoolname_d3 sch_schoolname_d4 sch_schoolname_d5	///
		sch_schoolname_d6 sch_schoolname_d7 sch_schoolname_d8 sch_schoolname_d9
drop	sch_schoolname_d11 // var used for combining with sch_names_official data set
list school sch_schoolcode sch_schoolname, string(8)
/* Note: pilot school; long ago was informed that it wouldn't be included in the final data */
drop if school == "Sardauna MPS Isa"
save "STS_NigeriaSTAT2010_TEACHER_NEI_STAT_2010_May19_2011_official.dta", replace
