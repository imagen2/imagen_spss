DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_AUDIT_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\audit_child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_AUDIT_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\audit_child.sav'.
EXECUTE.

** drop the id_checks - these should be dealt with as a whole in a different script.
SELECT IF(SUBSTR(block,1,5) = "audit" &  substr(SID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.




** convert the question number to a numeric.
*Compute Q =Number(substring(trial, 6, Length(trial) - 5), F2.0).
*formats Q(F2).

** convert the result to numeric.
compute R= Number(RESULT, F1.0).
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


** no inversions.
** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\AUDIT_complete.sav'
  /DROP=SID attempt locale completed_timestamp processed_timestamp attempt_complete trial result rsp rt first_complete_attempt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\AUDIT_complete.sav'.
execute.

** restructure.
SORT CASES BY id PorC  block .
CASESTOVARS
 /ID = id 
 /INDEX = PorC block 
 /GROUPBY = VARIABLE .

* compute the summary vars.
compute C.audit_freq  = sum(C.audit1, C.audit2, C.audit3).
compute C.audit_symp  = sum(C.audit4, C.audit6, C.audit8).
compute C.audit_prob  = sum(C.audit5, C.audit7, C.audit9,C.audit10).
compute C.audit_total = sum(C.audit_freq to C.audit_prob).
if (C.audit_total >8) C.audit_abuse_flag = 1.
compute P.audit_freq  = sum(P.audit1, P.audit2, P.audit3).
compute P.audit_symp  = sum(P.audit4, P.audit6, P.audit8).
compute P.audit_prob  = sum(P.audit5, P.audit7, P.audit9,P.audit10).
compute P.audit_total = sum(P.audit_freq to P.audit_prob).
if (P.audit_total >8) P.audit_abuse_flag = 1.
execute.

Variable labels ID 'Subject ID'
P.locale 'Locale of Parent'
C.locale 'Locale of Child'.
VALUE LABELS C.audit1 0 'Never' 1 'Monthly or less' 2 'Two to four times a month' 3 'Two to three times a week' 4 'Four or more times a week' .	
VALUE LABELS C.audit2 0 '1 or 2' 1 '3 or 4' 2 '5 or 6' 3 '7 to 9' 4 '10 or more' .	
VALUE LABELS C.audit3 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit4 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit5 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit6 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit7 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit8 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS C.audit9 0 'No' 1 'Yes, but not in the last year' 2 'Yes, during the last year' .	
VALUE LABELS C.audit10 0 'No' 1 'Yes, but not in the last year' 2 'Yes, during the last year' .	
VALUE LABELS P.audit1 0 'Never' 1 'Monthly or less' 2 'Two to four times a month' 3 'Two to three times a week' 4 'Four or more times a week' .	
VALUE LABELS P.audit2 0 '1 or 2' 1 '3 or 4' 2 '5 or 6' 3 '7 to 9' 4 '10 or more' .	
VALUE LABELS P.audit3 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit4 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit5 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit6 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit7 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit8 0 'Never' 1 'Less than monthly' 2 'Monthly' 3 'Weekly' 4 'Daily or almost daily' .	
VALUE LABELS P.audit9 0 'No' 1 'Yes, but not in the last year' 2 'Yes, during the last year' .	
VALUE LABELS P.audit10 0 'No' 1 'Yes, but not in the last year' 2 'Yes, during the last year' .	
VARIABLE LABELS C.audit1 'How often do you have a drink containing alcohol?'.	
VARIABLE LABELS C.audit2 'How many drinks containing alcohol do you have on a typical day when you are drinking?'.	
VARIABLE LABELS C.audit3 'How often do you have six or more drinks on one occasion?'.	
VARIABLE LABELS C.audit4 'How often during the last year have you found that you were not able to stop drinking once you had started?'.	
VARIABLE LABELS C.audit5 'How often during the last year have you failed to do what was normally expected from you because of drinking?'.	
VARIABLE LABELS C.audit6 'How often during the last year have you needed a first drink in the morning to get yourself going after a heavy drinking session?'.	
VARIABLE LABELS C.audit7 'How often during the last year have you had a feeling of guilt or remorse after drinking?'.	
VARIABLE LABELS C.audit8 'How often during the last year have you been unable to remember what happened the night before because you had been drinking?'.	
VARIABLE LABELS C.audit9 'Have you or someone else been injured as a result of your drinking?'.	
VARIABLE LABELS C.audit10 'Has a relative or friend, or a doctor or other health worker been concerned about your drinking or suggested you cut down?'.	
VARIABLE LABELS P.audit1 'How often do you have a drink containing alcohol?'.	
VARIABLE LABELS P.audit2 'How many drinks containing alcohol do you have on a typical day when you are drinking?'.	
VARIABLE LABELS P.audit3 'How often do you have six or more drinks on one occasion?'.	
VARIABLE LABELS P.audit4 'How often during the last year have you found that you were not able to stop drinking once you had started?'.	
VARIABLE LABELS P.audit5 'How often during the last year have you failed to do what was normally expected from you because of drinking?'.	
VARIABLE LABELS P.audit6 'How often during the last year have you needed a first drink in the morning to get yourself going after a heavy drinking session?'.	
VARIABLE LABELS P.audit7 'How often during the last year have you had a feeling of guilt or remorse after drinking?'.	
VARIABLE LABELS P.audit8 'How often during the last year have you been unable to remember what happened the night before because you had been drinking?'.	
VARIABLE LABELS P.audit9 'Have you or someone else been injured as a result of your drinking?'.	
VARIABLE LABELS P.audit10 'Has a relative or friend, or a doctor or other health worker been concerned about your drinking or suggested you cut down?'.	


** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\AUDIT_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\AUDIT_summary.sav'
 /DROP C.audit1 to P.audit9
 /COMPRESSED.
