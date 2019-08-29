* Encoding: UTF-8.

**Activate dataset.
DATASET ACTIVATE DataSet2.

**Reverse-code Q335 variables to make scales go in the same direction.
RECODE Q335_1nr Q335_5nr Q335_6nr (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) INTO Q335_1r Q335_5r Q335_6r.
VARIABLE LABELS  Q335_1r 'Protecting peoples jobs is more important than protecting the environment'
/Q335_5r 'The question of the environment is secondary to economic growth' 
/Q335_6r 'The benefits of modern consumer products are more important than the pollution that results from their production and use'.
EXECUTE.

**Create new variable that computes mean of Q335 measures.
COMPUTE proenvironment=mean(Q335_2,Q335_3,Q335_4,Q335_1r,Q335_5r,Q335_6r).
EXECUTE.

**Create frequency table and histogram of Q335 attitude measures. 
FREQUENCIES VARIABLES=proenvironment
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=proenvironment Q306
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

**Non-MR set of Q338.
FREQUENCIES VARIABLES=Q338_1 Q338_2 Q338_3 Q338_4 Q338_7
  /ORDER=ANALYSIS.

**Multiple Response set of Q338. 
DATASET ACTIVATE DataSet1.
MULT RESPONSE GROUPS=$Q338_rs 'Anticipated electricity bill - RS' (q338_1 q338_2 q338_3 q338_4 
    q338_7 (1))
  /FREQUENCIES=$Q338_rs.

**temporary select if on areas of interest (antienvironment respondents). 

