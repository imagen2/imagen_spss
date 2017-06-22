DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_KIRBY_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A12) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

** drop the id_checks - these should be dealt with as a whole in a different script.
SELECT IF(SUBSTR(block,1,5) = "kirby" &  substr(SID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

** Strip the -C off the IDs to allow merging of files.
String ID (A12).
Compute ID = rtrim(substr(Sid, 1, 12)).
Exe.



IF (block= 'kirby01') SIR=54.	
IF (block= 'kirby02') SIR=55.	
IF (block= 'kirby03') SIR=19.	
IF (block= 'kirby04') SIR=31.	
IF (block= 'kirby05') SIR=14.	
IF (block= 'kirby06') SIR=47.	
IF (block= 'kirby07') SIR=15.	
IF (block= 'kirby08') SIR=25.	
IF (block= 'kirby09') SIR=78.	
IF (block= 'kirby10') SIR=40.	
IF (block= 'kirby11') SIR=11.	
IF (block= 'kirby12') SIR=67.	
IF (block= 'kirby13') SIR=19.	
IF (block= 'kirby14') SIR=27.	
IF (block= 'kirby15') SIR=69.	
IF (block= 'kirby16') SIR=49.	
IF (block= 'kirby17') SIR=80.	
IF (block= 'kirby18') SIR=24.	
IF (block= 'kirby19') SIR=33.	
IF (block= 'kirby20') SIR=28.	
IF (block= 'kirby21') SIR=34.	
IF (block= 'kirby22') SIR=25.	
IF (block= 'kirby23') SIR=41.	
IF (block= 'kirby24') SIR=54.	
IF (block= 'kirby25') SIR=54.	
IF (block= 'kirby26') SIR=22.	
IF (block= 'kirby27') SIR=20.	
IF (block= 'kirby01') LDR=55.	
IF (block= 'kirby02') LDR=75.	
IF (block= 'kirby03') LDR=25.	
IF (block= 'kirby04') LDR=85.	
IF (block= 'kirby05') LDR=25.	
IF (block= 'kirby06') LDR=50.	
IF (block= 'kirby07') LDR=35.	
IF (block= 'kirby08') LDR=60.	
IF (block= 'kirby09') LDR=80.	
IF (block= 'kirby10') LDR=55.	
IF (block= 'kirby11') LDR=30.	
IF (block= 'kirby12') LDR=75.	
IF (block= 'kirby13') LDR=25.	
IF (block= 'kirby14') LDR=50.	
IF (block= 'kirby15') LDR=85.	
IF (block= 'kirby16') LDR=60.	
IF (block= 'kirby17') LDR=85.	
IF (block= 'kirby18') LDR=35.	
IF (block= 'kirby19') LDR=80.	
IF (block= 'kirby20') LDR=30.	
IF (block= 'kirby21') LDR=50.	
IF (block= 'kirby22') LDR=30.	
IF (block= 'kirby23') LDR=75.	
IF (block= 'kirby24') LDR=60.	
IF (block= 'kirby25') LDR=80.	
IF (block= 'kirby26') LDR=25.	
IF (block= 'kirby27') LDR=55.	
IF (block= 'kirby01') DELAY=117.	
IF (block= 'kirby02') DELAY=61.	
IF (block= 'kirby03') DELAY=53.	
IF (block= 'kirby04') DELAY=7.	
IF (block= 'kirby05') DELAY=19.	
IF (block= 'kirby06') DELAY=160.	
IF (block= 'kirby07') DELAY=13.	
IF (block= 'kirby08') DELAY=14.	
IF (block= 'kirby09') DELAY=162.	
IF (block= 'kirby10') DELAY=62.	
IF (block= 'kirby11') DELAY=7.	
IF (block= 'kirby12') DELAY=119.	
IF (block= 'kirby13') DELAY=53.	
IF (block= 'kirby14') DELAY=21.	
IF (block= 'kirby15') DELAY=91.	
IF (block= 'kirby16') DELAY=89.	
IF (block= 'kirby17') DELAY=157.	
IF (block= 'kirby18') DELAY=29.	
IF (block= 'kirby19') DELAY=14.	
IF (block= 'kirby20') DELAY=179.	
IF (block= 'kirby21') DELAY=30.	
IF (block= 'kirby22') DELAY=80.	
IF (block= 'kirby23') DELAY=20.	
IF (block= 'kirby24') DELAY=111.	
IF (block= 'kirby25') DELAY=30.	
IF (block= 'kirby26') DELAY=136.	
IF (block= 'kirby27') DELAY=7.	
IF (block= 'kirby01') LDR_SIZE=2.	
IF (block= 'kirby02') LDR_SIZE=3.	
IF (block= 'kirby03') LDR_SIZE=1.	
IF (block= 'kirby04') LDR_SIZE=3.	
IF (block= 'kirby05') LDR_SIZE=1.	
IF (block= 'kirby06') LDR_SIZE=2.	
IF (block= 'kirby07') LDR_SIZE=1.	
IF (block= 'kirby08') LDR_SIZE=2.	
IF (block= 'kirby09') LDR_SIZE=3.	
IF (block= 'kirby10') LDR_SIZE=2.	
IF (block= 'kirby11') LDR_SIZE=1.	
IF (block= 'kirby12') LDR_SIZE=3.	
IF (block= 'kirby13') LDR_SIZE=1.	
IF (block= 'kirby14') LDR_SIZE=2.	
IF (block= 'kirby15') LDR_SIZE=3.	
IF (block= 'kirby16') LDR_SIZE=2.	
IF (block= 'kirby17') LDR_SIZE=3.	
IF (block= 'kirby18') LDR_SIZE=1.	
IF (block= 'kirby19') LDR_SIZE=3.	
IF (block= 'kirby20') LDR_SIZE=1.	
IF (block= 'kirby21') LDR_SIZE=2.	
IF (block= 'kirby22') LDR_SIZE=1.	
IF (block= 'kirby23') LDR_SIZE=3.	
IF (block= 'kirby24') LDR_SIZE=2.	
IF (block= 'kirby25') LDR_SIZE=3.	
IF (block= 'kirby26') LDR_SIZE=1.	
IF (block= 'kirby27') LDR_SIZE=2.	
IF (block= 'kirby01') K_ORDER=9.	
IF (block= 'kirby02') K_ORDER=5.	
IF (block= 'kirby03') K_ORDER=5.	
IF (block= 'kirby04') K_ORDER=1.	
IF (block= 'kirby05') K_ORDER=3.	
IF (block= 'kirby06') K_ORDER=8.	
IF (block= 'kirby07') K_ORDER=2.	
IF (block= 'kirby08') K_ORDER=2.	
IF (block= 'kirby09') K_ORDER=9.	
IF (block= 'kirby10') K_ORDER=5.	
IF (block= 'kirby11') K_ORDER=1.	
IF (block= 'kirby12') K_ORDER=7.	
IF (block= 'kirby13') K_ORDER=6.	
IF (block= 'kirby14') K_ORDER=3.	
IF (block= 'kirby15') K_ORDER=6.	
IF (block= 'kirby16') K_ORDER=6.	
IF (block= 'kirby17') K_ORDER=8.	
IF (block= 'kirby18') K_ORDER=4.	
IF (block= 'kirby19') K_ORDER=2.	
IF (block= 'kirby20') K_ORDER=9.	
IF (block= 'kirby21') K_ORDER=4.	
IF (block= 'kirby22') K_ORDER=7.	
IF (block= 'kirby23') K_ORDER=3.	
IF (block= 'kirby24') K_ORDER=7.	
IF (block= 'kirby25') K_ORDER=4.	
IF (block= 'kirby26') K_ORDER=8.	
IF (block= 'kirby27') K_ORDER=1.	

Compute Kind = ((LDR/SIR)-1)/DELAY.
Compute Choice = NUMBER (Result, F1.0).
Formats K_ORDER (F1.0) LDR_SIZE (F1.0) Choice(F1.0).

exe.

SAVE OUTFILE='C:\imagen_data\spss_data_files\KIRBY_complete.sav' /COMPRESSED.


** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\KIRBY_SUMMARY.sav'
  /DROP=SID attempt completed_timestamp processed_timestamp result attempt_complete trial block rsp rt valid valid_attempt first_complete_attempt first_complete_valid_attempt ever_valid SIR LDR DELAY KIND /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\KIRBY_SUMMARY.sav'.
execute.

** restructure.
SORT CASES BY id LDR_SIZE K_ORDER .
CASESTOVARS
 /ID = id 
 /INDEX = LDR_SIZE K_ORDER 
 /GROUPBY = VARIABLE .

Compute Con1.1 = (9 - Sum(Choice.1.1 to Choice.1.9))/9.
Compute Con1.2 = (Choice.1.1 + 8 - Sum(Choice.1.2 to Choice.1.9))/9.
Compute Con1.3 = (SUM(Choice.1.1 to Choice.1.2) + 7 - Sum(Choice.1.3 to Choice.1.9))/9.
Compute Con1.4 = (SUM(Choice.1.1 to Choice.1.3) + 6 - Sum(Choice.1.4 to Choice.1.9))/9.
Compute Con1.5 = (SUM(Choice.1.1 to Choice.1.4) + 5 - Sum(Choice.1.5 to Choice.1.9))/9.
Compute Con1.6 = (SUM(Choice.1.1 to Choice.1.5) + 4 - Sum(Choice.1.6 to Choice.1.9))/9.
Compute Con1.7 = (SUM(Choice.1.1 to Choice.1.6) + 3 - Sum(Choice.1.7 to Choice.1.9))/9.
Compute Con1.8 = (SUM(Choice.1.1 to Choice.1.7) + 2 - Sum(Choice.1.8 to Choice.1.9))/9.
Compute Con1.9 = (SUM(Choice.1.1 to Choice.1.8) + 1 - Choice.1.9)/9.
Compute Con1.10 = SUM(Choice.1.1 to Choice.1.9) /9.

Compute Con2.1 = (9 - Sum(Choice.2.1 to Choice.2.9))/9.
Compute Con2.2 = (Choice.2.1 + 8 - Sum(Choice.2.2 to Choice.2.9))/9.
Compute Con2.3 = (SUM(Choice.2.1 to Choice.2.2) + 7 - Sum(Choice.2.3 to Choice.2.9))/9.
Compute Con2.4 = (SUM(Choice.2.1 to Choice.2.3) + 6 - Sum(Choice.2.4 to Choice.2.9))/9.
Compute Con2.5 = (SUM(Choice.2.1 to Choice.2.4) + 5 - Sum(Choice.2.5 to Choice.2.9))/9.
Compute Con2.6 = (SUM(Choice.2.1 to Choice.2.5) + 4 - Sum(Choice.2.6 to Choice.2.9))/9.
Compute Con2.7 = (SUM(Choice.2.1 to Choice.2.6) + 3 - Sum(Choice.2.7 to Choice.2.9))/9.
Compute Con2.8 = (SUM(Choice.2.1 to Choice.2.7) + 2 - Sum(Choice.2.8 to Choice.2.9))/9.
Compute Con2.9 = (SUM(Choice.2.1 to Choice.2.8) + 1 - Choice.2.9)/9.
Compute Con2.10 = SUM(Choice.2.1 to Choice.2.9) /9.

Compute Con3.1 = (9 - Sum(Choice.3.1 to Choice.3.9))/9.
Compute Con3.2 = (Choice.3.1 + 8 - Sum(Choice.3.2 to Choice.3.9))/9.
Compute Con3.3 = (SUM(Choice.3.1 to Choice.3.2) + 7 - Sum(Choice.3.3 to Choice.3.9))/9.
Compute Con3.4 = (SUM(Choice.3.1 to Choice.3.3) + 6 - Sum(Choice.3.4 to Choice.3.9))/9.
Compute Con3.5 = (SUM(Choice.3.1 to Choice.3.4) + 5 - Sum(Choice.3.5 to Choice.3.9))/9.
Compute Con3.6 = (SUM(Choice.3.1 to Choice.3.5) + 4 - Sum(Choice.3.6 to Choice.3.9))/9.
Compute Con3.7 = (SUM(Choice.3.1 to Choice.3.6) + 3 - Sum(Choice.3.7 to Choice.3.9))/9.
Compute Con3.8 = (SUM(Choice.3.1 to Choice.3.7) + 2 - Sum(Choice.3.8 to Choice.3.9))/9.
Compute Con3.9 = (SUM(Choice.3.1 to Choice.3.8) + 1 - Choice.3.9)/9.
Compute Con3.10 = SUM(Choice.3.1 to Choice.3.9) /9.

Compute MaxCon1 = Max(Con1.1 to Con1.10).
Compute MaxCon2 = Max(Con2.1 to Con2.10).
Compute MaxCon3 = Max(Con3.1 to Con3.10).

If (Maxcon1=Con1.1) ln.k1.1 = -1.39938.	
If (Maxcon1=Con1.2) ln.k1.2 = -1.83834.	
If (Maxcon1=Con1.3) ln.k1.3 = -2.7315.	
If (Maxcon1=Con1.4) ln.k1.4 = -3.66671.	
If (Maxcon1=Con1.5) ln.k1.5 = -4.63522.	
If (Maxcon1=Con1.6) ln.k1.6 = -5.12268.	
If (Maxcon1=Con1.7) ln.k1.7 = -5.55707.	
If (Maxcon1=Con1.8) ln.k1.8 = -6.44961.	
If (Maxcon1=Con1.9) ln.k1.9 = -7.3659.	
If (Maxcon1=Con1.10) ln.k1.10 = -7.82405.	
If (Maxcon2=Con2.1) ln.k2.1 = -1.38629.	
If (Maxcon2=Con2.2) ln.k2.2 = -1.84444.	
If (Maxcon2=Con2.3) ln.k2.3 = -2.75378.	
If (Maxcon2=Con2.4) ln.k2.4 = -3.67985.	
If (Maxcon2=Con2.5) ln.k2.5 = -4.63121.	
If (Maxcon2=Con2.6) ln.k2.6 = -5.5456.	
If (Maxcon2=Con2.7) ln.k2.7 = -6.44563.	
If (Maxcon2=Con2.8) ln.k2.8 = -7.3659.	
If (Maxcon2=Con2.9) ln.k2.9 = -8.28219.	
If (Maxcon2=Con2.10) ln.k2.10 = -8.74034.	
If (Maxcon3=Con3.1) ln.k3.1 = -1.3909.	
If (Maxcon3=Con3.2) ln.k3.2 = -1.83817.	
If (Maxcon3=Con3.3) ln.k3.3 = -2.73423.	
If (Maxcon3=Con3.4) ln.k3.4 = -3.65754.	
If (Maxcon3=Con3.5) ln.k3.5 = -4.62737.	
If (Maxcon3=Con3.6) ln.k3.6 = -5.54717.	
If (Maxcon3=Con3.7) ln.k3.7 = -6.43971.	
If (Maxcon3=Con3.8) ln.k3.8 = -7.3659.	
If (Maxcon3=Con3.9) ln.k3.9 = -8.28219.	
If (Maxcon3=Con3.10) ln.k3.10 = -8.74034.	

Compute Kest1 = EXP(MEAN(ln.k1.1 to ln.k1.10)).
Compute Kest2 = EXP(MEAN(ln.k2.1 to ln.k2.10)).
Compute Kest3 = EXP(MEAN(ln.k3.1 to ln.k3.10)).
EXE.

Formats Kest1 to Kest3 (F6.5).
Variable Labels Kest1 'Estimated K for small LDRs' Kest2 'Esitmated K for Medium LDRs' Kest3 'Estimated K for Large LDRs'.


** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\KIRBY_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\KIRBY_summary.sav'
 /KEEP ID Locale Maxcon1 Maxcon2 Maxcon3 Kest1 Kest2 kest3
 /COMPRESSED.
