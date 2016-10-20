# README

Java File Structure :
DataMining601
	src
		statistics
			DBUtility.java [Contains odbc connection details]
			Ttest.java [Main()]
	config.properties [File with odbc credentials]
	Libraries [Apache Math Libary]
	test_samples.txt [test sample file]

All the test functions are in Ttest.java . [Can import DataMining601 into eclipse and Run]


The schema used for this project is a fact constellation schema. The OLAP layer was developed using Oracle SQL Developer.
The following README file lists some of the important points to be noted for executing the OLAP layer.

Data cleanup was performed on the original schema to aid more efficient querying. 
We populated sample_id for patients where it was null .Our clinical_fact table name is test_fact;

-----------------------------------------PART 2--------------------------------------------------

Question 1 :
	Execute the Query 1 from cse601_test.sql

Question 2:
	Execute the Query 2 from cse601_test.sql

Question 3:
	Execute the queries in Query 3 from cse601_test.sql
		First query List s_id,exp values for the patients with all  -> Created a table with name "forag" out of it so that we can show the results concatenated
		Second query gives the list of mRNA expressions can be displayed as a list.

Question 4:
    Refer Query4 in cse601_test.sql
	For executing query 4 in Part 2, a new view is created for calculating the t_test between the two groups. 
	Name of the view : ttest_view
	To calculate t statistics and p values we used oracle built in  STATS_T_TEST_INDEP function.
	   - For calculating the t_test for disease "ALL", expr ='ALL'   
		 STATS_T_TEST_INDEP(patient, n1,'STATISTIC', 'ALL')
	   - For calculating the t_test for disease "NOT ALL", expr ='NOT ALL'
		 STATS_T_TEST_INDEP(patient, n1,'STATISTIC', 'NOT ALL')
	   - For calculating the p value, ignore the expr value. 
		 STATS_T_TEST_INDEP(patient, n1)
   
Question 5:
    Refer Query5 in cse601_test.sql
	For executing query 5 in part 2, a new view is created that contains expressions from all four groups of patients. The STATS_ONE_WAY_ANOVA(patient,n1,expr) is used to calculate the f statistics among three or more samples.	
	Name of the view :ftest_view
	- For calculating the ratio of the mean squares, use expr as 'F_RATIO'
	  STATS_ONE_WAY_ANOVA(patient,n1,'F_RATIO')
    - For calculating the significance, use expr as 'SIG'
	  STATS_ONE_WAY_ANOVA(patient,n1,'SIG')
	  
	  
Question 6:   

   Refer Query6 in cse601_test.sql
   Note : The U_ID values are ordered as per PB_ID
   This process was done in two steps .First we created a table in sql and used java to calculate correlation:
	    Tables in SQL:
		   Table name "correlation_table_all" :  which consists of s_id ,array of exp values ,array of probe values for each s_id  and for patients with ALL;
		   Table name "correlation_table_aml" :  which consists of s_id ,array of exp values ,array of probe values for each s_id  and for patients with AML;
	    Java Code :
	    Java package in apache math package that implements a pearson correlation class is used.
		    Functions to Run from Main():
			   correlation_table_all() - Returns list of correlation values between each pair of patients
			   correlation_table_all_aml() - Returns list of correlation values between each pair of patients
			   cal_average() - Returns average of all the correlation values
			   
			   
			   
			   
-----------------------------------------PART 3--------------------------------------------------			   

Question 1:
	Refer Query1 in cse601_test.sql under Part 3
	The t_test is performed in the same way as Part2 Query4 but for each gene. Then , a new view is created for counting the number of unique genes. The value for disease.name is changed if the calculation is for different disease but the query remains the same.
		Created a view named "viewnow1" which lists patient with ALL,NOT ALL and its respective expression values
		Create a table named "ftable" which consits of set of informative genes
		Function used : STATS_T_TEST_INDEP from Oracle
	 
Question 2:
	Refer Query2 in cse601_test.sql under Part 3
	Note : The U_ID values are ordered as per PB_ID
	This process was done in two steps .First we created a table in sql and used java to calculate correlation:
	    Tables in SQL:
		   Table name "part6" :  which consists of s_id ,array of exp values ,array of u_id values for each s_id  and for patients with ALL;
		   Table name "part7" :  which consists of s_id ,array of exp values ,array of probe values for each s_id  and for patients with NOT ALL;
	    Java Code :
	    Java package in apache math package that implements a TTest is used to calculate p value. --Ttest().homoscedasticTTest()
		    Functions to Run from Main():
			
			   correlation_table_test_all() - Returns list of correlation values  between Patients ALL and Patients N
			   correlation_table_test_notall() - Returns list of correlation values  between Patients NOT ALL and Patients N
			    TTest().homoscedasticTTest(arr1,arr2) - Returns p_value for each patient
	
	







  