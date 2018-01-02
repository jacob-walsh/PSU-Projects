/**********
Author: Jacob Walsh
Title: Case Study 1 - Memory Study Analysis
Stat 580 - Summer Term
**********/
OPTIONS PS = 58 LS = 72 NODATE NONUMBER;

title "Memory";
proc import datafile="C:\Penn State MAS\Stat 580\Memory_Data.xlsx" out=memory dbms=xlsx;
	range="Memory Data.csv$A1:F49";
run;


proc sgplot data=memory;
	title "Distribution of All Memory Scores";
	hbox Score;
run;

proc means data=memory mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - All Scores";
	var Score;
	run;
proc sgplot data=memory;
	title "Distribution of Memory Scores by Wordlist";
	hbox Score/ category=Wordlist;
	refline 8.1/axis=x lineattrs=(color=red);
run;

proc sgplot data=memory;
	title "Distribution of Memory Scores by Distracter";
	hbox Score/ category=Distracter;
	refline 8.1/axis=x lineattrs=(color=red);
	run;

proc means data=memory mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - Wordlists and Distracters";
	var Score;
	class Wordlist Distracter;
	run;

proc sgplot data=memory;
	title "Distribution of Memory Scores by Major";
	hbox Score / Category=Major;
	refline 8.1/axis=x lineattrs=(color=red) ;
run;
proc means data=memory mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary - All Scores";
	class Major;
	var Score;
	run;

proc mixed data=memory;
	class Major Student Wordlist Distracter;
	model score=Major|Wordlist|Distracter Student(Major)/ ddfm=kr;
	random Student(Major) Major;
	repeated Student / subject=Student type=CS rcorr;

ods output FitStatistics=FitCS (rename=(value=CS))
FitStatistics=FitCSp;
title 'Compound Symmetry'; run;

proc mixed data=memory;

	class Major Student Wordlist Distracter;
	model score=Major|Wordlist|Distracter Student(Major)/ ddfm=kr;
	random Student(Major) Major;
	repeated / subject=Student type=VC rcorr;

ods output FitStatistics=FitVC (rename=(value=VC))
FitStatistics=FitVCp;
title 'Variance Components'; run;

proc mixed data=memory;
	class Major Student Wordlist Distracter;
	model score=Major|Wordlist|Distracter Student(Major)/ ddfm=kr;
	random Student(Major) Major;
	repeated / subject=Student type=UN rcorr;

ods output FitStatistics=FitUN (rename=(value=UN))
FitStatistics=FitUNp;
title 'Unstructured'; run;

title 'Covariance Summary'; run;
data fits;
merge FitCS FitVC FitUN;
by descr;
run;
ods listing; proc print data=fits; run;

proc means data=memory mean std min q1 median q3 max maxdec=2;
	title "Numerical Summary by Treatment";
	class Major Distracter;
	var Score;

ods graphics on;
	proc mixed data=memory;

	class Major Student Wordlist Distracter;
	model score=Major|Wordlist|Distracter Student(Major)/ residual;
	random Student(Major) Major;
	repeated / subject=Student type=VC rcorr;

title 'Residual Analysis - Variance Components Structure'; run;

ods graphics off;


data submemory;
	set memory;
	if Student="4" then delete;
	if Student="9" then delete;
run;

proc mixed data=submemory;
	class Major Student Wordlist Distracter;
	model score=Major|Wordlist|Distracter Student(Major) / ddfm=kr;
	random Student(Major);
	repeated / subject=Student type=VC rcorr;

title 'Variance Components - Students 4 and 9 removed'; run;

