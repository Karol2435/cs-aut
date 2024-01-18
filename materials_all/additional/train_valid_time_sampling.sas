/*  autor: Ada Cierkowska na podstawie kodu train_valid   */
/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */

%let sets=&in_abt;
%put &sets;
%put &prop;

/*data step zamieniaj¹cy zmienn¹ period na zmienn¹ numeryczn¹*/
data test;
set &sets;
numeric_period = input(period, 6.);
run;

/*wybór wartoœci minimalnej wœród numerycznego odpowiednika zmiennej period*/
proc sql;
select distinct numeric_period
into :min
from test
having numeric_period = min(numeric_period);
quit;

%put &min;

/*wybór wartoœci maksymalnej wœród numerycznego odpowiednika zmiennej period*/
proc sql;
select distinct numeric_period
into :max
from test
having numeric_period = max(numeric_period);
quit;

%put &max;

data abt.train;
	set test;

%dodatkowe_zmienne;
/*output*/
	if &tar in (0,1,.i,.d)
	then do;
		/*krok, w którym do zbioru treningowego wybierane s¹ obserwacje, które s¹ wczeœniejsze ni¿ data, stanowi¹ca
		percentyl okreœlony przez makrozmienn¹ &prop*/
		where numeric_period < &min. +(&max. - &min.)*&prop.;
	end;
	if _error_ then _error_=0;
	keep 
	&tar aid cid outstanding period 
	default:
	app:  act:
	agr: ags:
;
drop numeric_period;
run;

data abt.valid;
	set test;

%dodatkowe_zmienne;
/*output*/
	if &tar in (0,1,.i,.d)
	then do;
		/*krok, w którym do zbioru walidacyjnego wybierane s¹ obserwacje, które s¹ póŸniejsze lub równe dacie,
		stanowi¹cej percentyl okreœlony przez makrozmienn¹ &prop*/
		where numeric_period >= &min. +(&max. - &min.)*&prop.;
	end;
	if _error_ then _error_=0;
	keep 
	&tar aid cid outstanding period 
	default:
	app:  act:
	agr: ags:
;
drop numeric_period;
run;
