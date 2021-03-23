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
# "https://docs.google.com/spreadsheets/d/1sPBXkgm7o4IsMrP55ZPk0v06U-qBSgRrmDkbiJLBe_g/edit?usp=sharing" 
# url-ről tudod betölteni. Használd a betöltéshez a gsheet2tbl() funkciot a gsheet package-bol

# 3. Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **exam_score** (ZH eredmeny) a kimeneti valtozo es az **hours_of_practice_per_week** (hetente atlagosan hany orat gyakololt) a prediktor. A modell eredmenyet mentsd el egy objektumba.

# 4. Ird le a regresszios fuggvenyt amivel bejosolhato a ZH eredmeny (exam_score).

# 5. Ertelmezd a regresszios fuggvenyt. Aki tobbet gyakorol annak magasabb vagy alacsonyabb a ZH eredmenye? (Egy abra segithet)

# 6. Ertelmezd a regresszios fuggvenyt. Aki egy oraval tobbet gyakorol hetente mint masok, annak mennyivel varhato hogy magasabb lesz az energiaszintje?

# (Opcionális: Ennek a modellnek a segitsegevel becsuld meg a ZH eredmenyet olyan embereknek akik heti 2, 5, vagy 8 orat gyakorolnak.)

# 7. Listazd ki a model summary-t a summary() fugvennyel

# 8. Olvasd le hogy a model ami tartalmazza az hours_of_practice_per_week prediktort szignifikansan jobb bejosloja-e az exam_score-nak mint a null modell.

# 9. Hatarozd meg a regresszios egyutthatok konfidencia intervallumat a confint() fuggvennyel

# 10. Toltsd be a lakasarak adatbazist. Ezt a 
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_7/data_house_small_sub.csv"
# url-ről tudod betölteni. Ez egy .csv file, szoval erdemes a read.csv() vagy read_csv() funkciokat hasznalni a betolteshez.

# 11. Epits egy tobbszoros linearis regresszio modellt az lm() fugvennyel amiben az **price** a kimeneti valtozot becsuljuk meg. Hasznalhatod a **data_house** adatbazisban szereplo barmelyik valtozot a modellben, ami szerinted realisan hozzajarulhat a lakas aranak meghatarozasahoz.

# 12. Hatarozd meg, hogy szignifikansan jobb-e a modelled mint a null modell (a teljese modell F-teszthez tartozo p-ertek alapjan)?

# 13. Mekkora a teljes modell altal bejosolt varianciaarany (adj.R^2)?

# 14. Melyik az a prediktor, mely a legnagyobb hozzadaott ertekkel bir a becslesben?

