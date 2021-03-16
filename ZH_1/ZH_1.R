# 1. toltsd be a ZH megoldasahoz hasznalt package-eket, ha szukseges, installald is a 
# package-eket betoltes elott (az alabbi feladatok a psych és a tidyverse package-ekkel megoldhatók) - 1/1 pont

# 2. töltsd be az adatot erről az URL-ről (ez egy .csv file). - 1/1 pont
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH1_data_20210316.csv"

# Olvasd el figyelmesen az adat leírását, mert az adatok ismerete szükséges az alábbi feladatok megoldásához

# Az adatok PSWR package-ből származnak, és egy kutatás eredményei tartalmazzák. A kutatás célja
# az volt, hogy a sima ülő pozíció, vagy a nyújtott lábakra ráhajoló, nyújtó pozíció előnyösebb
# epidurális érzéstelenítés beadásához terhes nők vajúdása során.

# Változók:
#     ID - páciens személyes azonosítója
#     Doctor - faktor változó, a páciensek orvosait jelöli. Dr. A, Dr. B, Dr. C, és Dr. D szintekkel.
#     kg - a páciens kg-ban jelölt súlya
#     cm - a páciens magassága cm-ben
#     Ease - faktor változó Difficult, Easy, Impossible szintekkel. Azt jelzi, hogy az orvos milyen könnyen
#            tudta kitapintani a páciens csontjain a tájékozódási pontokat.
#     Treatment - faktor változó, Hamstring Stretch és Traditional Sitting szintekkel. A 
#            hamstring stretch az ülve nyújtott lábra való ráhajoló nyújtó pozíciót, 
#            a traditional sitting pedig a sima ülő pozíciót jelenti.
#     OC - (obstructive contacts) a tű-csont érintkezések száma
#     Complications - Failure - person got dizzy = sikertelen, a pánciens
#             szédült, Failure - too many OCs = sikertelen, túl sok tű-csont érintekzés, None = semmi,
#             Paresthesia = téves bőrérzékelés, Wet Tap = a gerinc csonhártyájának véletlen átszúrása
#     Pain - A páciens által jelzett fájdalomszint az epidurális injekció beadása során. 0-10-ig kellett
#     értékelni a fájdalom szintjét, a magasabb értékek nagyobb fájdalmat jelentenek. Csak egesz szamerteket
#     vehet fel.

# 3. Jelöld faktorként a faktor változókat (a fenti leírás alapján) - 1/1 pont

# 4. Végezz az adatokon alapvető adatellenörző műveleteket. - 7/7 pont
# Ellenőrizd hogy vannak-e furcsa vagy hibás adatok, és ha vannak ilyenek, javítsd ki őket.
# A javításokat kóddal csináld (hogy reprodukálható és átlátható legyen, mit csináltál pontosan).

# Ellenőrizd, hogy sikerült-e minden adatot helyesen javítani (ez az ellenőrzés is szerepeljen a kódban).
# Ha a javítás során vannak olyan faktorszintek amikből már nem marad egy megfigyelés sem, ejtsd ezeket a
# faktorszinteket a droplevels() funcióval
# A javított adatfájlt mentsd el egy uj objektumba, és a következő lépésekben már ezzel a javított adattáblával dolgozz.

# 5. Jelöld sorrendezett (ordinális) valtozóként az "Ease" változót úgy,
# hogy a következő legyen a faktorszintek sorrendje: "Easy", "Difficult", "Impossible" - 1 pont

#6. Teszteld a következő hiptozéiseket.
# Minden hipotézisnél először végezz leíró elemzést táblázatokkal, összegző adatokkal vagy ábrákkal.
# Az elemzés elvégzése után röviden írd le az eredmények értelmezését. Szerepeljenek ebben 
# a releváns számszerű adatok is.
# teszt-statisztika értéke, szabadságfok, p-érték, és amikor ez releváns, a hatás méretének pontbecslése és konfidencia intervalluma.

# 6/ 1. Hipotézis
# A páciensek súlya és magassága között pozitív együttjárás van. - 5 pont

# 6/  2. Hipotézis
# Van különbség a kezelési csoportok között (Treatment) a vizsgálati személyek magasságában.- 4 pont

# 6/  3. Hipotézis
# Van összefüggés az orvos személye és a tű-csont érintkezések (OC) átlagos száma között.
# Melyik orvosnál volt a legkevesebb a tű-csont érintkezés?- 5 pont

# 6 /4. Hipotézis
# A kevés tű-csont érintkezés (OC változó értéke 1 vagy az alatt) nagyobb valószínűséggel
# fordul elő valamelyik kezeléstípusnál.
# Ehhez a feladathoz lehet hogy szükséges egy meglévő változót új változóvá alakítanod - 6 pont

# 7. Toltsd fel a megoldast .R filekent elmentve a hazi feladatokhoz 
# is hasznalt sajat google drive folderedbe a megadott hataridoig. A File neve legyen 
# zh_1_[neved].R (pl. zh_1_kekecszoltan.R)