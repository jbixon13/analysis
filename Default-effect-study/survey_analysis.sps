* Encoding: UTF-8.

* Recoding IVs.
IF(Q4.1 = 1) Default_R = 1.
IF(Q4.1 = 2) Default_R = 1.
IF(Q4.1 = 1) Transparency = 0.
IF(Q4.1 = 2) Transparency = 0.
IF(Q5.1 = 1) Default_R = 1.
IF(Q5.1 = 2) Default_R = 1.
IF(Q5.1 = 1) Transparency = 1.
IF(Q5.1 = 2) Transparency = 1.
IF(Q6.1 = 1) Default_R = 0.
IF(Q6.1 = 2) Default_R = 0.
IF(Q6.1 = 1) Transparency = 0.
IF(Q6.1 = 2) Transparency = 0.
IF(Q7.1 = 1) Default_R = 0.
IF(Q7.1 = 2) Default_R = 0.
IF(Q7.1 = 1) Transparency = 1.
IF(Q7.1 =2) Transparency = 1.
EXECUTE.

*Recoding DVs.
IF(Q4.1 = 1) R_Choice = 1.
IF(Q4.1 = 2) R_Choice = 0.
IF(Q5.1 = 1) R_Choice = 1.
IF(Q5.1 = 2) R_Choice = 0.
IF(Q6.1 = 1) R_Choice = 0.
IF(Q6.1 = 2) R_Choice = 1.
IF(Q7.1 = 1) R_Choice = 0.
IF(Q7.1 = 2) R_Choice = 1.
EXECUTE.

IF(Q4.1 = 1) Temp = 1.
IF(Q4.1 = 2) Temp = -1.
IF(Q5.1 = 1) Temp = 1.
IF(Q5.1 = 2) Temp = -1.
IF(Q6.1 = 1) Temp = -1.
IF(Q6.1 = 2) Temp = 1.
IF(Q7.1 = 1) Temp = -1.
IF(Q7.1 = 2) Temp = 1.
EXECUTE.

COMPUTE Strength_Choice = Temp * Q8.1.
EXECUTE.

RELIABILITY
/VARIABLES=Q8.3_1 Q8.3_2 Q8.3_3 Q8.3_4 Q8.3_5
/SCALE('Threat') ALL
/MODEL=ALPHA
/STATISTICS=SCALE
/SUMMARY=TOTAL.
COMPUTE Threat = mean(Q8.3_1, Q8.3_2, Q8.3_3, Q8.3_4, Q8.3_5).
EXECUTE.

RELIABILITY
/VARIABLES=Q8.4_1, Q8.4_2, Q8.4_3, Q8.4_4
/SCALE('Anger') ALL
/MODEL=ALPHA
/STATISTICS=SCALE
/SUMMARY=TOTAL.
COMPUTE Anger = mean(Q8.4_1, Q8.4_2, Q8.4_3, Q8.4_4).
EXECUTE.

*Attention Check.
FREQUENCIES Var = Q13.1_9.
USE ALL.
COMPUTE filter_$=(Q13.1_9 = 1).
VARIABLE LABELS filter_$ 'Q13.1_9 = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

**checking default manipulation check.
GLM Q9.1_3 Q9.1_2 BY Default_R Transparency
/WSFACTOR=AidNrvsR 2 Polynomial
/METHOD=SSTYPE(3)
/EMMEANS=TABLES(Default_R)
/EMMEANS=TABLES(AidNrvsR)
/EMMEANS=TABLES(Default_R*AidNrvsR)
/EMMEANS=TABLES(Default_R*AidNrvsR * Transparency) Compare (AidNrvsR)
/PRINT=DESCRIPTIVE ETASQ
/CRITERIA=ALPHA(.05)
/WSDESIGN=AidNrvsR
/DESIGN=Default_R Transparency Default_R * Transparency.

*MANOVAS.
GLM R_Choice Strength_Choice Threat Anger BY Default_R Transparency WITH proenvironment
/METHOD=SSTYPE(3)
/INTERCEPT=INCLUDE
/PLOT=PROFILE(Default_R*Transparency)
/EMMEANS=TABLES(Default_R) WITH(proenvironment=MEAN)
/EMMEANS=TABLES(Transparency) WITH(proenvironment=MEAN)
/EMMEANS=TABLES(Default_R*Transparency) WITH(proenvironment=MEAN)
/PRINT=DESCRIPTIVE ETASQ
/CRITERIA=ALPHA(.05)
/DESIGN=Default_R Transparency proenvironment Default_R*Transparency Default_R*proenvironment
Transparency*proenvironment Default_R*Transparency*proenvironment.

**Effects of our IVs on Choice in MANOVA and in binary logistic regressions. But the three-way with
self-classify on dichotomous variable of choice found in MANOVA is not found in logistic regressions--also
true if use self-classify as a continuous

LOGISTIC REGRESSION VARIABLES R_Choice
/METHOD=ENTER Default_R Transparency Self_Classify_3_Cat
/METHOD=ENTER Default_R*Transparency Default_R* Self_Classify_3_Cat Transparency*Self_Classify_3_
Cat
/METHOD=ENTER Default_R* Transparency*Self_Classify_3_Cat
/CONTRAST (Default_R)=Indicator
/CONTRAST (Transparency)=Indicator
/CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

LOGISTIC REGRESSION VARIABLES R_Choice
/METHOD=ENTER Default_R Transparency Self_Classify
/METHOD=ENTER Default_R*Transparency Default_R* Self_Classify_3_Cat Transparency*Self_Classify
/METHOD=ENTER Default_R* Transparency*Self_Classify
/CONTRAST (Default_R)=Indicator
/CONTRAST (Transparency)=Indicator
/CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

***No effects of proenvironment even when trichotomized.

RECODE proenvironment (SYSMIS=SYSMIS) (Lowest thru 4.167=-1) (5 thru Highest=1) (ELSE=0) INTO
proenvironment_3_cat.
VARIABLE LABELS proenvironment_3_cat 'trichotomized environmental attitudes '.
EXECUTE.

**factor analyses suggested two seperate variables for evaluation of renewable energy and two for evaluation
of nonrewables.
**But there was no interactions of difference between variablesn our DVs.

COMPUTE RHealth=mean(Q11.1_4,Q11.1_5,Q11.1_6,Q11.1_7,Q11.1_8,Q11.1_9).
COMPUTE REcon=mean(Q11.1_1,Q11.1_2,Q11.1_3).
EXECUTE.
COMPUTE NRHealth=mean(Q12.1_4,Q12.1_5,Q12.1_6,Q12.1_7,Q12.1_8,Q12.1_9).
COMPUTE NREcon=mean(Q12.1_1,Q12.1_2,Q12.1_3).
EXECUTE.

Compute RvsNrHealth =RHealth-NRHealth.
Compute RvsNrEcon=REcon-NREcon.
Execute.

*Recode self-classify into 3 & 4 category variables because variable is skewed.

RECODE Self_Classify (1=1) (2=2) (3 thru 6=3) INTO Self_Classify_3_Cat.
VARIABLE LABELS Self_Classify_3_Cat 'reaction to climate change - 3 categories'.
EXECUTE.

**effect on reactance not significant (because of lack of reactance on feeling like choices were threatened).
Compute Reactance = mean(anger, threat).
Execute.

GLM Strength_Choice Threat Anger BY Default_R Transparency Self_Classify_3_Cat
/METHOD=SSTYPE(3)
/INTERCEPT=INCLUDE
/PLOT=PROFILE(Self_Classify_3_Cat*Default_R*Transparency)
/EMMEANS=TABLES(Default_R*Transparency*Self_Classify_3_Cat) Compare (Default_R)
/EMMEANS=TABLES(Default_R*Transparency*Self_Classify_3_Cat) Compare (Transparency)
/EMMEANS=TABLES(Default_R*Transparency*Self_Classify_3_Cat) Compare (Self_Classify_3_Cat)
/PRINT=DESCRIPTIVE ETASQ
/CRITERIA=ALPHA(.05)
/DESIGN= Default_R Transparency Self_Classify_3_Cat Default_R*Transparency
Default_R*Self_Classify_3_Cat Transparency*Self_Classify_3_Cat
Default_R*Transparency*Self_Classify_3_Cat.

GLM Strength_Choice Threat Anger BY Default_R Transparency Self_Classify_3_Cat
/METHOD=SSTYPE(3)
/INTERCEPT=INCLUDE
/PRINT=DESCRIPTIVE ETASQ
/CRITERIA=ALPHA(.05)
/DESIGN= Default_R Transparency Self_Classify_3_Cat Default_R*Transparency
Default_R*Self_Classify_3_Cat Transparency*Self_Classify_3_Cat
Default_R*Transparency*Self_Classify_3_Cat.

DATASET ACTIVATE DataSet1.
LOGISTIC REGRESSION VARIABLES R_Choice
/METHOD=ENTER Default_R Transparency Self_Classify_3_Cat
/METHOD=ENTER Default_R*Transparency Self_Classify_3_Cat Transparency*Self_Classify_3_Cat Default
_R*Self_Classify_3_Cat
/METHOD=ENTER Default_R*Transparency*Self_Classify_
3_Cat
/CONTRAST (Default_R)=Indicator(1)
/CONTRAST (Transparency)=Indicator(1)
/CONTRAST (Self_Classify_3_Cat)=Indicator(1)
/CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

