####################################
#          Hazi feladat            #
####################################


# 1. feladat: Toltsd be a szukseges package-eket. (Az alabbi feladatok megoldhatok a tidyverse es a psych package-ekkel)

# 2. feladat: Olvasd be az adatokat errol az URL-rol (ez egy .csv file): 
# https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv
# Ha a fenti link nem mukodne, alternativ link: "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_4/COVID19_OWID_20200929.csv"

# 3. feladat: Szurd az adatokat ugy, hogy csak a 2020-09-29 datummal 
# felvett adatok legyenek benne. Rendeld hozza ezt a szurt adatottablat egy uj objektumhoz
# aminek a neve: COVID_20200929

# 4. feladat: Listazz ki az atlagot, legalacsonyabb es legmagasabb ertekek, es mediant
# a COVID_20200929 adatbazisban a kovetkezo valtozokrol: 
# new_cases, new_cases_per_million, total_cases, gdp_per_capita

# 5. feladat: Abrazold a population_density valtozo eloszlasat tetszoleges abraval.

# 6.a. feladat: Csinalj egy kategorikus valtozot a population_density alapjan ugy, 
# hogy harom csoport alakuljon ki: 100 alatt - "ritka", 100-500 - "kozepes", 500 felett - "suru". 
# (Emlekezteto: ezt a mutate() es a case_when() funkciokkal tudod peldaul elerni.) 
# Ezt az uj valtozot nevezd el "population_density_kat" -nak, es az ezt az uj
# valtozot is tartalmazo adattablat mentsd el "COVID_20200929_ujvaltozok" neven.

# 6.b. feladat: Fontos, hogy a "population_density_kat" valtozot faktor valotozokent jelold meg.
# (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de 
# mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)

# 6.c. feladat: Add meg a faktorszintek helyes sorrendjet: "ritka", "kozepes", "suru". 

# 7. feladat: Keszits egy tablazatot arrol, hogy hanyan esnek a "population_density_kat" egyes kategoriaiba. 

# 8. feladat: Keszits egy abrat amin azt abrazolod hogy a population_density_kat egyes faktorszintjeikbe hany 
# megigyeles tartozik. Ezen az abran azt is ellenorziheted hogy a sorrendezes jol mukodott-e.

# 9. feladat: Keszits egy ujabb adat objektumot (nevezzuk mondjuk COVID_20200929_ujvaltozok_surunelkul -nek),
# amiben nincsenek benne a "suru" nepsurusegi kategoriaba
# eso orzsagok adatai (population_density_kat). Ezutan keszits egy tablazatot arrol, 
# hogy az egyes faktorszintekre a "population_density_kat" valtozon belul hany megfigyeles esik.

# 10. feladat: A COVID_20200929_ujvaltozok_surunelkul adat-objektumban ejtsd a 
# nem hasznalt faktorszinteket.  Ird felul a COVID_20200929_ujvaltozok_surunelkul  objektumon belul 
# a "population_density_kat" valtozo korabbi valtozatat ezzel az 
# modositott valatozoval, ahol mar nincsenek meg a felesleges szintek. 
# Ehhez a mutate() funkcion belul kell a droplevels() funkciot hasznalni. 
# Amint ez kesz van, keszits egy tablazatot a table() vagy summary() funciokkal
# arrol, hogy az egyes faktorszintekre a "population_density_kat" 
# valtozon belul hany megfigyeles esik, igy ellenorizd hogy eltunt a "suru" faktorszint.

# 11. feladat: Keszits egy ujabb kategorikus valtozot gdp_per_capita_kat neven
# a gdp_per_capita alapjan ugy hogy a 10000 alatti gdp_per_capita-ju 
# megfigyelesek "alacsony", a 10000 vagy a feletti megfigyelesek pedig "magas" erteket
# vegyenek fel.

# 12. feladat: Keszits egy tablazatot, amely a population_density_kat 
# es a gdp_per_capita_kat valtozok osszefuggeset mutatja (vagyis hogy 
# hany megfigyeles tartozik a ritka nepsurusegu, alacsony gdp-ju, a ritka 
# nepsurusegu magas gdp-ju, a kozepes nepsurusegu alacsony gdp-ju stb. csoportokba.

# 13. feldat: abrazold ugyan ezt egy abran is.

