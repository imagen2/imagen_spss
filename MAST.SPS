DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_MAST_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

** drop the TEST users.
SELECT IF(substr(SID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

**Create an ID code and CHILD / PARENT variable.
String ID(A12).
Compute ID = substr(SID, 1, 12).



** convert the result to numeric.
compute R = Number(Result, F1.0).
formats R(F1).
EXECUTE .

** score the responses - the ones that get one point do not need any alterations.
if (block = "8"  | block = "20" | block = "21a") R = 5*R.
if (block = "1"  |
block = "2" |
block = "4" |
block = "6" |
block = "7" |
block = "10" |
block = "11" |
block = "12" |
block = "13" |
block = "14" |
block = "15" |
block = "17" |
block = "24" |
block = "25" 
) R = 2*R.

** handle inversions - MAREN COULD YOU CHECK THIS VERY CAREFULLY Some inversion seem to be handled within the task - but these two were listed in the original version and do not seem to have been carried over.
** If (block="20" | block="23") R = 0-R.


** give the questions titles a letter at the beginng so spss will allow the transpose.
Do If (length(rtrim(block))=1) .
Compute block = concat("R.","0", block).
Else .
Compute  block = concat("R.", block).
End If .

** drop unneccesary vars.
MATCH FILES FILE=*  /DROP= trial Result rsp rt first_complete_attempt processed_timestamp completed_timestamp attempt_complete attempt SID.
execute.

** restructure.
SORT CASES BY id block .
CASESTOVARS
 /ID = id 
 /INDEX = block
 /GROUPBY = VARIABLE .

* compute the summary vars.
compute mast_total= SUM(R.01 to R.31) .
IF(R.01 = -2) mast_total = mast_total + 2 .
compute mast_dsm = sum(R.26 to R.31).
compute mast_sum = sum (R.01 to R.25) .
IF(R.01 = -2) mast_sum = mast_sum + 2 .
execute.

Variable labels ID 'Subject ID' Locale 'Locale of test'.
VALUE LABELS R.01 0 'YES' 2 'NO' -2 'ALMOST NEVER DRINK' .
VALUE LABELS R.02 2 'YES' 0 'NO' .
VALUE LABELS R.03 1 'YES' 0 'NO' .
VALUE LABELS R.04 0 'YES' 2 'NO' .
VALUE LABELS R.05 1 'YES' 0 'NO' .
VALUE LABELS R.06 0 'YES' 2 'NO' .
VALUE LABELS R.07 0 'YES' 2 'NO' .
VALUE LABELS R.08 5 'YES' 0 'NO' .
VALUE LABELS R.09 1 'YES' 0 'NO' .
VALUE LABELS R.10 2 'YES' 0 'NO' .
VALUE LABELS R.11 2 'YES' 0 'NO' .
VALUE LABELS R.12 2 'YES' 0 'NO' .
VALUE LABELS R.13 2 'YES' 0 'NO' .
VALUE LABELS R.14 2 'YES' 0 'NO' .
VALUE LABELS R.15 2 'YES' 0 'NO' .
VALUE LABELS R.16 1 'YES' 0 'NO' .
VALUE LABELS R.17 2 'YES' 0 'NO' .
VALUE LABELS R.18 1 'YES' 0 'NO' .
VALUE LABELS R.19 1 'YES' 0 'NO' .
VALUE LABELS R.20 5 'YES' 0 'NO' .
VALUE LABELS R.21a 5 'YES' 0 'NO' .
VALUE LABELS R.22a 1 'YES' 0 'NO' .
VALUE LABELS R.22b 1 'YES' 0 'NO' .
VALUE LABELS R.23a 1 'YES' 0 'NO' .
VALUE LABELS R.23b 1 'YES' 0 'NO' .
VALUE LABELS R.24 2 'YES' 0 'NO' .
VALUE LABELS R.25 2 'YES' 0 'NO' .
VALUE LABELS R.26 1 'YES' 0 'NO' .
VALUE LABELS R.27 1 'YES' 0 'NO' .
VALUE LABELS R.28 1 'YES' 0 'NO' .
VALUE LABELS R.29 1 'YES' 0 'NO' .
VALUE LABELS R.30 1 'YES' 0 'NO' .
VALUE LABELS R.31 1 'YES' 0 'NO' .
VARIABLE LABELS R.01 'Do you feel you are a normal drinker?'.
VARIABLE LABELS R.02 'Have you ever awakened the morning after some drinking the night before and found that you could not remember a part of the evening before?'.
VARIABLE LABELS R.03 'Does any member of your family (wife, husband, parents, etc.) ever worry or complain about your drinking?'.
VARIABLE LABELS R.04 'Can you stop drinking without a struggle after one or two drinks?'.
VARIABLE LABELS R.05 'Do you ever feel bad about your drinking?'.
VARIABLE LABELS R.06 'Do friends or relatives think you are a normal drinker?'.
VARIABLE LABELS R.07 'Are you always able to stop drinking when you want to?'.
VARIABLE LABELS R.08 'Have you ever attended a meeting of Alcoholics Anonymous?'.
VARIABLE LABELS R.09 'Have you gotten into fights when drinking?'.
VARIABLE LABELS R.10 'Has drinking ever created problems with you and your spouse?'.
VARIABLE LABELS R.11 'Has your spouse (or other family member) ever gone to anyone for help about your drinking?'.
VARIABLE LABELS R.12 'Have you ever lost friends or lovers because of your drinking?'.
VARIABLE LABELS R.13 'Have you ever gotten into trouble at work because of drinking?'.
VARIABLE LABELS R.14 'Have you ever lost a job because of drinking?'.
VARIABLE LABELS R.15 'Have you ever neglected your obligations, your family, or your work for two or more days in a row because you were drinking?'.
VARIABLE LABELS R.16 'Do you ever drink before noon?'.
VARIABLE LABELS R.17 'Have you ever been told you have liver trouble?'.
VARIABLE LABELS R.18 'Have you ever had severe shaking after heavy drinking?'.
VARIABLE LABELS R.19 'Have you ever heard voices or seen things that werent there after heavy drinking?'.
VARIABLE LABELS R.20 'Have you ever gone to anyone for help about your drinking?'.
VARIABLE LABELS R.21a 'Have you ever been in a hospital because of drinking?'.
VARIABLE LABELS R.22a 'Have you ever been a patient in a psychiatric hospital or on a Psychiatric ward of a general hospital?'.
VARIABLE LABELS R.22b 'Was drinking part of the problem?'.
VARIABLE LABELS R.23a 'Have you ever been seen at a psychiatric or mental health clinic?'.
VARIABLE LABELS R.23b 'Was drinking part of the problem?'.
VARIABLE LABELS R.24 'Have you ever been arrested, even for a few hours, because of drunken behaviour (other than driving)?'.
VARIABLE LABELS R.25 'Have you ever been arrested for drunk driving or driving after drinking?'.
VARIABLE LABELS R.26 'Have you ever had a hangover?'.
VARIABLE LABELS R.27 'Have you ever had vague feelings of fear, anxiety, or nervousness after drinking?'.
VARIABLE LABELS R.28 'Have you ever felt a craving or strong need for a drink?'.
VARIABLE LABELS R.29 'Are you able to drink more now than you used to without feeling the same effect?'.
VARIABLE LABELS R.30 'Has drinking or stopping drinking ever resulted in your having a seizure or convulsion?'.
VARIABLE LABELS R.31 'Do you ever skip meals when you are drinking?'.



** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\MAST_complete.sav'
 /COMPRESSED.



