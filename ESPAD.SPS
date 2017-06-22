DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_ESPAD_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_ESPAD_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\child.sav'.
EXECUTE.

 
** drop the id_checks - these should be dealt with as a whole in a different script.
USE ALL.
SELECT IF(SUBSTR(block,1,2) <> "id" AND SUBSTR(block,1,2) <> "ts" AND  substr(SID, 1,4) <> "TEST").
 
** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

** convert the result to numeric.
compute R = Number(Result, F8.0).
formats R(F8).
 
**Create an ID code and CHILD / PARENT variable.
String ID(A12).
String PorC(A1).
String P.locale(A2).
String C.locale(A2).
Compute ID = substr(SID, 1, 12).
Compute PorC = substr(SID, 14, 1).
If (PorC="C") C.Locale = Locale.
If (PorC="P") P.Locale = Locale.

** no known inversions beyond coding within task.
 
** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\ESPAD_complete.sav'
  /DROP=SID attempt locale completed_timestamp processed_timestamp attempt_complete trial result rsp rt first_complete_attempt /COMPRESSED.
GET
 FILE='C:\imagen_data\spss_data_files\ESPAD_complete.sav'.
execute.


*** BY ADDING THIS DUMMY SUBJECT WHO HAS AN ENSWER FOR ALL POSSIBLE QUESTIONS      .
*** WE ENSURE THAT ALL QUESTINS WILL PRODUCE A VARIABLE IN THE TRANSPOSED FILE         .

ADD FILES /FILE=*
 /FILE='C:\imagen_data\syntaxes\ESPAD_DUMMY_NEEDED_FOR_ESPAD_SCRIPT.sav'.
EXECUTE.


** restructure.
SORT CASES BY id PorC  block.
CASESTOVARS
 /ID = id 
 /INDEX = PorC block 
 /GROUPBY = VARIABLE .
 
** THE Dummy subject has now done its job and can be removed.
SELECT IF (ID <> "DUMMYSUBJECT") .
 
* compute the summary vars the + 1 is because dast1 is not answered and has to be validated if they complete any items.
 
compute C.ftnd_sum  = sum(C.ftnd1 to C.ftnd6) .
compute P.ftnd_sum  = sum(P.ftnd1 to P.ftnd6) .

compute P.dast_amphet_sum = SUM(P.dast3amphet,P.dast4amphet,P.dast5amphet,P.dast6amphet,P.dast7amphet,P.dast8amphet,P.dast9amphet,P.dast10amphet,P.dast11amphet,P.dast12amphet,P.dast13amphet,P.dast14amphet,P.dast15amphet,P.dast16amphet,P.dast17amphet,P.dast18amphet,P.dast19amphet,P.dast20amphet).	
compute P.dast_anabolic_sum = SUM(P.dast3anabolic,P.dast4anabolic,P.dast5anabolic,P.dast6anabolic,P.dast7anabolic,P.dast8anabolic,P.dast9anabolic,P.dast10anabolic,P.dast11anabolic,P.dast12anabolic,P.dast13anabolic,P.dast14anabolic,P.dast15anabolic,P.dast16anabolic,P.dast17anabolic,P.dast18anabolic,P.dast19anabolic,P.dast20anabolic).	
compute P.dast_cannabis_sum = SUM(P.dast3cannabis,P.dast4cannabis,P.dast5cannabis,P.dast6cannabis,P.dast7cannabis,P.dast8cannabis,P.dast9cannabis,P.dast10cannabis,P.dast11cannabis,P.dast12cannabis,P.dast13cannabis,P.dast14cannabis,P.dast15cannabis,P.dast16cannabis,P.dast17cannabis,P.dast18cannabis,P.dast19cannabis,P.dast20cannabis).	
compute P.dast_coke_sum = SUM(P.dast3coke,P.dast4coke,P.dast5coke,P.dast6coke,P.dast7coke,P.dast8coke,P.dast9coke,P.dast10coke,P.dast11coke,P.dast12coke,P.dast13coke,P.dast14coke,P.dast15coke,P.dast16coke,P.dast17coke,P.dast18coke,P.dast19coke,P.dast20coke).	
compute P.dast_crack_sum = SUM(P.dast3crack,P.dast4crack,P.dast5crack,P.dast6crack,P.dast7crack,P.dast8crack,P.dast9crack,P.dast10crack,P.dast11crack,P.dast12crack,P.dast13crack,P.dast14crack,P.dast15crack,P.dast16crack,P.dast17crack,P.dast18crack,P.dast19crack,P.dast20crack).	
compute P.dast_ghb_sum = SUM(P.dast3ghb,P.dast4ghb,P.dast5ghb,P.dast6ghb,P.dast7ghb,P.dast8ghb,P.dast9ghb,P.dast10ghb,P.dast11ghb,P.dast12ghb,P.dast13ghb,P.dast14ghb,P.dast15ghb,P.dast16ghb,P.dast17ghb,P.dast18ghb,P.dast19ghb,P.dast20ghb).	
compute P.dast_glue_sum = SUM(P.dast3glue,P.dast4glue,P.dast5glue,P.dast6glue,P.dast7glue,P.dast8glue,P.dast9glue,P.dast10glue,P.dast11glue,P.dast12glue,P.dast13glue,P.dast14glue,P.dast15glue,P.dast16glue,P.dast17glue,P.dast18glue,P.dast19glue,P.dast20glue).	
compute P.dast_heroin_sum = SUM(P.dast3heroin,P.dast4heroin,P.dast5heroin,P.dast6heroin,P.dast7heroin,P.dast8heroin,P.dast9heroin,P.dast10heroin,P.dast11heroin,P.dast12heroin,P.dast13heroin,P.dast14heroin,P.dast15heroin,P.dast16heroin,P.dast17heroin,P.dast18heroin,P.dast19heroin,P.dast20heroin).	
compute P.dast_ketamine_sum = SUM(P.dast3ketamine,P.dast4ketamine,P.dast5ketamine,P.dast6ketamine,P.dast7ketamine,P.dast8ketamine,P.dast9ketamine,P.dast10ketamine,P.dast11ketamine,P.dast12ketamine,P.dast13ketamine,P.dast14ketamine,P.dast15ketamine,P.dast16ketamine,P.dast17ketamine,P.dast18ketamine,P.dast19ketamine,P.dast20ketamine).	
compute P.dast_lsd_sum = SUM(P.dast3lsd,P.dast4lsd,P.dast5lsd,P.dast6lsd,P.dast7lsd,P.dast8lsd,P.dast9lsd,P.dast10lsd,P.dast11lsd,P.dast12lsd,P.dast13lsd,P.dast14lsd,P.dast15lsd,P.dast16lsd,P.dast17lsd,P.dast18lsd,P.dast19lsd,P.dast20lsd).	
compute P.dast_mdma_sum = SUM(P.dast3mdma,P.dast4mdma,P.dast5mdma,P.dast6mdma,P.dast7mdma,P.dast8mdma,P.dast9mdma,P.dast10mdma,P.dast11mdma,P.dast12mdma,P.dast13mdma,P.dast14mdma,P.dast15mdma,P.dast16mdma,P.dast17mdma,P.dast18mdma,P.dast19mdma,P.dast20mdma).	
compute P.dast_mushrooms_sum = SUM(P.dast3mushrooms,P.dast4mushrooms,P.dast5mushrooms,P.dast6mushrooms,P.dast7mushrooms,P.dast8mushrooms,P.dast9mushrooms,P.dast10mushrooms,P.dast11mushrooms,P.dast12mushrooms,P.dast13mushrooms,P.dast14mushrooms,P.dast15mushrooms,P.dast16mushrooms,P.dast17mushrooms,P.dast18mushrooms,P.dast19mushrooms,P.dast20mushrooms).	
compute P.dast_narcotic_sum = SUM(P.dast3narcotic,P.dast4narcotic,P.dast5narcotic,P.dast6narcotic,P.dast7narcotic,P.dast8narcotic,P.dast9narcotic,P.dast10narcotic,P.dast11narcotic,P.dast12narcotic,P.dast13narcotic,P.dast14narcotic,P.dast15narcotic,P.dast16narcotic,P.dast17narcotic,P.dast18narcotic,P.dast19narcotic,P.dast20narcotic).	
compute P.dast_relevin_sum = SUM(P.dast3relevin,P.dast4relevin,P.dast5relevin,P.dast6relevin,P.dast7relevin,P.dast8relevin,P.dast9relevin,P.dast10relevin,P.dast11relevin,P.dast12relevin,P.dast13relevin,P.dast14relevin,P.dast15relevin,P.dast16relevin,P.dast17relevin,P.dast18relevin,P.dast19relevin,P.dast20relevin).	
compute P.dast_tranq_sum = SUM(P.dast3tranq,P.dast4tranq,P.dast5tranq,P.dast6tranq,P.dast7tranq,P.dast8tranq,P.dast9tranq,P.dast10tranq,P.dast11tranq,P.dast12tranq,P.dast13tranq,P.dast14tranq,P.dast15tranq,P.dast16tranq,P.dast17tranq,P.dast18tranq,P.dast19tranq,P.dast20tranq).	

If (not sysmis(P.dast_amphet_sum)) P.dast_amphet_sum = P.dast_amphet_sum +1 .	
If (not sysmis(P.dast_anabolic_sum)) P.dast_anabolic_sum = P.dast_anabolic_sum +1 .	
If (not sysmis(P.dast_cannabis_sum)) P.dast_cannabis_sum = P.dast_cannabis_sum +1 .	
If (not sysmis(P.dast_coke_sum)) P.dast_coke_sum = P.dast_coke_sum +1 .	
If (not sysmis(P.dast_crack_sum)) P.dast_crack_sum = P.dast_crack_sum +1 .	
If (not sysmis(P.dast_ghb_sum)) P.dast_ghb_sum = P.dast_ghb_sum +1 .	
If (not sysmis(P.dast_glue_sum)) P.dast_glue_sum = P.dast_glue_sum +1 .	
If (not sysmis(P.dast_heroin_sum)) P.dast_heroin_sum = P.dast_heroin_sum +1 .	
If (not sysmis(P.dast_ketamine_sum)) P.dast_ketamine_sum = P.dast_ketamine_sum +1 .	
If (not sysmis(P.dast_lsd_sum)) P.dast_lsd_sum = P.dast_lsd_sum +1 .	
If (not sysmis(P.dast_mdma_sum)) P.dast_mdma_sum = P.dast_mdma_sum +1 .	
If (not sysmis(P.dast_mushrooms_sum)) P.dast_mushrooms_sum = P.dast_mushrooms_sum +1 .	
If (not sysmis(P.dast_narcotic_sum)) P.dast_narcotic_sum = P.dast_narcotic_sum +1 .	
If (not sysmis(P.dast_relevin_sum)) P.dast_relevin_sum = P.dast_relevin_sum +1 .	
If (not sysmis(P.dast_tranq_sum)) P.dast_tranq_sum = P.dast_tranq_sum +1 .	
 
execute.
 
Variable labels ID 'Subject ID'
P.locale 'Locale of Parent'
C.locale 'Locale of Child'.

** BELOW IS ALL CHILD FOLLOWED BY ALL PARENT LABELS for the main body of the questionnaire .

VALUE LABELS C.4a 1 'None' 2 '1 day' 3 '2 days' 4 '3-4 days' 5 '5-6 days' 6 '7 days or more' .
VALUE LABELS C.4b 1 'None' 2 '1 day' 3 '2 days' 4 '3-4 days' 5 '5-6 days' 6 '7 days or more' .
VALUE LABELS C.4c 1 'None' 2 '1 day' 3 '2 days' 4 '3-4 days' 5 '5-6 days' 6 '7 days or more' .
VALUE LABELS C.5 1 'A  (93-100)' 2 'A- (90-92)' 3 'B+ (87-89)' 4 'B  (83-86)' 5 'B- (80-82)' 6 'C+ (77-79)' 7 'C  (73-76)' 8 'C- (70-72)' .
VALUE LABELS C.6 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29e 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.29f 0 'Never' 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.7 0 'Not at all' 1 'Less than 1 cigarette per week' 2 'Less than 1 cigarette per day' 3 '1-5 cigarettes per day' 4 '6-10 cigarettes per day' 5 '11-20 cigarettes per day' 6 'More than 20 cigarettes per day' .
VALUE LABELS C.ftnd1 3 'Within 5 minutes' 2 '6-30 minutes' 1 '31-60 minutes' 0 'after 60 minutes' .
VALUE LABELS C.ftnd2 1 'Yes' 0 'No' .
VALUE LABELS C.ftnd3 1 'The first one in the morning' 0 'All others' .
VALUE LABELS C.ftnd4 0 '10 or less' 1 '11-20' 2 '21-30' 3 '31 or more' .
VALUE LABELS C.ftnd5 1 'Yes' 0 'No' .
VALUE LABELS C.ftnd6 1 'Yes' 0 'No' .
VALUE LABELS C.8a 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.8b 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.8c 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.9a 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29beer 0 'Never' 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.9b 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29wine 0 'Never' 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.9c 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29alcopop 0 'Never' 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.9d 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29spirits 0 'Never' 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.17a 0 '0' 1 '1' 2 '2' 3 '3-5' 4 '6-9' 5 '10 or more times' .
VALUE LABELS C.17b 0 '0' 1 '1' 2 '2' 3 '3-5' 4 '6-9' 5 '10 or more times' .
VALUE LABELS C.17c 0 '0' 1 '1' 2 '2' 3 '3-5' 4 '6-9' 5 '10 or more times' .
VALUE LABELS C.prev31 1 '1 or 2' 2 '3 or 4' 3 '5 or 6' 4 '7 to 9' 5 '10 or more' .
VALUE LABELS C.18a 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18b 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18c 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18d 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18e 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18f 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18g 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18h 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18i 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18j 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.18k 1 'Very likely' 2 'Likely' 3 'Unsure' 4 'Unlikely' 5 'Very unlikely' .
VALUE LABELS C.19a 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.19b 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.19c 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.29d 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.20 1 '1 Somewhat merry only' 2 '2' 3 '3' 4 '4' 5 '5' 6 '6' 7 '7' 8 '8' 9 '9' 10 '10 Heavily intoxicated to the point of being unable to stand on my feet.' .
VALUE LABELS C.21 1 '1-2 drinks' 2 '3-4 drinks' 3 '5-6 drinks' 4 '7-8 drinks' 5 '9-10 drinks' 6 '11-12 drinks' 7 '13 drinks or more' .
VALUE LABELS C.22_hash 1 'Yes' 0 'No' .
VALUE LABELS C.22_inhalants 1 'Yes' 0 'No' .
VALUE LABELS C.22_tranq 1 'Yes' 0 'No' .
VALUE LABELS C.22_amphet 1 'Yes' 0 'No' .
VALUE LABELS C.22_lsd 1 'Yes' 0 'No' .
VALUE LABELS C.22_mushrooms 1 'Yes' 0 'No' .
VALUE LABELS C.22_crack 1 'Yes' 0 'No' .
VALUE LABELS C.22_coke 1 'Yes' 0 'No' .
VALUE LABELS C.22_relevin 1 'Yes' 0 'No' .
VALUE LABELS C.22_heroin 1 'Yes' 0 'No' .
VALUE LABELS C.22_narcotic 1 'Yes' 0 'No' .
VALUE LABELS C.22_mdma 1 'Yes' 0 'No' .
VALUE LABELS C.22_ketamine 1 'Yes' 0 'No' .
VALUE LABELS C.22_ghb 1 'Yes' 0 'No' .
VALUE LABELS C.22_anabolic 1 'Yes' 0 'No' .
VALUE LABELS C.23 1 'Yes' 0 'No' .
VALUE LABELS C.life_hash 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_hash 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_hash 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_hash 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_hash 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_glue 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_glue 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_glue 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_glue 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_glue 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_tranq 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_tranq 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_tranq 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_tranq 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_tranq 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_amphet 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_amphet 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_amphet 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_amphet 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_amphet 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_lsd 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_lsd 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_lsd 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_lsd 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_lsd 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_mushrooms 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_mushrooms 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_mushrooms 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_mushrooms 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_mushrooms 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_crack 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_crack 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_crack 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_crack 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_crack 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_coke 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_coke 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_coke 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_coke 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_coke 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_relevin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_relevin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_relevin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_relevin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_relevin 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_heroin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_heroin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_heroin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_heroin 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_heroin 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_narcotic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_narcotic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_narcotic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_narcotic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_narcotic 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_mdma 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_mdma 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_mdma 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_mdma 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_mdma 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_ketamine 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_ketamine 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_ketamine 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_ketamine 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_ketamine 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_ghb 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_ghb 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_ghb 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_ghb 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_ghb 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.life_anabolic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.year_anabolic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.month_anabolic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.week_anabolic 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS C.first_anabolic 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' .
VALUE LABELS C.bully01 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully02 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully03 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully04 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully05 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully06 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully07 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully08 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully09 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully10 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully11 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VALUE LABELS C.bully12 1 'None' 2 'Only once or twice' 3 '2 or 3 times a month' 4 'About once a week' 5 'Several times a week' .
VARIABLE LABELS C.4a 'During the LAST 30 DAYS how many whole days of school have you missed because of illness?'.
VARIABLE LABELS C.4b 'During the LAST 30 DAYS how many whole days of school have you missed because you skipped or ”cut”?'.
VARIABLE LABELS C.4c 'During the LAST 30 DAYS how many whole days of school have you missed for other reasons?'.
VARIABLE LABELS C.5 'Which of the following best describes your average grade in the end of the last term?'.
VARIABLE LABELS C.6 'On how many occasions during your lifetime have you smoked cigarettes?'.
VARIABLE LABELS C.29e 'When did you smoke your FIRST cigarette?'.
VARIABLE LABELS C.29f 'When did you first smoke cigarettes ON A DAILY BASIS?'.
VARIABLE LABELS C.7 'How frequently have you smoked cigarettes during the LAST 30 DAYS?'.
VARIABLE LABELS C.ftnd1 'How soon after you wake up do you smoke your first cigarette?'.
VARIABLE LABELS C.ftnd2 'Do you find it difficult to refrain from smoking in places where it is forbidden, e.g. at the mosque (church), at the bus?'.
VARIABLE LABELS C.ftnd3 'Which cigarette would you hate most to give up?'.
VARIABLE LABELS C.ftnd4 'How many cigarettes/day do you smoke?'.
VARIABLE LABELS C.ftnd5 'Do you smoke more frequently during the first hours after waking than the rest of the day?'.
VARIABLE LABELS C.ftnd6 'Do you smoke when you are so ill that you are in bed most of the day?'.
VARIABLE LABELS C.8a 'On how many occasions IN YOUR WHOLE LIFETIME have you had any alcoholic beverage to drink?'.
VARIABLE LABELS C.8b 'On how many occasions OVER THE LAST 12 MONTHS have you had any alcoholic beverage to drink?'.
VARIABLE LABELS C.8c 'On how many occasions OVER THE LAST 30 DAYS have you had any alcoholic beverage to drink?'.
VARIABLE LABELS C.9a 'On how many occasions OVER THE LAST 30 DAYS have you had beer to drink? (do not include low alcohol beer)'.
VARIABLE LABELS C.29beer 'When did you FIRST drink beer (at least one glass)?'.
VARIABLE LABELS C.9b 'On how many occasions OVER THE LAST 30 DAYS have you had wine to drink?'.
VARIABLE LABELS C.29wine 'When did you FIRST drink wine (at least one glass)?'.
VARIABLE LABELS C.9c 'On how many occasions OVER THE LAST 30 DAYS have you had an alcopop to drink? (e.g. Barcardi Breezer)'.
VARIABLE LABELS C.29alcopop 'When did you FIRST drink alcopops (at least one bottle)?'.
VARIABLE LABELS C.9d 'On how many occasions OVER THE LAST 30 DAYS have you had spirits to drink? (whisky, cognac, shot drinks etc) (also include spirits mixed with soft drinks, except alcopops)'.
VARIABLE LABELS C.29spirits 'When did you FIRST drink spirits (at least one glass)?'.
VARIABLE LABELS C.17a 'How many times IN YOUR WHOLE LIFETIME have you had five or more drinks in a row?'.
VARIABLE LABELS C.17b 'How many times OVER THE LAST 12 MONTHS have you had five or more drinks in a row?'.
VARIABLE LABELS C.17c 'How many times OVER THE LAST 30 DAYS have you had five or more drinks in a row?'.
VARIABLE LABELS C.prev31 'How many drinks containing alcohol do you have on a TYPICAL DAY when you are drinking?'.
VARIABLE LABELS C.18a 'Feel relaxed'.
VARIABLE LABELS C.18b 'Get into trouble with police'.
VARIABLE LABELS C.18c 'Harm my health'.
VARIABLE LABELS C.18d 'Feel happy'.
VARIABLE LABELS C.18e 'Forget my problems'.
VARIABLE LABELS C.18f 'Not be able to stop drinking'.
VARIABLE LABELS C.18g 'Get a hangover'.
VARIABLE LABELS C.18h 'Feel more friendly and outgoing'.
VARIABLE LABELS C.18i 'Do something I would regret'.
VARIABLE LABELS C.18j 'Have a lot of fun'.
VARIABLE LABELS C.18k 'Feel sick'.
VARIABLE LABELS C.19a 'On how many occasions IN YOUR WHOLE LIFETIME have you been drunk from drinking alcoholic beverages?'.
VARIABLE LABELS C.19b 'On how many occasions OVER THE LAST 12 MONTHS have you been drunk from drinking alcoholic beverages?'.
VARIABLE LABELS C.19c 'On how many occasions OVER THE LAST 30 DAYS have you been drunk from drinking alcoholic beverages?'.
VARIABLE LABELS C.29d 'When did you FIRST get drunk from drinking alcoholic beverages?'.
VARIABLE LABELS C.20 'Please indicate on this scale from 1 to 10 how drunk you would say you were the last time you were drunk.'.
VARIABLE LABELS C.21 'How many drinks do you usually need to get drunk?'.
VARIABLE LABELS C.22_hash 'Marijuana (weed, grass, skunk, pot, ganja) or hashish (hash, hash oil)'.
VARIABLE LABELS C.22_inhalants 'Inhalants like glue or aerosols'.
VARIABLE LABELS C.22_tranq 'Tranquillisers or sedatives (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal).'.
VARIABLE LABELS C.22_amphet 'Amphetamines (speed, uppers, crystal meth) or desoxyn.'.
VARIABLE LABELS C.22_lsd 'LSD (acid)'.
VARIABLE LABELS C.22_mushrooms 'Magic mushrooms or other hallucinogens (excluding LSD)'.
VARIABLE LABELS C.22_crack 'Crack'.
VARIABLE LABELS C.22_coke 'Cocaine (coke)'.
VARIABLE LABELS C.22_relevin 'Relevin'.
VARIABLE LABELS C.22_heroin 'Heroin'.
VARIABLE LABELS C.22_narcotic 'Narcotics (e.g. opium, morphine, codeine)'.
VARIABLE LABELS C.22_mdma 'Ecstasy (MDMA)'.
VARIABLE LABELS C.22_ketamine 'Ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)'.
VARIABLE LABELS C.22_ghb 'GHB or liquid ecstasy'.
VARIABLE LABELS C.22_anabolic 'Anabolic steroids'.
VARIABLE LABELS C.23 'Have you ever wanted to try any of the drugs mentioned in the previous questions?'.
VARIABLE LABELS C.life_hash 'On how many occasions IN YOUR WHOLE LIFETIME have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS C.year_hash 'On how many occasions OVER THE LAST 12 MONTHS have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS C.month_hash 'On how many occasions OVER THE LAST 30 DAYS have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS C.week_hash 'On how many occasions OVER THE LAST WEEK have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS C.first_hash 'When did you first try marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS C.life_glue 'On how many occasions IN YOUR WHOLE LIFETIME have you sniffed a substance (glue, aerosols etc) to get high??'.
VARIABLE LABELS C.year_glue 'On how many occasions OVER THE LAST 12 MONTHS have you sniffed a substance (glue, aerosols etc) to get high??'.
VARIABLE LABELS C.month_glue 'On how many occasions OVER THE LAST 30 DAYS have you sniffed a substance (glue, aerosols etc) to get high??'.
VARIABLE LABELS C.week_glue 'On how many occasions OVER THE LAST WEEK have you sniffed a substance (glue, aerosols etc) to get high??'.
VARIABLE LABELS C.first_glue 'When did you first use Inhalants (glue, etc) to get high?'.
VARIABLE LABELS C.life_tranq 'On how many occasions IN YOUR WHOLE LIFETIME have you used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS C.year_tranq 'On how many occasions OVER THE LAST 12 MONTHS have you used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS C.month_tranq 'On how many occasions OVER THE LAST 30 DAYS have you used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS C.week_tranq 'On how many occasions OVER THE LAST WEEK have you used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS C.first_tranq 'When did you first try tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS C.life_amphet 'On how many occasions IN YOUR WHOLE LIFETIME have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS C.year_amphet 'On how many occasions OVER THE LAST 12 MONTHS have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS C.month_amphet 'On how many occasions OVER THE LAST 30 DAYS have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS C.week_amphet 'On how many occasions OVER THE LAST WEEK have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS C.first_amphet 'When did you first try amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS C.life_lsd 'On how many occasions IN YOUR WHOLE LIFETIME have you used LSD (acid)?'.
VARIABLE LABELS C.year_lsd 'On how many occasions OVER THE LAST 12 MONTHS have you used LSD (acid)?'.
VARIABLE LABELS C.month_lsd 'On how many occasions OVER THE LAST 30 DAYS have you used LSD (acid)?'.
VARIABLE LABELS C.week_lsd 'On how many occasions OVER THE LAST WEEK have you used LSD (acid)?'.
VARIABLE LABELS C.first_lsd 'When did you first try LSD (acid)?'.
VARIABLE LABELS C.life_mushrooms 'On how many occasions IN YOUR WHOLE LIFETIME have you used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS C.year_mushrooms 'On how many occasions OVER THE LAST 12 MONTHS have you used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS C.month_mushrooms 'On how many occasions OVER THE LAST 30 DAYS have you used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS C.week_mushrooms 'On how many occasions OVER THE LAST WEEK have you used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS C.first_mushrooms 'When did you first try magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS C.life_crack 'On how many occasions IN YOUR WHOLE LIFETIME have you used crack?'.
VARIABLE LABELS C.year_crack 'On how many occasions OVER THE LAST 12 MONTHS have you used crack?'.
VARIABLE LABELS C.month_crack 'On how many occasions OVER THE LAST 30 DAYS have you used crack?'.
VARIABLE LABELS C.week_crack 'On how many occasions OVER THE LAST WEEK have you used crack?'.
VARIABLE LABELS C.first_crack 'When did you first try crack?'.
VARIABLE LABELS C.life_coke 'On how many occasions IN YOUR WHOLE LIFETIME have you used cocaine (coke)?'.
VARIABLE LABELS C.year_coke 'On how many occasions OVER THE LAST 12 MONTHS have you used cocaine (coke)?'.
VARIABLE LABELS C.month_coke 'On how many occasions OVER THE LAST 30 DAYS have you used cocaine (coke)?'.
VARIABLE LABELS C.week_coke 'On how many occasions OVER THE LAST WEEK have you used cocaine (coke)?'.
VARIABLE LABELS C.first_coke 'When did you first try cocaine (coke)?'.
VARIABLE LABELS C.life_relevin 'On how many occasions IN YOUR WHOLE LIFETIME have you used relevin?'.
VARIABLE LABELS C.year_relevin 'On how many occasions OVER THE LAST 12 MONTHS have you used relevin?'.
VARIABLE LABELS C.month_relevin 'On how many occasions OVER THE LAST 30 DAYS have you used relevin?'.
VARIABLE LABELS C.week_relevin 'On how many occasions OVER THE LAST WEEK have you used relevin?'.
VARIABLE LABELS C.first_relevin 'When did you first try relevin?'.
VARIABLE LABELS C.life_heroin 'On how many occasions IN YOUR WHOLE LIFETIME have you used heroin?'.
VARIABLE LABELS C.year_heroin 'On how many occasions OVER THE LAST 12 MONTHS have you used heroin?'.
VARIABLE LABELS C.month_heroin 'On how many occasions OVER THE LAST 30 DAYS have you used heroin?'.
VARIABLE LABELS C.week_heroin 'On how many occasions OVER THE LAST WEEK have you used heroin?'.
VARIABLE LABELS C.first_heroin 'When did you first try heroin?'.
VARIABLE LABELS C.life_narcotic 'On how many occasions IN YOUR WHOLE LIFETIME have you used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS C.year_narcotic 'On how many occasions OVER THE LAST 12 MONTHS have you used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS C.month_narcotic 'On how many occasions OVER THE LAST 30 DAYS have you used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS C.week_narcotic 'On how many occasions OVER THE LAST WEEK have you used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS C.first_narcotic 'When did you first try narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS C.life_mdma 'On how many occasions IN YOUR WHOLE LIFETIME have you used ecstasy (MDMA)?'.
VARIABLE LABELS C.year_mdma 'On how many occasions OVER THE LAST 12 MONTHS have you used ecstasy (MDMA)?'.
VARIABLE LABELS C.month_mdma 'On how many occasions OVER THE LAST 30 DAYS have you used ecstasy (MDMA)?'.
VARIABLE LABELS C.week_mdma 'On how many occasions OVER THE LAST WEEK have you used ecstasy (MDMA)?'.
VARIABLE LABELS C.first_mdma 'When did you first try ecstasy (MDMA)?'.
VARIABLE LABELS C.life_ketamine 'On how many occasions IN YOUR WHOLE LIFETIME have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS C.year_ketamine 'On how many occasions OVER THE LAST 12 MONTHS have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS C.month_ketamine 'On how many occasions OVER THE LAST 30 DAYS have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS C.week_ketamine 'On how many occasions OVER THE LAST WEEK have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS C.first_ketamine 'When did you first try ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS C.life_ghb 'On how many occasions IN YOUR WHOLE LIFETIME have you used GHB or liquid ecstasy?'.
VARIABLE LABELS C.year_ghb 'On how many occasions OVER THE LAST 12 MONTHS have you used GHB or liquid ecstasy?'.
VARIABLE LABELS C.month_ghb 'On how many occasions OVER THE LAST 30 DAYS have you used GHB or liquid ecstasy?'.
VARIABLE LABELS C.week_ghb 'On how many occasions OVER THE LAST WEEK have you used GHB or liquid ecstasy?'.
VARIABLE LABELS C.first_ghb 'When did you first try GHB or liquid ecstasy?'.
VARIABLE LABELS C.life_anabolic 'On how many occasions IN YOUR WHOLE LIFETIME have you used anabolic steroids?'.
VARIABLE LABELS C.year_anabolic 'On how many occasions OVER THE LAST 12 MONTHS have you used anabolic steroids?'.
VARIABLE LABELS C.month_anabolic 'On how many occasions OVER THE LAST 30 DAYS have you used anabolic steroids?'.
VARIABLE LABELS C.week_anabolic 'On how many occasions OVER THE LAST WEEK have you used anabolic steroids?'.
VARIABLE LABELS C.first_anabolic 'When did you first try anabolic steroids?'.
VARIABLE LABELS C.bully01 'I was bullied at school (a student/ peer said or did nasty or unpleasant things to me).'.
VARIABLE LABELS C.bully02 'I was called mean names, was made fun of, or teased in a hurtful way by a student/ peer.'.
VARIABLE LABELS C.bully03 'A student/ peer left me out of things on purpose, excluded me from their group of friends or completely ignored me.'.
VARIABLE LABELS C.bully04 'I was hit, kicked, pushed or shoved around, or locked indoors by a student/ peer.'.
VARIABLE LABELS C.bully05 'I took part in bullying another student/ peer at school.'.
VARIABLE LABELS C.bully06 'I called another student/ peer mean names, made fun of, or teased him or her in a hurtful way.'.
VARIABLE LABELS C.bully07 'I kept a student/ peer out of things on purpose, excluded that student/ peer from my group of friends, or completely ignored that student/ peer.'.
VARIABLE LABELS C.bully08 'I hit, kicked, pushed, shoved around, or locked a student/ peer indoors.'.
VARIABLE LABELS C.bully09 'I have been bullied by a teacher.'.
VARIABLE LABELS C.bully10 'I have been bullied by a family member.'.
VARIABLE LABELS C.bully11 'I have bullied a teacher.'.
VARIABLE LABELS C.bully12 'I have bullied a family member.'.
VALUE LABELS P.3a 1 'Professional qualification e.g. PhD, MD, Masters degree' 2 'Bachelor degree e.g. BA, BSc' 3 'Advanced diploma' 4 'A levels or a BTEC national diploma' 5 'NVQ or GNVQ' 6 'O levels, GCSEs or CSEs' 7 'Did not go to school or completed primary school education only' 8 'None of the above' .
VALUE LABELS P.3b 1 'Professional qualification e.g. PhD, MD, Masters degree' 2 'Bachelor degree e.g. BA, BSc' 3 'Advanced diploma' 4 'A levels or a BTEC national diploma' 5 'NVQ or GNVQ' 6 'O levels, GCSEs or CSEs' 7 'Did not go to school or completed primary school education only' 8 'None of the above' .
VALUE LABELS P.6 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29e 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.29f 0 'Never' 11 '11years old or less' 12 '12years old' 13 '13years old' 14 '14years old' 15 '15years old' 16 '16years old' 17 '17years old' 18 '18years or older' .
VALUE LABELS P.7 0 'Not at all' 1 'Less than 1 cigarette per week' 2 'Less than 1 cigarette per day' 3 '1-5 cigarettes per day' 4 '6-10 cigarettes per day' 5 '11-20 cigarettes per day' 6 'More than 20 cigarettes per day' .
VALUE LABELS P.ftnd1 3 'Within 5 minutes' 2 '6-30 minutes' 1 '31-60 minutes' 0 'after 60 minutes' .
VALUE LABELS P.ftnd2 1 'Yes' 0 'No' .
VALUE LABELS P.ftnd3 1 'The first one in the morning' 0 'All others' .
VALUE LABELS P.ftnd4 0 '10 or less' 1 '11-20' 2 '21-30' 3 '31 or more' .
VALUE LABELS P.ftnd5 1 'Yes' 0 'No' .
VALUE LABELS P.ftnd6 1 'Yes' 0 'No' .
VALUE LABELS P.27cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.24a 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.24b 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.24c 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.24d 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.24e 1 'Yes' 0 'No' .
VALUE LABELS P.dast3cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast4cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast5cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast6cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast7cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast8cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast9cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast10cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast11cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast12cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast13cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast14cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast15cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast16cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast17cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast18cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast19cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.dast20cannabis 1 'Yes' 0 'No' .
VALUE LABELS P.29i 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.27glue 1 'Yes' 0 'No' .
VALUE LABELS P.25a 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.25b 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.25c 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.25d 0 '0' 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.25e 1 'Yes' 0 'No' .
VALUE LABELS P.dast3glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast4glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast5glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast6glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast7glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast8glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast9glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast10glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast11glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast12glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast13glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast14glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast15glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast16glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast17glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast18glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast19glue 1 'Yes' 0 'No' .
VALUE LABELS P.dast20glue 1 'Yes' 0 'No' .
VALUE LABELS P.29r 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.27tranq 1 'Yes' 0 'No' .
VALUE LABELS P.28tranq 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29tranq 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30tranq 1 'Yes' 0 'No' .
VALUE LABELS P.31tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast3tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast4tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast5tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast6tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast7tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast8tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast9tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast10tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast11tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast12tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast13tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast14tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast15tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast16tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast17tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast18tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast19tranq 1 'Yes' 0 'No' .
VALUE LABELS P.dast20tranq 1 'Yes' 0 'No' .
VALUE LABELS P.27amphet 1 'Yes' 0 'No' .
VALUE LABELS P.28amphet 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29amphet 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30amphet 1 'Yes' 0 'No' .
VALUE LABELS P.31amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast3amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast4amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast5amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast6amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast7amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast8amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast9amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast10amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast11amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast12amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast13amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast14amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast15amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast16amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast17amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast18amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast19amphet 1 'Yes' 0 'No' .
VALUE LABELS P.dast20amphet 1 'Yes' 0 'No' .
VALUE LABELS P.27lsd 1 'Yes' 0 'No' .
VALUE LABELS P.28lsd 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29lsd 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30lsd 1 'Yes' 0 'No' .
VALUE LABELS P.31lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast3lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast4lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast5lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast6lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast7lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast8lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast9lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast10lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast11lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast12lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast13lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast14lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast15lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast16lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast17lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast18lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast19lsd 1 'Yes' 0 'No' .
VALUE LABELS P.dast20lsd 1 'Yes' 0 'No' .
VALUE LABELS P.27mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.28mushrooms 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29mushrooms 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.31mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast3mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast4mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast5mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast6mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast7mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast8mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast9mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast10mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast11mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast12mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast13mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast14mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast15mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast16mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast17mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast18mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast19mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.dast20mushrooms 1 'Yes' 0 'No' .
VALUE LABELS P.27crack 1 'Yes' 0 'No' .
VALUE LABELS P.28crack 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29crack 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30crack 1 'Yes' 0 'No' .
VALUE LABELS P.31crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast3crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast4crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast5crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast6crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast7crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast8crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast9crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast10crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast11crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast12crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast13crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast14crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast15crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast16crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast17crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast18crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast19crack 1 'Yes' 0 'No' .
VALUE LABELS P.dast20crack 1 'Yes' 0 'No' .
VALUE LABELS P.27coke 1 'Yes' 0 'No' .
VALUE LABELS P.28coke 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29coke 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30coke 1 'Yes' 0 'No' .
VALUE LABELS P.31coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast3coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast4coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast5coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast6coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast7coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast8coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast9coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast10coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast11coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast12coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast13coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast14coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast15coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast16coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast17coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast18coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast19coke 1 'Yes' 0 'No' .
VALUE LABELS P.dast20coke 1 'Yes' 0 'No' .
VALUE LABELS P.27relevin 1 'Yes' 0 'No' .
VALUE LABELS P.28relevin 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29relevin 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30relevin 1 'Yes' 0 'No' .
VALUE LABELS P.31relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast3relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast4relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast5relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast6relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast7relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast8relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast9relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast10relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast11relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast12relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast13relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast14relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast15relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast16relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast17relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast18relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast19relevin 1 'Yes' 0 'No' .
VALUE LABELS P.dast20relevin 1 'Yes' 0 'No' .
VALUE LABELS P.27heroin 1 'Yes' 0 'No' .
VALUE LABELS P.28heroin 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29heroin 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30heroin 1 'Yes' 0 'No' .
VALUE LABELS P.31heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast3heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast4heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast5heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast6heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast7heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast8heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast9heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast10heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast11heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast12heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast13heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast14heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast15heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast16heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast17heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast18heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast19heroin 1 'Yes' 0 'No' .
VALUE LABELS P.dast20heroin 1 'Yes' 0 'No' .
VALUE LABELS P.27narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.28narcotic 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29narcotic 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.31narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast3narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast4narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast5narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast6narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast7narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast8narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast9narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast10narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast11narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast12narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast13narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast14narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast15narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast16narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast17narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast18narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast19narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.dast20narcotic 1 'Yes' 0 'No' .
VALUE LABELS P.27mdma 1 'Yes' 0 'No' .
VALUE LABELS P.28mdma 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29mdma 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30mdma 1 'Yes' 0 'No' .
VALUE LABELS P.31mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast3mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast4mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast5mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast6mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast7mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast8mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast9mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast10mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast11mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast12mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast13mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast14mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast15mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast16mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast17mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast18mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast19mdma 1 'Yes' 0 'No' .
VALUE LABELS P.dast20mdma 1 'Yes' 0 'No' .
VALUE LABELS P.27ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.28ketamine 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29ketamine 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.31ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast3ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast4ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast5ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast6ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast7ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast8ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast9ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast10ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast11ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast12ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast13ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast14ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast15ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast16ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast17ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast18ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast19ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.dast20ketamine 1 'Yes' 0 'No' .
VALUE LABELS P.27ghb 1 'Yes' 0 'No' .
VALUE LABELS P.28ghb 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29ghb 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30ghb 1 'Yes' 0 'No' .
VALUE LABELS P.31ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast3ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast4ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast5ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast6ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast7ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast8ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast9ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast10ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast11ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast12ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast13ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast14ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast15ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast16ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast17ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast18ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast19ghb 1 'Yes' 0 'No' .
VALUE LABELS P.dast20ghb 1 'Yes' 0 'No' .
VALUE LABELS P.27anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.28anabolic 1 '1-2' 2 '3-5' 3 '6-9' 4 '10-19' 5 '20-39' 6 '40 or more' .
VALUE LABELS P.29anabolic 11 '11 years old or less' 12 '12 years old' 13 '13 years old' 14 '14 years old' 15 '15 years old' 16 '16 years old' 17 '17 years old' 18 '18 years or older' .
VALUE LABELS P.30anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.31anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast3anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast4anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast5anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast6anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast7anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast8anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast9anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast10anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast11anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast12anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast13anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast14anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast15anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast16anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast17anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast18anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast19anabolic 1 'Yes' 0 'No' .
VALUE LABELS P.dast20anabolic 1 'Yes' 0 'No' .
VARIABLE LABELS P.3a 'What is the highest level of education of the mother (stepmother) of the adolescent?'.
VARIABLE LABELS P.3b 'What is the highest level of education of the father (stepfather) of the adolescent?'.
VARIABLE LABELS P.6 'On how many occasions during your lifetime have you smoked cigarettes?'.
VARIABLE LABELS P.29e 'When did you smoke your FIRST cigarette?'.
VARIABLE LABELS P.29f 'When did you first smoke cigarettes ON A DAILY BASIS?'.
VARIABLE LABELS P.7 'How frequently have you smoked cigarettes during the LAST 30 DAYS?'.
VARIABLE LABELS P.ftnd1 'How soon after you wake up do you smoke your first cigarette?'.
VARIABLE LABELS P.ftnd2 'Do you find it difficult to refrain from smoking in places where it is forbidden, e.g. at the mosque (church), at the bus?'.
VARIABLE LABELS P.ftnd3 'Which cigarette would you hate most to give up?'.
VARIABLE LABELS P.ftnd4 'How many cigarettes/day do you smoke?'.
VARIABLE LABELS P.ftnd5 'Do you smoke more frequently during the first hours after waking than the rest of the day?'.
VARIABLE LABELS P.ftnd6 'Do you smoke when you are so ill that you are in bed most of the day?'.
VARIABLE LABELS P.27cannabis 'Have you ever used marijuana (grass, pott) or hashish (hash, hash oil)?'.
VARIABLE LABELS P.24a 'On how many occasions IN YOUR WHOLE LIFETIME have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS P.24b 'On how many occasions OVER THE LAST 12 MONTHS have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS P.24c 'On how many occasions OVER THE LAST 30 DAYS have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS P.24d 'On how many occasions OVER THE LAST WEEK have you used marijuana (grass, pot) or hashish (hash, hash oil)?'.
VARIABLE LABELS P.24e 'Please indicate if you have used marijuana (grass, pot) or hashish (hash, hash oil) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3cannabis 'Do you abuse more than one drug at a time when you used marijuana / hashish ?'.
VARIABLE LABELS P.dast4cannabis 'Can you get through the week without using marijuana / hashish  (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5cannabis 'Are you always able to stop using marijuana / hashish  when you want?'.
VARIABLE LABELS P.dast6cannabis 'Have you had "blackouts" or "flashbacks" as a result of marijuana / hashish  use?'.
VARIABLE LABELS P.dast7cannabis 'Do you ever feel bad about your marijuana / hashish  abuse?'.
VARIABLE LABELS P.dast8cannabis 'Does your spouse (or parents) ever complain about your involvement with marijuana / hashish ?'.
VARIABLE LABELS P.dast9cannabis 'Has marijuana / hashish  abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10cannabis 'Have you ever lost friends because of your use of marijuana / hashish ?'.
VARIABLE LABELS P.dast11cannabis 'Have you ever neglected your family or missed work because of your use of marijuana / hashish ?'.
VARIABLE LABELS P.dast12cannabis 'Have you ever been in trouble at work because of marijuana / hashish  abuse?'.
VARIABLE LABELS P.dast13cannabis 'Have you ever lost a job because of marijuana / hashish  abuse?'.
VARIABLE LABELS P.dast14cannabis 'Have you ever got into fights when under the influence of marijuana / hashish ?'.
VARIABLE LABELS P.dast15cannabis 'Have you engaged in illegal activities in order to obtain marijuana / hashish ?'.
VARIABLE LABELS P.dast16cannabis 'Have you ever been arrested for possession of marijuana / hashish ?'.
VARIABLE LABELS P.dast17cannabis 'Have you ever experienced withdrawal symptoms as a result of heavy marijuana / hashish  intake?'.
VARIABLE LABELS P.dast18cannabis 'Have you  had medical problems as a result of your marijuana / hashish  use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19cannabis 'Have you ever gone to anyone for help for a marijuana / hashish  problem?'.
VARIABLE LABELS P.dast20cannabis 'Have you ever been treated as an out-patient for problems related to marijuana / hashish  abuse?'.
VARIABLE LABELS P.29i 'When did you FIRST try marijuana?'.
VARIABLE LABELS P.27glue 'Have you ever sniffed a substance (glue, aerosols etc) to get high?'.
VARIABLE LABELS P.25a 'On how many occasions in your lifetime have you sniffed a substance (glue, aerosols etc) to get high?'.
VARIABLE LABELS P.25b 'On how many occasions OVER THE LAST 12 MONTHS have you sniffed a substance (glue, aerosols etc) to get high?'.
VARIABLE LABELS P.25c 'On how many occasions OVER THE LAST 30 DAYS have you sniffed a substance (glue, aerosols etc) to get high?'.
VARIABLE LABELS P.25d 'On how many occasions OVER THE LAST WEEK have you sniffed a substance (glue, aerosols etc) to get high?'.
VARIABLE LABELS P.25e 'Please indicate if you have sniffed a substance (glue, aerosols etc) to get high on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3glue 'Do you abuse more than one drug at a time when you used Inhalants (glue / aerosols) to get high?'.
VARIABLE LABELS P.dast4glue 'Can you get through the week without using Inhalants (glue / aerosols) to get high (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5glue 'Are you always able to stop using Inhalants (glue / aerosols) to get high when you want?'.
VARIABLE LABELS P.dast6glue 'Have you had "blackouts" or "flashbacks" as a result of Inhalants (glue / aerosols) use?'.
VARIABLE LABELS P.dast7glue 'Do you ever feel bad about your Inhalants (glue / aerosols) to get high abuse?'.
VARIABLE LABELS P.dast8glue 'Does your spouse (or parents) ever complain about your involvement with Inhalants (glue / aerosols)?'.
VARIABLE LABELS P.dast9glue 'Has Inhalants (glue / aerosols) abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10glue 'Have you ever lost friends because of your use of Inhalants (glue / aerosols)?'.
VARIABLE LABELS P.dast11glue 'Have you ever neglected your family or missed work because of your use of Inhalants (glue / aerosols)?'.
VARIABLE LABELS P.dast12glue 'Have you ever been in trouble at work because of Inhalants (glue / aerosols) abuse?'.
VARIABLE LABELS P.dast13glue 'Have you ever lost a job because of Inhalants (glue / aerosols) abuse?'.
VARIABLE LABELS P.dast14glue 'Have you ever got into fights when under the influence of Inhalants (glue / aerosols)?'.
VARIABLE LABELS P.dast15glue 'Have you engaged in illegal activities in order to obtain Inhalants (glue / aerosols) to get high?'.
VARIABLE LABELS P.dast16glue 'Have you ever been arrested for possession of Inhalants (glue / aerosols)?'.
VARIABLE LABELS P.dast17glue 'Have you ever experienced withdrawal symptoms as a result of heavy Inhalants (glue / aerosols) intake?'.
VARIABLE LABELS P.dast18glue 'Have you  had medical problems as a result of your Inhalants (glue / aerosols) use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19glue 'Have you ever gone to anyone for help for a Inhalants (glue / aerosols) problem?'.
VARIABLE LABELS P.dast20glue 'Have you ever been treated as an out-patient for problems related to Inhalants (glue / aerosols) abuse?'.
VARIABLE LABELS P.29r 'When did you FIRST use Inhalants (glue, etc) to get high?'.
VARIABLE LABELS P.27tranq 'Have you ever used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS P.28tranq 'On how many occasions in your lifetime have you used tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS P.29tranq 'When did you first try tranquillisers or sedatives (without a doctors prescription) (e.g. benzodiazepines such as valium or xanax; barbiturates, barbs or downers such as amytal, or seconal)?'.
VARIABLE LABELS P.30tranq 'Have you used tranquillisers OVER THE LAST WEEK?'.
VARIABLE LABELS P.31tranq 'Please indicate if you have used tranquillisers or sedatives (without a doctors prescription) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3tranq 'Do you abuse more than one drug at a time when you used tranquillisers?'.
VARIABLE LABELS P.dast4tranq 'Can you get through the week without using tranquillisers (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5tranq 'Are you always able to stop using tranquillisers when you want?'.
VARIABLE LABELS P.dast6tranq 'Have you had "blackouts" or "flashbacks" as a result of tranquilliser use?'.
VARIABLE LABELS P.dast7tranq 'Do you ever feel bad about your tranquilliser abuse?'.
VARIABLE LABELS P.dast8tranq 'Does your spouse (or parents) ever complain about your involvement with tranquillisers?'.
VARIABLE LABELS P.dast9tranq 'Has tranquilliser abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10tranq 'Have you ever lost friends because of your use of tranquillisers?'.
VARIABLE LABELS P.dast11tranq 'Have you ever neglected your family or missed work because of your use of tranquillisers?'.
VARIABLE LABELS P.dast12tranq 'Have you ever been in trouble at work because of tranquilliser abuse?'.
VARIABLE LABELS P.dast13tranq 'Have you ever lost a job because of tranquilliser abuse?'.
VARIABLE LABELS P.dast14tranq 'Have you ever got into fights when under the influence of tranquillisers?'.
VARIABLE LABELS P.dast15tranq 'Have you engaged in illegal activities in order to obtain tranquillisers?'.
VARIABLE LABELS P.dast16tranq 'Have you ever been arrested for possession of tranquillisers?'.
VARIABLE LABELS P.dast17tranq 'Have you ever experienced withdrawal symptoms as a result of heavy tranquilliser intake?'.
VARIABLE LABELS P.dast18tranq 'Have you  had medical problems as a result of your tranquilliser use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19tranq 'Have you ever gone to anyone for help for a tranquillisers problem?'.
VARIABLE LABELS P.dast20tranq 'Have you ever been treated as an out-patient for problems related to tranquilliser abuse?'.
VARIABLE LABELS P.27amphet 'Have you ever used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS P.28amphet 'On how many occasions in your lifetime have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS P.29amphet 'When did you first try amphetamines (speed), methamphetamine (crystal meth) or desoxyn?'.
VARIABLE LABELS P.30amphet 'Have you used amphetamines (speed), methamphetamine (crystal meth) or desoxyn OVER THE LAST WEEK?'.
VARIABLE LABELS P.31amphet 'Please indicate if you have used amphetamines (speed), methamphetamine (crystal meth) or desoxyn on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3amphet 'Do you abuse more than one drug at a time when you used amphetamines?'.
VARIABLE LABELS P.dast4amphet 'Can you get through the week without using amphetamines (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5amphet 'Are you always able to stop using amphetamines when you want?'.
VARIABLE LABELS P.dast6amphet 'Have you had "blackouts" or "flashbacks" as a result of amphetamine use?'.
VARIABLE LABELS P.dast7amphet 'Do you ever feel bad about your amphetamine abuse?'.
VARIABLE LABELS P.dast8amphet 'Does your spouse (or parents) ever complain about your involvement with amphetamines?'.
VARIABLE LABELS P.dast9amphet 'Has amphetamine abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10amphet 'Have you ever lost friends because of your use of amphetamines?'.
VARIABLE LABELS P.dast11amphet 'Have you ever neglected your family or missed work because of your use of amphetamines?'.
VARIABLE LABELS P.dast12amphet 'Have you ever been in trouble at work because of amphetamine abuse?'.
VARIABLE LABELS P.dast13amphet 'Have you ever lost a job because of amphetamine abuse?'.
VARIABLE LABELS P.dast14amphet 'Have you ever got into fights when under the influence of amphetamines?'.
VARIABLE LABELS P.dast15amphet 'Have you engaged in illegal activities in order to obtain amphetamines?'.
VARIABLE LABELS P.dast16amphet 'Have you ever been arrested for possession of amphetamines?'.
VARIABLE LABELS P.dast17amphet 'Have you ever experienced withdrawal symptoms as a result of heavy amphetamine intake?'.
VARIABLE LABELS P.dast18amphet 'Have you  had medical problems as a result of your amphetamine use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19amphet 'Have you ever gone to anyone for help for an amphetamine problem?'.
VARIABLE LABELS P.dast20amphet 'Have you ever been treated as an out-patient for problems related to amphetamine abuse?'.
VARIABLE LABELS P.27lsd 'Have you ever used LSD (acid)?'.
VARIABLE LABELS P.28lsd 'On how many occasions in your lifetime have you used LSD (acid)?'.
VARIABLE LABELS P.29lsd 'When did you first try LSD (acid)?'.
VARIABLE LABELS P.30lsd 'Have you used LSD (acid) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31lsd 'Please indicate if you have used LSD on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3lsd 'Do you abuse more than one drug at a time when you used LSD?'.
VARIABLE LABELS P.dast4lsd 'Can you get through the week without using LSD (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5lsd 'Are you always able to stop using LSD when you want?'.
VARIABLE LABELS P.dast6lsd 'Have you had "blackouts" or "flashbacks" as a result of LSD use?'.
VARIABLE LABELS P.dast7lsd 'Do you ever feel bad about your LSD abuse?'.
VARIABLE LABELS P.dast8lsd 'Does your spouse (or parents) ever complain about your involvement with LSD?'.
VARIABLE LABELS P.dast9lsd 'Has LSD abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10lsd 'Have you ever lost friends because of your use of LSD?'.
VARIABLE LABELS P.dast11lsd 'Have you ever neglected your family or missed work because of your use of LSD?'.
VARIABLE LABELS P.dast12lsd 'Have you ever been in trouble at work because of LSD abuse?'.
VARIABLE LABELS P.dast13lsd 'Have you ever lost a job because of LSD abuse?'.
VARIABLE LABELS P.dast14lsd 'Have you ever got into fights when under the influence of LSD?'.
VARIABLE LABELS P.dast15lsd 'Have you engaged in illegal activities in order to obtain LSD?'.
VARIABLE LABELS P.dast16lsd 'Have you ever been arrested for possession of LSD?'.
VARIABLE LABELS P.dast17lsd 'Have you ever experienced withdrawal symptoms as a result of heavy LSD intake?'.
VARIABLE LABELS P.dast18lsd 'Have you  had medical problems as a result of your LSD use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19lsd 'Have you ever gone to anyone for help for a LSD problem?'.
VARIABLE LABELS P.dast20lsd 'Have you ever been treated as an out-patient for problems related to LSD abuse?'.
VARIABLE LABELS P.27mushrooms 'Have you ever used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS P.28mushrooms 'On how many occasions in your lifetime have you used magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS P.29mushrooms 'When did you first try magic mushrooms or other hallucinogens (excluding LSD)?'.
VARIABLE LABELS P.30mushrooms 'Have you used magic mushrooms or other hallucinogens (excluding LSD) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31mushrooms 'Please indicate if you have used magic mushrooms or other hallucinogens (excluding LSD) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3mushrooms 'Do you abuse more than one drug at a time when you used hallucinogens?'.
VARIABLE LABELS P.dast4mushrooms 'Can you get through the week without using hallucinogens (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5mushrooms 'Are you always able to stop using hallucinogens when you want?'.
VARIABLE LABELS P.dast6mushrooms 'Have you had "blackouts" or "flashbacks" as a result of hallucinogens use?'.
VARIABLE LABELS P.dast7mushrooms 'Do you ever feel bad about your hallucinogens abuse?'.
VARIABLE LABELS P.dast8mushrooms 'Does your spouse (or parents) ever complain about your involvement with hallucinogens?'.
VARIABLE LABELS P.dast9mushrooms 'Has hallucinogens abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10mushrooms 'Have you ever lost friends because of your use of hallucinogens?'.
VARIABLE LABELS P.dast11mushrooms 'Have you ever neglected your family or missed work because of your use of hallucinogens?'.
VARIABLE LABELS P.dast12mushrooms 'Have you ever been in trouble at work because of hallucinogens abuse?'.
VARIABLE LABELS P.dast13mushrooms 'Have you ever lost a job because of hallucinogens abuse?'.
VARIABLE LABELS P.dast14mushrooms 'Have you ever got into fights when under the influence of hallucinogens?'.
VARIABLE LABELS P.dast15mushrooms 'Have you engaged in illegal activities in order to obtain hallucinogens?'.
VARIABLE LABELS P.dast16mushrooms 'Have you ever been arrested for possession of hallucinogens?'.
VARIABLE LABELS P.dast17mushrooms 'Have you ever experienced withdrawal symptoms as a result of heavy hallucinogens intake?'.
VARIABLE LABELS P.dast18mushrooms 'Have you  had medical problems as a result of your hallucinogens use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19mushrooms 'Have you ever gone to anyone for help for a hallucinogens problem?'.
VARIABLE LABELS P.dast20mushrooms 'Have you ever been treated as an out-patient for problems related to hallucinogens abuse?'.
VARIABLE LABELS P.27crack 'Have you ever used crack?'.
VARIABLE LABELS P.28crack 'On how many occasions in your lifetime have you used crack?'.
VARIABLE LABELS P.29crack 'When did you first try crack?'.
VARIABLE LABELS P.30crack 'Have you used crack OVER THE LAST WEEK?'.
VARIABLE LABELS P.31crack 'Please indicate if you have used crack on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3crack 'Do you abuse more than one drug at a time when you used crack?'.
VARIABLE LABELS P.dast4crack 'Can you get through the week without using crack (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5crack 'Are you always able to stop using crack when you want?'.
VARIABLE LABELS P.dast6crack 'Have you had "blackouts" or "flashbacks" as a result of crack use?'.
VARIABLE LABELS P.dast7crack 'Do you ever feel bad about your crack abuse?'.
VARIABLE LABELS P.dast8crack 'Does your spouse (or parents) ever complain about your involvement with crack?'.
VARIABLE LABELS P.dast9crack 'Has crack abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10crack 'Have you ever lost friends because of your use of crack?'.
VARIABLE LABELS P.dast11crack 'Have you ever neglected your family or missed work because of your use of crack?'.
VARIABLE LABELS P.dast12crack 'Have you ever been in trouble at work because of crack abuse?'.
VARIABLE LABELS P.dast13crack 'Have you ever lost a job because of crack abuse?'.
VARIABLE LABELS P.dast14crack 'Have you ever got into fights when under the influence of crack?'.
VARIABLE LABELS P.dast15crack 'Have you engaged in illegal activities in order to obtain crack?'.
VARIABLE LABELS P.dast16crack 'Have you ever been arrested for possession of crack?'.
VARIABLE LABELS P.dast17crack 'Have you ever experienced withdrawal symptoms as a result of heavy crack intake?'.
VARIABLE LABELS P.dast18crack 'Have you had medical problems as a result of your crack use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19crack 'Have you ever gone to anyone for help for a crack problem?'.
VARIABLE LABELS P.dast20crack 'Have you ever been treated as an out-patient for problems related to crack abuse?'.
VARIABLE LABELS P.27coke 'Have you ever used cocaine (coke)?'.
VARIABLE LABELS P.28coke 'On how many occasions in your lifetime have you used cocaine (coke)?'.
VARIABLE LABELS P.29coke 'When did you first try cocaine (coke)?'.
VARIABLE LABELS P.30coke 'Have you used cocaine (coke) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31coke 'Please indicate if you have used cocaine (coke) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3coke 'Do you abuse more than one drug at a time when you used cocaine?'.
VARIABLE LABELS P.dast4coke 'Can you get through the week without using cocaine (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5coke 'Are you always able to stop using cocaine when you want?'.
VARIABLE LABELS P.dast6coke 'Have you had "blackouts" or "flashbacks" as a result of cocaine use?'.
VARIABLE LABELS P.dast7coke 'Do you ever feel bad about your cocaine abuse?'.
VARIABLE LABELS P.dast8coke 'Does your spouse (or parents) ever complain about your involvement with cocaine?'.
VARIABLE LABELS P.dast9coke 'Has cocaine abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10coke 'Have you ever lost friends because of your use of cocaine?'.
VARIABLE LABELS P.dast11coke 'Have you ever neglected your family or missed work because of your use of cocaine?'.
VARIABLE LABELS P.dast12coke 'Have you ever been in trouble at work because of cocaine abuse?'.
VARIABLE LABELS P.dast13coke 'Have you ever lost a job because of cocaine abuse?'.
VARIABLE LABELS P.dast14coke 'Have you ever got into fights when under the influence of cocaine?'.
VARIABLE LABELS P.dast15coke 'Have you engaged in illegal activities in order to obtain cocaine?'.
VARIABLE LABELS P.dast16coke 'Have you ever been arrested for possession of cocaine?'.
VARIABLE LABELS P.dast17coke 'Have you ever experienced withdrawal symptoms as a result of heavy cocaine intake?'.
VARIABLE LABELS P.dast18coke 'Have you had medical problems as a result of your cocaine use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19coke 'Have you ever gone to anyone for help for a cocaine problem?'.
VARIABLE LABELS P.dast20coke 'Have you ever been treated as an out-patient for problems related to cocaine abuse?'.
VARIABLE LABELS P.27relevin 'Have you ever used relevin?'.
VARIABLE LABELS P.28relevin 'On how many occasions in your lifetime have you used relevin?'.
VARIABLE LABELS P.29relevin 'When did you first try relevin?'.
VARIABLE LABELS P.30relevin 'Have you used relevin OVER THE LAST WEEK?'.
VARIABLE LABELS P.31relevin 'Please indicate if you have used relevin on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3relevin 'Do you abuse more than one drug at a time when you used relevin?'.
VARIABLE LABELS P.dast4relevin 'Can you get through the week without using relevin (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5relevin 'Are you always able to stop using relevin when you want?'.
VARIABLE LABELS P.dast6relevin 'Have you had "blackouts" or "flashbacks" as a result of relevin use?'.
VARIABLE LABELS P.dast7relevin 'Do you ever feel bad about your relevin abuse?'.
VARIABLE LABELS P.dast8relevin 'Does your spouse (or parents) ever complain about your involvement with relevin?'.
VARIABLE LABELS P.dast9relevin 'Has relevin abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10relevin 'Have you ever lost friends because of your use of relevin?'.
VARIABLE LABELS P.dast11relevin 'Have you ever neglected your family or missed work because of your use of relevin?'.
VARIABLE LABELS P.dast12relevin 'Have you ever been in trouble at work because of relevin abuse?'.
VARIABLE LABELS P.dast13relevin 'Have you ever lost a job because of relevin abuse?'.
VARIABLE LABELS P.dast14relevin 'Have you ever got into fights when under the influence of relevin?'.
VARIABLE LABELS P.dast15relevin 'Have you engaged in illegal activities in order to obtain relevin?'.
VARIABLE LABELS P.dast16relevin 'Have you ever been arrested for possession of relevin?'.
VARIABLE LABELS P.dast17relevin 'Have you ever experienced withdrawal symptoms as a result of heavy relevin intake?'.
VARIABLE LABELS P.dast18relevin 'Have you had medical problems as a result of your relevin use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19relevin 'Have you ever gone to anyone for help for a relevin problem?'.
VARIABLE LABELS P.dast20relevin 'Have you ever been treated as an out-patient for problems related to relevin abuse?'.
VARIABLE LABELS P.27heroin 'Have you ever used heroin?'.
VARIABLE LABELS P.28heroin 'On how many occasions in your lifetime have you used heroin?'.
VARIABLE LABELS P.29heroin 'When did you first try heroin?'.
VARIABLE LABELS P.30heroin 'Have you used heroin OVER THE LAST WEEK?'.
VARIABLE LABELS P.31heroin 'Please indicate if you have used heroin on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3heroin 'Do you abuse more than one drug at a time when you used heroin?'.
VARIABLE LABELS P.dast4heroin 'Can you get through the week without using heroin (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5heroin 'Are you always able to stop using heroin when you want?'.
VARIABLE LABELS P.dast6heroin 'Have you had "blackouts" or "flashbacks" as a result of heroin use?'.
VARIABLE LABELS P.dast7heroin 'Do you ever feel bad about your heroin abuse?'.
VARIABLE LABELS P.dast8heroin 'Does your spouse (or parents) ever complain about your involvement with heroin?'.
VARIABLE LABELS P.dast9heroin 'Has heroin abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10heroin 'Have you ever lost friends because of your use of heroin?'.
VARIABLE LABELS P.dast11heroin 'Have you ever neglected your family or missed work because of your use of heroin?'.
VARIABLE LABELS P.dast12heroin 'Have you ever been in trouble at work because of heroin abuse?'.
VARIABLE LABELS P.dast13heroin 'Have you ever lost a job because of heroin abuse?'.
VARIABLE LABELS P.dast14heroin 'Have you ever got into fights when under the influence of heroin?'.
VARIABLE LABELS P.dast15heroin 'Have you engaged in illegal activities in order to obtain heroin?'.
VARIABLE LABELS P.dast16heroin 'Have you ever been arrested for possession of heroin?'.
VARIABLE LABELS P.dast17heroin 'Have you ever experienced withdrawal symptoms as a result of heavy heroin intake?'.
VARIABLE LABELS P.dast18heroin 'Have you had medical problems as a result of your heroin use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19heroin 'Have you ever gone to anyone for help for a heroin problem?'.
VARIABLE LABELS P.dast20heroin 'Have you ever been treated as an out-patient for problems related to heroin abuse?'.
VARIABLE LABELS P.27narcotic 'Have you ever used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS P.28narcotic 'On how many occasions in your lifetime have you used narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS P.29narcotic 'When did you first try narcotics (e.g. opium, morphine, codeine)?'.
VARIABLE LABELS P.30narcotic 'Have you used narcotics (e.g. opium, morphine, codeine) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31narcotic 'Please indicate if you have used narcotics (e.g. opium, morphine, codeine) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3narcotic 'Do you abuse more than one drug at a time when you used narcotics?'.
VARIABLE LABELS P.dast4narcotic 'Can you get through the week without using narcotics (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5narcotic 'Are you always able to stop using narcotics when you want?'.
VARIABLE LABELS P.dast6narcotic 'Have you had "blackouts" or "flashbacks" as a result of narcotics use?'.
VARIABLE LABELS P.dast7narcotic 'Do you ever feel bad about your narcotic abuse?'.
VARIABLE LABELS P.dast8narcotic 'Does your spouse (or parents) ever complain about your involvement with narcotics?'.
VARIABLE LABELS P.dast9narcotic 'Has narcotic abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10narcotic 'Have you ever lost friends because of your use of narcotics?'.
VARIABLE LABELS P.dast11narcotic 'Have you ever neglected your family or missed work because of your use of narcotics?'.
VARIABLE LABELS P.dast12narcotic 'Have you ever been in trouble at work because of narcotic abuse?'.
VARIABLE LABELS P.dast13narcotic 'Have you ever lost a job because of narcotic abuse?'.
VARIABLE LABELS P.dast14narcotic 'Have you ever got into fights when under the influence of narcotics?'.
VARIABLE LABELS P.dast15narcotic 'Have you engaged in illegal activities in order to obtain narcotics?'.
VARIABLE LABELS P.dast16narcotic 'Have you ever been arrested for possession of narcotics?'.
VARIABLE LABELS P.dast17narcotic 'Have you ever experienced withdrawal symptoms as a result of heavy narcotics intake?'.
VARIABLE LABELS P.dast18narcotic 'Have you had medical problems as a result of your narcotics use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19narcotic 'Have you ever gone to anyone for help for a narcotics problem?'.
VARIABLE LABELS P.dast20narcotic 'Have you ever been treated as an out-patient for problems related to narcotic abuse?'.
VARIABLE LABELS P.27mdma 'Have you ever used ecstasy (MDMA)?'.
VARIABLE LABELS P.28mdma 'On how many occasions in your lifetime have you used ecstasy (MDMA)?'.
VARIABLE LABELS P.29mdma 'When did you first try ecstasy (MDMA)?'.
VARIABLE LABELS P.30mdma 'Have you used ecstasy (MDMA) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31mdma 'Please indicate if you have used ecstasy (MDMA) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3mdma 'Do you abuse more than one drug at a time when you used ecstasy?'.
VARIABLE LABELS P.dast4mdma 'Can you get through the week without using ecstasy (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5mdma 'Are you always able to stop using ecstasy when you want?'.
VARIABLE LABELS P.dast6mdma 'Have you had "blackouts" or "flashbacks" as a result of ecstasy use?'.
VARIABLE LABELS P.dast7mdma 'Do you ever feel bad about your ecstasy abuse?'.
VARIABLE LABELS P.dast8mdma 'Does your spouse (or parents) ever complain about your involvement with ecstasy?'.
VARIABLE LABELS P.dast9mdma 'Has ecstasy abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10mdma 'Have you ever lost friends because of your use of ecstasy?'.
VARIABLE LABELS P.dast11mdma 'Have you ever neglected your family or missed work because of your use of ecstasy?'.
VARIABLE LABELS P.dast12mdma 'Have you ever been in trouble at work because of ecstasy abuse?'.
VARIABLE LABELS P.dast13mdma 'Have you ever lost a job because of ecstasy abuse?'.
VARIABLE LABELS P.dast14mdma 'Have you ever got into fights when under the influence of ecstasy?'.
VARIABLE LABELS P.dast15mdma 'Have you engaged in illegal activities in order to obtain ecstasy?'.
VARIABLE LABELS P.dast16mdma 'Have you ever been arrested for possession of ecstasy?'.
VARIABLE LABELS P.dast17mdma 'Have you ever experienced withdrawal symptoms as a result of heavy ecstasy intake?'.
VARIABLE LABELS P.dast18mdma 'Have you had medical problems as a result of your ecstasy use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19mdma 'Have you ever gone to anyone for help for a ecstasy problem?'.
VARIABLE LABELS P.dast20mdma 'Have you ever been treated as an out-patient for problems related to ecstasy abuse?'.
VARIABLE LABELS P.27ketamine 'Have you ever used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS P.28ketamine 'On how many occasions in your lifetime have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS P.29ketamine 'When did you first try ketamine (Ket, K) or Phencyclidine (PCP, or angel dust)?'.
VARIABLE LABELS P.30ketamine 'Have you used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust) OVER THE LAST WEEK?'.
VARIABLE LABELS P.31ketamine 'Please indicate if you have used ketamine (Ket, K) or Phencyclidine (PCP, or angel dust) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3ketamine 'Do you abuse more than one drug at a time when you used ketamine / pcp?'.
VARIABLE LABELS P.dast4ketamine 'Can you get through the week without using ketamine / pcp (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5ketamine 'Are you always able to stop using ketamine / pcp when you want?'.
VARIABLE LABELS P.dast6ketamine 'Have you had "blackouts" or "flashbacks" as a result of ketamine / pcp use?'.
VARIABLE LABELS P.dast7ketamine 'Do you ever feel bad about your ketamine / pcp abuse?'.
VARIABLE LABELS P.dast8ketamine 'Does your spouse (or parents) ever complain about your involvement with ketamine / pcp?'.
VARIABLE LABELS P.dast9ketamine 'Has ketamine / pcp abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10ketamine 'Have you ever lost friends because of your use of ketamine / pcp?'.
VARIABLE LABELS P.dast11ketamine 'Have you ever neglected your family or missed work because of your use of ketamine / pcp?'.
VARIABLE LABELS P.dast12ketamine 'Have you ever been in trouble at work because of ketamine / pcp abuse?'.
VARIABLE LABELS P.dast13ketamine 'Have you ever lost a job because of ketamine / pcp abuse?'.
VARIABLE LABELS P.dast14ketamine 'Have you ever got into fights when under the influence of ketamine / pcp?'.
VARIABLE LABELS P.dast15ketamine 'Have you engaged in illegal activities in order to obtain ketamine / pcp?'.
VARIABLE LABELS P.dast16ketamine 'Have you ever been arrested for possession of ketamine / pcp?'.
VARIABLE LABELS P.dast17ketamine 'Have you ever experienced withdrawal symptoms as a result of heavy ketamine / pcp intake?'.
VARIABLE LABELS P.dast18ketamine 'Have you had medical problems as a result of your ketamine / pcp use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19ketamine 'Have you ever gone to anyone for help for a ketamine / pcp problem?'.
VARIABLE LABELS P.dast20ketamine 'Have you ever been treated as an out-patient for problems related to ketamine / pcp abuse?'.
VARIABLE LABELS P.27ghb 'Have you ever used GHB or liquid ecstasy?'.
VARIABLE LABELS P.28ghb 'On how many occasions in your lifetime have you used GHB or liquid ecstasy?'.
VARIABLE LABELS P.29ghb 'When did you first try GHB or liquid ecstasy?'.
VARIABLE LABELS P.30ghb 'Have you used GHB or liquid ecstasy OVER THE LAST WEEK?'.
VARIABLE LABELS P.31ghb 'Please indicate if you have used GHB or liquid ecstasy) on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3ghb 'Do you abuse more than one drug at a time when you used ghb?'.
VARIABLE LABELS P.dast4ghb 'Can you get through the week without using ghb (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5ghb 'Are you always able to stop using ghb when you want?'.
VARIABLE LABELS P.dast6ghb 'Have you had "blackouts" or "flashbacks" as a result of ghb use?'.
VARIABLE LABELS P.dast7ghb 'Do you ever feel bad about your ghb abuse?'.
VARIABLE LABELS P.dast8ghb 'Does your spouse (or parents) ever complain about your involvement with ghb?'.
VARIABLE LABELS P.dast9ghb 'Has ghb abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10ghb 'Have you ever lost friends because of your use of ghb?'.
VARIABLE LABELS P.dast11ghb 'Have you ever neglected your family or missed work because of your use of ghb?'.
VARIABLE LABELS P.dast12ghb 'Have you ever been in trouble at work because of ghb abuse?'.
VARIABLE LABELS P.dast13ghb 'Have you ever lost a job because of ghb abuse?'.
VARIABLE LABELS P.dast14ghb 'Have you ever got into fights when under the influence of ghb?'.
VARIABLE LABELS P.dast15ghb 'Have you engaged in illegal activities in order to obtain ghb?'.
VARIABLE LABELS P.dast16ghb 'Have you ever been arrested for possession of ghb?'.
VARIABLE LABELS P.dast17ghb 'Have you ever experienced withdrawal symptoms as a result of heavy ghb intake?'.
VARIABLE LABELS P.dast18ghb 'Have you had medical problems as a result of your ghb use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19ghb 'Have you ever gone to anyone for help for a ghb problem?'.
VARIABLE LABELS P.dast20ghb 'Have you ever been treated as an out-patient for problems related to ghb abuse?'.
VARIABLE LABELS P.27anabolic 'Have you ever used anabolic steroids?'.
VARIABLE LABELS P.28anabolic 'On how many occasions in your lifetime have you used anabolic steroids?'.
VARIABLE LABELS P.29anabolic 'When did you first try anabolic steroids?'.
VARIABLE LABELS P.30anabolic 'Have you used anabolic steroids OVER THE LAST WEEK?'.
VARIABLE LABELS P.31anabolic 'Please indicate if you have used anabolic steroids on a weekly basis OVER A 12 MONTH PERIOD or in an excessive or problematic way IN YOUR LIFETIME?'.
VARIABLE LABELS P.dast3anabolic 'Do you abuse more than one drug at a time when you used anabolic steroids?'.
VARIABLE LABELS P.dast4anabolic 'Can you get through the week without using anabolic steroids (unless you require it for medical reasons)?'.
VARIABLE LABELS P.dast5anabolic 'Are you always able to stop using anabolic steroids when you want?'.
VARIABLE LABELS P.dast6anabolic 'Have you had "blackouts" or "flashbacks" as a result of anabolic steroid use?'.
VARIABLE LABELS P.dast7anabolic 'Do you ever feel bad about your anabolic steroid abuse?'.
VARIABLE LABELS P.dast8anabolic 'Does your spouse (or parents) ever complain about your involvement with anabolic steroids?'.
VARIABLE LABELS P.dast9anabolic 'Has anabolic steroid abuse ever created problems between you and your spouse?'.
VARIABLE LABELS P.dast10anabolic 'Have you ever lost friends because of your use of anabolic steroids?'.
VARIABLE LABELS P.dast11anabolic 'Have you ever neglected your family or missed work because of your use of anabolic steroids?'.
VARIABLE LABELS P.dast12anabolic 'Have you ever been in trouble at work because of anabolic steroid abuse?'.
VARIABLE LABELS P.dast13anabolic 'Have you ever lost a job because of anabolic steroid abuse?'.
VARIABLE LABELS P.dast14anabolic 'Have you ever got into fights when under the influence of anabolic steroids?'.
VARIABLE LABELS P.dast15anabolic 'Have you engaged in illegal activities in order to obtain anabolic steroids?'.
VARIABLE LABELS P.dast16anabolic 'Have you ever been arrested for possession of anabolic steroids?'.
VARIABLE LABELS P.dast17anabolic 'Have you ever experienced withdrawal symptoms as a result of heavy anabolic steroid intake?'.
VARIABLE LABELS P.dast18anabolic 'Have you had medical problems as a result of your anabolic steroids use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)?'.
VARIABLE LABELS P.dast19anabolic 'Have you ever gone to anyone for help for a anabolic steroids problem?'.
VARIABLE LABELS P.dast20anabolic 'Have you ever been treated as an out-patient for problems related to anabolic steroid abuse?'.


EXECUTE.

** save the complete file .
SAVE OUTFILE='C:\imagen_data\spss_data_files\ESPAD_complete.sav'
 /COMPRESSED.
 
