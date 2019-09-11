# Első óra

## Az órai anyag elkészítéséhez felhasználtuk a következőket:
### http://alyssafrazee.com/2014/01/02/introducing-R.html
### https://github.com/nthun/Data-analysis-in-R-2019-20-1/blob/master/Lecture%201%20-%20R%20101.R

#### Bevezetés az R nyelvbe
# Gondolhatunk úgy az R programra, mint egy számológépre...

21 + 16

# Ha lefuttatod a fenti kódot láthatod, hogy az eredménye a következő:
# [1] 37

# Biztosan észrevetted, hogy az a szöveg, amelyik "#" jellel kezdődik más színű, mint a többi.
# Ezek a kommentek. Akárhány kommentet rakhatsz a kódodba, hogy érthetőbb legyen mások és a jövő beli önmagad számára.
# Egy sort kommentelni a ctrl + shift +c billentyűparanccsal is tudsz.

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

# Hozz létre egy "number" nevű változót, amibe a 88 as számot mented el és vond ki a number1 és Number2 összegéből!

# Az R-ben vannak függvények is (function), amelyek mint egy parancsot értelmezhetünk.
# A függvényeknek általában több paramétere van, amellye meghatározhatjuk, hogy hogyan viselkedjen a függvény.
# Ha egy függvényt szeretnél használni, a neve beírása után zárójeleket "()" kell használj.
# Még akkor is, ha nincsenek paraméterei.
# Példaként lássuk, hogy milyen függvényeket kell használjunk, egy ábra elkészítéséhez.

# Először kellenek valamilyen adatok, amiket az ábránkon ábrázolhatunk...
# A rnorm()fügvénnyel 1000 random számot hozunk létre, amelyeknek az átlaga 100, és a szórása 10.
# Tehát ennek a függvénynek 3 paramétere van (hány számot generáljon, mi legyen ezeknek az átlaga és a szórása). 

# A függvény eredményét elmentjük az "x" nevű objektumba (object).
x <- rnorm(1000, mean = 100, sd = 10) 

x # használjuk az objektum nevét, hogy kinyomtassuk a függvény eredményét a konzolba (consoles)
# A változó eloszlását egy histogramként ábrázolhatjuk.
# Az ábrázoló függvény csak egy paramétert kér, az adatokat, az ábrázolához, de még többet is használhatsz, hogy szebbé tedd az ábrád.
hist(x)

# Mit tegyünk, ha elakadtunk?

?hist # Ezt használva láthatjuk a függvény leírását, és hogy milyen paramétereket használhatunk.

# Ha tudod mit szeretnál csinálni, de nem tudod a függvény nevét, két kérdőjelet használj
??histogram

# Milyen paraméterei vannak a plot() fügvénynek?


# De a Google is nagyon hasznos segítség tud lenni, ha megakadtál.
## Angolul tedd fel a kérdéseid.
## A kérdésed után általábaban érdemes odaírni, hogy "in r".
## Két oldal ahol általában megtalálod a választ:
### stackoverflow.com
### https://community.rstudio.com/

### Fesd az előbbi histogram oszlopait pirosra. Hívd segítségül az internetet a probléma megoldására.

# Adat típusok (type)

# Egy szám vektor (numeric vector)
numbers <- c(10, 11, 12, 13, 14, 15, 16, 17, 18, 19) # Létrehozunk egy szám vektort
# A c() fügvénnyel tudunk elemeket összefűzve elmenteni egy vektorba

numbers # Nyomtassuk ki a konzolba a vektor tartalmát
# [1] 10 11 12 13 14 15 16 17 18 19 

# Hozz létre egy "x" nevű vektort,amiben a számok egytől háromig vannak.

# Szorozd be az "x" vektort a "numbers" vektorral. A szorzás eredményét mentsd el egy "y" nevű vektorba.

# Nézzük meg hány elem (value) van a numbers nevű vektorban
length(numbers)
# [1] 10

# Ahhoz, hogy leellenőrizd egy változó típusát, használd a class() függvényt
class(numbers)

# Hány elem van az "y" nevű vektorban? És milyen típusú?

# Egy vektor típusát meg tudod változtatni.
# Például ahhoz, hogy szöveg vektort csinálj egy másik vektorból, használd az as.character() függvényt.

# A "z" változóba ments el az "y" vektort, de változtasd meg a típusát szöveg vektorrá.

# Nézzük meg a "z" vektor tartalmát.

# Mi lesz az eredménye annak, ha megszorozzuk a "z" vektort 10-el?

# Hozzunk létre egy szöveg vektort (character vector). Figyelj a "" jelre. Ez jelöli azt, hogy szövegről van szó. Használhatod a '' jelet is, de a kezdő és végződő jelnek ugyanannak kell lennie.
fruits <- c("apple", 'apple', "banana", "kiwi", "pear", "strawberry", 'strawberry')
print(fruits) # Nyomtassuk ki a szöveg változó tartalmát a print() függvényt használva
print("Hello world!") # Létrehoztuk az első R-ben írt "Hello word!" programunk!

# Milyen típusú a "fruits" nevű vektor?

# Indexelés (Indexing)
# Válasszuk ki a "fruits" objektum harmadik elemét
fruits[3]
# Az indexeléshez a [] jelet használjuk

# Válasszuk ki az első, harmadik és ötödik elemét a vektornak
fruits[c(1,3,5)]

# Távolítsuk el az első 3 és a 7. elemet
fruits[-c(1:3, 7)]

# Válaszd ki a fruits változó 2. és 5. elemét.

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