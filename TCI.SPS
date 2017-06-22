DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_TCI_CHILD_RC5-IMAGEN_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2) Valid(A1).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	IF (valid='t') Valid_attempt = Attempt.
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) / First_complete_valid_attempt = MIN(valid_attempt) / ever_valid = max(valid).
	SELECT IF(Attempt = First_complete_attempt & (Valid = 't' OR ever_valid = 'f') OR (Attempt = first_complete_valid_attempt)) .

SAVE OUTFILE='C:\temp\child.sav'/Compressed /DROP=valid to ever_valid.
DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_TCI_PARENT_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A16) Rsp(A13) RT (F5.2).
	** DROP INVALID AND INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /First_complete_attempt= FIRST(Attempt) .
	SELECT IF(Attempt = First_complete_attempt).

ADD FILES /FILE=*
 /FILE='C:\Temp\child.sav'.
EXECUTE.


** drop the id_checks - these should be dealt with as a whole in a different script.
USE ALL.
SELECT IF(SUBSTR(block,1,3) = "tci" &  substr(SID, 1,4) <> "TEST").


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

** INVSERIONS DEALT WITH IN TASK CODING.

** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\TCI_complete.sav'
  /DROP= SID attempt locale completed_timestamp processed_timestamp attempt_complete trial result rsp rt first_complete_attempt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\TCI_complete.sav'.
execute.

** restructure.
SORT CASES BY id PorC  block .
CASESTOVARS
 /ID = id 
 /INDEX = PorC block 
 /GROUPBY = VARIABLE .


* compute the summary vars.
compute C.tci_excit=sum(C.tci001, C.tci063, C.tci053, C.tci104, C.tci122, C.tci145, C.tci156, C.tci165, C.tci176, C.tci205).
compute C.tci_imp=sum(C.tci010, C.tci047, C.tci071, C.tci102, C.tci123, C.tci179, C.tci193, C.tci210, C.tci239).
compute C.tci_extra=sum(C.tci014, C.tci024, C.tci059, C.tci105, C.tci139, C.tci155, C.tci172, C.tci215, C.tci222).
compute C.tci_diso=sum ( C.tci044, C.tci051, C.tci077, C.tci109, C.tci135, C.tci159, C.tci170).
compute C.tci_novseek=sum(C.tci_excit to C.tci_diso) .

compute P.tci_excit=sum(P.tci001, P.tci063, P.tci053, P.tci104, P.tci122, P.tci145, P.tci156, P.tci165, P.tci176, P.tci205).
compute P.tci_imp=sum(P.tci010, P.tci047, P.tci071, P.tci102, P.tci123, P.tci179, P.tci193, P.tci210, P.tci239).
compute P.tci_extra=sum(P.tci014, P.tci024, P.tci059, P.tci105, P.tci139, P.tci155, P.tci172, P.tci215, P.tci222).
compute P.tci_diso=sum ( P.tci044, P.tci051, P.tci077, P.tci109, P.tci135, P.tci159, P.tci170).
compute P.tci_novseek=sum(P.tci_excit to P.tci_diso) .
execute.

Variable labels ID 'Subject ID'.
VARIABLE LABELS C.Locale 'Child Locale' P.Locale 'Parent Locale'.

VALUE LABELS C.tci001 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci010 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci014 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci024 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci044 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci047 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci051 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci059 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci063 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci071 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci077 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci053 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci102 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci104 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci105 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci109 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci122 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci123 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci135 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci139 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci145 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci155 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci156 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci159 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci165 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci170 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci172 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci176 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci179 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci193 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci205 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci210 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS C.tci215 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci222 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS C.tci239 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci001 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci010 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci014 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci024 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci044 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci047 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci051 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci059 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci063 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci071 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci077 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci053 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci102 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci104 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci105 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci109 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci122 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci123 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci135 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci139 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci145 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci155 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci156 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci159 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci165 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci170 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci172 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci176 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci179 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci193 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci205 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci210 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VALUE LABELS P.tci215 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci222 1 'definitely false' 2 'mostly false' 3 'neither true or false' 4 'mostly true' 5 'definitely true' .	
VALUE LABELS P.tci239 5 'definitely false' 4 'mostly false' 3 'neither true or false' 2 'mostly true' 1 'definitely true' .	
VARIABLE LABELS C.tci001 'I often try new things just for fun or thrills, even if most people think it is a waste of time.'.	
VARIABLE LABELS C.tci010 'I often do things based on how I feel at the moment without thinking about how they were done in the past.'.	
VARIABLE LABELS C.tci014 'I am much more reserved and controlled than most people.'.	
VARIABLE LABELS C.tci024 'I often spend money until I run out of cash or get into debt from using too much credit.'.	
VARIABLE LABELS C.tci044 'I like it when people can do whatever they want without strict rules and regulations.'.	
VARIABLE LABELS C.tci047 'I usually think about all the facts in detail before I make a decision.'.	
VARIABLE LABELS C.tci051 'I am usually able to get other people to believe me, even when I know that what I am saying is exaggerated or untrue.'.	
VARIABLE LABELS C.tci059 'I prefer spending money rather than saving it.'.	
VARIABLE LABELS C.tci063 'I usually demand very good practical reasons before I am willing to change my old ways of doing things.'.	
VARIABLE LABELS C.tci071 'I often follow my instincts, hunches, or intuition without thinking through all the details.'.	
VARIABLE LABELS C.tci077 'Even when most people feel it is not important, I often insist on things being done in a strict and orderly way.'.	
VARIABLE LABELS C.tci053 'I have a reputation as someone who is very practical and does not act on emotion.'.	
VARIABLE LABELS C.tci102 'I like to make quick decisions so I can get on with what has to be done.'.	
VARIABLE LABELS C.tci104 'I like to explore new ways to do things.'.	
VARIABLE LABELS C.tci105 'I enjoy saving money more than spending it on entertainment or thrills.'.	
VARIABLE LABELS C.tci109 'I often break rules and regulations when I think I can get away with it.'.	
VARIABLE LABELS C.tci122 'When nothing new is happening, I usually start looking for something that is thrilling or exciting.'.	
VARIABLE LABELS C.tci123 'I like to think about things for a long time before I make a decision.'.	
VARIABLE LABELS C.tci135 'I can usually do a good job of stretching the truth to tell a funnier story or to play a joke on someone.'.	
VARIABLE LABELS C.tci139 'I am better at saving money than most people.'.	
VARIABLE LABELS C.tci145 'I am slower than most people to get excited about new ideas and activities.'.	
VARIABLE LABELS C.tci155 'Some people think I am too stingy or tight with my money.'.	
VARIABLE LABELS C.tci156 'I like old "tried and true" ways of doing things much better than trying "new and improved" ways.'.	
VARIABLE LABELS C.tci159 'I am not very good at talking my way out of trouble when I am caught doing something wrong.'.	
VARIABLE LABELS C.tci165 'In conversations I am much better as a listener than as a talker.'.	
VARIABLE LABELS C.tci170 'I have some trouble telling a lie, even when it is meant to spare someone elses feelings.'.	
VARIABLE LABELS C.tci172 'It is hard for me to enjoy spending money on myself, even when I have saved plenty of money.'.	
VARIABLE LABELS C.tci176 'I like to stay at home better than to travel or explore new places.'.	
VARIABLE LABELS C.tci179 'I like to read everything when I am asked to sign any papers.'.	
VARIABLE LABELS C.tci193 'I hate to make decisions based only on my first impressions.'.	
VARIABLE LABELS C.tci205 'I hate to change the way I do things, even if many people tell me there is a new and better way to do it.'.	
VARIABLE LABELS C.tci210 'I like to pay close attention to details in everything I do.'.	
VARIABLE LABELS C.tci215 'Because I so often spend too much money on impulse, it is hard for me to save money - even for special plans like a vacation.'.	
VARIABLE LABELS C.tci222 'It is fun for me to buy things for myself.'.	
VARIABLE LABELS C.tci239 'I nearly always think about all the facts in detail before I make a decision, even when other people demand a quick decision.'.	
VARIABLE LABELS P.tci001 'I often try new things just for fun or thrills, even if most people think it is a waste of time.'.	
VARIABLE LABELS P.tci010 'I often do things based on how I feel at the moment without thinking about how they were done in the past.'.	
VARIABLE LABELS P.tci014 'I am much more reserved and controlled than most people.'.	
VARIABLE LABELS P.tci024 'I often spend money until I run out of cash or get into debt from using too much credit.'.	
VARIABLE LABELS P.tci044 'I like it when people can do whatever they want without strict rules and regulations.'.	
VARIABLE LABELS P.tci047 'I usually think about all the facts in detail before I make a decision.'.	
VARIABLE LABELS P.tci051 'I am usually able to get other people to believe me, even when I know that what I am saying is exaggerated or untrue.'.	
VARIABLE LABELS P.tci059 'I prefer spending money rather than saving it.'.	
VARIABLE LABELS P.tci063 'I usually demand very good practical reasons before I am willing to change my old ways of doing things.'.	
VARIABLE LABELS P.tci071 'I often follow my instincts, hunches, or intuition without thinking through all the details.'.	
VARIABLE LABELS P.tci077 'Even when most people feel it is not important, I often insist on things being done in a strict and orderly way.'.	
VARIABLE LABELS P.tci053 'I have a reputation as someone who is very practical and does not act on emotion.'.	
VARIABLE LABELS P.tci102 'I like to make quick decisions so I can get on with what has to be done.'.	
VARIABLE LABELS P.tci104 'I like to explore new ways to do things.'.	
VARIABLE LABELS P.tci105 'I enjoy saving money more than spending it on entertainment or thrills.'.	
VARIABLE LABELS P.tci109 'I often break rules and regulations when I think I can get away with it.'.	
VARIABLE LABELS P.tci122 'When nothing new is happening, I usually start looking for something that is thrilling or exciting.'.	
VARIABLE LABELS P.tci123 'I like to think about things for a long time before I make a decision.'.	
VARIABLE LABELS P.tci135 'I can usually do a good job of stretching the truth to tell a funnier story or to play a joke on someone.'.	
VARIABLE LABELS P.tci139 'I am better at saving money than most people.'.	
VARIABLE LABELS P.tci145 'I am slower than most people to get excited about new ideas and activities.'.	
VARIABLE LABELS P.tci155 'Some people think I am too stingy or tight with my money.'.	
VARIABLE LABELS P.tci156 'I like old "tried and true" ways of doing things much better than trying "new and improved" ways.'.	
VARIABLE LABELS P.tci159 'I am not very good at talking my way out of trouble when I am caught doing something wrong.'.	
VARIABLE LABELS P.tci165 'In conversations I am much better as a listener than as a talker.'.	
VARIABLE LABELS P.tci170 'I have some trouble telling a lie, even when it is meant to spare someone elses feelings.'.	
VARIABLE LABELS P.tci172 'It is hard for me to enjoy spending money on myself, even when I have saved plenty of money.'.	
VARIABLE LABELS P.tci176 'I like to stay at home better than to travel or explore new places.'.	
VARIABLE LABELS P.tci179 'I like to read everything when I am asked to sign any papers.'.	
VARIABLE LABELS P.tci193 'I hate to make decisions based only on my first impressions.'.	
VARIABLE LABELS P.tci205 'I hate to change the way I do things, even if many people tell me there is a new and better way to do it.'.	
VARIABLE LABELS P.tci210 'I like to pay close attention to details in everything I do.'.	
VARIABLE LABELS P.tci215 'Because I so often spend too much money on impulse, it is hard for me to save money - even for special plans like a vacation.'.	
VARIABLE LABELS P.tci222 'It is fun for me to buy things for myself.'.	
VARIABLE LABELS P.tci239 'I nearly always think about all the facts in detail before I make a decision, even when other people demand a quick decision.'.	


** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\TCI_complete.sav'
 /COMPRESSED.

** and the summary file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\TCI_summary.sav'
 /DROP C.tci001 to P.tci239
 /COMPRESSED.
