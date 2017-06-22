DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_NI_DATA_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A40) Trial(A40) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /last_complete_attempt= LAST(Attempt) .
	SELECT IF(Attempt = last_complete_attempt).

** drop the Test Subjects and any pegboard assemby version of the ttask used at the begining.
SELECT IF(substr(SID, 1,4) <> "TEST" & substr(block, 1, 17) <> "Pegboard_Assembly").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

** convert the result to numeric.
compute R= Number(RESULT, F8.0).
formats R(F8).
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

Missing Values ni_height to WISCIV_Vocabulary (-1) .

Variable labels ID 'Subject ID' Locale ' Locale of test'.
** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\NI_complete.sav'
 /COMPRESSED.

