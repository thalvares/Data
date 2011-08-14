version 11
clear all
macro drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-16-2011

/*	
	Master do-file
*/

// Edit 01: 
//	Date:

do "STS_KenyaYIF_an_1prep-cohort2_baseline" /* use STS_KenyaYIF_Combined Datasets-cohort2_baseline_wide
												reshape to STS_KenyaYIF_Combined Datasets-cohort2_baseline_long	*/
do "STS_KenyaYIF_an_2comp-cohort2_baseline" // use STS_KenyaYIF_Combined Datasets-cohort2_baseline_long
do "STS_KenyaYIF_an_3pbis-cohort2_baseline" // use STS_KenyaYIF_Combined Datasets-cohort2_baseline_wide

exit

