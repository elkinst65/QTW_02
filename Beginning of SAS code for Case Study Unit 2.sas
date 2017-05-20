/*
Case Study, Unit 2
Baldree, Brock, Elkins, Kelly
*/

/*switching mpg and eng_type to clear the null missing data issue*/
proc import datafile = 'C:\Users\austi\Documents\GitHub\QTW_02\carmpg.txt'
	out = carmpg
	dbms = dlm
	replace;
	datarow = 2;
	delimiter = '09'x;
run;

proc print data = carmpg; run;


/* applying the initial proc reg*/
proc reg data = carmpg;
	model size = mpg cylinders size hp weight accel eng_type; 
run;

/* Here, size was chosen to be modeled arbitrarily. Nothing indicating any particular variable should be chosen.*/

ods select misspattern;
proc mi data = carmpg nimpute=0;
	var  mpg cylinders size hp weight accel eng_type;
run;

proc MI data = carmpg
out = miout seed = 35399;
var mpg cylinders size hp weight accel eng_type;
run;

proc reg data = miout outest = outreg 
			covout;
	model size = eng_type mpg cylinders hp weight accel;
	by _Imputation_; 
run;

proc mianalyze data=outreg;
modeleffects mpg cylinders hp weight accel eng_type Intercept;
run;

/*
ERROR: Within-imputation COV missing for _Imputation_= 1 in the input DATA= data set.

This error is thrown when the above code is run. This is because size is included when it is what we are trying to model. 
*/

