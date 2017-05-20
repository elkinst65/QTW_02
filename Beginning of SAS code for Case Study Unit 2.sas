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


/* applying proc reg, as seen in the videos*/
proc reg data = carmpg;
	model mpg = cylinders size hp weight accel eng_type;
run;



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

