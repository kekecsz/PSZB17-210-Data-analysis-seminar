######################################
# Az 4. gyakorlat gyakorlo script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20210928.R” !

# 1. Toltsd be a szukseges package-eket. (Az alabbi feladatok megoldhatok a tidyverse es a psych package-ekkel)

# 2. Olvasd be az adatokat errol az URL-rol (ez egy .csv file): 
# https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/refs/heads/master/seminar_04/StudentPerformanceFactors.csv

# 3. Mi volt a legalacsonyabb részvételi arány (*Attendance*)?	

# 4. Mi az átlagos alvásmennyiség (*Sleep_Hours*) azok között a hallgatók között, akiknek alacsony a hozzéférése az erőforrásokhoz (Access_to_Resources == "Low")?	

# 5. Szurd az adatokat ugy hogy ne legyenek benne az otthon tanulo (School_Type == "Home") hallgatok.	

# 6. Csinalj egy uj kategorikus valtozot (nevezzuk ezt *Sleep_Categorical*-nak) a mutate() funkcio hasznalataval amiben azok a diakok akiknek a  *Sleep_Hours* valtozo 6 alatti ertket mutat, "inadequate", ahol 6 vagy a felett van "adequate" kategoriaba keruljenek.	
# Figyelj oda hogy faktorkent jelold meg ezt az uj valtozot (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)	
# 8. Mentsd el ezt a valtozot az eredeti adatobjektumban ugy hogy kesobb is lehessen vele dolgozni 	
# 9. keszits egy tablazatot arrol, hogy hanyan esnek a *Sleep_Categorical* egyes kategoriaiba.	
# 10. Add meg a faktorszintek helyes sorrendjet: az "inadequate" szint legyen elorebb sorolva, mint az "adequate" szint (Ird felul a *Sleep_Categorical* korabbi valtozatat ezzel a valtozattal ahol a szintek mar helyes sorrendben vannak, vagy ezt a sorrendezest is bele vonhatod az eredeti funkcioba, amivel a valtozot generaltad)	
# 11. Ellenorizd, hogy valoban helyes sorrendben szerepelnek-e a faktor szintjei.	

# 12. Szurd az adatokat ugy hogy csak a Previous_Scores, Peer_Influence, Parental_Involvement, es a Sleep_Hours valtozokkal dolgozz.	
# - Hasznald a fent tanult modszereket, hogy **azonositsd a my_data adattablaban levo hibakat** vagy nem vart furcsasagokat.	
# - A vizualizacion tul a View(), describe(), table(), es summary() funciokat erdemes hasznalni az adatok elso attekintesere 	
# - A numerikus (vagy eppen folytonos) valtozoknal vizsgald meg a minimum es maximum erteket es a hianyzo adatok mennyiseget, valamint az eloszlast, esetleg a felvett ertekek mennyiseget, ha nincs tul sok felveheto ertek.	
# - A kategorikus valtozoknal vizsgald meg az osszes faktorszintet es az egyes szintekhez tartozo megfigyelesek mennyiseget.	

# 13. Hasznald a fent tanult modszereket, hogy megvizsgald a my_data adatbazisban a **Sleep_Categorical** es a **Distance_from_Home** valtozok kozotti osszefuggest.	
# - hasznalj **geom_bar()** geomot a megjeleniteshez	
# - probald meg mind a **szamossagot**, mind a **reszaranyt** kifejezo abrat megvizsgalni geom_bar(position = "fill")	
# - milyen **kovetkeztetest** tudsz levonni az abrakrol?	

# 14. Hasznald a fent tanult modszereket, hogy megvizsgald az **Exam_Score** es a **Learning_Disabilities** valtozok kozotti osszefuggest.	
# - keszits legalabb ket kulonbozo abrat mas-mas geomokkal	

# 15. Milyen eros a kapcsolat az Exam_Score es a Sleep_Hours kozott?	
# - hatarozd meg a korrelacios egyutthatot a valtozok kozott	
# - abrazold a valtozok kapcsolatat	

