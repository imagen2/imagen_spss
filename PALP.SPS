** CONVERT ALL THE CSV FILES TO SAV FILES AND THEN MERGE THEM TOGETHER.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 1.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_11.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 1.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)).
SAVE OUTFILE='C:\temp\PALP_TEMP_21.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 1.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
SAVE OUTFILE='C:\temp\PALP_TEMP_31.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 2.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
SAVE OUTFILE='C:\temp\PALP_TEMP_12.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 2.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
SAVE OUTFILE='C:\temp\PALP_TEMP_22.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 2.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_32.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 3.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_13.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 3.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_23.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 3.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_33.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 4.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_14.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 4.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_24.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	Compute Stim_Set= 4.	
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
SAVE OUTFILE='C:\temp\PALP_TEMP_34.sav' /COMPRESSED /DROP=valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid.

ADD FILES  /FILE='C:\temp\PALP_TEMP_11.sav'
 /FILE='C:\temp\PALP_TEMP_21.sav'
 /FILE='C:\temp\PALP_TEMP_31.sav'
 /FILE='C:\temp\PALP_TEMP_12.sav'
 /FILE='C:\temp\PALP_TEMP_22.sav'
 /FILE='C:\temp\PALP_TEMP_32.sav'
 /FILE='C:\temp\PALP_TEMP_13.sav'
 /FILE='C:\temp\PALP_TEMP_23.sav'
 /FILE='C:\temp\PALP_TEMP_33.sav'
 /FILE='C:\temp\PALP_TEMP_14.sav'
 /FILE='C:\temp\PALP_TEMP_24.sav'
 /FILE='C:\temp\PALP_TEMP_34.sav'
.


** drop practice and pretreat blocks NB - YOU MIGHT ACTALLY WANT TO LOOK AT THIS DATA?.
** Also drop the ID CHECK AND Testing situation Questions AND TEST subjects.
SELECT IF(SUBSTR(block,4,2) <> "pr" & SUBSTR(block, 1, 2) <> "ts" & substr(block, 1,2) <> "id" & substr(block, 4,5) <> "intro"& substr(OID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(OID, 2, 1) = "1" OR substr(OID, 2, 1) = "2" OR substr(OID, 2, 1) = "3") locale = "en".
if (substr(OID, 2, 1) = "4" OR substr(OID, 2, 1) = "5" OR substr(OID, 2, 1) = "6" OR substr(OID, 2, 1) = "8") locale = "de".
if (substr(OID, 2, 1) = "7") locale = "fr".
End If.

** Strip the -C off the IDs to allow merging of files.
String ID (A12).
Compute ID = rtrim(substr(Oid, 1, 12)).
Exe.



** calculate an omission flag.
compute omission = 0.
If (rsp <> 'space' & substr(result, 1, 1) = 'I') Omission = 1.

** calculate an Comission flag.
compute comission = 0.
If (rsp = 'space' & substr(result, 1, 1) = 'I') Comission = 1.

* we need a condition variable for the final aggregate and then transpose.
string Condition (A2).
compute condition = substr(block, 1,2).

** Create a variable for the block "scores" to ensure this is carried over the aggregate steps.
Do if(substr(block, 1, 7) = 'summary') .
Compute tmpScore = Number (Result, F4).
Compute Condition = substr(Block,8, 2).
End If.


** aggregate these by subject / condition to make the score variable carry the score per condition as a new variable.
AGGREGATE  /OUTFILE=*  MODE=ADDVARIABLES  OVERWRITEVARS=YES  /BREAK=ID condition  /score= FIRST(tmpscore).

** we can now throw away the summary and set rows as those have been transfered to new variables.
SELECT IF(SUBSTR(block,1,1) <> "s").
Compute TrialStim = NUMBER(Trial, F2).
Compute BlockNum = NUMBER(substr(block, 4,2), F2).
Formats BlockNum(F2.0) Score(F3.0).


SAVE OUTFILE='C:\imagen_data\spss_data_files\PALP_COMPLETE.sav' DROP OID tmpSCORE /COMPRESSED .


** aggregate some summary variables by condition NB YOU COULD DO THIS BY BLOCK or by stimulus etc to see how the task is working overall - a VERY handy command.
** without the addvariables flag this wil replace the current file so we need to make sure everythgin we want is in here.
GET FILE='C:\imagen_data\spss_data_files\PALP_COMPLETE.sav'.
AGGREGATE  /OUTFILE=*    /BREAK=ID Locale Condition stim_set score  /Om = SUM(Omission) /Com= SUM(Comission) /RT_mean = MEAN(RT).

** now we can transpose the summary variables.
SORT CASES BY id condition.
CASESTOVARS
 /ID = id 
 /INDEX = condition
 /GROUPBY = INDEX .

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\PALP_Condition_Level_summary.sav'
 /COMPRESSED.

**************************************************************************.
** And Do it again to give a by block file.
GET FILE='C:\imagen_data\spss_data_files\PALP_COMPLETE.sav'.
AGGREGATE  /OUTFILE=*    /BREAK=ID Locale Condition BlockNum /Om = SUM(Omission) /Com= SUM(Comission) /RT_mean = MEAN(RT).

** now we can transpose the summary variables.
SORT CASES BY id condition BlockNum.
CASESTOVARS
 /ID = id 
 /INDEX = condition BlockNum
 /GROUPBY = INDEX .


** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\PALP_Block_Level_summary.sav'
 /COMPRESSED.

