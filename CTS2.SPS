GET DATA  /TYPE = TXT
 /FILE = "C:\imagen_data\csv_data_files\IMAGEN-IMGN_CTS_PARENT_RC5-BASIC_DIGEST.csv"
 /DELCASE = LINE
 /DELIMITERS = ",_"
 /ARRANGEMENT = DELIMITED
 /FIRSTCASE = 2
 /IMPORTCASE = ALL
 /VARIABLES =
 ID A12
 Attempt F1.0
 Locale A2
 Attempt_Complete A1
 Completed_timestamp A16
 Processed_timestamp A16
 page A15
 Q F2.0
 Response F1.0
 Score F1.0
 .
CACHE.
EXECUTE.

	** DROP INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=ID 	 /last_complete_attempt= LAST(Attempt) .
	SELECT IF(Attempt = last_complete_attempt).


** get rid of test subjects.
SELECT IF(substr(ID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(ID, 2, 1) = "1" OR substr(ID, 2, 1) = "2" OR substr(ID, 2, 1) = "3") locale = "en".
if (substr(ID, 2, 1) = "4" OR substr(ID, 2, 1) = "5" OR substr(ID, 2, 1) = "6" OR substr(ID, 2, 1) = "8") locale = "de".
if (substr(ID, 2, 1) = "7") locale = "fr".
End If.

** IDs already imported at 12 characters.
** no  inversions.

** Recode the scores to represent the midpoints of the response category ( see Strauss 96) response 7 ( not in past year ) remiains as 0 but you could alter this to give you a lifetime measure of some items.
If (Response = 3) Score = 4.
If (Response = 4) Score = 8.
If (Response = 5) Score = 15.
If (Response = 6) Score = 25.


** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\CTS_complete.sav'
  /DROP= attempt attempt_complete completed_timestamp processed_timestamp page last_complete_attempt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\CTS_complete.sav'.
execute.

** restructure.
SORT CASES BY id Q .
CASESTOVARS
 /ID = id 
 /INDEX = Q
 /GROUPBY = VARIABLE .


* compute the summary vars.
compute ccamyp= mean(score.8, score.10, score.18, score.46, score.54) .
compute ccamys= mean(score.7, score.9, score.17, score.45, score.53) .
compute ccasyp= mean(score.22, score.28, score.34, score.38, score.44, score.62, score.74) .
compute ccasys= mean(score.21, score.27, score.33, score.37, score.43, score.61, score.73) .
compute ccimyp= mean(score.12, score.72) .
compute ccimys= mean(score.11, score.71) .
compute ccisyp= mean(score.24, score.32, score.42, score.56) .
compute ccisys= mean(score.23, score.31, score.41, score.55) .
compute ccncyp= mean(score.4, score.60, score.78) .
compute ccncys= mean(score.3, score.59, score.77) .
compute ccneyp= mean(score.2, score.14, score.40) .
compute ccneys= mean(score.1, score.13, score.39) .
compute ccpmyp= mean(score.6, score.36, score.50, score.68) .
compute ccpmys= mean(score.5, score.35, score.49, score.67) .
compute ccpsyp= mean(score.26, score.30, score.66, score.70) .
compute ccpsys= mean(score.25, score.29, score.65, score.69) .
compute ccsmyp= mean(score.16, score.52, score.64) .
compute ccsmys= mean(score.15, score.51, score.63) .
compute ccssyp= mean(score.20, score.48, score.58, score.76) .
compute ccssys= mean(score.19, score.47, score.67, score.75) .
compute cts_assault = mean(ccamyp to ccasys).
compute cts_injury = mean(ccimyp to ccisys).
compute cts_negotiation= mean(ccncyp to ccneys).
compute cts_psychological_aggression = mean(ccpmyp to ccpsys).
compute cts_sexual_coercion = mean(ccsmyp to ccssys).

EXECUTE.


* Add the labels.
VARIABLE LABELS ID 'Subject ID' Locale ' Locale of test'.
VARIABLE LABELS Response.1 'I showed my partner I cared even though we disagreed.'.
VARIABLE LABELS Response.2 'My partner showed care for me even though we disagreed.'.
VARIABLE LABELS Response.3 'I explained my side of a disagreement to my partner.'.
VARIABLE LABELS Response.4 'My partner explained his or her side of a disagreement to me.'.
VARIABLE LABELS Response.5 'I insulted or swore at my partner.'.
VARIABLE LABELS Response.6 'My partner did this to me.'.
VARIABLE LABELS Response.7 'I threw something at my partner that could hurt.'.
VARIABLE LABELS Response.8 'My partner did this to me.'.
VARIABLE LABELS Response.9 'I twisted my partners arm or hair.'.
VARIABLE LABELS Response.10 'My partner did this to me.'.
VARIABLE LABELS Response.11 'I had a sprain, bruise, or small cut because of a fight with my partner.'.
VARIABLE LABELS Response.12 'My partner had a sprain, bruise, or small cut because of a fight with me.'.
VARIABLE LABELS Response.13 'I showed respect for my partners feelings about an issue.'.
VARIABLE LABELS Response.14 'My partner showed respect for my feelings about an issue.'.
VARIABLE LABELS Response.15 'I made my partner have sex without a condom.'.
VARIABLE LABELS Response.16 'My partner did this to me.'.
VARIABLE LABELS Response.17 'I pushed or shoved my partner.'.
VARIABLE LABELS Response.18 'My partner did this to me.'.
VARIABLE LABELS Response.19 'I used force (like hitting, holding down, or using a weapon) to make my partner have oral or anal sex.'.
VARIABLE LABELS Response.20 'My partner did this to me.'.
VARIABLE LABELS Response.21 'I used a knife or gun on my partner.'.
VARIABLE LABELS Response.22 'My partner did this to me.'.
VARIABLE LABELS Response.23 'I passed out from being hit on the head by my partner in a fight.'.
VARIABLE LABELS Response.24 'My partner passed out from beiig hit on the head in a fight with me.'.
VARIABLE LABELS Response.25 'I called my partner fat or ugly.'.
VARIABLE LABELS Response.26 'My partner called me fat or ugly.'.
VARIABLE LABELS Response.27 'I punched or hit my partner with something that could hurt.'.
VARIABLE LABELS Response.28 'My partner did this to me.'.
VARIABLE LABELS Response.29 'I destroyed something belonging to my partner.'.
VARIABLE LABELS Response.30 'My partner did this to me.'.
VARIABLE LABELS Response.31 'I went to a doctor because of a fight with my partner.'.
VARIABLE LABELS Response.32 'My partner went to a doctor because of a fight with me.'.
VARIABLE LABELS Response.33 'I choked my partner.'.
VARIABLE LABELS Response.34 'My partner did this to me.'.
VARIABLE LABELS Response.35 'I shouted or yelled at my partner.'.
VARIABLE LABELS Response.36 'My partner did this to me.'.
VARIABLE LABELS Response.37 'I slammed my partner against a wall.'.
VARIABLE LABELS Response.38 'My partner did this to me.'.
VARIABLE LABELS Response.39 'I said I was sure we could work out a problem.'.
VARIABLE LABELS Response.40 'My partner was sure we could work it out.'.
VARIABLE LABELS Response.41 'I needed to see a doctor because of a fight with my partner, but I didnt.'.
VARIABLE LABELS Response.42 'My partner needed to see a doctor because of a fight with me, but didnt.'.
VARIABLE LABELS Response.43 'I beat up my partner.'.
VARIABLE LABELS Response.44 'My partner did this to me.'.
VARIABLE LABELS Response.45 'I grabbed my partner.'.
VARIABLE LABELS Response.46 'My partner did this to me.'.
VARIABLE LABELS Response.47 'I used force (like hitting, holding down, or using a weapon) to make my partner have sex.'.
VARIABLE LABELS Response.48 'My partner did this to me.'.
VARIABLE LABELS Response.49 'I stomped out of the room or house or yard during a disagreement.'.
VARIABLE LABELS Response.50 'My partner did this to me.'.
VARIABLE LABELS Response.51 'I insisted on sex when my partner did not want to (but did not use physical force).'.
VARIABLE LABELS Response.52 'My partner did this to me.'.
VARIABLE LABELS Response.53 'I slapped my partner.'.
VARIABLE LABELS Response.54 'My partner did this to me.'.
VARIABLE LABELS Response.55 'I had a broken bone from a fight with my partner.'.
VARIABLE LABELS Response.56 'My partner had a broken bone from a fight with me.'.
VARIABLE LABELS Response.57 'I used threats to make my partner have oral or anal sex.'.
VARIABLE LABELS Response.58 'My partner did this to me.'.
VARIABLE LABELS Response.59 'I suggested a compromise to a disagreement.'.
VARIABLE LABELS Response.60 'My partner did this to me.'.
VARIABLE LABELS Response.61 'I burned or scalded my partner on purpose.'.
VARIABLE LABELS Response.62 'My partner did this to me.'.
VARIABLE LABELS Response.63 'I insisted my partner have oral or anal sex (but did not use physical force).'.
VARIABLE LABELS Response.64 'My partner did this to me.'.
VARIABLE LABELS Response.65 'I accused my partner of being a lousy lover.'.
VARIABLE LABELS Response.66 'My partner accused me of this.'.
VARIABLE LABELS Response.67 'I did something to spite my partner.'.
VARIABLE LABELS Response.68 'My partner did this to me.'.
VARIABLE LABELS Response.69 'I threatened to hit or throw something at my partner.'.
VARIABLE LABELS Response.70 'My partner did this to me.'.
VARIABLE LABELS Response.71 'I felt physical pain that still hurt the next day because of a fight with my partner.'.
VARIABLE LABELS Response.72 'My partner still felt physical pain the next day because of a fight we had.'.
VARIABLE LABELS Response.73 'I kicked my partner.'.
VARIABLE LABELS Response.74 'My partner did this to me.'.
VARIABLE LABELS Response.75 'I used threats to make my partner have sex.'.
VARIABLE LABELS Response.76 'My partner did this to me.'.
VARIABLE LABELS Response.77 'I agreed to try a solution to a disagreement my partner suggested.'.
VARIABLE LABELS Response.78 'My partner agreed to try a solution I suggested.'.
VALUE LABELS Response.1 to response.78 0 'This has never happened' 1 'Once in the past year' 2 'Twice in the past year' 3 '3-5 times in the past year' 4 '6-10 times in the past year' 5 '11-20 times in the past year' 6 'More than 20 times in the past year' 7 'Not in the past year but this has happened before' .

** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\CTS_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\CTS_summary.sav'
 /DROP response.1 to score.78
 /COMPRESSED.

