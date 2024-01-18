

options mprint;
%macro genetic_selection(dataset,target,criterion,max_iter,mutate_ix,n_vars,population,excl,ile_nom_kat);
ods listing close;
ods results off;

Excld = &target %sysfunc(upcase(&Excl));

data _null_;
	A = "&Excld";
	num_word = countw(A);
	length quote_A $2000.;
	do i = 1 to num_word;
		word = upcase(cats("'",scan(A,i),"'"));
		quote_A = catx(',',quote_A,word);
	end;
	Call symputx('Excl_list',quote_A);
run;

proc contents 
	data=&dataset. 
	out=varlist(keep=name where=(upcase(name) ne upcase("&target") and upcase(name) not in (&excl_list)));
run;


proc sql noprint;
	create table zmienne_definicja as
	select 
			name as zmienna, 
			'int' as typ, 
			'y' as wer
	from dictionary.columns 
	where
		libname=upcase("%scan(&dataset,1,.)") 
		and memname=upcase("%scan(&dataset,2,.)")
		and upcase(name) ne upcase("&target") 
		and upcase(name) not in (&excl_list)
		and  type='num'
		; 
quit; 

proc sql noprint;
	create table nom as
	select 
		name as zmienna, 
		'nom' as typ, 
		'y' as wer
	from dictionary.columns 
	where
		libname=upcase("%scan(&dataset,1,.)") 
		and memname=upcase("%scan(&dataset,2,.)")
		and upcase(name) ne upcase("&target") 
		and upcase(name) not in (&excl_list)
		and  type='char'; 

	select zmienna 
	into :zm separated by ' '
	from nom;
quit; 
%let il=&sqlobs;
%put &il***&zm;

%macro licz;
	data uni;
		length zmienna $32 il 8;
		delete;
	run;

	%do i=1 %to &il;
		%let z=%scan(&zm,&i,%str( ));
		proc sql;
			insert into uni
			select "&z" as zmienna, count(distinct &z) as il
			from &datasets(drop=&target &excl);
		quit;
	%end;
%mend;
%licz;

proc sql;
	insert into zmienne_definicja 
	select 
		zmienna, 
		'nom' as typ, 
		'y' as wer
	from uni 

	where il<=&ile_nom_kat and il>=1
	;
quit;

proc sql;
	select
		zmienna into :class_vars separated by " " 
	from zmienne_definicja
	where typ in ('nom','char');
quit;


data tmp1 (keep=name var_num);
  set varlist end=eof;
  var_num=_n_;
  if eof=1 then call symput('nvars',_n_) ;
run;


proc surveyselect 
 data=tmp1 
 noprint
 method=srs
 out=tmp2
 n=&n_vars
 outall
 rep = &population;
run;
proc transpose data=tmp2 out=tmp3 prefix=v_;
                by Replicate;
                var Selected;
                id name;
run;

data tmp4;
	length individual $&nvars..;
set tmp3;
	individual=cats(of v_:);
run;

data individuals_base;
	retain generation;
	set tmp4;
	keep v_: individual generation;
	generation=1;
run;



%do h=1 %to &max_iter;

%macro access_indiv;

%do i=1 %to &population;


data tmp5;
	set tmp4;
	if _n_=&i.;
	keep v_: individual;
run;

proc transpose data=tmp5 out=tmp6;
run;
%put %Length(&class_vars);
proc sql;
	select substr(_name_,3,length(_name_)) into :ind_var separated by " "  from tmp6 where col1=1;
quit;
%put  %symexist(class_vars);
proc genmod data=train_woe namelen=32 desc ;
 	%if  %symexist(class_vars)=1 %then %do;
		class &class_vars;
	%end;
	model &target = &ind_var /dist=binomial link=logit ;
	ods output ModelFit = fit_stats;
run;

data fit_stats;
	length model $500.;
	set fit_stats;
	indiv=&i ;
	model="&ind_var";
	generation=&h.;
run;
%if %sysfunc(exist(work.fit_stats_all))=0 %then %do; 
data fit_stats_all;
	set fit_stats;
	generation=&h;
run;
%end;
%else %do;
proc append 
	base=fit_stats_all 
	data=fit_stats
	force;
run;
%end;


%if %sysfunc(exist(work.fit_stats_gener))=0 %then %do; 
data fit_stats_gener;
	set fit_stats;
	generation=&h;
run;
%end;
%else %do;
proc append 
	base=fit_stats_gener 
	data=fit_stats
	force;
run;
%end;
%end;

%mend;
%access_indiv;

%let crit=%&criterion%;

data tmp7;
	set fit_stats_gener;
	where criterion like "&crit";
run;
proc sort data=tmp7;
	by value;
run;
proc sql;
	drop table fit_stats_gener ;
quit;
data tmp8;
	set tmp7;
	if _n_<=%eval(&population/2);
run;


proc surveyselect data=tmp8  noprint
 groups=%eval(&population/2)
 out=tmp9
 rep = 2;
run;

%macro cross_mutation;
%do j=1 %to %eval(&population/2);
data tmp10;
	set tmp9;
	where groupid=&j. ;
	keep indiv;
	call symput (cat('ind_',_n_),indiv);
run;

data tmp11;
	set tmp4;
	where Replicate in (&ind_1,&ind_2);
	_name_="Selected";
run;

proc sort 
	data=tmp11;
	by individual;
run;
proc transpose
	data=tmp11(drop=replicate _name_ ) 
	out=tmp12;
run;

%macro mutacja;
data _null_;
	rand= put(round(%sysevalf(0.1*&nvars) +( %sysfunc(floor((1+&nvars-0.1*&nvars)))*rand("uniform"))),$20.);
	call symput('los',rand);
	call symput ('il',c);
	%do i=1 %to %sysfunc(ceil(&mutate_ix*&nvars));;
		d=put(round(%sysevalf(0.1*&nvars) +( %sysfunc(floor((1+&nvars-0.1*&nvars)))*rand("uniform"))),$20.);
		call symput (cat('los',&i),d);
		f=put(round(%sysevalf(0.1*&nvars) +( %sysfunc(floor((1+&nvars-0.1*&nvars)))*rand("uniform"))),$20.);
		call symput (cat('loss',&i),f);
	%end;

run;

data tmp13(drop=col1 col2);
	set tmp12;
	if _n_<=&los then do;
	col3=col2;
	col4=col1;
	end;
	else do;
	col3=col1;
	col4=col2;
end;

%do i=1 %to %sysfunc(ceil(&mutate_ix*&nvars));;

	if _n_= &&los&i. and col1=1 then col1=0;
	if _n_= &&los&i. and col1=0 then col1=1;
	if _n_= &&loss&i. and col2=1 then col2=0;
	if _n_= &&loss&i. and col2=0 then col2=1;
%end;
run;


%mend;
%mutacja;

proc transpose 
	data=tmp13
	out=tmp14;
	id _name_;
run;
data tmp15;
	length individual $&nvars..;
	set tmp14;
	generation=&h;
	individual=cats(of v_:);
	keep individual v_: generation;
run;

proc append 
	base=individuals_base 
	data=tmp15 
	force;
run;
%end;
data tmp4(drop=i);
	do i=1 to &population.;
	set individuals_base;
	replicate=i;
	output;
end;
	where generation=&h.;
run;
%mend;
%cross_mutation;
%end;
ods graphics on;
ods results on;



%mend genetic_selection;

%genetic_selection(dataset=work.train_woe,target=default_cross12,criterion=BIC,max_iter=50,mutate_ix=0.005,n_vars=5,population=30,excl= ,ile_nom_kat=1);





