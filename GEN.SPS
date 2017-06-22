DATA LIST LIST (",") FILE="C:\imagen_data\csv_data_files\IMAGEN-IMGN_GEN_RC5-BASIC_DIGEST.csv"  SKIP=1 /  SID(A14) Attempt(F1.0)  Locale(A2) Attempt_Complete(A1) Completed_timestamp(A23) Processed_timestamp(A23) Block(A25) Trial(A15) Result(A6) Rsp(A13) RT (F5.2).

	** DROP INCOMPLETE ATTEMPTS and select first real one.
	SELECT IF(Attempt_Complete = "t" ).
	AGGREGATE 	 /OUTFILE=* 	 MODE=ADDVARIABLES 	 OVERWRITEVARS=YES	 /BREAK=SID 	 /last_complete_attempt= LAST(Attempt) .
	SELECT IF(Attempt = last_complete_attempt).

** drop the id_checks - these should be dealt with as a whole in a different script.
** Drop the relation results that just mark whether the task is to show another relation and the result that indicates if the Psych history seciton is to be filled in.
SELECT IF(SUBSTR(trial,1,9) <> "relation_" & RESULT <> '' & substr(SID, 1,4) <> "TEST").

** make a best guess for missing locale info (Old version of Psytools installer used - not from delosis website).
do if locale = ''.
if (substr(SID, 2, 1) = "1" OR substr(SID, 2, 1) = "2" OR substr(SID, 2, 1) = "3") locale = "en".
if (substr(SID, 2, 1) = "4" OR substr(SID, 2, 1) = "5" OR substr(SID, 2, 1) = "6" OR substr(SID, 2, 1) = "8") locale = "de".
if (substr(SID, 2, 1) = "7") locale = "fr".
End If.

String RelTemp(A10).
If (trial='relation') RelTemp = Result.
Do If (trial='sure').
  Compute certTemp = 0.
  If (result='SURE') certTemp = 1.
END IF.
Formats certtemp (F1.0).

AGGREGATE  /OUTFILE=*   MODE=ADDVARIABLES /BREAK=SID Block / Relation = FIRST(RelTemp) / Certain = FIRST(certTEMP) .

If (trial="break_q") trial = "Psych_History".
Select If (trial <> "relation" & trial <> "sure").


**Create an ID code variable.
String ID(A12).
Compute ID = substr(SID, 1, 12).

** no inversions.
** drop unneccesary vars.
SAVE OUTFILE='C:\imagen_data\spss_data_files\GEN_complete.sav'
  /DROP=SID attempt completed_timestamp processed_timestamp attempt_complete reltemp certtemp block Rsp RT last_complete_attempt /COMPRESSED.
GET
  FILE='C:\imagen_data\spss_data_files\GEN_complete.sav'.
execute.


**split file into Relation and other section and transpose seperately then rejoin.
select IF (trial="disorder" & NOT sysmis(certain) & relation <> '') .
String Disorder (A6).
Compute Disorder = Result.
Match Files /File=* /DROP Result .

* Identify relatiosn with multiple diagnoses.
SORT CASES BY ID(A) Relation(A) .
MATCH FILES /FILE = * /BY ID Relation
 /FIRST = PrimaryFirst /LAST = PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE RNum = 1 - PrimaryLast.
ELSE.
COMPUTE RNum = RNum + 1.
END IF.
LEAVE RNum.
FORMAT RNum (f7).
MATCH FILES /FILE = * /DROP = PrimaryFirst PrimaryLast.

Compute RNUM = RNUM +1.
CASESTOVARS
 /ID = id 
 /INDEX = relation Rnum
 /GROUPBY = VARIABLE .

SAVE OUTFILE='C:\temp\GEN_disorders.sav' /DROP=Trial .
GET FILE='C:\imagen_data\spss_data_files\GEN_complete.sav'.
MATCH FILES /FILE = * /DROP = Relation Certain.
select IF (trial<>"disorder") .

** restructure.
CASESTOVARS
 /ID = id 
 /INDEX = trial 
 /GROUPBY = VARIABLE .
MATCH FILES /FILE=* /FILE='c:\temp\GEN_disorders.sav' /BY ID.

EXECUTE.

Variable labels ID 'Subject ID' Psych_history 'Do you know about any mental health problems in first or second degree relatives of the adolesescent?'.
VALUE LABELS Disorder.PF.1 to Disorder.SMCM.1 'PM' 'Father'  'PF' 'Mother'  'SM' 'Brother'  'SF' 'Sister'  'PFPM' 'Grandfather (maternal)'  'PFPF' 'Grandmother (maternal)'  'PMPM' 'Grandfather (paternal)'  'PMPF' 'Grandmother (paternal)'  'PFSM' 'Uncle (maternal)'  'PFSF' 'Aunt (maternal)'  'PMSM' 'Uncle (paternal)'  'PMSF' 'Aunt (paternal)'  'PFCF' 'Halfsister (maternal)'  'PFCM' 'Halfbrother (maternal)'  'PMCF' 'Halfsister (paternal)'  'PMCM' 'Halfbrother (paternal)'  'SMCM' 'Nephew (brothers son)'  'SMCF' 'Niece (brothers daughter)'  'SFCM' 'Nephew (sisters son)'  'SFCF' 'Niece (sisters daughter)'  'SCZ' 'Schizophrenia'  'SCZAD' 'Schizoaffective Disorder'  'DPR_R' 'Major Depression recurrent'  'DPR_SE' 'Major Depression single episode'  'BIP_I' 'Bipolar I Disorder'  'BIP_II' 'Bipolar II Disorder'  'OCD' 'Obessive-compulsive Disorder'  'ANX' 'Anxiety Disorder'  'EAT' 'Eating Disorder'  'ALC' 'Alcohol problems'  'DRUG' 'Drug problems'  'SUIC' 'Suicide  / Suicidal Attempt'  'OTHER' 'Other' .
Value Labels PF_country PFPF_country PFPM_country PM_country PMPF_country PMPM_country  'AD' 'Andorra'  'AE' 'United Arab Emirates'  'AF' 'Afghanistan'  'AG' 'Antigua and Barbuda'  'AI' 'Anguilla'  'AL' 'Albania'  'AM' 'Armenia'  'AN' 'Netherlands Antilles'  'AO' 'Angola'  'AQ' 'Antarctica'  'AR' 'Argentina'  'AS' 'American Samoa'  'AT' 'Austria'  'AU' 'Australia'  'AW' 'Aruba'  'AZ' 'Azerbaijan'  'BA' 'Bosnia and Herzegovina'  'BB' 'Barbados'  'BD' 'Bangladesh'  'BE' 'Belgium'  'BF' 'Burkina Faso'  'BG' 'Bulgaria'  'BH' 'Bahrain'  'BI' 'Burundi'  'BJ' 'Benin'  'BM' 'Bermuda'  'BN' 'Brunei Darussalam'  'BO' 'Bolivia'  'BR' 'Brazil'  'BS' 'Bahamas'  'BT' 'Bhutan'  'BV' 'Bouvet Island'  'BW' 'Botswana'  'BY' 'Belarus'  'BZ' 'Belize'  'CA' 'Canada'  'CC' 'Cocos (Keeling) Islands'  'CD' 'Congo, the Democratic Republic of the'  'CF' 'Central African Republic'  'CG' 'Congo'  'CH' 'Switzerland'  'CI' 'Côte dIvoire'  'CK' 'Cook Islands'  'CL' 'Chile'  'CM' 'Cameroon'  'CN' 'China'  'CO' 'Colombia'  'CR' 'Costa Rica'  'CU' 'Cuba'  'CV' 'Cape Verde'  'CX' 'Christmas Island'  'CY' 'Cyprus'  'CZ' 'Czech Republic'  'DE' 'Germany'  'DJ' 'Djibouti'  'DK' 'Denmark'  'DM' 'Dominica'  'DO' 'Dominican Republic'  'DZ' 'Algeria'  'EC' 'Ecuador'  'EE' 'Estonia'  'EG' 'Egypt'  'EH' 'Western Sahara'  'ER' 'Eritrea'  'ES' 'Spain'  'ET' 'Ethiopia'  'FI' 'Finland'  'FJ' 'Fiji'  'FK' 'Falkland Islands (Malvinas)'  'FM' 'Micronesia, Federated States of'  'FO' 'Faroe Islands'  'FR' 'France'  'GA' 'Gabon'  'GB' 'United Kingdom'  'GD' 'Grenada'  'GE' 'Georgia'  'GF' 'French Guiana'  'GH' 'Ghana'  'GI' 'Gibraltar'  'GL' 'Greenland'  'GM' 'Gambia'  'GN' 'Guinea'  'GP' 'Guadeloupe'  'GQ' 'Equatorial Guinea'  'GR' 'Greece'  'GS' 'South Georgia and the South Sandwich Islands'  'GT' 'Guatemala'  'GU' 'Guam'  'GW' 'Guinea-Bissau'  'GY' 'Guyana'  'HK' 'Hong Kong'  'HM' 'Heard Island and McDonald Islands'  'HN' 'Honduras'  'HR' 'Croatia'  'HT' 'Haiti'  'HU' 'Hungary'  'ID' 'Indonesia'  'IE' 'Ireland'  'IL' 'Israel'  'IN' 'India'  'IO' 'British Indian Ocean Territory'  'IQ' 'Iraq'  'IR' 'Iran, Islamic Republic of'  'IS' 'Iceland'  'IT' 'Italy'  'JM' 'Jamaica'  'JO' 'Jordan'  'JP' 'Japan'  'KE' 'Kenya'  'KG' 'Kyrgyzstan'  'KH' 'Cambodia'  'KI' 'Kiribati'  'KM' 'Comoros'  'KN' 'Saint Kitts and Nevis'  'KP' 'Korea, Democratic Peoples Republic of'  'KR' 'Korea, Republic of'  'KW' 'Kuwait'  'KY' 'Cayman Islands'  'KZ' 'Kazakhstan'  'LA' 'Lao Peoples Democratic Republic'  'LB' 'Lebanon'  'LC' 'Saint Lucia'  'LI' 'Liechtenstein'  'LK' 'Sri Lanka'  'LR' 'Liberia'  'LS' 'Lesotho'  'LT' 'Lithuania'  'LU' 'Luxembourg'  'LV' 'Latvia'  'LY' 'Libyan Arab Jamahiriya'  'MA' 'Morocco'  'MC' 'Monaco'  'MD' 'Moldova, Republic of'  'ME' 'Montenegro'  'MG' 'Madagascar'  'MH' 'Marshall Islands'  'MK' 'Macedonia, the former Yugoslav Republic of'  'ML' 'Mali'  'MM' 'Myanmar'  'MN' 'Mongolia'  'MO' 'Macao'  'MP' 'Northern Mariana Islands'  'MQ' 'Martinique'  'MR' 'Mauritania'  'MS' 'Montserrat'  'MT' 'Malta'  'MU' 'Mauritius'  'MV' 'Maldives'  'MW' 'Malawi'  'MX' 'Mexico'  'MY' 'Malaysia'  'MZ' 'Mozambique'  'NA' 'Namibia'  'NC' 'New Caledonia'  'NE' 'Niger'  'NF' 'Norfolk Island'  'NG' 'Nigeria'  'NI' 'Nicaragua'  'NL' 'Netherlands'  'NO' 'Norway'  'NP' 'Nepal'  'NR' 'Nauru'  'NU' 'Niue'  'NZ' 'New Zealand'  'OM' 'Oman'  'PA' 'Panama'  'PE' 'Peru'  'PF' 'French Polynesia'  'PG' 'Papua New Guinea'  'PH' 'Philippines'  'PK' 'Pakistan'  'PL' 'Poland'  'PM' 'Saint Pierre and Miquelon'  'PN' 'Pitcairn'  'PR' 'Puerto Rico'  'PS' 'Palestinian Territory, Occupied'  'PT' 'Portugal'  'PW' 'Palau'  'PY' 'Paraguay'  'QA' 'Qatar'  'RE' 'Réunion'  'RO' 'Romania'  'RS' 'Serbia'  'RU' 'Russian Federation'  'RW' 'Rwanda'  'SA' 'Saudi Arabia'  'SB' 'Solomon Islands'  'SC' 'Seychelles'  'SD' 'Sudan'  'SE' 'Sweden'  'SG' 'Singapore'  'SH' 'Saint Helena'  'SI' 'Slovenia'  'SJ' 'Svalbard and Jan Mayen'  'SK' 'Slovakia'  'SL' 'Sierra Leone'  'SM' 'San Marino'  'SN' 'Senegal'  'SO' 'Somalia'  'SR' 'Suriname'  'ST' 'Sao Tome and Principe'  'SV' 'El Salvador'  'SY' 'Syrian Arab Republic'  'SZ' 'Swaziland'  'TC' 'Turks and Caicos Islands'  'TD' 'Chad'  'TF' 'French Southern Territories'  'TG' 'Togo'  'TH' 'Thailand'  'TJ' 'Tajikistan'  'TK' 'Tokelau'  'TL' 'Timor-Leste'  'TM' 'Turkmenistan'  'TN' 'Tunisia'  'TO' 'Tonga'  'TR' 'Turkey'  'TT' 'Trinidad and Tobago'  'TV' 'Tuvalu'  'TW' 'Taiwan, Province of China'  'TZ' 'Tanzania, United Republic of'  'UA' 'Ukraine'  'UG' 'Uganda'  'US' 'United States'  'UY' 'Uruguay'  'UZ' 'Uzbekistan'  'VA' 'Holy See (Vatican City State)'  'VC' 
'Saint Vincent and the Grenadines'  'VE' 'Venezuela'  'VG' 'Virgin Islands, British'  'VI' 'Virgin Islands, U.S.'  'VN' 'Viet Nam'  'VU' 'Vanuatu'  'WF' 'Wallis and Futuna'  'WS' 'Samoa'  'YE' 'Yemen'  'YT' 'Mayotte'  'ZA' 'South Africa'  'ZM' 'Zambia'  'ZW' 'Zimbabwe'  'XX' 'Not Known' .
Value Labels PF_ethnicity PFPF_ethnicity PFPM_ethnicity PM_ethnicity PMPF_ethnicity PMPM_ethnicity 'GB' 'White: British'  'IE' 'White: Irish'  'FR' 'White: French'  'DE' 'White: German'  'TR' 'White: Turkish'  'GR' 'White: Greek'  'IT' 'White: Italian'  'PL' 'White: Polish'  'RU' 'White: Russian'  'ES' 'White: Spanish'  'NL' 'White: Dutch'  'PT' 'White: Portuguese'  'EU' 'White: Other - European'  'NA' 'White: Other - North American'  'AU' 'White: Other - Australian'  'AP' 'Asian: Pakistani'  'AI' 'Asian: Indian'  'AB' 'Asian: Bangladeshi'  'AK' 'Asian: Korean'  'AV' 'Asian: Vietnamese'  'AC' 'Asian: Chinese'  'AJ' 'Asian: Japanese'  'BC' 'Black or Black British: Black Caribbean'  'BA' 'Black or Black British: Black African'  'AR' 'North African: Arabic'  'EG' 'North African: Egyptian'  'MA' 'North African: Maghreb'  'OE' 'Other - European'  'OF' 'Other - African'  'ON' 'Other - North American'  'OM' 'Other - Middle American'  'OS' 'Other - South American'  'OA' 'Other - Asian'  'OU' 'Other - Australian'  'WC' 'Mixed: White and Black Caribbean'  'WF' 'Mixed: White and Black African'  'WA' 'Mixed: White and Asian'  'OX' 'Other - Mixed'  'XX' 'Not Known' .
VARIABLE Labels Disorder.PM.1 'First Disorder of  Father'.
VARIABLE Labels Disorder.PF.1 'First Disorder of  Mother'.
VARIABLE Labels Disorder.SM.1 'First Disorder of  Brother'.
VARIABLE Labels Disorder.SF.1 'First Disorder of  Sister'.
VARIABLE Labels Disorder.PFPM.1 'First Disorder of  Grandfather (maternal)'.
VARIABLE Labels Disorder.PFPF.1 'First Disorder of  Grandmother (maternal)'.
VARIABLE Labels Disorder.PMPM.1 'First Disorder of  Grandfather (paternal)'.
VARIABLE Labels Disorder.PMPF.1 'First Disorder of  Grandmother (paternal)'.
VARIABLE Labels Disorder.PFSM.1 'First Disorder of  Uncle (maternal)'.
VARIABLE Labels Disorder.PFSF.1 'First Disorder of  Aunt (maternal)'.
VARIABLE Labels Disorder.PMSM.1 'First Disorder of  Uncle (paternal)'.
VARIABLE Labels Disorder.PMSF.1 'First Disorder of  Aunt (paternal)'.
VARIABLE Labels Disorder.PFCF.1 'First Disorder of  Halfsister (maternal)'.
VARIABLE Labels Disorder.PFCM.1 'First Disorder of  Halfbrother (maternal)'.
VARIABLE Labels Disorder.PMCF.1 'First Disorder of  Halfsister (paternal)'.
VARIABLE Labels Disorder.PMCM.1 'First Disorder of  Halfbrother (paternal)'.
VARIABLE Labels Disorder.SMCM.1 'First Disorder of  Nephew (brothers son)'.
VARIABLE Labels Disorder.SMCF.1 'First Disorder of  Niece (brothers daughter)'.
VARIABLE Labels Disorder.SFCM.1 'First Disorder of  Nephew (sisters son)'.
VARIABLE Labels Disorder.SFCF.1 'First Disorder of  Niece (sisters daughter)'.
VARIABLE Labels Certain.PM.1 'Certain of first disorder of Father'.
VARIABLE Labels Certain.PF.1 'Certain of first disorder of Mother'.
VARIABLE Labels Certain.SM.1 'Certain of first disorder of Brother'.
VARIABLE Labels Certain.SF.1 'Certain of first disorder of Sister'.
VARIABLE Labels Certain.PFPM.1 'Certain of first disorder of Grandfather (maternal)'.
VARIABLE Labels Certain.PFPF.1 'Certain of first disorder of Grandmother (maternal)'.
VARIABLE Labels Certain.PMPM.1 'Certain of first disorder of Grandfather (paternal)'.
VARIABLE Labels Certain.PMPF.1 'Certain of first disorder of Grandmother (paternal)'.
VARIABLE Labels Certain.PFSM.1 'Certain of first disorder of Uncle (maternal)'.
VARIABLE Labels Certain.PFSF.1 'Certain of first disorder of Aunt (maternal)'.
VARIABLE Labels Certain.PMSM.1 'Certain of first disorder of Uncle (paternal)'.
VARIABLE Labels Certain.PMSF.1 'Certain of first disorder of Aunt (paternal)'.
VARIABLE Labels Certain.PFCF.1 'Certain of first disorder of Halfsister (maternal)'.
VARIABLE Labels Certain.PFCM.1 'Certain of first disorder of Halfbrother (maternal)'.
VARIABLE Labels Certain.PMCF.1 'Certain of first disorder of Halfsister (paternal)'.
VARIABLE Labels Certain.PMCM.1 'Certain of first disorder of Halfbrother (paternal)'.
VARIABLE Labels Certain.SMCM.1 'Certain of first disorder of Nephew (brothers son)'.
VARIABLE Labels Certain.SMCF.1 'Certain of first disorder of Niece (brothers daughter)'.
VARIABLE Labels Certain.SFCM.1 'Certain of first disorder of Nephew (sisters son)'.
VARIABLE Labels Certain.SFCF.1 'Certain of first disorder of Niece (sisters daughter)'.

VARIABLE Labels Disorder.PM.2 'Second Disorder of  Father'.
VARIABLE Labels Disorder.PF.2 'Second Disorder of  Mother'.
VARIABLE Labels Disorder.SM.2 'Second Disorder of  Brother'.
VARIABLE Labels Disorder.SF.2 'Second Disorder of  Sister'.
VARIABLE Labels Disorder.PFPM.2 'Second Disorder of  Grandfather (maternal)'.
VARIABLE Labels Disorder.PFPF.2 'Second Disorder of  Grandmother (maternal)'.
VARIABLE Labels Disorder.PMPM.2 'Second Disorder of  Grandfather (paternal)'.
VARIABLE Labels Disorder.PMPF.2 'Second Disorder of  Grandmother (paternal)'.
VARIABLE Labels Disorder.PFSM.2 'Second Disorder of  Uncle (maternal)'.
VARIABLE Labels Disorder.PFSF.2 'Second Disorder of  Aunt (maternal)'.
VARIABLE Labels Disorder.PMSM.2 'Second Disorder of  Uncle (paternal)'.
VARIABLE Labels Disorder.PMSF.2 'Second Disorder of  Aunt (paternal)'.
VARIABLE Labels Disorder.PFCF.2 'Second Disorder of  Halfsister (maternal)'.
VARIABLE Labels Disorder.PFCM.2 'Second Disorder of  Halfbrother (maternal)'.
VARIABLE Labels Disorder.PMCF.2 'Second Disorder of  Halfsister (paternal)'.
VARIABLE Labels Disorder.PMCM.2 'Second Disorder of  Halfbrother (paternal)'.
VARIABLE Labels Disorder.SMCM.2 'Second Disorder of  Nephew (brothers son)'.
VARIABLE Labels Disorder.SMCF.2 'Second Disorder of  Niece (brothers daughter)'.
VARIABLE Labels Disorder.SFCM.2 'Second Disorder of  Nephew (sisters son)'.
VARIABLE Labels Disorder.SFCF.2 'Second Disorder of  Niece (sisters daughter)'.
VARIABLE Labels Certain.PM.2 'Certain of second disorder of Father'.
VARIABLE Labels Certain.PF.2 'Certain of second disorder of Mother'.
VARIABLE Labels Certain.SM.2 'Certain of second disorder of Brother'.
VARIABLE Labels Certain.SF.2 'Certain of second disorder of Sister'.
VARIABLE Labels Certain.PFPM.2 'Certain of second disorder of Grandfather (maternal)'.
VARIABLE Labels Certain.PFPF.2 'Certain of second disorder of Grandmother (maternal)'.
VARIABLE Labels Certain.PMPM.2 'Certain of second disorder of Grandfather (paternal)'.
VARIABLE Labels Certain.PMPF.2 'Certain of second disorder of Grandmother (paternal)'.
VARIABLE Labels Certain.PFSM.2 'Certain of second disorder of Uncle (maternal)'.
VARIABLE Labels Certain.PFSF.2 'Certain of second disorder of Aunt (maternal)'.
VARIABLE Labels Certain.PMSM.2 'Certain of second disorder of Uncle (paternal)'.
VARIABLE Labels Certain.PMSF.2 'Certain of second disorder of Aunt (paternal)'.
VARIABLE Labels Certain.PFCF.2 'Certain of second disorder of Halfsister (maternal)'.
VARIABLE Labels Certain.PFCM.2 'Certain of second disorder of Halfbrother (maternal)'.
VARIABLE Labels Certain.PMCF.2 'Certain of second disorder of Halfsister (paternal)'.
VARIABLE Labels Certain.PMCM.2 'Certain of second disorder of Halfbrother (paternal)'.
VARIABLE Labels Certain.SMCM.2 'Certain of second disorder of Nephew (brothers son)'.
VARIABLE Labels Certain.SMCF.2 'Certain of second disorder of Niece (brothers daughter)'.
VARIABLE Labels Certain.SFCM.2 'Certain of second disorder of Nephew (sisters son)'.
VARIABLE Labels Certain.SFCF.2 'Certain of second disorder of Niece (sisters daughter)'.

VARIABLE Labels PM_Country 'Country of Father'.
VARIABLE Labels PF_Country 'Country of Mother'.
VARIABLE Labels PFPM_Country 'Country of Grandfather (maternal)'.
VARIABLE Labels PFPF_Country 'Country of Grandmother (maternal)'.
VARIABLE Labels PMPM_Country 'Country of Grandfather (paternal)'.
VARIABLE Labels PMPF_Country 'Country of Grandmother (paternal)'.
VARIABLE Labels PM_Ethnicity 'Ethnicity of Father'.
VARIABLE Labels PF_Ethnicity 'Ethnicity of Mother'.
VARIABLE Labels PFPM_Ethnicity 'Ethnicity of Grandfather (maternal)'.
VARIABLE Labels PFPF_Ethnicity 'Ethnicity of Grandmother (maternal)'.
VARIABLE Labels PMPM_Ethnicity 'Ethnicity of Grandfather (paternal)'.
VARIABLE Labels PMPF_Ethnicity 'Ethnicity of Grandmother (paternal)'.
Variable Labels PsychHistory 'RF' 'REFUSE' 'DK' 'Do not know' .
Value Labels Certain.PF.1 to Certain.SMCM.1 0 'Unsure' 1 'Sure' .

** save the complete file.
SAVE OUTFILE='C:\imagen_data\spss_data_files\GEN_complete.sav'
 /COMPRESSED.
