# Első óra

## Az órai anyag elkészítéséhez felhasználtuk a következőket:
### http://alyssafrazee.com/2014/01/02/introducing-R.html
### https://github.com/nthun/Data-analysis-in-R-2019-20-1/blob/master/Lecture%201%20-%20R%20101.R

#### Bevezetés az R nyelvbe
# Gondolhatunk úgy az R programra, mint egy számológépre...

21 + 16

# Ha lefuttatod a fenti kódot láthatod, hogy az eredménye a következő:
# [1] 37

# Biztosan észrevetted, hogy az a szöveg, amelyik "#" jellel kezdődik más színű, mint a többi. Ezek a kommentek. Akárhány kommentet rakhatsz a kódodba, hogy érthetőbb legyen mások és a jövő beli önmagad számára.

# Bonyolultabb számolásokat is lefuttathatunk:

(11*2.3)^2 + 3*(log(15)) * pi + sin(1/5) 
# [1] 665.8114

# Változók (variables)

number1 <- 55 # Rendelj hozzá egy értéket (value) a változódhoz
Number2 = 66 # a "=" ugyanaz, mint a  "<-"

number1 + number2
# Szerinted mi lesz a következő összeadás eredménye?

# Figyelj rá, hogy az R érzékeny a kis és nagybetűk közti különbségre! Azonaban a szóközök számára nem!
number1 +      Number2
# [1] 121

# Az R-ben vannak függvények is (function), amelyek mint egy parancsot értelmezhetünk.
# A függvényeknek általában több paramétere van, amellye meghatározhatjuk, hogy hogyan viselkedjen a függvény.
# Ha egy függvényt szeretnél használni, a neve beírása után zárójeleket "()" kell használj. Még akkor is, ha nincsenek paraméterei.
# Példaként lássuk, hogy milyen függvényeket kell használjunk, egy ábra elkészítéséhez.

# Először kellenek valamilyen adatok, amiket az ábránkon ábrázolhatunk...
# A rnorm()fügvénnyel 1000 random számot hozunk létre, amelyeknek az átlaga 100, és a szórása 10.
# Tehát ennek a függvénynek 3 paramétere van (hány számot generáljon, mi legyen ezeknek az átlaga és a szórása). 

# A függvény eredményét elmentjük az "x" nevű objektumba (object).
x <- rnorm(1000, mean = 100, sd = 10) 

x # használjuk az objektum nevét, hogy kinyomtassuk a függvény eredményét a konzolba (consoles)
# A változó eloszlását egy histogramként ábrázolhatjuk. Az ábrázoló függvény csak egy paramétert kér, az adatokat, az ábrázolához, de még többet is használhatsz, hogy szebbá tedd az ábrád.
hist(x)

# Mit tegyünk, ha elakadtunk?
?hist # Ezt használva láthatjuk a függvény leírását, és hogy milyen paramétereket használhatunk.

# Ha tudod mit szeretnál csinálni, de nem tudod a függvény nevét, két kérdőjelet használj
??histogram

# Adat típusok (type)

# Egy szám vektor (numeric vector)
numbers <- c(10, 11, 12, 13, 14, 15, 16, 17, 18, 19) # Létrehozunk egy szám vektort
# A c() fügvénnyel tudunk elemeket összefűzve elmenteni egy vektorba

numbers # Nyomtassuk ki a konzolba a vektor tartalmát
# [1] 10 11 12 13 14 15 16 17 18 19 

# Nézzük meg hány elem (value) van a numbers nevű vektorban
length(numbers)
# [1] 10

# Hozzunk létre egy szöveg vektort (character vector). Figyelj a "" jelre. Ez jelöli azt, hogy szövegről van szó. Használhatod a '' jelet is, de a kezdő és végződő jelnek ugyanannak kell lennie.
fruits <- c("apple", 'apple', "banana", "kiwi", "pear", "strawberry", 'strawberry')
print(fruits) # Nyomtassuk ki a szöveg változó tartalmát a print() függvényt használva
print("Hello world!") # Létrehoztuk az első R-ben írt "Hello word!" programunk!

# Indexelés (Indexing)
# Válasszuk ki a "fruits" objektum harmadik elemét
fruits[3]
# Az indexeléshez a [] jelet használjuk

# Válasszuk ki az első, harmadik és ötödik elemét a vektornak
fruits[c(1,3,5)]

# Távolítsuk el az első 3 és a 7. elemet
fruits[-c(1:3, 7)]

# Adattáblák (Data frames)
# Az R-ben vannak előre beépített adattáblák is. Próbáljunk betölteni egyet!

data("USArrests") # A data() függvény betölti az előre beépített adattáblát. Ez az USA-ban történt letartóztatásokról szól.
USArrests  # Nézzük meg az adattáblát

# Ha ez egy kicsit zavarosnak tűnik, nyisd meg az adattáblát máshogy:
View(USArrests)

str(USArrests) # ENézzük meg az adattábla struktúráját, hogy milyen változók vannak benne, hány megfigyelés stb.
# 'data.frame':	50 obs. of  4 variables:
# $ Murder  : num  13.2 10 8.1 8.8 9 7.9 3.3 5.9 15.4 17.4 ...
# $ Assault : int  236 263 294 190 276 204 110 238 335 211 ...
# $ UrbanPop: int  58 48 80 50 91 78 77 72 80 60 ...
# $ Rape    : num  21.2 44.5 31 19.5 40.6 38.7 11.1 15.8 31.9 25.8 ...

head(USArrests) # Nézzük meg az első 5 sorát
tail(USArrests, 10) # Vagy az utolsó 10 sorát

names(USArrests) # Adattábla változóinak nevei
row.names(USArrests) # A megfigyelések (observation) nevei
nrow(USArrests) # Megfigyelések száma

# Feltáró adatelemzés

# Nyissunk meg konkrét változókat az adattáblában
# Két fő lehetséges útja van ennek:
# Lehet úgy kezelni az adattáblát, mintha egy két dimenziós változó lenne:
USArrests[1:10, c("Murder","Assault","Rape")]

# Ezen felül használhatod a "$" jelet is, hogy meghívj egy konkrét változót az adattáblából
USArrests$Assault

# Ahhoz, hogy egy számszerűsített összefoglalást kapjunk a [Murder] változóról a USArrests adattáblában
summary(USArrests$Murder)

# Ábrázoljuk egy pont diagrammon a városi lakosság száma és a gyilkosságok miatti letartóztatások száma közötti összefüggést
plot(x = USArrests$UrbanPop, y = USArrests$Murder)

# Hozzunk létre egy lineáris modelt (későbbi órákon részletesen lesz erről szó, most a két változó közti asszociáció vizsgálatára használjuk)
USArrest_lm <- lm(USArrests$Rape ~ USArrests$UrbanPop) # Egy complex objektumot kapunk eredméynek, de minket csak az lm változó érdekel.

abline(USArrest_lm$coefficients, lty = "dashed", col = "red") # Rakjuk rá a lináris összefüggést ábrázoló piros vonalat az ábránkra.

### Csomagok (Packages)
# Ha az R-re úgy gondolunk, mint egty szerszámosládára, akkor a csomagok az egyes szerszámok, amiket valamilyen feladat megoldására fejlesztettek ki.
# Rengeteg csomagot fejlesztettek ki az R-hez, de egy egy projekt során általában csak párat fogtok használni.
# A csomagokat direkt az R-en belülről is le tudsz tölteni.
# Töltsük le például a "swirl" nevű csomagot.

install.packages("swirl") # Ez a függvény letölti a csomagot a csomagokat tároló fő gyűjteményből (CRAN)

# swirl egy remek csomag, aminek segítségével az Rstudio-n belül tanulhatsz R-t önállóan. Ajánlom, hogy próbáljátok ki!
# Ahhoz, hogy egy csomagot az adott munka során használjatok, nem elég letölteni, be is kell töltsétek (mintha kivennétek a szerszámot, a szerszámos ládából)

library(swirl) # Töltsük be a csomagot az adott munkafolyamatba (R session)

# Hogy elindítsuk a swirl-t, csak futtasd le a következő parancsot:
swirl()