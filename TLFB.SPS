DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_TLFB_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A40) Trial(A40) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /last_complete_attempt= LAST(Attempt) .
	SELECT IF(Attempt = last_complete_attempt).

** drop the Test Subjects and any pegboard assemby version of the ttask used at the begining.
SELECT IF(substr(SID, 1,4) <> "TEST" ).

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

if (rtrim(result)='euro') result='1'.
if (rtrim(result)='pounds') result='2'.

** convert the result to numeric.
compute R= Number(RESULT, F8).
formats R(F8.2).
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

Missing Values tlfb_alcohol1 to tlfb_tobacco2 (-1) .

Variable labels ID 'Subject ID' Locale ' Locale of test'.
VALUE LABELS tlfb_currency 1 '€ Euro'  2 '£ Pounds'.
VARIABLE LABELS tlfb_currency 'Which currency will you use for the TLFB?'.
VARIABLE LABELS tlfb_alcohol1 'Total # of days using alcohol in the past 30 days:'.
VARIABLE LABELS tlfb_alcohol2 'Total # of Alcohol Drink Units in past 30 days:'.
VARIABLE LABELS tlfb_alcohol3 'Total # of days using = 5 (for boys)/ = 4 (for girls) Alcohol Drink Units in past 30 days:'.
VARIABLE LABELS tlfb_alcohol4 'Total cost of alcohol in past 30 days:'.
VARIABLE LABELS tlfb_tobacco1 'Total # of days smoking tobacco in the past 30 days:'.
VARIABLE LABELS tlfb_tobacco2 'Total cost of tobacco in past 30 days:'.
VARIABLE LABELS tlfb_cannabis1 'Total # of days using cannabis in the past 30 days:'.
VARIABLE LABELS tlfb_cannabis2 'Total cost of cannabis in past 30 days:'.
VARIABLE LABELS tlfb_inhalants1 'Total # of days using inhalants in the past 30 days:'.
VARIABLE LABELS tlfb_inhalants2 'Total cost of inhalants in past 30 days:'.
VARIABLE LABELS tlfb_prescription1 'Total # of days using prescription drugs in the past 30 days:'.
VARIABLE LABELS tlfb_prescription2 'Total cost of prescription drugs in past 30 days:'.
VARIABLE LABELS tlfb_amphet1 'Total # of days using Amphetamines in the past 30 days:'.
VARIABLE LABELS tlfb_amphet2 'Total cost of Amphetamines in past 30 days:'.
VARIABLE LABELS tlfb_lsd1 'Total # of days using LSD in the past 30 days:'.
VARIABLE LABELS tlfb_lsd2 'Total cost of LSD in past 30 days:'.
VARIABLE LABELS tlfb_mushrooms1 'Total # of days using Magic Mushrooms or other hallocinogens(excluding LSD) in the past 30 days:'.
VARIABLE LABELS tlfb_mushrooms2 'Total cost of Magic Mushrooms or other hallocinogens (excluding LSD) in past 30 days:'.
VARIABLE LABELS tlfb_crack1 'Total # of days using crack in the past 30 days:'.
VARIABLE LABELS tlfb_crack2 'Total cost of crack in past 30 days:'.
VARIABLE LABELS tlfb_cocaine1 'Total # of days using cocaine in the past 30 days:'.
VARIABLE LABELS tlfb_cocaine2 'Total cost of cocaine in past 30 days:'.
VARIABLE LABELS tlfb_heroin1 'Total # of days using heroin in the past 30 days:'.
VARIABLE LABELS tlfb_heroin2 'Total cost of heroin in past 30 days:'.
VARIABLE LABELS tlfb_narcotics1 'Total # of days using Narcotics in the past 30 days:'.
VARIABLE LABELS tlfb_narcotics2 'Total cost of Naroctics in past 30 days:'.
VARIABLE LABELS tlfb_ecstasy1 'Total # of days using ecstasy in the past 30 days:'.
VARIABLE LABELS tlfb_ecstasy2 'Total cost of ecstasy in past 30 days:'.
VARIABLE LABELS tlfb_ketamine1 'Total # of days using Ketamine in the past 30 days:'.
VARIABLE LABELS tlfb_ketamine2 'Total cost of Ketamine in past 30 days:'.
VARIABLE LABELS tlfb_ghb1 'Total # of days using GHB or Liquid Ecstasy in the past 30 days:'.
VARIABLE LABELS tlfb_ghb2 'Total cost of GHB or Liquid Ecstasy in past 30 days:'.
VARIABLE LABELS tlfb_anabolic1 'Total # of days using anabolic steroids in the past 30 days:'.
VARIABLE LABELS tlfb_anabolic2 'Total cost of anabolic steroids in past 30 days:'.
VARIABLE LABELS tlfb_other1 'Total # of days using other drugs in the past 30 days:'.
VARIABLE LABELS tlfb_other2 'Total cost of other drugs in past 30 days:'.

** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\TLFB_complete.sav'
 /COMPRESSED.

