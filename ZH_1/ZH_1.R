# 1. toltsd be a ZH megoldasahoz hasznalt package-eket, ha szukseges, installald is a 
# package-eket betoltes elott (az alabbi feladatok a psych és a tidyverse package-ekkel megoldhatók) - 1/1 pont

# 2. töltsd be az adatot erről az URL-ről (ez egy .csv file). - 1/1 pont
# https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-1/achivment_dataset.csv

# Olvasd el figyelmesen az adat leírását, mert az adatok ismerete szükséges az alábbi feladatok megoldásához

#Az adatok a LearnBayes package-ből származnak, és osztrák általánosiskolások teljesítményének adatait tartalmazzák.

#Változók:
#   X - tanuló egyedi azonosítója
#   Gen - gender, faktor változó, ahol 0 fiút, 1 pedig lányt jelöl
#   Age - a tanulók életkora hónapban megadva, csak pozitív egész értékeket vehet fel (8-12 éves diákok vettek részt a kutatásban)
#   IQ - tanulók IQ szintje, csak pozitív egész értékeket vehet fel (a normál populációban 100 az IQ átlaga és 15 a szórása, így reális értékei nagyjából 50-150 között vannak)
#   math1 - a tanulók teszteredményei matematikai számítási feladatoknál, csak pozitív egész értékeket vehet fel
#   math2 - a tanulók teszteredményei matematikai probléma megoldási feladatoknál, csak pozitív egész értékeket vehet fel
#   read1 - a tanulók eredményei olvasási sebesség teszten, csak pozitív egész értékeket vehet fel
#   read2 - a tanulók teszteredményei szövegértési feladatoknál, csak pozitív egész értékeket vehet fel

# 3. Jelöld faktorként a faktor változókat (a fenti leírás alapján) - 1/1 pont

# 4. Végezz az adatokon alapvető adatellenörző műveleteket. - 6/6 pont
# Ellenőrizd hogy vannak-e furcsa vagy hibás adatok, és ha vannak ilyenek, javítsd ki őket.
# A javításokat kóddal csináld (hogy reprodukálható és átlátható legyen, mit csináltál pontosan).

# Ellenőrizd, hogy sikerült-e minden adatot helyesen javítani (ez az ellenőrzés is szerepeljen a kódban).
# Ha a javítás során vannak olyan faktorszintek amikből már nem marad egy megfigyelés sem, ejtsd ezeket a
# faktorszinteket a droplevels() funcióval
# A javított adatfájlt mentsd el egy uj objektumba, és a következő lépésekben már ezzel a javított adattáblával dolgozz.

# hiba 1 felfedezése és javítása (droplevels ha kell) - 2p
# hiba 2 felfedezése és javítása (droplevels ha kell) - 2p
# ellenőrzés - 1p
# elmentés új objektumba - 1p

#4. Készíts egy új faktor változót ami a diákok évfolyamát mutatja a következők alapján: 
# a 8 évesek másodikosok, a 9 évesek harmadikosok, a 10 évesek negyedikesek,
# 11 évesek ötödikesek, és a 12 évesek hatodikosok.  - 1/1 pont


#5. Kódold újra a Gen (a tanuló neme) változót úgy hogy a 0 helyett "fiu", az 1 helyett
# pedig "lany" szerepeljen - 1/1 pont


#6. Teszteld a következő hiptozéiseket.
# Minden hipotézisnél először végezz leíró (explorátoros) elemzést táblázatokkal, összegző adatokkal vagy ábrákkal,
# majd futtasd le a megfelelő statisztikai tesztet.
# Az elemzés elvégzése után röviden írd le az eredmények értelmezését. Szerepeljenek ebben 
# a releváns számszerű adatok is. Vagyis a teszt-statisztika értéke, szabadságfok, p-érték,
# és amikor ez releváns, a hatás méretének pontbecslése és konfidencia intervalluma.
# Ha az adatellenőrzés során találtál hibákat és ezeket javítottad, akkor az elemzéshez minden esetben
# a javított adatbázist használd!

#6/ 1. Hipotézis
# A lányok szövegértés eredményeinek átlaga magasabb, mint a fiúk szövegértés eredményeinek átlaga. - 5/5 pont

#6/ 2. Hipotézis
# Van együttjárás a tanulók IQ szintje és a matematikai probléma megoldó teszten elért ereményeik között. - 4/4 pont

#6/ 3. Hipotézis
# Van különbség az évfolyamcsoportok (másodikosok, harmadikosok, negyedikesek, stb.)
# között az olvasási sebesség teszten elért eredményekben. Az évfolyamot itt csoportosító (faktor)
# változóként kezeld, és úgy haosnlítsd össze a különböző évfolyamok közötti olvasási sebességet. - 4/4 pont

#6/ 4. Hipotézis
# A felsősök (11-12 évesek) matematikai számítási feladatban jobb eredményt
# érnek el mint az alsósok (8-10 évesek). 
# Lehet, hogy a hipotézis teszteléséhez létre kell hoznod új vátlozó(ka)t. - 6/6 pont

#7. Töltsd fel a megoldást .R fileként elmentve a házi feladatokhoz 
# is használt saját google drive folderedbe. A File neve legyen 
# zh_1_[neved].R (pl. zh_1_kekecszoltan.R)