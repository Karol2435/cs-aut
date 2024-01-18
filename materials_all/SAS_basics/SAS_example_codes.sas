/*Examples of SAS codes to beeter understand SAS process*/

/*library examples*/
libname libr 'path' compress=yes access=readonly;
libname libr ('path1' 'path2');
libname libr (work);
libname libr clear;

libname libr excel 'path\report.xlsx';
libname libr odbc dsn=database;
libname libr oracle, teradata itp.

/*macro variable*/
%let dir=c:\karol\oferta_zajec\CS-AUT\materials_all\SAS_basics\;
libname data "&dir" compress=yes;

/*typical data processing, datastep:*/
/*internal loop to read, modify and write every row in sequential mode*/
/*classical code*/
data data.class;
set sashelp.class;
age=age+10;
run;
/*different mofifications*/
/*library WORK is default library*/
data class;
set sashelp.class;
age=age+10;
output;
output;
keep age name;
run;
data class;
do i=1 to nrows;
	set sashelp.class nobs=nrows;
	age=age+10;
	output;
end;
drop weight height;
run;
data class;
set sashelp.class;
where age>13 and name like 'J%' and sex='F';
rename age=seniorinty sex=gender;
run;


/*cummulative value*/
data class;
retain cum_age 0;
set sashelp.class;
cum_age=sum(cum_age,age);
/*below is biased by missing values*/
/*cum_age=cum_age+age;*/
run;
/*or equivalent*/
data class;
set sashelp.class;
cum_age+age;
run;

data w;
a=1; b=.;
s=sum(a,b);
s2=a+b;
s3=mean(a,b);
run;


/*datastep does not stop, only put PDV into log.*/
data w;
a=0;
b=1/a;
run;
/*log:*/
/*NOTE: Division by zero detected at line 6 column 4.*/
/*a=0 b=. _ERROR_=1 _N_=1*/
/*NOTE: Mathematical operations could not be performed at the following places. The results of the*/
/*      operations have been set to missing values.*/
/*      Each place is given by: (Number of times) at (Line):(Column).*/
/*      1 at 6:4*/
/*NOTE: The data set WORK.W has 1 observations and 2 variables.*/
/*NOTE: DATA statement used (Total process time):*/
/*      real time           0.48 seconds*/
/*      cpu time            0.01 seconds*/



/*variable attributes*/
/*name (restricted letter, a-z, A-Z,0-9, _, length=32)*/
/*type (Num, Char)*/
/*format*/
/*informat*/
/*label - any letters*/
/*what attributes are assigned in the following lines?*/
data w;
a=1;
a='1';
run;

/*be careful about length*/
data w;
a='123';
a='Helen has a cat';
run;
data w;
length a $300;
a='123';
a='Helen has a cat';
run;

/*conversion*/
data result;
a=1234567.45678;
text=put(a,commax12.2);
number=input(text,commax12.2);
run;

/*Please study in SAS documentation*/

/*formats with a dot - digital separator*/
/*best12.*/
/*12.2*/
/*comma12.2*/
/*percent12.2*/
/*formats with a comma - digital separator*/
/*numx12.2*/
/*nlnum12.2*/
/*commax12.2*/
/*nlpct12.2*/
/*useful format*/
/*z12.*/
/*date formats*/
/*datetime.*/
/*time.*/
/*date.*/
/*yymmdd10.*/
/*ddmmyy10.*/
/*POLDFDWN.*/

/*functions should be known*/
/*dim*/
/*byte*/
/*cat, catx, catt*/
/*compress*/
/*compare*/
/*index, indexw*/
/*length*/
/*missing*/
/*upcase, propcase, lowcase*/
/*rank*/
/*repeat*/
/*reverse*/
/*scan*/
/*substr*/
/*translate, tranwrd*/
/*datepart*/
/*sum, nmiss, n, std, itp.*/
/*ordinal*/
/*constant*/
/*ranuni, rannor*/
/*inputc, inputn, putc, putn*/
/*int, round, floor*/
/*vname, vlength*/
/*day(), year(), month(), qtr(),*/
/*week(), weekday(), hms(), mdy()*/
/*intck() i intnx()*/

/*useful joining codes*/
%include "&dir.test.sas" / source2;


/*In SAS data is a number*/
data result;
a=-1; /*1959-12-31*/
a=0;  /*1960-01-01*/
format a yymmdd10.;
run;

data result;
length d1 d2 d3 t1 t2 t3 dt1 dt2 8;
d1=today();
d2='01jan2014'd;
d3=0;
t1='12:34:56't;
t2=0;
t3=time();
dt1='01jan2014:12:34:56'dt;
dt2=datetime();
format d1 yymmdd10. d2 ddmmyy10. d3 date.
t1 t2 t3 time. dt1 dt2 datetime.;
run;
/*where data > '01mar2013'd;*/

data result;
length d1 d2 d3 t1 t2 t3 dt1 dt2 8;
dt1='01jan2014:12:34:56'dt;
d1=datepart(dt1);
d2='01jan2014'd;
d3=0;
t1='12:34:56't;
t2=timepart(dt1);
t3=time();
dt2=d2*24*3600+t1;
format d1 yymmdd10. d2 ddmmyy10. d3 date.
t1 t2 t3 time. dt1 dt2 datetime.;
run;

data result;
t='elen has a cat';
t2=substr(t,6,3);
t3=scan(t,2,' a');
run;

data result;
t='elen has a cat';
i=index(t,'elen');
i2=index(t,'Elen');
t3=scan(t,-1,' ');
run;

data result;
t='elen has a cat';
i=index(t,'elen');
i2=index(upcase(t),'ELEN');
t3=scan(t,-1,' ');
run;

/*missing values and indicators*/
data result;
a=.;
b=.a;
c=0;
t='    ';
ma=missing(a);
mb=missing(b);
mc=missing(c);
mt=missing(t);
run;

/*substr can change a text variable*/
data result;
t='elen';
substr(t,1,2)='Te';
run;

/*good function to calculate age*/
data result;
wiek=yrdif('12jan1980'd, date(), 'ACT/ACT');
run;

/*useful SAS tricks*/
data result;
retain a1-a100 1;
s=sum(a1,a2,a3);
ss=sum(of a1-a100);
sss=sum(of a:);
run;

/*rando numbers*/
data result;
do i=1 to 1000;
	x=ranuni(1);
	output;
end;
run;

/*different functions of length*/
data result;
length a 5;
l=vlength(a);
run;

/*Text functions*/
data result;
a='SAS has a power';
b0=compress(a);
b=compress(a,'a ');
run;
data resultw;
a='SAS has a power';
b=translate(a,'sa','SA');
run;
data result;
length a b $15 c d $100;
a='SAS'; b='has a power';
c=catt(a,b);
d=catx(' ',a,b);
run;

/*do loop statements*/
data w;
amount=1000;
percent=0.04;
do year=1 to 5;
	do m=1 to 12;
		amount=amount*(1+percent/12);
		output;
	end;
end;
format amount nlnum12.2;
/*drop year m;*/
run;

/*last argument*/
data w;
set sashelp.class;
age1=lag(age);
age2=lag2(age);
age3=lag3(age);
run;
/*Be careful*/
/*Each occurrence of a LAGn function */
/*in a program generates its own queue */
/*of values.*/

/*sorting data*/
proc sort data=sashelp.class out=class
dupout=duplicates nodupkey;
by age descending height;
run;



/*SQL Ansi standard*/
/*proc sql outobs=3;*/
proc sql;
create table result as
select * from sashelp.class;
create table result2 as
select age as seniority
label='Customer seniority' format=nlnum12.
from sashelp.class;
quit;

/*Joining tables*/
proc sort data=sashelp.class out=d1;
by name;
run;
data d2;
length name $10 town $20;
input name town;
cards;
Alfred Amsterdam
Alice Praha
Meg London
;
run;

proc sql;
create table sqljoin as
select a.name, age, town
from d1 as a inner join d2 as b
/*from d1 as a left join d2 as b*/
/*from d1 as a full join d2 as b*/
on a.name=b.name; 
quit;

/*datasets d1 and d2 should have a proper order by name*/
data join left right;
merge d1(in=z1) d2(in=z2);
by name;
if z1 and z2 then output join;
if z1 and not z2 then output left;
if not z1 and z2 then output right;
run;

/*transposition*/
proc transpose data=d1 out=t1(drop=_name_)
prefix=age_;
by name;
id age;
var weight;
run;

/*formats*/
proc format;
value agef
low-13 = 'Young'
13-high = 'Old';
run;
data formated;
set sashelp.class;
format age agef.;
run;


/*aggregation*/
/*freq*/
proc freq data=sashelp.class;
table age;
run;
proc freq data=sashelp.class noprint;
table age / out=freq missing outcum;
run;
proc freq data=sashelp.class noprint;
table age*sex / out=freq missing;
run;

/*means*/
proc means data=sashelp.class n nmiss max;
class sex;
var age;
run;
proc means data=sashelp.class noprint nway;
class sex name;
var age;
output out=stat sum()=sum min()=min p25()=p25;
run;
proc means data=sashelp.class noprint nway;
class sex name;
var age height;
output out=stat sum(age height)=suma sumh;
run;
proc means data=sashelp.class noprint;
class sex name;
var age height;
output out=stat sum()= n()= std()=
kurtosis()= skewness()= p50()=
/ autoname;
run;

%let d1=sashelp.class;
%let d2=sashelp.air;
%let i=1;
/*%let dataset= d(i)*/
%let dataset=&&d&i;
%put &dataset;

%macro do_loop(max_inter);
%do i=1 %to &max_inter;
	title "Dataset: &&d&i";
	proc print data=&&d&i (obs=5);
	run;
%end;
%mend;
%do_loop(2);

proc sql noprint;
select distinct name into :name1-:name999999 from sashelp.class;
quit;
%let n_mac_var=&sqlobs;
%put &n_mac_var;
%put _user_;

%macro do_loop2;
%do i=1 %to &n_mac_var;
	title "Name: &&name&i";
	proc print data=sashelp.class;
		where name="&&name&i";
	run;
%end;
%mend;
%do_loop2;

ods output Association=a;
/*ods trace on / listing;*/
/*ods trace off;*/
proc logistic data=sashelp.class desc outest=bety;
model sex= age weight height;
run;
ods output close;

proc logistic data=sashelp.class desc outest=bety;
model sex= age weight height;
output out=logit p=p;
run;
data logit2;
set logit;
p_new=1/(1+exp(-(
-1.764655894*age
+0.1326268932*weight
+0.1517277246*height
+1.192626698
)));
sex_m=(sex='M');
run;
proc means data=logit2 noprint nway;
var sex_m p p_new;
output out=stat mean()=;
format sex_m p p_new percent12.2;
run;


data result;
length gender $15 agegroup $10;
set sashelp.class;

if sex="F" then gender='Female';
else gender='Male';

if age<13 then agegroup='Young';
else agegroup='Old';
run;
