 -----------------------------------------Part 2 ------------------------------------------
 ------------Query1----------
select count(patient.p_id) from clinical_fact,patient,disease where clinical_fact.p_id=patient.p_id and disease.ds_id=clinical_fact.ds_id and 
disease.name like '%tumor%';
select count(patient.p_id) from clinical_fact,patient,disease where clinical_fact.p_id=patient.p_id and disease.ds_id=clinical_fact.ds_id and 
disease.name  like '%leukamia%';
select count(patient.p_id) from clinical_fact,patient,disease where clinical_fact.p_id=patient.p_id and disease.ds_id=clinical_fact.ds_id and 
disease.name like '%ALL%';

------------Query2----------
select drug.type from drug ,disease,patient,clinical_fact where clinical_fact.dr_id=drug.dr_id and disease.ds_id=clinical_fact.ds_id 
and patient.p_id=clinical_fact.p_id and disease.name like '%tumor%';

------------Query3----------

create table forag as(select microarray_fact.s_id,microarray_fact.e_id,microarray_fact.exp from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and probe.u_id=gene_fact.u_id and gene_fact.cl_id='2' and microarray_fact.mu_id='1' 
and microarray_fact.s_id in ( select test_fact.s_id  from test_fact,disease where test_fact.ds_id=disease.ds_id and disease.name like '%ALL%' 
and test_fact.s_id in(select microarray_fact.s_id from sample_fact,microarray_fact where sample_fact.s_id=microarray_fact.s_id)));         

--count(*) from forag = 325                

select s_id, LISTAGG(exp,',') within group (order by s_id) as EXP  from forag group by S_ID;

--count(*) = 13
   
------------Query4----------

CREATE OR REPLACE FORCE VIEW "SUKANYAM"."TTEST_VIEW" ("PATIENT", "N1") AS 
(select  'NOT ALL' as patient, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.go_id='12502' and gene_fact.u_id=probe.u_id 
and  microarray_fact.s_id in (select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name!='ALL')
union all
select  'ALL' as patient , microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.go_id='12502' and gene_fact.u_id=probe.u_id 
and  microarray_fact.s_id in (select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='ALL'));

select  STATS_T_TEST_INDEP(patient, n1,'STATISTIC', 'NOT ALL') from ttest_view;

select  STATS_T_TEST_INDEP(patient, n1,'STATISTIC', 'ALL') from ttest_view;

select  STATS_T_TEST_INDEP(patient, n1) from ttest_view;

------------Query5----------

create view ftest_view as ((select  'ALL' as patient, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154'and microarray_fact.s_id in 
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='ALL'))
union all
(select  'AML' as patient, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact where microarray_fact.pb_id=probe.pb_id 
and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154' and microarray_fact.s_id in (select test_fact.s_id from test_fact,disease 
where  test_fact.ds_id=disease.ds_id and disease.name='AML'))
union all
(select  'Colon tumor' as patient, microarray_fact.exp as n1 from  microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154'and microarray_fact.s_id in 
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='Colon tumor'))
union all
(select  'Breast tumor' as patient, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154'and microarray_fact.s_id in 
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='Breast tumor')));


select STATS_ONE_WAY_ANOVA(patient,n1,'F_RATIO')from ftest_view;

select STATS_ONE_WAY_ANOVA(patient,n1,'SIG')from ftest_view;

------------Query6----------

	---ALL - ALL ---
create view correlation_view_all as 
((select 'ALL' as patient,microarray_fact.s_id,microarray_fact.pb_id, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154'and microarray_fact.s_id in 
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='ALL')));

SELECT   s_id, LISTAGG(pb_id, ',') WITHIN GROUP (ORDER BY pb_id) AS probe, LISTAGG(n1, ',') WITHIN GROUP 
(ORDER BY pb_id) FROM correlation_view_all GROUP BY s_id;

create table correlation_table_all as( SELECT   s_id, LISTAGG(pb_id, ',') WITHIN GROUP (ORDER BY pb_id) AS probe, LISTAGG(n1, ',') WITHIN GROUP 
(ORDER BY pb_id) as n1 FROM correlation_view_all GROUP BY s_id);


	---ALL - AML ---
  CREATE OR REPLACE FORCE VIEW "SUKANYAM"."CORRELATION_VIEW_AML" ("PATIENT", "S_ID", "PB_ID", "N1") AS 
  ((
select 'AML' as patient,microarray_fact.s_id,microarray_fact.pb_id, microarray_fact.exp as n1 from microarray_fact,probe,gene_fact 
where microarray_fact.pb_id=probe.pb_id and gene_fact.u_id=probe.u_id and gene_fact.go_id='7154'
and microarray_fact.s_id in (select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='AML')));

SELECT   s_id, LISTAGG(pb_id, ',') WITHIN GROUP (ORDER BY pb_id) AS probe, LISTAGG(n1, ',') WITHIN GROUP 
(ORDER BY pb_id) FROM CORRELATION_VIEW_AML GROUP BY s_id;

create table correlation_table_aml as( SELECT   s_id, LISTAGG(pb_id, ',') WITHIN GROUP (ORDER BY pb_id) AS probe, LISTAGG(n1, ',') WITHIN GROUP 
(ORDER BY pb_id) as n1 FROM CORRELATION_VIEW_AML GROUP BY s_id);


-----This is fed to Java code which then gives us the correlation value.
			--correlation_table_all() - Returns list of correlation values between each pair of patients
			--correlation_table_all_aml() - Returns list of correlation values between each pair of patients
			--cal_average() - Returns average of all the correlation values
			   


 -----------------------------------------Part 3 ------------------------------------------
 
 ------------Query1----------
 
 create view viewnow1 as ((select  'ALL' as patient ,microarray_fact.s_id,gene_fact.u_id,avg(microarray_fact.exp) AS n1 from microarray_fact,probe,gene_fact where microarray_fact.pb_id=probe.pb_id 
  and gene_fact.u_id=probe.u_id and  microarray_fact.s_id in 
  (select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='ALL') GROUP BY gene_fact.U_ID,microarray_fact.S_ID) 
  union all
  (select  'OTHER' as patient ,microarray_fact.s_id,gene_fact.u_id,avg(microarray_fact.exp) as n1 from microarray_fact,probe,gene_fact where microarray_fact.pb_id=probe.pb_id 
  and gene_fact.u_id=probe.u_id and  microarray_fact.s_id in 
  (select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name<>'ALL') GROUP BY gene_fact.U_ID,microarray_fact.S_ID));
  
  select * from viewnow1;
 
  drop table ftable; 
  
  create table ftable as (select U_ID ,STATS_T_TEST_INDEP(patient, n1) as p_val from viewnow1 group by U_ID having STATS_T_TEST_INDEP(patient, n1)<0.01 );
  
  select count(U_ID) from ftable;
  
  --Informative Genes
  select u_id from ftable;

------------Query2----------


create or replace view sm as(select  microarray_fact.s_id,microarray_fact.pb_id,gene_fact.u_id,avg(microarray_fact.exp) as n1 from microarray_fact,probe,gene_fact where microarray_fact.pb_id=probe.pb_id 
and gene_fact.u_id=probe.u_id and  microarray_fact.s_id in
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name='ALL')
group by microarray_fact.pb_id,microarray_fact.s_id,gene_fact.u_id);

create table part6 as (SELECT s_id,WM_CONCAT(n1) as n1,WM_CONCAT(u_id) as u_id 
FROM (SELECT s_id,n1,u_id FROM sm ) where u_id in (select u_id from part32)
 GROUP BY s_id);
 
 create or replace view sm_notall as(select  microarray_fact.s_id,microarray_fact.pb_id,gene_fact.u_id,avg(microarray_fact.exp) as n1 from microarray_fact,probe,gene_fact where microarray_fact.pb_id=probe.pb_id 
and gene_fact.u_id=probe.u_id and  microarray_fact.s_id in
(select test_fact.s_id from test_fact,disease where  test_fact.ds_id=disease.ds_id and disease.name!='ALL')
group by microarray_fact.pb_id,microarray_fact.s_id,gene_fact.u_id);

create table part7 as (SELECT s_id,WM_CONCAT(n1) as n1,WM_CONCAT(u_id) as u_id 
FROM (SELECT s_id,n1,u_id FROM sm_notall ) where u_id in (select u_id from part32)
 GROUP BY s_id);
 
 

-----This is fed to Java code which then gives us the correlation value.
			 --correlation_table_test_all() - Returns list of correlation values  between Patients ALL and Patients N
			 --correlation_table_test_notall() - Returns list of correlation values  between Patients NOT ALL and Patients N
			 --TTest().homoscedasticTTest(arr1,arr2) - Returns p_value for each patient