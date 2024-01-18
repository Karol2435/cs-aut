/*autor: Wojtek Kliszczak*/
/*KOD DO ALTERNATYWNEGO WYBORU ZMIENNYCH DO MODELU*/
/*WYBIERA ITERACYJNIE ZMIENNE, KTORE GWARANTUJA NAJWIEKSZA WARTOSC WSP GINI*/
/*JEDNOCZESNIE PILNUJE, ZEBY BETY NIE BYLY UJEMNE, A SAM MODEL NIE BYL PRZEUCZONY*/
/*JEST TO ZACHLANNA ITERACJA, TZN. W KAZDEJ ITERACJI JEST SPRAWDZANA KAZDA ZMIENNA*/
/*CZAS ODPALENIA NA 200 ZMIENNYCH TO KILKANASCIE MINUT*/

/*PO URUCHOMIENIU NALEZY SKOPIOWAC NAZWY ZMIENNYCH Z LOGU, Z JEDNEJ Z OSTATNICH LINIJEK*/
/*I UZYC ICH RAZEM ZE ZMIENNA POCZATKOWA W KODZIE MODELE_EXPERCKIE*/

proc sql noprint;
select name into :zmienne separated by ' ' from dictionary.columns 
where upcase(substr(name,1,3))='WOE'
and libname='ABT'
and memname='TRAIN_WOE';
quit;

proc sql noprint;
select count(*) into :l_zmiennych from dictionary.columns 
where upcase(substr(name,1,3))='WOE'
and libname='ABT'
and memname='TRAIN_WOE';
quit;
%put ****** Zmiennych branych pod uwage: &l_zmiennych. ******;

%macro model;

/*WPISZ NAZWE PIERWSZEJ NAJSILNIEJSZEJ ZMIENNEJ*/
%let zmienne_pocz=woe_ACT_CCSS_DUEUTL;

/*ZADANA PRZEZ NAS WARTOSC WZROSTU WART. GINI*/
/*JESLI KOLEJNA ZMIENNA WNIOSLA MNIEJ DO MODELU, TO PETLA SIE KONCZY*/
%let gini_dif=0.006;

/*ZADANA WARTOSC ROZNICY GINIEGO MIEDZY Z. TRENINGOWYM A WALIDACYJNYM*/
/*IM WIEKSZA WARTOSC, TYM WIEKSZE NIEBEZPIECZENSTWO PRZEUCZENIA MODELU*/
%let gini_tr_val_dif=0.015;

/*STALE*/
%let i=1;
%let gini_obc=0.011;
%let gini_poprz=0.0001;
%let separator_s=%str( );

data wszystko;
gini_obc=0.00001;
zmienna='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
run;

%do %while (%sysevalf(&gini_obc.-&gini_poprz.)>&gini_dif.);

	%let gini_poprz=&gini_obc.;
	%let j=%eval(&i.+1);

		%do k=1 %to &l_zmiennych.;

		%let zm=%scan(&zmienne.,&k.,%str( ));

		/*REGRESJA*/
		ods output Association=Association ScoreFitStat=ScoreFitStat ParameterEstimates=ParameterEstimates;
	/*	ods trace on;*/
		proc logistic data=abt.train_woe;
		model &tar. = &zmienne_pocz. &zm. / maxstep=&j. include=&i.;
		score data=abt.valid_woe fitstat out=ss;
		run;
	/*	ods trace off;*/
		ods output close;

		proc sql;
		drop table ss;
		quit;

		/*D SOMERSA LUB SOMERS' D W ZALEZNOSCI OD WERSJI JEZYKOWEJ SASA*/
		proc sql noprint;
		select nValue2 into :gini_tr from Association(where=(Label2='D Somersa'));
		quit;

		/*WARUNEK NA BETY - WSZYSTKIE MAJA BYC DODATNIE*/
		/*TUTAJ WARUNEK NA UJEMNE, BO W LOGISTICU MODELOWANY JEST BRAK ZDARZENIA, CZYLI NA ODWROT*/
		proc sql noprint;
		select sum(case when estimate>0 then 1 else 0 end) into :bety 
		from ParameterEstimates(where=(Variable^='Intercept'));
		quit;

		/*BETY CD. PLUS WARUNEK NA ROZNICE GINIEGO*/
		data ScoreFitStat(keep=gini_obc zmienna);
		set ScoreFitStat;
		if (&bety.>0 or abs(&gini_tr.-(2*AUC-1))>&gini_tr_val_dif.) then gini_obc=0;
		else gini_obc=2*AUC-1;
		zmienna="&zm.";
		run;

		data wszystko;
		set wszystko ScoreFitStat;
		run;

		%end;

	proc sort data=wszystko out=wybor;
	by descending gini_obc;
	run;

	/*WYBIERANA JEST NAJLEPSZA ZMIENNA*/
	data _null_;
	set wybor(obs=1);
	call symputx("gini_obc",gini_obc);
	call symputx("nowa_zm",zmienna);
	run;

	data wszystko;
	set wszystko;
	if gini_obc>0.00001 or gini_obc=0 then delete;
	run;

	%let i=%eval(&i.+1);
	%let roznica=%sysevalf(&gini_obc.-&gini_poprz.);
	%put gini_obc: &gini_obc. , gini_poprz: &gini_poprz.;
	%let zmienne_pocz=%sysfunc(catx(&separator_s.,&zmienne_pocz.,&nowa_zm.));
	%put &zmienne_pocz.;
	%put &roznica.;

%end;

%mend;
%model;

