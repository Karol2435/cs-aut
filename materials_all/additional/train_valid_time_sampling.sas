/*  autor: Ada Cierkowska na podstawie kodu train_valid   */
/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */

%let sets=&in_abt;
%put &sets;
%put &prop;

/*data step zamieniaj�cy zmienn� period na zmienn� numeryczn�*/
data test;
set &sets;
numeric_period = input(period, 6.);
run;

/*wyb�r warto�ci minimalnej w�r�d numerycznego odpowiednika zmiennej period*/
proc sql;
select distinct numeric_period
into :min
from test
having numeric_period = min(numeric_period);
quit;

%put &min;

/*wyb�r warto�ci maksymalnej w�r�d numerycznego odpowiednika zmiennej period*/
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
		/*krok, w kt�rym do zbioru treningowego wybierane s� obserwacje, kt�re s� wcze�niejsze ni� data, stanowi�ca
		percentyl okre�lony przez makrozmienn� &prop*/
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
		/*krok, w kt�rym do zbioru walidacyjnego wybierane s� obserwacje, kt�re s� p�niejsze lub r�wne dacie,
		stanowi�cej percentyl okre�lony przez makrozmienn� &prop*/
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
