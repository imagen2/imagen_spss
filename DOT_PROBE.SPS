** CONVERT ALL THE CSV FILES TO SAV FILES AND THEN MERGE THEM TOGETHER.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_DOT_PROBE_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

** drop practice and pretreat blocks NB - YOU MIGHT ACTALLY WANT TO LOOK AT THIS DATA?.
** Also drop the ID CHECK AND Testing situation Questions AND TEST subjects.
SELECT IF(block = 'DOT_PROBE_MAIN' &  substr(OID, 1,4) <> "TEST").

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


** Create a numerical Pass variable.
If (Result = 'PASS')  Nresult =1.
If (Result = 'FAIL')  Nresult =0.

**Split the Trial name into variables for Emotion Congruency.
String Emotion(A2).
String Congruent(A1).
Compute Emotion = substr(trial, 1, 2) .
Compute Congruent = substr(trial, 4, 1).
EXE.

** aggregate some summary variables by condition NB YOU COULD DO THIS BY BLOCK or by stimulus etc to see how the task is working overall - a VERY handy command.
** without the addvariables flag this wil replace the current file so we need to make sure everythgin we want is in here.
AGGREGATE  /OUTFILE=*    /BREAK=ID Locale Emotion Congruent / SCORE = SUM(Nresult) /RT_mean = MEAN(RT).


** now we can transpose the summary variables.
SORT CASES BY id Emotion Congruent.
CASESTOVARS
 /ID = id 
 /INDEX = Emotion Congruent
 /GROUPBY = INDEX .

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\DOT_PROBE_summary.sav'
 /COMPRESSED.
