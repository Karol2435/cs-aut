/* (C) Karol Przanowski */
/* kprzan@sgh.waw.pl    */

%let coef=1;
%let vars=x y z;
%let set=test;
%let tar=default;
%let id=id;



data vars;
do i=1 to count(symget('vars'),' ')+1;
var=upcase(scan(symget('vars'),i,' '));
output;
end;
drop i;
run;
proc sql noprint;
select 
'GRP_'||trim(var) , 'WOE_'||trim(var), 'LGT_'||trim(var),
'%woe('||compress(var)||')', 'sc_'||trim(var)
into 
:grp_vars separated by ' ',
:woe_vars separated by ' ',
:lgt_vars separated by ' ',
:macro separated by ';',
:sc_sets separated by ' '
from vars;
quit;
%put &grp_vars;
%put &woe_vars;
%put &lgt_vars;

data abt.t;
length id 8;
set abt.train_woe;
id=_n_;
keep default: id
&vars &grp_vars;
run;


/*example data preparation*/
data test0;
do id=1 to 50000;
x=ranuni(1)*200;
y=rannor(1)*100;
z=ranuni(1)*200;
w=(ranuni(1)*3)*(x+0.3*y+4*z)/1000;
default=(w<0.11);
output;
end;
run;
proc sort data=test0;
by w;
run;
proc rank data=test0 out=test groups=6;
var &vars;
ranks &grp_vars;
run;
data test;
set test;
array t(*) &grp_vars;
do i=1 to dim(t);
t(i)=t(i)+1;
end;
drop i;
label grp_x='GRP_X' grp_y='GRP_Y' grp_z='GRP_Z';
run;

/*bad = 1*/
/*good = 0*/

/*test of order grp*/
/*proc means data=test noprint;*/
/*ways 1 0;*/
/*class &grp_vars;*/
/*var &tar;*/
/*output out=stat mean()=br;*/
/*run;*/
/*test of order grp*/


/*example data preparation*/

/*first data processing*/
proc sort data=&set;
by &id;
run;
/*first data processing*/

/*score calculated in Dummy aproach*/
/*variables should not have labels or have the same label as name*/
proc logistic data=&set outest=betas_all;
class &grp_vars / param=glm ref=last;
model &tar=&grp_vars;
run;


%macro notesc(coeff,outnote);


proc transpose data=&coeff(drop=_LINK_ _TYPE_ _STATUS_ _NAME_
_LNLIKE_) 
out=tcoeff prefix=beta;
run;

data tcoeff;
length var $ 32;
set tcoeff;
if _name_ ne 'Intercept' then do;
var=substr(scan(_label_,1),5);
l=input(scan(_label_,2),best12.);
end;
run;

proc sql noprint;
select sum(beta1)*20/log(2)+300 into :alp
from tcoeff where l=1;
select beta1 into :intercept
from tcoeff where _name_='Intercept';
select count(distinct var) into :n
from tcoeff where _name_ ne 'Intercept';
quit;
%put &alp***&intercept***&n;

data &outnote;
retain first_beta;
set tcoeff;
by var notsorted;
if first.var then first_beta=beta1;
score_all=round((beta1-first_beta+&intercept/&n)*20/log(2)+&alp/&n);
where _name_ ne 'Intercept';
rename l=grp;
keep var l score_all;
run;
%mend notesc;

%notesc(betas_all,scores_all);

/*score calculated in Dummy aproach*/



/*woe and logit calculation*/
proc sql noprint;
select sum((&tar=0)),sum((&tar=1)) into
:good,:bad from &set;
quit;
%put &good***&bad;
%macro woe(var);
proc sql;
create table &var as
select &id,grp_&var,
&coef*log((sum((&tar=0))/&good)/(sum((&tar=1))/&bad)) 
as WOE_&var,
&coef*log(sum((&tar=1))/sum((&tar=0))) as LGT_&var
from &set group by 2 order by 1;
quit;
proc sort data=&var(drop=&id) out=sc_&var nodupkey;
by grp_&var;
run;
data sc_&var;
length var $ 32;
set sc_&var;
var="&var";
rename grp_&var=grp;
label grp_&var='GRP';
rename woe_&var=woe;
rename lgt_&var=lgt;
label woe_&var='WOE';
label lgt_&var='LGT';
run;
%mend;
&macro;
data &set._woe;
merge &set &vars;
by &id;
run;
data scorecard;
set &sc_sets;
run;
/*woe and logit calculation*/


/*score calculated in WOE and LGT aproach*/


proc logistic data=&set._woe outest=betas_woe;
model &tar=&woe_vars;
run;
proc transpose data=betas_woe(drop=_LNLIKE_) out=tbetas_woe;
run;

proc logistic data=&set._woe desc outest=betas_lgt;
model &tar=&lgt_vars;
run;
proc transpose data=betas_lgt(drop=_LNLIKE_) out=tbetas_lgt;
run;







/*woe approach*/
proc sql noprint;
select &tar into :alpha_woe
from tbetas_woe where _name_ eq "Intercept";
select &tar into :betas_woe separated by ','
from tbetas_woe where _name_ ne "Intercept"
order by _name_;
select quote(compress(var))  into :names
separated by ',' from vars order by 1;
quit;
%let n_vars=&sqlobs;
%put &n_vars;
%put &alpha_woe;
%put &betas_woe;
%put &names;

data _null_;
length names1-names&n_vars $ 32;
array b(&n_vars) (&betas_woe);
array names(&n_vars)$ (&names);
set scorecard end=e;
n=0;
do i=1 to &n_vars;
if var=names(i) then n=i;
end;
retain first_betas 0;
if grp=1 then first_betas=first_betas+woe*b(n)*20/log(2);
if e;
first_betas=first_betas+300;
call symput('alp_woe',put(first_betas,best12.-L));
run;


data scorecard;
length names1-names&n_vars $ 32;
array b(&n_vars) (&betas_woe);
array names(&n_vars)$ (&names);
retain first_beta;

set scorecard;

factor=20/log(2);
offset=300;

n=0;
do i=1 to &n_vars;
if var=names(i) then n=i;
end;

if grp=1 then first_beta=woe*b(n);
score_woe=
round((woe*b(n)-first_beta+&alpha_woe/&n_vars)*factor+&alp_woe/&n_vars);
keep grp var woe lgt score:;
run;
/*woe approach*/




/*lgt approach*/
proc sql noprint;
select &tar into :alpha_lgt
from tbetas_lgt where _name_ eq "Intercept";
select &tar into :betas_lgt separated by ','
from tbetas_lgt where _name_ ne "Intercept"
order by _name_;
select quote(compress(var))  into :names
separated by ',' from vars order by 1;
quit;
%let n_vars=&sqlobs;
%put &n_vars;
%put &alpha_lgt;
%put &betas_lgt;
%put &names;

data _null_;
length names1-names&n_vars $ 32;
array b(&n_vars) (&betas_lgt);
array names(&n_vars)$ (&names);
set scorecard end=e;
n=0;
do i=1 to &n_vars;
if var=names(i) then n=i;
end;
retain first_betas 0;
if grp=1 then first_betas=first_betas+lgt*b(n)*20/log(2);
if e;
first_betas=-first_betas+300;
call symput('alp_lgt',put(first_betas,best12.-L));
run;


data scorecard;
length names1-names&n_vars $ 32;
array b(&n_vars) (&betas_lgt);
array names(&n_vars)$ (&names);
retain first_beta;

set scorecard;

factor=20/log(2);
offset=300;

n=0;
do i=1 to &n_vars;
if var=names(i) then n=i;
end;

if grp=1 then first_beta=lgt*b(n);
score_lgt=
round(-(lgt*b(n)-first_beta+&alpha_lgt/&n_vars)*factor+&alp_lgt/&n_vars);
keep grp var woe lgt score:;
run;
/*lgt approach*/
/*score calculated in WOE and LGT aproach*/

proc sort data=scorecard;
by var grp;
run;

proc sort data=Scores_all;
by var grp;
run;

data scorecard_&coef;
merge scorecard scores_all;
by var grp;
run;

/*comments from results calculated on test data set:*/
/*WOE and LOGIT give the same results.*/
/*Dummy has the same first partial scores. Other scores are similar*/
/*but not equal.*/
/*Main differences we can identify when beta (measured by p-value) */
/*for individual attribute is less significat.*/
/*But for X variable grp=5 in logistic p-value is 0.54 and still we have*/
/*the same scores as in woe and lgt.*/
/*Example data set has variables with good predictive power, when we have */
/*more variables we can indicate greater differences*/







