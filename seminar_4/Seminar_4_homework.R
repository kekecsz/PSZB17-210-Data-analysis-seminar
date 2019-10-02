####################################
#          Hazi feladat            #
####################################


# 1.a. feladat: Kezdd el merni az idot, hogy mennyi ido alatt csinalod meg az alabbi hazi feladat egeszet. Ha felbehagyod a megoldast, jegyezd fel az idot ahol tartottal, es amikor ujrakozded, folytasd onnan a szamlast, ahol abbahagytad. 

# 2. feladat: Toltsd be a szukseges package-eket. (Az alabbi feladatok megoldhatok a tidyverse es a Psych package-ekkel)

# 3. feladat: Olvasd be az adatokat errol az URL-rol (ez egy .csv file): 
# "https://tinyurl.com/statgyak2019-seminar-4-data"
# Ha a fenti link nem mukodne, alternativ link: "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_4/Orai_kerdoives_adatok%20-%20ora_1_3.csv"

# 4. feladat: Vegezd el az adattisztitast a kovetkezo koddal:
  
orai_adat_corrected = orai_adat %>%
  mutate(szocmedia_3 = replace(szocmedia_3,  szocmedia_3=="youtube", NA))

orai_adat_corrected = orai_adat_corrected %>%
  mutate(magassag = replace(magassag,  magassag == 1.82, 182))

orai_adat_corrected = orai_adat_corrected %>%
  mutate(cipomeret = replace(cipomeret, cipomeret == 47, 37))

# 5. feladat: Hatarozd meg az elso orai hangulat atlagat ("hangulat_1" valotzo).


# 6. feladat: Csinalj egy kategorikus valtozot az elso orai hangulat alapjan ugy, hogy harom csoport alakuljon ki: 0-3 - rossz, 4-6 - kozepes, 7-10 - jo. (Emlekeztetoum: ezt a mutate() es a recode() funkciokkal tudod peldaul elerni.) Ezt az uj valtozot nevezd el "hangulat_kat_1" -nek, es az ezt az uj valtozot is tartalmazo adattablat mentsd el "orai_adat_harmashangulat_1" neven.


# 7. feladat: Fontos, hogy a "hangulat_kat_1" valtozot faktor valotozokent jelold meg. (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)


# 8. feladat: Add meg a faktorszintek helyes sorrendjet: rossz, kozepes, jo. 


# 9. feladat: Keszits egy tablazatot arrol, hogy hanyan esnek a "hangulat_kat_1" egyes kategoriaiba. Ebben a tablazatban ellenorizd hogy a faktor szintjei valoban helyes sorrendben szerepelnek-e. 


# 10. feladat: Keszits egy ujabb adat objektumot, amiben nincsenek benne a "rossz" hangulatuak (mondjuk a filter() segitsegevel), mondjuk legyen a neve "orai_adat_ketteshangulat_1". Ezutan keszits egy tablazatot arrol, hogy az egyes faktorszintekre a "hangulat_kat_1" valtozon belul hany megfigyeles esik.


# 11. feladat: Ejtsd a nem hasznalt faktorszinteket (a droplevels() funkcioval). Ird felul a "orai_adat_ketteshangulat_1"  objektumon belul a "hangulat_kat_1" korabbi valtozatat ezzel az modositott valatozoval, ahol mar nincsenek meg a felesleges szintek. Ehhez a mutate() funkcion belul kell a droplevels() funkciot hasznalni. Amint ez kesz van, keszits egy tablazatot arrol, hogy az egyes faktorszintekre a "hangulat_kat_1" valtozon belul hany megfigyeles esik, igy ellenorizd hogy eltunt a "rossz" faktorszint.


# 12. feladat: Terjunk vissza a "orai_adat_harmashangulat_1" objektum hasznalatahoz (amiben a rossz hangulatuak is benne vannak). Most a "hangulat_kat_1" valtozo es a "valasztott_szam" valtozo kapcsolatat vizsgaljuk majd. Eloszor is jelenitsd meg hogy a "hangulat_kat_1" egyes kategoriaiban (roszz, kozepes jo) mekkora az emberek altal valasztott szamok atlaga ("valasztott_szam" valtozo).

# 13. feladat: Ez utan abrazold a hangulat "hangulat_kat_1" es a "valasztott_szam" valtozok kapcsolatat abrakon. Rajzolj legalabb ket abrat amin mas geomokat hasznalsz.

# 14. feladat: Hatarozd mega korrelacios egyutthatot az elso orai es a harmadik orai hangulat kozott ("hangulat_1" es "hangulat_3" valtozok).


# 15. feladat: Abrazold a "hangulat_1" es "hangulat_3" valtozok kozotti kapcsolatot egy pontdiagrammal. Illessz egy trendvonalat is az abrara. 

# 16. feladat: A korrelacios egyutthato es az abra alapjan milyen a kapcsolat a "hangulat_1" es "hangulat_3" valtozok kozott? Ird le roviden egy comment-ben.

# 1.b. feladat: Ird ide, osszesen mennyi idobe tellett megoldani ezt a hazi feladatot. (ez nem szamit bele az ertekelesbe, csak a ZH feladatmennyisegenek tervezesehez hasznaljuk fel ezt az informaciot)

