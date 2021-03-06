* data: Knoke and Burk 1980
* Table 3, pp 23
#delimit ;
tabi 114 122 \
     150  67 \
      88  72 \
     208  83 \
      58  18 \
     264  60 \
      23  31 \
      22   7 \
      12   7 \
      21   5 \
       3   4 \
      24  10, replace;
#delimit cr

rename col vote
quietly replace vote=2-vote

gen race=1+mod(group(2)-1,2)
gen educ=1+mod(group(6)-1,3)
gen memb=1+mod(group(12)-1,2)

label var race "Race"
label var educ "Education"
label var memb "Membership"
label var vote "Vote Turnout"

label def race 1 "White" 2 "Black"
label def educ 1 "Less than High School" 2 "High School Graduate" 3 "College"
label def memb 1 "None" 2 "One or More"
label def vote 1 "Voted" 0 "Not Voted"
label val race race
label val educ educ
label val memb memb
label val vote vote

table educ vote memb [fw=pop], by(race)

desmat: logistic vote memb educ*race [fw=pop], desrep(exp all) 

desmat: glm pop vote*memb vote*educ*race educ*race*memb, link(log) family(poisson)
desrep, all
showtrms
predict pred

table educ vote memb [iw=pred], by(race) format(%9.2f)

* test only the highest order terms
destest vote*memb vote*educ*race educ*race*memb
* test all terms
destest
