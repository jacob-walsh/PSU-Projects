proc import datafile="C:\Penn State MAS\Stat 580\test.xlsx" out=memory dbms=xlsx replace;
	range="data$A1:E46";
run;

proc mixed data=test method=type3;
	class Treat Test ID;
	model Score= Treat|Test;
	random ID(Treat);
	lsmean Score/tdiff CI;
run;
