local st_dir: sysdir STATA
use `st_dir'systolic

anova systolic drug*disease, regress

desmat: regress systolic drug*disease
destest
destest, j
