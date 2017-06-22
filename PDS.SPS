DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PDS_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .


** drop the id_checks - these should be dealt with as a whole in a different script.
SELECT IF(SUBSTR(block,1,1) = "a" &  substr(SID, 1,4) <> "TEST").

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

**Create an ID code and CHILD / PARENT variable.
String ID(A12).
Compute ID = substr(SID, 1, 12).


** no inversions.
** drop unneccesary vars.
MATCH FILES FILE=*  /DROP=SID attempt valid completed_timestamp processed_timestamp attempt_complete trial result rsp rt first_complete_attempt Valid_attempt first_complete_valid_attempt ever_valid.

** restructure.
SORT CASES BY id block .
CASESTOVARS
 /ID = id 
 /INDEX = block 
 /GROUPBY = VARIABLE .


Variable labels ID 'Subject ID' locale 'Locale of Test'.
VALUE LABELS a8_f 1 'Has not yet begun to spurt (spurt means more growth than usual)' 2 'Has barely started' 3 'Is definitely underway' 4 'Seems completed' .
VALUE LABELS a9_f 1 'Not yet started growing' 2 'Has barely started growing' 3 'Is definitely underway' 4 'Seems completed' .
VALUE LABELS a10_f 1 'Not yet started showing changes' 2 'Have barely started showing changes' 3 'Skin changes are definitely underway' 4 'Skin changes seem completed' .
VALUE LABELS a11_f 1 'Not yet started growing' 2 'Has barely started changing' 3 'Breast growth is definitely underway' 4 'Breast growth seems completed' .
VALUE LABELS a12a_f 1 'Yes' 0 'No' .
VALUE LABELS a12b_f 10 '10 years or younger' 11 '11' 12 '12' 13 '13' 14 '14' .
VALUE LABELS a13_f 5 'Much earlier' 4 'Somewhat earlier' 3 'About the same' 2 'Somewhat later' 1 'Much later' .
VALUE LABELS a8_m 1 'Has not yet begun to spurt (spurt means more growth than usual)' 2 'Has barely started' 3 'Is definitely underway' 4 'Seems completed' .
VALUE LABELS a9_m 1 'Not yet started growing' 2 'Has barely started growing' 3 'Is definitely underway' 4 'Seems completed' .
VALUE LABELS a10_m 1 'Not yet started showing changes' 2 'Have barely started showing changes' 3 'Skin changes are definitely underway' 4 'Skin changes seem completed' .
VALUE LABELS a11_m 1 'Not yet started changing' 2 'Has barely started changing' 3 'Voice change is definitely underway' 4 'Voice change seems completed' .
VALUE LABELS a12_m 1 'Not yet started growing hair' 2 'Has barely started growing hair' 3 'Facial hair growth is definitely underway' 4 'Facial hair growth seems completed' .
VALUE LABELS a13_m 5 'Much earlier' 4 'Somewhat earlier' 3 'About the same' 2 'Somewhat later' 1 'Much later' .
VARIABLE LABELS a8_f 'Would you say that your growth in height: …?'.
VARIABLE LABELS a9_f 'And how about the growth of body hair (body hair means underarm and pubic hair), would you say that your body hair has:…?'.
VARIABLE LABELS a10_f 'Have you noticed any skin changes, especially pimples?'.
VARIABLE LABELS a11_f 'Have your breasts begun to grow?'.
VARIABLE LABELS a12a_f 'Have you begun to menstruate?'.
VARIABLE LABELS a12b_f 'How old were you when you had your first period?'.
VARIABLE LABELS a13_f 'Do you think your development is any earlier or later than most other girls your age?'.
VARIABLE LABELS a8_m 'Would you say that your growth in height: …?'.
VARIABLE LABELS a9_m 'And how about the growth of body hair (body hair means underarm and pubic hair), would you say that your body hair has:…?'.
VARIABLE LABELS a10_m 'Have you noticed any skin changes, especially pimples?'.
VARIABLE LABELS a11_m 'Have you noticed a deepening of your voice?'.
VARIABLE LABELS a12_m 'Have you begun to grow hair on your face?'.
VARIABLE LABELS a13_m 'Do you think your development is any earlier or later than most other boys your age?'.


** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\PDS_complete.sav'
 /COMPRESSED.
