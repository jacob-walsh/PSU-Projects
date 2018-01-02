/**********
Author: Jacob Walsh
Title: Case Study 2 - Awesome Bakery Analysis
Stat 580 - Summer Term
**********/
OPTIONS PS = 58 LS = 72 NODATE NONUMBER;

title "Bakery";
proc import datafile="C:\Penn State MAS\Stat 580\bakery.xlsx" out=bakery dbms=xlsx replace;
	range="C5 Cookies.csv$A1:D136";
run;

proc sgplot data=bakery;
	title "Distribution of Taste Ratings";
	hbox Taste;
	run;
proc means data=bakery mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - Taste Ratings";
	var Taste;
	run;

proc sgplot data=bakery;
	title "Distribution of Taste Ratings by Day";
	hbox Taste /category=Day;
	refline 6.05/axis=x lineattrs=(color=red) label="Overall Mean";
	run;
proc means data=bakery mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - Taste Ratings by Day";
	class Day;
	var Taste;
run;

proc sgplot data=bakery;
	title "Distribution of Taste Ratings by Sugar Level";
	hbox Taste /category=Sugar;
	refline 6.05/axis=x lineattrs=(color=red) label="Overall Mean";
	run;
proc means data=bakery mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - Taste Ratings by Sugar Level";
	class Sugar;
	var Taste;
	run;

proc sgplot data=bakery;
	title "Distribution of Taste Ratings by Batch";
	hbox Taste /category=Batch;
	refline 6.05/axis=x lineattrs=(color=red) label="Overall Mean";
	run;

proc means data=bakery;
	class Batch;
	var Taste;
	output out=avg mean=xbar;
	run;
proc sgplot data=avg;
	hbox xbar;
	run;
data newbake;
	set bakery;
	if Batch NE 2;
	run;
proc means data=newbake mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - Taste Ratings";
	var Taste;
	run;

proc mixed data=bakery;
	title "Split-Plot CRD";
	class Batch Day Sugar;
	model Taste=Day|Sugar;
	random Batch(Sugar);
	lsmeans Day/ adjust=tukey diff cl;
	run;

proc mixed data=newbake;
	title "Split-Plot CRD w/2nd Batch Removed";
	class Batch Day Sugar;
	model Taste=Day|Sugar;
	random Batch(Sugar);
	lsmeans Day/ adjust=tukey diff cl;
run;

/*

proc sort data=bakery out=new;
	by Batch Day Sugar;
run;
proc means noprint data=new;
	var Taste;
	by Batch Day Sugar;
	output out=new1 mean=taste1;
run; 

proc mixed data=new1;
	title "Split-Plot CRD w/Averages of Sampling Units";
	class Batch Day Sugar;
	model taste1=Day|Sugar;
	random Batch(Sugar);
	lsmeans Day Sugar/ adjust=tukey diff cl;
	run;

	proc mixed data=new1;
	title "Repeated";
	class Batch Day Sugar;
	model taste1=Day|Sugar;
	random Batch(Sugar);
	repeated / subject=Batch(Sugar) type=AR(1);
	lsmeans Day Sugar/ adjust=tukey diff cl;
	run;

*/


