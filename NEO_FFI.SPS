DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_NEO_FFI_CHILD_RC5-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_NEO_FFI_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\child.sav'.
EXECUTE.

** drop the id_checks - these should be dealt with as a whole in a different script.
USE ALL.
SELECT IF(SUBSTR(block,1,6) = "neoffi" &  substr(SID, 1,4) <> "TEST").


** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.



** convert the result to numeric.
compute R = Number(result, F1.0).
formats R(F1).
EXECUTE .

**Create an ID code and CHILD / PARENT variable.
String ID(A12).
String PorC(A1).
String P.locale(A2).
String C.locale(A2).
Compute ID = substr(SID, 1, 12).
Compute PorC = substr(SID, 14, 1).
If (PorC="C") C.Locale = Locale.
If (PorC="P") P.Locale = Locale.

**inversions dealt with in task coding.

** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\NEO_FFI_complete.sav'
  /DROP= SID attempt locale completed_timestamp processed_timestamp attempt_complete trial result rsp rt first_complete_attempt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\NEO_FFI_complete.sav'.
execute.

** restructure.
SORT CASES BY id PorC  block .
CASESTOVARS
 /ID = id 
 /INDEX = PorC block 
 /GROUPBY = VARIABLE .

* compute the summary vars.
compute C.neur_mean = mean( C.neoffi1, C.neoffi6, C.neoffi11, C.neoffi16, C.neoffi21, C.neoffi26, C.neoffi31, C.neoffi36, C.neoffi41, C.neoffi46, C.neoffi51, C.neoffi56).
compute C.extr_mean = mean( C.neoffi2, C.neoffi7, C.neoffi12, C.neoffi17, C.neoffi22, C.neoffi27, C.neoffi32, C.neoffi37, C.neoffi42, C.neoffi47, C.neoffi52, C.neoffi57).
compute C.open_mean =mean( C.neoffi3, C.neoffi8, C.neoffi13, C.neoffi18, C.neoffi23, C.neoffi28, C.neoffi33, C.neoffi38, C.neoffi43, C.neoffi48, C.neoffi53, C.neoffi58).
compute C.agre_mean = mean( C.neoffi4, C.neoffi9, C.neoffi14, C.neoffi19, C.neoffi24, C.neoffi29, C.neoffi34, C.neoffi39, C.neoffi44, C.neoffi49, C.neoffi54, C.neoffi59).
compute C.cons_mean = mean( C.neoffi5, C.neoffi10, C.neoffi15, C.neoffi20, C.neoffi25, C.neoffi30, C.neoffi35, C.neoffi40, C.neoffi45, C.neoffi50, C.neoffi55, C.neoffi60).

compute P.neur_mean = mean( P.neoffi1, P.neoffi6, P.neoffi11, P.neoffi16, P.neoffi21, P.neoffi26, P.neoffi31, P.neoffi36, P.neoffi41, P.neoffi46, P.neoffi51, P.neoffi56).
compute P.extr_mean = mean( P.neoffi2, P.neoffi7, P.neoffi12, P.neoffi17, P.neoffi22, P.neoffi27, P.neoffi32, P.neoffi37, P.neoffi42, P.neoffi47, P.neoffi52, P.neoffi57).
compute P.open_mean =mean( P.neoffi3, P.neoffi8, P.neoffi13, P.neoffi18, P.neoffi23, P.neoffi28, P.neoffi33, P.neoffi38, P.neoffi43, P.neoffi48, P.neoffi53, P.neoffi58).
compute P.agre_mean = mean( P.neoffi4, P.neoffi9, P.neoffi14, P.neoffi19, P.neoffi24, P.neoffi29, P.neoffi34, P.neoffi39, P.neoffi44, P.neoffi49, P.neoffi54, P.neoffi59).
compute P.cons_mean = mean( P.neoffi5, P.neoffi10, P.neoffi15, P.neoffi20, P.neoffi25, P.neoffi30, P.neoffi35, P.neoffi40, P.neoffi45, P.neoffi50, P.neoffi55, P.neoffi60).
execute.

Variable labels ID 'Subject ID'.
VARIABLE LABELS C.Locale 'Child Locale' P.Locale 'Parent Locale'.

VALUE LABELS C.neoffi1 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi2 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi3 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi4 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi5 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi6 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi7 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi8 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi9 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi10 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi11 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi12 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi13 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi14 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi15 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi16 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi17 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi18 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi19 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi20 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi21 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi22 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi23 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi24 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi25 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi26 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi27 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi28 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi29 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi30 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi31 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi32 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi33 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi34 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi35 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi36 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi37 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi38 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi39 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi40 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi41 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi42 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi43 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi44 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi45 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi46 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi47 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi48 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi49 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi50 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi51 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi52 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi53 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi54 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi55 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi56 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi57 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi58 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS C.neoffi59 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS C.neoffi60 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi1 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi2 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi3 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi4 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi5 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi6 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi7 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi8 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi9 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi10 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi11 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi12 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi13 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi14 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi15 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi16 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi17 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi18 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi19 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi20 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi21 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi22 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi23 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi24 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi25 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi26 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi27 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi28 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi29 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi30 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi31 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi32 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi33 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi34 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi35 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi36 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi37 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi38 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi39 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi40 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi41 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi42 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi43 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi44 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi45 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi46 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi47 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi48 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi49 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi50 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi51 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi52 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi53 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi54 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi55 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi56 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi57 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi58 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VALUE LABELS P.neoffi59 4 'Strongly Disagree' 3 'Disagree' 2 'Neutral' 1 'Agree' 0 'Strongly Agree' .	
VALUE LABELS P.neoffi60 0 'Strongly Disagree' 1 'Disagree' 2 'Neutral' 3 'Agree' 4 'Strongly Agree' .	
VARIABLE LABELS C.neoffi1 'I am not a worrier'.	
VARIABLE LABELS C.neoffi2 'I like to have a lot of people around me'.	
VARIABLE LABELS C.neoffi3 'I dont like to waste my time daydreaming'.	
VARIABLE LABELS C.neoffi4 'I try to be courteous to everyone I meet'.	
VARIABLE LABELS C.neoffi5 'I keep my belongings neat and clean'.	
VARIABLE LABELS C.neoffi6 'I often feel that Im not as good as others'.	
VARIABLE LABELS C.neoffi7 'I laugh easily'.	
VARIABLE LABELS C.neoffi8 'Once I find the right way to do something, I stick to it'.	
VARIABLE LABELS C.neoffi9 'I often get into arguments with my family and co-workers'.	
VARIABLE LABELS C.neoffi10 'Im pretty good about pacing myself so as to get things done on time'.	
VARIABLE LABELS C.neoffi11 'When Im under a great deal of stress, sometimes I feel like Im going to pieces'.	
VARIABLE LABELS C.neoffi12 'Im not happy-go-lucky'.	
VARIABLE LABELS C.neoffi13 'I am intrigued by the patterns I find in art and nature'.	
VARIABLE LABELS C.neoffi14 'Some people think Im selfish and egotistical'.	
VARIABLE LABELS C.neoffi15 'Im not a very orderly or methodical person'.	
VARIABLE LABELS C.neoffi16 'I rarely feel lonely or blue'.	
VARIABLE LABELS C.neoffi17 'I really enjoy talking to people'.	
VARIABLE LABELS C.neoffi18 'I believe letting students hear controversial speakers can only confuse and mislead them'.	
VARIABLE LABELS C.neoffi19 'I would rather cooperate with others than compete with them'.	
VARIABLE LABELS C.neoffi20 'I try to perform all the tasks assigned to me conscientiously'.	
VARIABLE LABELS C.neoffi21 'I often feel tense and jittery'.	
VARIABLE LABELS C.neoffi22 'I like to be where the action is'.	
VARIABLE LABELS C.neoffi23 'Poetry has little or no effect on me'.	
VARIABLE LABELS C.neoffi24 'Often, people arent as nice as they seem to be'.	
VARIABLE LABELS C.neoffi25 'I have a clear set of goals and work toward them in an orderly fashion'.	
VARIABLE LABELS C.neoffi26 'Sometimes I feel completely worthless'.	
VARIABLE LABELS C.neoffi27 'I usually  prefer to do things alone'.	
VARIABLE LABELS C.neoffi28 'I often try new and foreign foods'.	
VARIABLE LABELS C.neoffi29 'I believe that most people will take advantage of you if you let them'.	
VARIABLE LABELS C.neoffi30 'I waste a lot of time before settling down to work'.	
VARIABLE LABELS C.neoffi31 'I rarely feel fearful or anxious'.	
VARIABLE LABELS C.neoffi32 'I often feel as if Im bursting with energy'.	
VARIABLE LABELS C.neoffi33 'I seldom notice the moods or feelings that different environments produce'.	
VARIABLE LABELS C.neoffi34 'Most people I know like me'.	
VARIABLE LABELS C.neoffi35 'I work hard to accomplish my goals'.	
VARIABLE LABELS C.neoffi36 'I often get angry at the way people treat me'.	
VARIABLE LABELS C.neoffi37 'I am a cheerful, high-spirited person'.	
VARIABLE LABELS C.neoffi38 'I believe we should look to our religious authorities for decisions on moral issues'.	
VARIABLE LABELS C.neoffi39 'Some people think of me as cold and calculating'.	
VARIABLE LABELS C.neoffi40 'When I make a commitment, I can always be counted on to follow through'.	
VARIABLE LABELS C.neoffi41 'Too often, when things go wrong, I get discouraged and feel like giving up'.	
VARIABLE LABELS C.neoffi42 'I am not a cheerful optimist'.	
VARIABLE LABELS C.neoffi43 'Sometimes when I am reading poetry or looking at a work of art, I feel a chill or wave of excitement'.	
VARIABLE LABELS C.neoffi44 'I dont worry much about the homeless'.	
VARIABLE LABELS C.neoffi45 'Sometimes Im not as dependable or reliable as I should be'.	
VARIABLE LABELS C.neoffi46 'I am seldom sad or depressed'.	
VARIABLE LABELS C.neoffi47 'My life is fast-paced'.	
VARIABLE LABELS C.neoffi48 'I have little interest in speculating on the nature of the universe or human condition'.	
VARIABLE LABELS C.neoffi49 'I generally try to be thoughtful and considerate'.	
VARIABLE LABELS C.neoffi50 'I am a productive person who always gets the job done'.	
VARIABLE LABELS C.neoffi51 'I often feel helpless and want someone else to solve my problems'.	
VARIABLE LABELS C.neoffi52 'I am a very active person'.	
VARIABLE LABELS C.neoffi53 'I have a lot of intellectual curiosity'.	
VARIABLE LABELS C.neoffi54 'If I dont like people, I let them know it'.	
VARIABLE LABELS C.neoffi55 'I never seem to be able to get organized'.	
VARIABLE LABELS C.neoffi56 'At times I have been so ashamed I just wanted to hide'.	
VARIABLE LABELS C.neoffi57 'I would rather go my own way than be a leader of others'.	
VARIABLE LABELS C.neoffi58 'I often enjoy playing with theories or abstract ideas'.	
VARIABLE LABELS C.neoffi59 'If necessary, I am willing to manipulate people to get what I want'.	
VARIABLE LABELS C.neoffi60 'I strive for excellence in everything I do'.	
VARIABLE LABELS P.neoffi1 'I am not a worrier'.	
VARIABLE LABELS P.neoffi2 'I like to have a lot of people around me'.	
VARIABLE LABELS P.neoffi3 'I dont like to waste my time daydreaming'.	
VARIABLE LABELS P.neoffi4 'I try to be courteous to everyone I meet'.	
VARIABLE LABELS P.neoffi5 'I keep my belongings neat and clean'.	
VARIABLE LABELS P.neoffi6 'I often feel that Im not as good as others'.	
VARIABLE LABELS P.neoffi7 'I laugh easily'.	
VARIABLE LABELS P.neoffi8 'Once I find the right way to do something, I stick to it'.	
VARIABLE LABELS P.neoffi9 'I often get into arguments with my family and co-workers'.	
VARIABLE LABELS P.neoffi10 'Im pretty good about pacing myself so as to get things done on time'.	
VARIABLE LABELS P.neoffi11 'When Im under a great deal of stress, sometimes I feel like Im going to pieces'.	
VARIABLE LABELS P.neoffi12 'Im not happy-go-lucky'.	
VARIABLE LABELS P.neoffi13 'I am intrigued by the patterns I find in art and nature'.	
VARIABLE LABELS P.neoffi14 'Some people think Im selfish and egotistical'.	
VARIABLE LABELS P.neoffi15 'Im not a very orderly or methodical person'.	
VARIABLE LABELS P.neoffi16 'I rarely feel lonely or blue'.	
VARIABLE LABELS P.neoffi17 'I really enjoy talking to people'.	
VARIABLE LABELS P.neoffi18 'I believe letting students hear controversial speakers can only confuse and mislead them'.	
VARIABLE LABELS P.neoffi19 'I would rather cooperate with others than compete with them'.	
VARIABLE LABELS P.neoffi20 'I try to perform all the tasks assigned to me conscientiously'.	
VARIABLE LABELS P.neoffi21 'I often feel tense and jittery'.	
VARIABLE LABELS P.neoffi22 'I like to be where the action is'.	
VARIABLE LABELS P.neoffi23 'Poetry has little or no effect on me'.	
VARIABLE LABELS P.neoffi24 'Often, people arent as nice as they seem to be'.	
VARIABLE LABELS P.neoffi25 'I have a clear set of goals and work toward them in an orderly fashion'.	
VARIABLE LABELS P.neoffi26 'Sometimes I feel completely worthless'.	
VARIABLE LABELS P.neoffi27 'I usually  prefer to do things alone'.	
VARIABLE LABELS P.neoffi28 'I often try new and foreign foods'.	
VARIABLE LABELS P.neoffi29 'I believe that most people will take advantage of you if you let them'.	
VARIABLE LABELS P.neoffi30 'I waste a lot of time before settling down to work'.	
VARIABLE LABELS P.neoffi31 'I rarely feel fearful or anxious'.	
VARIABLE LABELS P.neoffi32 'I often feel as if Im bursting with energy'.	
VARIABLE LABELS P.neoffi33 'I seldom notice the moods or feelings that different environments produce'.	
VARIABLE LABELS P.neoffi34 'Most people I know like me'.	
VARIABLE LABELS P.neoffi35 'I work hard to accomplish my goals'.	
VARIABLE LABELS P.neoffi36 'I often get angry at the way people treat me'.	
VARIABLE LABELS P.neoffi37 'I am a cheerful, high-spirited person'.	
VARIABLE LABELS P.neoffi38 'I believe we should look to our religious authorities for decisions on moral issues'.	
VARIABLE LABELS P.neoffi39 'Some people think of me as cold and calculating'.	
VARIABLE LABELS P.neoffi40 'When I make a commitment, I can always be counted on to follow through'.	
VARIABLE LABELS P.neoffi41 'Too often, when things go wrong, I get discouraged and feel like giving up'.	
VARIABLE LABELS P.neoffi42 'I am not a cheerful optimist'.	
VARIABLE LABELS P.neoffi43 'Sometimes when I am reading poetry or looking at a work of art, I feel a chill or wave of excitement'.	
VARIABLE LABELS P.neoffi44 'I dont worry much about the homeless'.	
VARIABLE LABELS P.neoffi45 'Sometimes Im not as dependable or reliable as I should be'.	
VARIABLE LABELS P.neoffi46 'I am seldom sad or depressed'.	
VARIABLE LABELS P.neoffi47 'My life is fast-paced'.	
VARIABLE LABELS P.neoffi48 'I have little interest in speculating on the nature of the universe or human condition'.	
VARIABLE LABELS P.neoffi49 'I generally try to be thoughtful and considerate'.	
VARIABLE LABELS P.neoffi50 'I am a productive person who always gets the job done'.	
VARIABLE LABELS P.neoffi51 'I often feel helpless and want someone else to solve my problems'.	
VARIABLE LABELS P.neoffi52 'I am a very active person'.	
VARIABLE LABELS P.neoffi53 'I have a lot of intellectual curiosity'.	
VARIABLE LABELS P.neoffi54 'If I dont like people, I let them know it'.	
VARIABLE LABELS P.neoffi55 'I never seem to be able to get organized'.	
VARIABLE LABELS P.neoffi56 'At times I have been so ashamed I just wanted to hide'.	
VARIABLE LABELS P.neoffi57 'I would rather go my own way than be a leader of others'.	
VARIABLE LABELS P.neoffi58 'I often enjoy playing with theories or abstract ideas'.	
VARIABLE LABELS P.neoffi59 'If necessary, I am willing to manipulate people to get what I want'.	
VARIABLE LABELS P.neoffi60 'I strive for excellence in everything I do'.	


** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\NEO_FFI_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\NEO_FFI_summary.sav'
 /DROP C.neoffi1 to P.neoffi9
 /COMPRESSED.
