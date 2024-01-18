/* (c) Karol Przanowski */
/* kprzan@sgh.waw.pl */


libname abt (work);

/*preparation of data example*/
data periods;
do i=0 to 24;
period=put(intnx('month','01jan2005'd,i,'beginning'),yymmn6.);
output;
end;
run;
proc sql noprint;
select 
period, 'dpd'||trim(period), 'bal'||trim(period)
into :periods separated by ' ',
:dpd separated by ' ',
:bal separated by ' '
from periods order by 1;
quit;
%let num_p=&sqlobs;
%put &num_p***&periods;
%put &dpd;
%put &bal;

data abt.example_data;
array daypastdue(&num_p) &dpd;
array balance(&num_p) &bal;
do id_client=1 to 10;
	do i=1 to 10;
	id_account=id_client*100+i;
	term=15+int(ranuni(1)*10);
	do p=1 to &num_p;
		if p<=term then do;
		daypastdue(p)=int(ranuni(1)*180);
		balance(p)=ranuni(1)*3000;
		end; else do;
		daypastdue(p)=.;
		balance(p)=.;
		end;
	end;
	output;
	end;
end;
drop i p term;
run;

/*begining of the program*/
options mprint;
%let data=abt.Example_data;
%let id_client=id_client;
%let id_account=id_account;

%macro make_abt(period);

/*%let period=200701;*/
proc sql noprint;
select distinct substr(name,4)
into :periods separated by ' '
from dictionary.columns 
where libname=upcase("%scan(&data,1,.)") and memname=upcase("%scan(&data,2,.)") 
and name like 'dpd%'
order by 1;
quit;
%let n_periods=&sqlobs;
%put &n_periods;
%put &periods;


%let first_period=%scan(&periods,1,%str( ));
%put &first_period;

data _null_;
index=intck('month',input("&first_period",yymmn6.),input("&period",yymmn6.))+1;
call symput('index',put(index,best12.-L));
run;
%put &index;


data abt.sub&period;
set &data;
keep 
&id_client &id_account
%do i=1 %to &index;
%let p=%scan(&periods,&i,%str( ));
bal&p dpd&p
%end;
;
run;

%let var1=Bal;
%let var2=Dpd;
%let n_var=2;
%let var3=Loans;
%let n_var_agr=3;


%let s1=Max;
%let s2=Min;
%let s3=Avg;
%let s4=Sum;
%let n_s=4;

%let n_s_spec=5;
%let s5=N;




proc sql;
create table abt.clients&period as
select 
%do i=1 %to &index;
%let p=%scan(&periods,&i,%str( ));
	%do v=1 %to &n_var;
		%do s=1 %to &n_s;
		&&s&s(&&var&v..&p) as &&s&s.._&&var&v..&p,
		%end;
	%end;
	sum((not missing(dpd&p))) as N_Loans&p,
%end;
&id_client
from abt.sub&period
group by &id_client;
quit;


%let sagr1=Median;
%let sagr2=Mean;
%let sagr3=Max;
%let sagr4=Min;
%let sagr5=Sum;
%let sagr6=N;
%let sagr7=Nmiss;
%let sagr8=Range;
%let sagr9=Iqr;
%let sagr10=Kurtosis;
%let sagr11=Skewness;
%let sagr12=Std;
%let n_sagr=12;

%let lengths=3 6 12 24;
%let n_lengths=4;
%let max_length=36;

%let percentil=5 25 75 95;
%let n_percentil=4;



data abt.abt&period;
array tx(&max_length);
array ty(&max_length);

set abt.clients&period;

%do len=1 %to &n_lengths;
%let length=%scan(&lengths,&len,%str( ));
%let first_index=%eval(&index-&length+1);
%if &first_index<1 %then %let first_index=1;
	%do v=1 %to &n_var_agr;
		%do s=1 %to &n_s;
		%if &v>&n_var %then %let s=&n_s_spec;
			%do a=1 %to &n_sagr;
			agr&length._&&sagr&a.._&&s&s.._&&var&v=&&sagr&a(
			%do i=&first_index %to &index;
				%let p=%scan(&periods,&i,%str( ));
				&&s&s.._&&var&v..&p ,
				%end;
			.);
			%end;
			%do c=1 %to &n_percentil;
			%let cen=%scan(&percentil,&c,%str( ));
			agr&length._Pctl&cen._&&s&s.._&&var&v=Pctl(&cen,
			%do i=&first_index %to &index;
				%let p=%scan(&periods,&i,%str( ));
				&&s&s.._&&var&v..&p ,
				%end;
			.);
			%end;
/*			other useful statistics*/
/*			under and upper mean*/
			un=0; up=0;
			mean=mean(
			%do i=&first_index %to &index;
				%let p=%scan(&periods,&i,%str( ));
				&&s&s.._&&var&v..&p ,
				%end;
			.);
			%do i=&first_index %to &index;
			%let p=%scan(&periods,&i,%str( ));
			if &&s&s.._&&var&v..&p>mean then up=up+1;
			if &&s&s.._&&var&v..&p<mean then un=un+1;
			%end;
			agr&length._UpMean_&&s&s.._&&var&v=up;
			agr&length._UnMean_&&s&s.._&&var&v=un;
/*			relations < and >*/
			rl=0; rg=0;
			%do i=&first_index %to %eval(&index-1);
			%let p=%scan(&periods,&i,%str( ));
			%let p2=%scan(&periods,%eval(&i+1),%str( ));
			if &&s&s.._&&var&v..&p>&&s&s.._&&var&v..&p2 then rg=rg+1;
			if &&s&s.._&&var&v..&p<&&s&s.._&&var&v..&p2 then rl=rl+1;
			%end;
			agr&length._RelDwn_&&s&s.._&&var&v=rg;
			agr&length._RelUp_&&s&s.._&&var&v=rl;
/*			trend*/
			do m=1 to &max_length;
			ty(m)=.;
			tx(m)=.;
			end;
			%do i=&first_index %to &index;
			%let p=%scan(&periods,&i,%str( ));
			ty(%eval(&i-&first_index+1))=&&s&s.._&&var&v..&p;
			tx(%eval(&i-&first_index+1))=%eval(&i-&first_index+1);
			if missing(ty(%eval(&i-&first_index+1))) then
			 tx(%eval(&i-&first_index+1))=.;
			%end;
			meanx=mean(of tx:);
			meany=mean(of ty:);
			upp=0;down=0;
			do m=1 to &max_length;
			upp+(tx(m)-meanx)*(ty(m)-meany);
			down+((tx(m)-meanx)**2);
			end;
			agr&length._Trend_&&s&s.._&&var&v=upp/down;
		%end;
	%end;
%end;
if _error_=1 then _error_=0;
keep &id_client agr:;
run;

%mend;
%make_abt(200610);
/*%make_abt(200701);*/

