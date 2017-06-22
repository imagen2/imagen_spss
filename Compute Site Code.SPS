Compute SiteCode = Number(substr(ID,1,2), F2.0).
If ( Locale = "en") LocaleCode = 1.
If ( Locale = "de") LocaleCode = 2.
If ( Locale = "fr") LocaleCode = 3.
Value Labels LocaleCode 1 'en' 2 'de' 3 'fr'.
Value Labels SiteCode 1 'lond' 2 'nott' 3 'dubl' 4 'berl' 5 'hamb' 6 'mann' 7 'paris' 8 'dres' .
Execute.

