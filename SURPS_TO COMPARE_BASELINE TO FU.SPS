DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_RC5-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\child.sav'.
EXECUTE.

**Mark these as the baseline assessments then lets add in FU1.
Compute Phase = 1.
SAVE OUTFILE='C:\temp\surps.sav'/Compressed.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_FU_RC5-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_PARENT_FU_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\child.sav'.
EXECUTE.

**Mark these as the baseline assessments then lets get FU2.
Compute Phase = 2.
SAVE OUTFILE='C:\temp\surps2.sav'/Compressed .

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_FU2-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A125) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

**Mark these as FU2 assessments then lets add in FU1 and baseline.
Compute Phase = 3.

ADD FILES /FILE=*
 /FILE='C:\Temp\surps2.sav'.
EXECUTE.
ADD FILES /FILE=*
 /FILE='C:\Temp\surps.sav'.
EXECUTE.

MATCH FILES /file=* /drop valid to ever_valid.


** drop the id_checks - these should be dealt with as a whole in a different script.
USE ALL.
SELECT IF(SUBSTR(block,1,5) = "surps" &  substr(SID, 1,4) <> "TEST").
SELECT IF(SUBSTR(SID, 1, 8)<>'FOLLOWUP').

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


**INVERSIONS DEALT WITH AT TASK CODING LEVEL.


** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\SURPS_complete.sav'
  /DROP= SID attempt locale completed_timestamp processed_timestamp attempt_complete trial result rsp rt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\SURPS_complete.sav'.
execute.

** restructure.
SORT CASES BY id   PorC  block Phase.
CASESTOVARS
 /ID = id 
 /INDEX =  PorC  block Phase 
 /GROUPBY = VARIABLE .

* compute the summary vars.
compute C.as_mean.1 = mean(C.surps8.1, C.surps10.1, C.surps14.1, C.surps18.1, C.surps21.1) .
compute C.h_mean.1 = mean(C.surps1.1, C.surps4.1, C.surps7.1, C.surps13.1, C.surps17.1, C.surps20.1, C.surps23.1) .
compute C.imp_mean.1 = mean(C.surps2.1, C.surps5.1, C.surps11.1, C.surps15.1, C.surps22.1) .
compute C.ss_mean.1 = mean(C.surps3.1, C.surps6.1, C.surps9.1, C.surps12.1, C.surps16.1, C.surps19.1) .

compute P.as_mean.1= mean(P.surps8.1, P.surps10.1, P.surps14.1, P.surps18.1, P.surps21.1) .
compute P.h_mean.1 = mean(P.surps1.1, P.surps4.1, P.surps7.1, P.surps13.1, P.surps17.1, P.surps20.1, P.surps23.1) .
compute P.imp_mean.1 = mean(P.surps2.1, P.surps5.1, P.surps11.1, P.surps15.1, P.surps22.1) .
compute P.ss_mean.1 = mean(P.surps3.1, P.surps6.1, P.surps9.1, P.surps12.1, P.surps16.1, P.surps19.1) .

compute C.as_mean.2 = mean(C.surps8.2, C.surps10.2, C.surps14.2, C.surps18.2, C.surps21.2) .
compute C.h_mean.2 = mean(C.surps1.2, C.surps4.2, C.surps7.2, C.surps13.2, C.surps17.2, C.surps20.2, C.surps23.2) .
compute C.imp_mean.2 = mean(C.surps2.2, C.surps5.2, C.surps11.2, C.surps15.2, C.surps22.2) .
compute C.ss_mean.2 = mean(C.surps3.2, C.surps6.2, C.surps9.2, C.surps12.2, C.surps16.2, C.surps19.2) .

compute P.as_mean.2= mean(P.surps8.2, P.surps10.2, P.surps14.2, P.surps18.2, P.surps21.2) .
compute P.h_mean.2 = mean(P.surps1.2, P.surps4.2, P.surps7.2, P.surps13.2, P.surps17.2, P.surps20.2, P.surps23.2) .
compute P.imp_mean.2 = mean(P.surps2.2, P.surps5.2, P.surps11.2, P.surps15.2, P.surps22.2) .
compute P.ss_mean.2 = mean(P.surps3.2, P.surps6.2, P.surps9.2, P.surps12.2, P.surps16.2, P.surps19.2) .

compute C.as_mean.3 = mean(C.surps8.3, C.surps10.3, C.surps14.3, C.surps18.3, C.surps21.3) .
compute C.h_mean.3 = mean(C.surps1.3, C.surps4.3, C.surps7.3, C.surps13.3, C.surps17.3, C.surps20.3, C.surps23.3) .
compute C.imp_mean.3 = mean(C.surps2.3, C.surps5.3, C.surps11.3, C.surps15.3, C.surps22.3) .
compute C.ss_mean.3 = mean(C.surps3.3, C.surps6.3, C.surps9.3, C.surps12.3, C.surps16.3, C.surps19.3) .

execute.

CORRELATIONS
  /VARIABLES=C.as_mean.1 C.h_mean.1 C.imp_mean.1 C.ss_mean.1 P.as_mean.1 P.h_mean.1 P.imp_mean.1 
    P.ss_mean.1 WITH C.as_mean.2 C.h_mean.2 C.imp_mean.2 C.ss_mean.2 P.as_mean.2 P.h_mean.2 P.imp_mean.2 
    P.ss_mean.2 
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES= C.as_mean.2 C.h_mean.2 C.imp_mean.2 C.ss_mean.2 P.as_mean.2 P.h_mean.2 P.imp_mean.2 
    P.ss_mean.2 WITH C.as_mean.3 C.h_mean.3 C.imp_mean.3 C.ss_mean.3
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.




Variable labels ID 'Subject ID'.
VARIABLE LABELS C.Locale 'Child Locale' P.Locale 'Parent Locale'
C.as_mean 'Anxiety sensitivity mean'
C.h_mean 'Hopelessness mean'
C.imp_mean 'Impulsivity mean'
C.ss_mean 'Sensation Seeking mean'
P.as_mean 'Anxiety sensitivity mean'
P.h_mean 'Hopelessness mean'
P.imp_mean 'Impulsivity mean'
P.ss_mean 'Sensation Seeking mean'.

VALUE LABELS C.surps1 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS C.surps2 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps3 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps4 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS C.surps5 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps6 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps7 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS C.surps8 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps9 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps10 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps11 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps12 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps13 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS C.surps14 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps15 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps16 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps17 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps18 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps19 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps20 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS C.surps21 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps22 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS C.surps23 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps1 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps2 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps3 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps4 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps5 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps6 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps7 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps8 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps9 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps10 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps11 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps12 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps13 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps14 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps15 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps16 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps17 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps18 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps19 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps20 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VALUE LABELS P.surps21 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps22 1 '1 - strongly disagree' 2 '2 - disagree' 3 '3 - agree' 4 '4 - strongly agree' .	
VALUE LABELS P.surps23 4 '1 - strongly disagree' 3 '2 - disagree' 2 '3 - agree' 1 '4 - strongly agree' .	
VARIABLE LABELS C.surps1 'I am content.'.	
VARIABLE LABELS C.surps2 'I often dont think things through before I speak.'.	
VARIABLE LABELS C.surps3 'I would like to skydive.'.	
VARIABLE LABELS C.surps4 'I am happy.'.	
VARIABLE LABELS C.surps5 'I often involve myself in situations that I later regret being involved in.'.	
VARIABLE LABELS C.surps6 'I enjoy new and exciting experiences even if they are unconventional.'.	
VARIABLE LABELS C.surps7 'I have faith that my future holds great promise.'.	
VARIABLE LABELS C.surps8 'Its frightening to feel dizzy or faint.'.	
VARIABLE LABELS C.surps9 'I like doing things that frighten me a little.'.	
VARIABLE LABELS C.surps10 'It frightens me when I feel my heart beat change.'.	
VARIABLE LABELS C.surps11 'I usually act without stopping to think.'.	
VARIABLE LABELS C.surps12 'I would like to learn how to drive a motorcycle.'.	
VARIABLE LABELS C.surps13 'I feel proud of my accomplishments.'.	
VARIABLE LABELS C.surps14 'I get scared when Im too nervous.'.	
VARIABLE LABELS C.surps15 'Generally, I am an impulsive person.'.	
VARIABLE LABELS C.surps16 'I am interested in experience for its own sake even if it is illegal.'.	
VARIABLE LABELS C.surps17 'I feel that Im a failure.'.	
VARIABLE LABELS C.surps18 'I get scared when I experience unusual body sensations.'.	
VARIABLE LABELS C.surps19 'I would enjoy hiking long distances in wild and uninhabited territory.'.	
VARIABLE LABELS C.surps20 'I feel pleasant.'.	
VARIABLE LABELS C.surps21 'It scares me when Im unable to focus on a task.'.	
VARIABLE LABELS C.surps22 'I feel I have to be manipulative to get what I want.'.	
VARIABLE LABELS C.surps23 'I am very enthusiastic about my future.'.	
VARIABLE LABELS P.surps1 'I am content.'.	
VARIABLE LABELS P.surps2 'I often dont think things through before I speak.'.	
VARIABLE LABELS P.surps3 'I would like to skydive.'.	
VARIABLE LABELS P.surps4 'I am happy.'.	
VARIABLE LABELS P.surps5 'I often involve myself in situations that I later regret being involved in.'.	
VARIABLE LABELS P.surps6 'I enjoy new and exciting experiences even if they are unconventional.'.	
VARIABLE LABELS P.surps7 'I have faith that my future holds great promise.'.	
VARIABLE LABELS P.surps8 'Its frightening to feel dizzy or faint.'.	
VARIABLE LABELS P.surps9 'I like doing things that frighten me a little.'.	
VARIABLE LABELS P.surps10 'It frightens me when I feel my heart beat change.'.	
VARIABLE LABELS P.surps11 'I usually act without stopping to think.'.	
VARIABLE LABELS P.surps12 'I would like to learn how to drive a motorcycle.'.	
VARIABLE LABELS P.surps13 'I feel proud of my accomplishments.'.	
VARIABLE LABELS P.surps14 'I get scared when Im too nervous.'.	
VARIABLE LABELS P.surps15 'Generally, I am an impulsive person.'.	
VARIABLE LABELS P.surps16 'I am interested in experience for its own sake even if it is illegal.'.	
VARIABLE LABELS P.surps17 'I feel that Im a failure.'.	
VARIABLE LABELS P.surps18 'I get scared when I experience unusual body sensations.'.	
VARIABLE LABELS P.surps19 'I would enjoy hiking long distances in wild and uninhabited territory.'.	
VARIABLE LABELS P.surps20 'I feel pleasant.'.	
VARIABLE LABELS P.surps21 'It scares me when Im unable to focus on a task.'.	
VARIABLE LABELS P.surps22 'I feel I have to be manipulative to get what I want.'.	
VARIABLE LABELS P.surps23 'I am very enthusiastic about my future.'.	




** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\SURPS_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\SURPS_summary.sav'
 /DROP C.surps1 to p.surps9
 /COMPRESSED.

