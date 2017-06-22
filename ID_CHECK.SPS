** CONVERT ALL THE CSV FILES TO SAV FILES AND THEN MERGE THEM TOGETHER.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP1'.
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)).
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP2'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_1_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP3'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP1'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt) ).
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP2'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_2_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP3'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP1'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP2'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_3_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP3'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_1_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP1'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_2_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP2'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PALP_3_4_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PALP3'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_AUDIT_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='AUDIT'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_ESPAD_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='ESPAD'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_DOT_PROBE_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='DOT_PROBE'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_IDENT_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='IDENT'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_KIRBY_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='KIRBY'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_NEO_FFI_CHILD_RC5-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='NEO_FFI'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_PDS_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='PDS'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_SURPS_RC5-IMAGEN_SURVEY_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='SURPS'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .
SAVE OUTFILE='C:\temp\id_check.sav' /COMPRESSED /DROP=attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_TCI_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  OID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A15) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1) .
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .
	SELECT IF(substr(block,1,2) = "id").
	String Task (A10).
	Compute Task='TCI'.
ADD FILES FILE=* FILE='C:\temp\id_check.sav' .


EXECUTE.

** drop the test users
SELECT IF(substr(OID, 1,4) <> "TEST").

String res (A7).
Compute res = substr(result, 1,7).


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

MATCH FILES FILE=* /DROP=OID result attempt attempt_complete locale valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid trial rsp rt valid processed_timestamp completed_timestamp.

** now we can transpose the summary variables.
SORT CASES BY id Block TASK.
CASESTOVARS
 /ID = id 
 /INDEX = Block Task 
 /GROUPBY = INDEX.

String confirmed_dob (A7).
compute confirmed_dob="NA".
String confirmed_gender (A7).
compute confirmed_gender="NA".
exe.

Do Repeat DOBVAR = id_check_dob.AUDIT to id_check_dob.TCI .
	DO If ((DOBVAR <> "" & confirmed_dob <> "NA" & DOBVAR = confirmed_dob) OR (DOBVAR <> "" & confirmed_dob = "NA" )) .
		Compute confirmed_dob = DOBVAR.
	ELSE IF ( DOBVAR <> confirmed_dob & DOBVAR <> "" ) .
		COMPUTE confirmed_dob = "ERROR".
	END IF.
END REPEAT.

Do Repeat GENVAR = id_check_gender.AUDIT to id_check_gender.TCI .
	DO If ((GENVAR <> "" & confirmed_gender<> "NA" & GENVAR = confirmed_gender) OR (GENVAR <> "" & confirmed_gender= "NA" )) .
		Compute confirmed_gender= GENVAR .
	ELSE IF ( GENVAR <> confirmed_gender& GENVAR <> "" ) .
		COMPUTE confirmed_gender= "ERROR".
	END IF.
END REPEAT.


** REQUIRE AT LEAST THREE TASKS TO CONFIRM A GENDER/DOB.
COUNT genMiss= id_check_gender.AUDIT to id_check_gender.TCI ("").
COUNT dobMiss= id_check_dob.AUDIT to id_check_dob.TCI ("").
If (genMiss >9) confirmed_gender = "NA".
If (dobMiss >9) confirmed_dob = "NA".

If (confirmed_gender<>"ERROR" & confirmed_gender <> "NA") gender = Number(confirmed_gender, F1.0).
Do If (length(rtrim(confirmed_dob))=6).
	compute birth_year = number(substr(confirmed_dob, 3,4), F4.0).
	compute birth_month = number(substr(confirmed_dob, 1,1), F1.0).
else if (length(rtrim(confirmed_dob))=7).
	compute birth_year = number(substr(confirmed_dob, 4,4), F4.0).
	compute birth_month = number(substr(confirmed_dob, 1,2), F2.0).
end if.
Formats gender (F1) birth_year (F1) birth_month (F1) .
VALUE LABELS gender 2 "Female" 1 "Male".
exe.


** Save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\ID_CHECK_COMPLETE.sav' /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\ID_CHECK_SUMMARY.sav' /COMPRESSED /KEEP id gender birth_year birth_month .

