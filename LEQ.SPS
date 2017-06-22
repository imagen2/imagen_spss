DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_LEQ_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /last_complete_attempt= LAST(Attempt) .
	SELECT IF(Attempt = last_complete_attempt).

** drop the Test Subjects.
SELECT IF(substr(SID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.




** convert the result to numeric.
compute R= Number(RESULT, F2.0).
formats R(F2).
EXECUTE .

**Create an ID code.
String ID(A12).
Compute ID = substr(SID, 1, 12).

** drop unneccesary vars.
MATCH FILES FILE=* /DROP=SID attempt completed_timestamp processed_timestamp attempt_complete trial result rsp rt last_complete_attempt .

** restructure.
SORT CASES BY id block .
CASESTOVARS
 /ID = id 
 /INDEX = block 
 /GROUPBY = VARIABLE .

Variable labels ID 'Subject ID' Locale ' Locale of test'.
VALUE LABELS leq_01_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_01_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_01_year 1 'Yes' 0 'No' .
VALUE LABELS leq_02_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_02_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_02_year 1 'Yes' 0 'No' .
VALUE LABELS leq_03_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_03_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_03_year 1 'Yes' 0 'No' .
VALUE LABELS leq_04_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_04_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_04_year 1 'Yes' 0 'No' .
VALUE LABELS leq_05_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_05_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_05_year 1 'Yes' 0 'No' .
VALUE LABELS leq_06_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_06_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_06_year 1 'Yes' 0 'No' .
VALUE LABELS leq_07_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_07_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_07_year 1 'Yes' 0 'No' .
VALUE LABELS leq_08_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_08_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_08_year 1 'Yes' 0 'No' .
VALUE LABELS leq_09_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_09_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_09_year 1 'Yes' 0 'No' .
VALUE LABELS leq_10_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_10_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_10_year 1 'Yes' 0 'No' .
VALUE LABELS leq_11_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_11_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_11_year 1 'Yes' 0 'No' .
VALUE LABELS leq_12_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_12_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_12_year 1 'Yes' 0 'No' .
VALUE LABELS leq_13_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_13_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_13_year 1 'Yes' 0 'No' .
VALUE LABELS leq_14_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_14_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_14_year 1 'Yes' 0 'No' .
VALUE LABELS leq_15_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_15_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_15_year 1 'Yes' 0 'No' .
VALUE LABELS leq_16_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_16_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_16_year 1 'Yes' 0 'No' .
VALUE LABELS leq_17_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_17_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_17_year 1 'Yes' 0 'No' .
VALUE LABELS leq_18_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_18_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_18_year 1 'Yes' 0 'No' .
VALUE LABELS leq_19_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_19_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_19_year 1 'Yes' 0 'No' .
VALUE LABELS leq_20_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_20_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_20_year 1 'Yes' 0 'No' .
VALUE LABELS leq_21_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_21_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_21_year 1 'Yes' 0 'No' .
VALUE LABELS leq_22_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_22_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_22_year 1 'Yes' 0 'No' .
VALUE LABELS leq_23_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_23_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_23_year 1 'Yes' 0 'No' .
VALUE LABELS leq_24_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_24_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_24_year 1 'Yes' 0 'No' .
VALUE LABELS leq_25_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_25_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_25_year 1 'Yes' 0 'No' .
VALUE LABELS leq_26_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_26_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_26_year 1 'Yes' 0 'No' .
VALUE LABELS leq_27_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_27_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_27_year 1 'Yes' 0 'No' .
VALUE LABELS leq_28_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_28_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_28_year 1 'Yes' 0 'No' .
VALUE LABELS leq_29_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_29_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_29_year 1 'Yes' 0 'No' .
VALUE LABELS leq_30_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_30_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_30_year 1 'Yes' 0 'No' .
VALUE LABELS leq_31_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_31_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_31_year 1 'Yes' 0 'No' .
VALUE LABELS leq_32_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_32_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_32_year 1 'Yes' 0 'No' .
VALUE LABELS leq_33_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_33_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_33_year 1 'Yes' 0 'No' .
VALUE LABELS leq_34_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_34_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_34_year 1 'Yes' 0 'No' .
VALUE LABELS leq_35_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_35_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_35_year 1 'Yes' 0 'No' .
VALUE LABELS leq_36_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_36_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_36_year 1 'Yes' 0 'No' .
VALUE LABELS leq_37_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_37_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_37_year 1 'Yes' 0 'No' .
VALUE LABELS leq_38_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_38_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_38_year 1 'Yes' 0 'No' .
VALUE LABELS leq_39_feel -2 'Very Unhappy' -1 'Unhappy' 0 'Neutral' 1 'Happy' 2 'Very Happy' .
VALUE LABELS leq_39_ever 1 'Yes' 0 'No' .
VALUE LABELS leq_39_year 1 'Yes' 0 'No' .

VARIABLE LABELS leq_01_feel 'Parents divorced'.
VARIABLE LABELS leq_01_ever 'Parents divorced'.
VARIABLE LABELS leq_01_year 'Parents divorced'.
VARIABLE LABELS leq_02_feel 'Family accident or illness'.
VARIABLE LABELS leq_02_ever 'Family accident or illness'.
VARIABLE LABELS leq_02_year 'Family accident or illness'.
VARIABLE LABELS leq_03_feel 'Found a new group of friends'.
VARIABLE LABELS leq_03_ever 'Found a new group of friends'.
VARIABLE LABELS leq_03_year 'Found a new group of friends'.
VARIABLE LABELS leq_04_feel 'Got in trouble with the law'.
VARIABLE LABELS leq_04_ever 'Got in trouble with the law'.
VARIABLE LABELS leq_04_year 'Got in trouble with the law'.
VARIABLE LABELS leq_05_feel 'Stole something valuable'.
VARIABLE LABELS leq_05_ever 'Stole something valuable'.
VARIABLE LABELS leq_05_year 'Stole something valuable'.
VARIABLE LABELS leq_06_feel 'Given medication by physician'.
VARIABLE LABELS leq_06_ever 'Given medication by physician'.
VARIABLE LABELS leq_06_year 'Given medication by physician'.
VARIABLE LABELS leq_07_feel 'Fell in love'.
VARIABLE LABELS leq_07_ever 'Fell in love'.
VARIABLE LABELS leq_07_year 'Fell in love'.
VARIABLE LABELS leq_08_feel 'Death in family'.
VARIABLE LABELS leq_08_ever 'Death in family'.
VARIABLE LABELS leq_08_year 'Death in family'.
VARIABLE LABELS leq_09_feel 'Face broke out with pimples'.
VARIABLE LABELS leq_09_ever 'Face broke out with pimples'.
VARIABLE LABELS leq_09_year 'Face broke out with pimples'.
VARIABLE LABELS leq_10_feel 'Brother or sister moved out'.
VARIABLE LABELS leq_10_ever 'Brother or sister moved out'.
VARIABLE LABELS leq_10_year 'Brother or sister moved out'.
VARIABLE LABELS leq_11_feel 'Started seeing a therapist'.
VARIABLE LABELS leq_11_ever 'Started seeing a therapist'.
VARIABLE LABELS leq_11_year 'Started seeing a therapist'.
VARIABLE LABELS leq_12_feel 'Parent changed jobs'.
VARIABLE LABELS leq_12_ever 'Parent changed jobs'.
VARIABLE LABELS leq_12_year 'Parent changed jobs'.
VARIABLE LABELS leq_13_feel 'Began a time-consuming hobby'.
VARIABLE LABELS leq_13_ever 'Began a time-consuming hobby'.
VARIABLE LABELS leq_13_year 'Began a time-consuming hobby'.
VARIABLE LABELS leq_14_feel 'Got or made pregnant'.
VARIABLE LABELS leq_14_ever 'Got or made pregnant'.
VARIABLE LABELS leq_14_year 'Got or made pregnant'.
VARIABLE LABELS leq_15_feel 'Decided about college / university'.
VARIABLE LABELS leq_15_ever 'Decided about college / university'.
VARIABLE LABELS leq_15_year 'Decided about college / university'.
VARIABLE LABELS leq_16_feel 'Thought about suicide'.
VARIABLE LABELS leq_16_ever 'Thought about suicide'.
VARIABLE LABELS leq_16_year 'Thought about suicide'.
VARIABLE LABELS leq_17_feel 'Changed schools'.
VARIABLE LABELS leq_17_ever 'Changed schools'.
VARIABLE LABELS leq_17_year 'Changed schools'.
VARIABLE LABELS leq_18_feel 'Joined a club or group'.
VARIABLE LABELS leq_18_ever 'Joined a club or group'.
VARIABLE LABELS leq_18_year 'Joined a club or group'.
VARIABLE LABELS leq_19_feel 'Got in trouble at school'.
VARIABLE LABELS leq_19_ever 'Got in trouble at school'.
VARIABLE LABELS leq_19_year 'Got in trouble at school'.
VARIABLE LABELS leq_20_feel 'Got or gave sexually transmitted disease'.
VARIABLE LABELS leq_20_ever 'Got or gave sexually transmitted disease'.
VARIABLE LABELS leq_20_year 'Got or gave sexually transmitted disease'.
VARIABLE LABELS leq_21_feel 'Met a teacher I liked a lot'.
VARIABLE LABELS leq_21_ever 'Met a teacher I liked a lot'.
VARIABLE LABELS leq_21_year 'Met a teacher I liked a lot'.
VARIABLE LABELS leq_22_feel 'Family had money problems'.
VARIABLE LABELS leq_22_ever 'Family had money problems'.
VARIABLE LABELS leq_22_year 'Family had money problems'.
VARIABLE LABELS leq_23_feel 'Got own TV or computer'.
VARIABLE LABELS leq_23_ever 'Got own TV or computer'.
VARIABLE LABELS leq_23_year 'Got own TV or computer'.
VARIABLE LABELS leq_24_feel 'Parents argued or fought'.
VARIABLE LABELS leq_24_ever 'Parents argued or fought'.
VARIABLE LABELS leq_24_year 'Parents argued or fought'.
VARIABLE LABELS leq_25_feel 'Ran away from home'.
VARIABLE LABELS leq_25_ever 'Ran away from home'.
VARIABLE LABELS leq_25_year 'Ran away from home'.
VARIABLE LABELS leq_26_feel 'Started going out with a girlfriend/boyfriend'.
VARIABLE LABELS leq_26_ever 'Started going out with a girlfriend/boyfriend'.
VARIABLE LABELS leq_26_year 'Started going out with a girlfriend/boyfriend'.
VARIABLE LABELS leq_27_feel 'Got poor grades in school'.
VARIABLE LABELS leq_27_ever 'Got poor grades in school'.
VARIABLE LABELS leq_27_year 'Got poor grades in school'.
VARIABLE LABELS leq_28_feel 'Went on holiday without parents'.
VARIABLE LABELS leq_28_ever 'Went on holiday without parents'.
VARIABLE LABELS leq_28_year 'Went on holiday without parents'.
VARIABLE LABELS leq_29_feel 'Started driving a motor vehicle'.
VARIABLE LABELS leq_29_ever 'Started driving a motor vehicle'.
VARIABLE LABELS leq_29_year 'Started driving a motor vehicle'.
VARIABLE LABELS leq_30_feel 'Broke up with boy/ girl-friend'.
VARIABLE LABELS leq_30_ever 'Broke up with boy/ girl-friend'.
VARIABLE LABELS leq_30_year 'Broke up with boy/ girl-friend'.
VARIABLE LABELS leq_31_feel 'Family moved'.
VARIABLE LABELS leq_31_ever 'Family moved'.
VARIABLE LABELS leq_31_year 'Family moved'.
VARIABLE LABELS leq_32_feel 'Started making own money'.
VARIABLE LABELS leq_32_ever 'Started making own money'.
VARIABLE LABELS leq_32_year 'Started making own money'.
VARIABLE LABELS leq_33_feel 'Found religion'.
VARIABLE LABELS leq_33_ever 'Found religion'.
VARIABLE LABELS leq_33_year 'Found religion'.
VARIABLE LABELS leq_34_feel 'Parent remarried'.
VARIABLE LABELS leq_34_ever 'Parent remarried'.
VARIABLE LABELS leq_34_year 'Parent remarried'.
VARIABLE LABELS leq_35_feel 'Had a gay experience'.
VARIABLE LABELS leq_35_ever 'Had a gay experience'.
VARIABLE LABELS leq_35_year 'Had a gay experience'.
VARIABLE LABELS leq_36_feel 'Gained a lot of weight'.
VARIABLE LABELS leq_36_ever 'Gained a lot of weight'.
VARIABLE LABELS leq_36_year 'Gained a lot of weight'.
VARIABLE LABELS leq_37_feel 'Serious accident or illness'.
VARIABLE LABELS leq_37_ever 'Serious accident or illness'.
VARIABLE LABELS leq_37_year 'Serious accident or illness'.
VARIABLE LABELS leq_38_feel 'Lost virginity'.
VARIABLE LABELS leq_38_ever 'Lost virginity'.
VARIABLE LABELS leq_38_year 'Lost virginity'.
VARIABLE LABELS leq_39_feel 'Parent abused alcohol'.
VARIABLE LABELS leq_39_ever 'Parent abused alcohol'.
VARIABLE LABELS leq_39_year 'Parent abused alcohol'.
** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\LEQ_complete.sav'
 /COMPRESSED.

