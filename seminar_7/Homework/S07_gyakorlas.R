######################################
# Az 7. gyakorlat gyakorló script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20200912.R” !
## A beadási határidő minden héten vasárnap éjfél.


# 
# 1. Töltsd be a tidyverse és a gsheet csomagokat!

# 2. Töltsd be az adatokat. Ezt a 
# https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/S05_orai_adat.csv 
# url-ről tudod betölteni. Használd a betöltéshez a read.csv() vagy a read_csv() funkciókat.

mydata = as_tibble(gsheet2tbl("https://docs.google.com/spreadsheets/d/1GXx2YoktyIdXLqKdm4f_MMWHUzXYgxWRRr3avYnWaew/edit?usp=sharing"))

# 3. Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **energiaszint_1** a kimeneti valtozo es az **alvas_altalaban_1** a prediktor. A modell eredmenyet mentsd el egy objektumba.

# 4. Ird le a regresszios fuggvenyt amivel bejosolhato az energiaszint.

# 5. Ertelmezd a regresszios fuggvenyt. Aki tobbet alszik annak magasabb vagy alacsonyabb az energiaszintje? (Egy abra segithet)

# 6. Ertelmezd a regresszios fuggvenyt. Aki egy oraval tobbet alszik mint masok, annak mennyivel varhato hogy magasabb lesz az energiaszintje?

# 7. Listazd ki a model summary-t a summary() fugvennyel

# 8. Olvasd le hogy a model ami tartalmazza az alvas_altalaban_1 prediktort szignifikansan jobb bejosloja-e az energiaszintnek mint a null modell.

# 9. Hatarozd meg a regresszios egyutthatok konfidencia intervallumat a confint() fuggvennyel

# (Opcionális: Ennek a modellnek a segitsegevel becsuld meg az energiaszintjet olyan embereknek akik altalaban 5, 7, vagy 9 orat alszanak.)


