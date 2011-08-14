local st_dir: sysdir STATA
use `st_dir'systolic

*-------------------------------------------------
* the simple contrast
*-------------------------------------------------
desmat drug=sim(99)
table drug, contents(min _x_1 min _x_2 min _x_3)
regress systolic _x_*
desrep
* the constant is the mean value of the category means
* (26.06667+25.53333+8.75+13.5)/4=18.4625
sort drug
by drug: summarize systolic 
* coding using the simple contrast:
table drug, contents(min _x_1 min _x_2 min _x_3)

/*
predicted values per category of drug using the simple contrast:
constant + b[i]*code[i]

drug==1: 18.463 -.250*-.533 -.250*-17.317 -.250*-12.567 = 26.067
drug==2: 18.463  .750*-.533 -.250*-17.317 -.250*-12.567 = 25.533
drug==3: 18.463 -.250*-.533 +.750*-17.317 -.250*-12.567 =  8.750
drug==4: 18.463 -.250*-.533 -.250*-17.317 +.750*-12.567 = 13.500
*/

*-------------------------------------------------
* the indicator contrast
*-------------------------------------------------
desmat drug=ind(1)
regress systolic _x_*
desrep
* the constant is the mean within category 1
* coding using the indicator contrast:
table drug, contents(min _x_1 min _x_2 min _x_3)

/*
predicted values per category of drug using the indicator contrast:

drug==1: 26.067                                         = 26.067
drug==2: 26.067       -.533                             = 25.533
drug==3: 26.067                   -17.317               =  8.750
drug==4: 26.067                                 -12.567 = 13.500
*/
