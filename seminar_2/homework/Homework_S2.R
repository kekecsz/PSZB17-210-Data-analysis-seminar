# Házi feladat

# 1.feladat
## A házifeladat elkészítéséhez telepítsd és töltsd be a "dplyr" és a "titanic" nevű csomagokat.

# 2.feladat
## Töltsd be a "titanic_train" nevű adattáblát és mentsd el egy "titanic_data" nevű objektumba.
## Ha problémát jelentenek a hiányzó adatok (NA), akkor érdemes a drop_na() fügvényt használni 
## azoknak a soroknak a kizárására amik hiányzó adatot tartalmaznak.

# 3.feladat
## A Titanic korának lenagyobb hajója volt. De hányan utaztak rajta? Számold ki az órán tanült függvényekkel.

# 4.feladat:
## Hányan élték túl a katasztrófát és hányan vesztették az életüket?
## Számold ki mindkét értéket és mentsd el egy "titanic_survived" nevű objektumba.
## Segítség: Ha valaki túlélte a katasztrófát, az 1-es értéket kap a "survived" változóban, aki nem az 0-ás értéket.

# 5.feladat:
## Ahhoz, hogy érthetőbb legyen az előbb kiszámolt eredmény, kódold át a 0-ás értéket "elhunyt"-ra,
## az 1-es értéket "tulelte"-re a "Survived" változóban a "titanic_survived" objektumban.

# 6.feladat:
## A "titanic_data" adattáblából szűrd ki csak az első osztályon utazókat.
## Az, hogy ki melyik osztályon utazik a "Pclass" változóban van.

# 7.feladat:
## Rakd sorrendbe az utasokat asszerint, hogy ki mennyit fizetett a jegyért növekvő sorrendben ("Fare").

# 8.feladat:
## A "Fare" változóban dollárban van a jegyek ára. Mennyibe kerülnének most ezek a jegyek forintban?
## Számold ki (1 dollár = 300 forint), és mentsd el egy új változóba "Fare_HUF".