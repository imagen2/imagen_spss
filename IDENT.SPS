GET DATA  /TYPE = TXT
 /FILE = "C:\imagen_data\csv_data_files\IMAGEN-IMGN_IDENT_RC5-IMAGEN_DIGEST.csv"
 /DELCASE = LINE
 /DELIMITERS = "_,"
 /ARRANGEMENT = DELIMITED
 /FIRSTCASE = 2
 /IMPORTCASE = ALL
 /VARIABLES =
 OID A14
 Attempt F1.0
 Locale A2
 Attempt_Complete A1
 Completed_timestamp A16
 Processed_timestamp A16
 Block1 A20
 Block2 A20
 FaceID A3
 ContA A10
 ContB A10
 Morph F3.0
 Result A7
 Response_side A2
 Response_emotion A10
 RT F5.2
 Valid A1
 .
CACHE.
EXECUTE.


SELECT IF(block2 = 'MAIN' &  substr(OID, 1,4) <> "TEST").


	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=OID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .


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


**create a single continuum variable.
String Continuum(A20).
Compute Continuum = concat(rtrim(ContA), "_", rtrim(ContB)).

**Turn the Morph variable into a %.
Compute Morph = Morph * 10.

** create a response variable indicating which end of the continuum they chose 0% or 100%.
If (Response_emotion = ContA) Presponse = 0.
If (Response_emotion = ContB) Presponse = 100.

** aggregate some summary variables by condition NB YOU COULD DO THIS BY BLOCK or by stimulus etc to see how the task is working overall - a VERY handy command.
** without the addvariables flag this wil replace the current file so we need to make sure everythgin we want is in here.
AGGREGATE  /OUTFILE=*    /BREAK=ID Locale Continuum Morph / P = MEAN(Presponse) /RT = MEAN(RT).

** now we can transpose the summary variables.
SORT CASES BY id Continuum Morph.
CASESTOVARS
 /ID = id 
 /INDEX = Continuum Morph
 /GROUPBY = VARIABLE .


****************COMPUTE THRESHOLDS FOR ANGER_FEAR.

compute #lower = -99.
compute #morph=0.
Do Repeat morphVar = P.anger_fear.0 to P.anger_fear.100.
	Do if (morphVar >=50).
		Do if (#lower = -99).
			compute #lower=#morph.
		end if.
	end if.

	Do if (morphVar <=50).
		compute #higher=#morph.
	end if.
	compute #morph = #morph+10.
end repeat.
do if (not(missing(P.anger_fear.0))).
compute anger_fear_Threshold = (#higher+#lower) /2.
compute anger_fear_noise = ABS(#higher-#lower).
end if.
exe.

****************COMPUTE THRESHOLDS FOR ANGER_SAD.

compute #lower = -99.
compute #morph=0.
Do Repeat morphVar = P.anger_sad.0 to P.anger_sad.100.
	Do if (morphVar >=50).
		Do if (#lower = -99).
			compute #lower=#morph.
		end if.
	end if.

	Do if (morphVar <=50).
		compute #higher=#morph.
	end if.
	compute #morph = #morph+10.
end repeat.
do if (not(missing(P.anger_sad.0))).
compute anger_sad_Threshold = (#higher+#lower) /2.
compute anger_sad_Noise = ABS(#higher-#lower).
end if.
exe.

****************COMPUTE THRESHOLDS FOR HAPPY_FEAR.

compute #lower = -99.
compute #morph=0.
Do Repeat morphVar = P.happy_fear.0 to P.happy_fear.100.
	Do if (morphVar >=50).
		Do if (#lower = -99).
			compute #lower=#morph.
		end if.
	end if.

	Do if (morphVar <=50).
		compute #higher=#morph.
	end if.
	compute #morph = #morph+10.
end repeat.
do if (not(missing(P.happy_fear.0))).
compute happy_fear_Threshold = (#higher+#lower) /2.
compute happy_fear_noise = ABS(#higher-#lower).
end if.
exe.


****************COMPUTE THRESHOLDS FOR HAPPY_SAD.

compute #lower = -99.
compute #morph=0.
Do Repeat morphVar = P.happy_sad.0 to P.happy_sad.100.
	Do if (morphVar >=50).
		Do if (#lower = -99).
			compute #lower=#morph.
		end if.
	end if.

	Do if (morphVar <=50).
		compute #higher=#morph.
	end if.
	compute #morph = #morph+10.
end repeat.
do if (not(missing(P.happy_sad.0))).
compute happy_sad_Threshold = (#higher+#lower) /2.
compute happy_sad_Noise = ABS(#higher-#lower).
end if.
exe.


** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\IDENT_COMPLETE.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\IDENT_SUMMARY.sav'
 /DROP P.anger_fear.0 to RT.happy_sad.100 /COMPRESSED.

