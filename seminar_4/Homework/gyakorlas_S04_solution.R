######################################
# Az 4. gyakorlat gyakorlo script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20200912.R” !
## A beadási határidő minden héten vasárnap éjfél.

# 1. Toltsd be a szukseges package-eket. (Az alabbi feladatok megoldhatok a tidyverse es a psych package-ekkel)

library(tidyverse)
library(psych)

# 2. Olvasd be az adatokat errol az URL-rol (ez egy .csv file): 
# https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv
# Ha a fenti link nem mukodne, alternativ link: "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_4/COVID19_OWID_20200929.csv"

COVID_data <- read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")


# 3. Szurd az adatokat ugy, hogy csak a 2020-09-29 datummal 
# felvett adatok legyenek benne. Rendeld hozza ezt a szurt adatottablat egy uj objektumhoz
# aminek a neve: COVID_20200929

COVID_20200929 <- COVID_data %>% 
  filter(date == "2020-09-29")

# 4. Szamold ki hany regisztralt eset volt osszesen Magyarorszagon 2020-09-29-ig (*total_cases*)?	

COVID_20200929 %>% 
  filter(location=="Hungary") %>% 
  select(total_cases)

# 5. Mi volt a legmagasabb uj eset-szam Magyarorszagon eddig (*new_cases*)?

COVID_data %>% 
  filter(location == "Hungary") %>% 
  select(new_cases) %>% 
  summary()

### 1322

# 6. Futtass le olyan leiro statisztikakat megado funkciot amibol latszik az egy millio 
# fore eso uj esetek (*new_cases_per_million*) ferdesegi mutatoja (skew/skewness), es az is,
# hany valid (nem NA, nem hianyzo adat) megfigyeles szerepel az adatbazisban az egy fore eso gdp-rol?

COVID_20200929 %>% 
  select(new_cases_per_million, gdp_per_capita) %>% 
describe()

# 7. szurd az adatokat ugy hogy csak a 2020-09-29-ei adatokkal dolgozzunk.	

# 8. csinalj egy uj kategorikus valtozot (nevezzuk ezt *new_cases_per_million_kat*-nak)
# a mutate() funkcio hasznalataval, amiben azok az orszagok ahol a  *new_cases_per_million*
# valtozo 20 alatt van "small", ahol 20 vagy a felett van "large" kategoriaba keruljenek.	

# 9. figyelj oda hogy faktorkent jelold meg ezt az uj valtozot 

# 10. mentsd el ezt a valtozot az eredeti adatobjektumban ugy hogy kesobb is lehessen vele dolgozni 	

COVID_20200929 <- COVID_20200929 %>% 
  mutate(new_cases_per_million_kat = factor(
    case_when(new_cases_per_million < 20 ~ "small",
              new_cases_per_million >= 20 ~ "large"), ordered = T, levels = c("small", "large")))

# 11. keszits egy tablazatot arrol, hogy hany megfigyeles van a *new_cases_per_million_kat* egyes kategoriaiban.	

table(COVID_20200929$new_cases_per_million_kat)

# 12. Add meg a faktorszintek helyes sorrendjet: small, large (Ird felul a *new_cases_per_million_kat*
# korabbi valtozatat ezzel a valtozattal ahol a szintek mar helyes sorrendben vannak, 
# vagy ezt a sorrendezest is bele vonhatod az eredeti funkcioba, amivel a valtozot generaltad)	

# 13. Ellenorizd, hogy valoban helyes sorrendben szerepelnek-e a faktor szintjei.

COVID_20200929$new_cases_per_million_kat
