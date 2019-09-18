# Második óra

# Első órai ismétlés
## Változó típusok (variable types) R-ben

# karakter (character): "Ez egy karakter érték"
# faktor (factor): Egy karater változó rögzített értékekkel
# szám (numeric): 2 vagy 13.5
# egész szám (integer): 2L (Az L mondja meg az R-nek, hogy az előtte lévő számot, mint egész számot kezelje)
# logikai változó (logical): TRUE vagy FALSE
# complex számok (complex): 1+5i

## A változó típúsát milyen fügvénnyel tudjuk ellenőrizni?
integer <- 4

# Egész szám típusú változó az "integer" nevű objektum, amit létrehoztunk?
# Ellenőrizd le a múlt órán tanult függvénnyel!


# Nem csak általánosságban tudjuk megnzni, hogy milyen típusú változó egy objektum,
# hanem konkrétan rá is tudunk kérdezni:
is.integer(integer) # Ehhez általában az is.[változó típus, ami érdekel minket] formulát tudjuk használni.
# A függvény paramétere pedig a változó, amit vizsgálni akarunk.

# Milyen típusú változó az is.integer(integer) kód eredménye? Ellenőrizd le!

# Gratulálok! Befejeztük az ismétlést.

# Adatstruktúrák R-ben

# vektorok (atomic vector): Minden elemének ugyanaz kell legyen a típusa
# listák (list): Elemének különböző típusai lehetnek
# mátrix (matrix): Két dimenziós vektor (mindig csak egy típusú változó lehet benne)
# adattábla (dataframe): Két dimenziós vektor, ahol a sorok és az oszlopok el vannak nevezve (több típusú változó is lehet benne)

# Adattáblák (Data frames)
# Az R-ben vannak előre beépített adattáblák is. Próbáljunk betölteni egyet!

USArrests <- USArrests
USArrests  # Nézzük meg az adattáblát

# Ha kíváncsiak vagyunk arra, hogy mit jelentenek a változók a beépített adattáblákban:
?USArrests

# Ha ez egy kicsit zavarosnak tűnik, nyisd meg az adattáblát máshogy:
View(USArrests)

str(USArrests) # Nézzük meg az adattábla struktúráját, hogy milyen változók vannak benne, hány megfigyelés stb.
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
# Lehet úgy kezelni az adattáblát, mintha egy két dimenziós változó (vector) lenne:
USArrests[1:10, c("Murder","Assault","Rape")]

# Ezen felül használhatod a "$" jelet is, hogy meghívj egy konkrét változót az adattáblából
USArrests$Assault

# Ahhoz, hogy egy számszerűsített összefoglalást kapjunk a [Murder] változóról a USArrests adattáblában
summary(USArrests$Murder)

# Ábrázoljuk egy pont diagrammon a városi lakosság száma és a gyilkosságok miatti letartóztatások száma közötti összefüggést
plot(x = USArrests$UrbanPop, y = USArrests$Murder)

# Hozzunk létre egy lineáris modelt (későbbi órákon részletesen lesz erről szó, most a két változó közti asszociáció vizsgálatára használjuk)
USArrest_lm <- lm(USArrests$Murder ~ USArrests$UrbanPop) # Egy complex objektumot kapunk eredméynek, de minket csak az lm változó érdekel.

abline(USArrest_lm$coefficients, lty = "dashed", col = "red") # Rakjuk rá a lináris összefüggést ábrázoló piros vonalat az ábránkra.

# Ismerkedjünk az adattáblákkal
# Próbáld meg minél több féle módon kinyomtatni a "USArrests" adattábla 3. oszlopát:

# Töltsd be az "iris" nevű beépített adattáblát:

# Mekkora az első változójának az átlaga (átlagot a mean() függvénnyel):

# A pipe operátor

# A pipe ( %>% ) operátorral több sornyi kódot tudunk összekötni egymással.
# A pipe előtt lévő függvény eredményét olvassa be a pipe utáni következő függvény.
# Több csomag is használja a pipe operátort, a egyik ilyen a "magrittr"
library(magrittr)

# Hozzunk létre egy vektort:
x <- c(55:120, 984, 552, 17, 650)

# És a pipe operátor használatával több függvényt sorban alkalmazzunk rá:
x %>%
  sort() %>%
  subtract(5) %>%
  divide_by(3) %>%
  mean()

# [1] 36.32381

# Adatrendezés
# Töltsük be a "dplyr" csomagot, amit adatrendezésre találtak ki:
library(dplyr)

# Most a ToothGrowth nevű beépített adattáblát fogjuk használni, hogy megtanuljuk a függvények használatát.
ToothGrowth <- ToothGrowth

# Miről szól az adattábla
?ToothGrowth

# Válasszunk ki azokat az eseteket, ahol narancslével adták be a C-vitamint:
ToothGrowth %>%
  filter(supp == "OJ")

# Hozzunk létre egy új változót, ami nem mm-ben, hanem cm-ben tárolja a fogak hosszát
ToothGrowth %>%
  mutate(len_cm = len / 10)

# Most nézzük meg, hogy mennyi a fogak átlaghossza cm-ben.
# Ehhez használjuk a summarise() függvényt.
# Ez a függvény összesíti az adatokat, azonban az összesítés során az eredeti adatokat nem tartja meg.
ToothGrowth %>%
  mutate(len_cm = len / 10) %>%
  summarise(mean_len_cm = mean(len_cm))

# A summarise függvényben az n() függvényt használva meg tudjuk számolni azt is, hogy hány esetünk van.
ToothGrowth %>%
  mutate(len_cm = len / 10) %>%
  summarise(mean_len_cm = mean(len_cm),
            n_cases = n())

# A group_by() függvényt használva pedig valamilyen szempont szerint tudjuk csoportosítani az adataink.
# Ezután az R a csoportokon belül végzi el külön a számításokat.
tooth_results <-
  ToothGrowth %>%
  mutate(len_cm = len / 10) %>%
  group_by(supp) %>%
  summarise(mean_len_cm = mean(len_cm),
            cases = n())

# Ezen felül használhatod a group_by() függvényt a mutate() függvény előtt is.
# Ebben az esetben az összesített adatokat csoportonként hozzáadja az adatokhoz és
# nem írja felül az eredeti adatokat. Így viszont redundancia lesz az adatokban.
ToothGrowth %>%
  mutate(len_cm = len / 10) %>%
  group_by(supp) %>%
  mutate(mean_len_cm = mean(len_cm),
         cases = n())

# Ezen felül egy bizonyos változó értékei mentén sorba is rendezhetjük az adatokat.
tooth_results %>% 
  arrange(mean_len_cm)

# Ha a mínusz jelet a változó elé rakjuk, akkor csökkenő sorrendbe rakja az értékeket, növekvő helyet.
tooth_results %>% 
  arrange(-mean_len_cm)

# Végül kiválaszhatunk bizonyos változókat, ha csak azokat szeretnénk megtartani.
ToothGrowth %>%
  select(supp, len)

# A mínusz jellel pedig törölhetünk egy adott változót
ToothGrowth %>%
  select(-dose)

# Válasszunk pozíció alapján változót (inkább használjunk neveket)
ToothGrowth %>% select(1, 2)
ToothGrowth %>% select(2:3)

# A select() függvénynek vannak segítő függvényei is, amivel szöveg részletek alapján tudunk választani több változót.
ToothGrowth %>% select(starts_with("d", ignore.case = TRUE)) 

# A select() függvényhez hasonlóan át is nevezhetsz bizonyos változókat a rename() függvénnyel.
ToothGrowth %>% rename(new_name = dose)

# Változók újrakódolása
# A case_when() függvénnyel diszkrét változókat tudunk újra kódolni.
ToothGrowth %>% 
  mutate(dose_descriptive = case_when(dose == 0.5 ~ "small",
                                      dose == 1.0 ~ "medium",
                                      dose == 2.0 ~ "large",
                                      TRUE ~ NA_character_))

# Adatok tisztítása
library(tidyr)
library(tibble)

# A második órához tartozó slide-okon találsz leírást a hosszú és széles adatformátumról.

# Ehhez a who adatokat fogjuk használni
who <- who
?who

# A gather() függvénnyel hosszú formátumba (long) tudjuk alakítani az adatokat.
who_long <- 
  who %>% 
  gather(key = variable, value = value, new_sp_m014:newrel_f65)

# Láthatjátok, hogy rengeteg hiányzó adat van (NA). Ezeket a drop_na() függvénnyel kizárhatjuk.
# Az adattáblában minden változó ugyanolyan hosszú kell legyen. Ezért ahol nincs adat, ott az R NA értéket tárol.
who_long <- 
  who_long %>% 
  drop_na(value)

# Az adatok leírása alapján sok nem tidy adat van tárolva az adattáblánkban.
# Például a "new_" szöveg a változók nevében nem hordoz semmilyen információt.
# Így azt eltávolíthatjuk.
# A karaktereken (string) való mindenféle operációhoz a stringr csomagot használjuk.
library(stringr)

who_long <-
  who_long %>% 
  mutate(variable = str_replace(variable, "new_",""))

# Most a variable változó 3 fontos infromációt tartalmaz:
## a teszt eredményét (test_restult)
## a nemet (gender)
## és az életkort (age)

# Először a teszt eredmény válasszuk el a nemtől és a kortól.
# Ehhez a separate() függvényt használjuk.

who_long <-
  who_long %>% 
  mutate(variable = str_replace(variable, "new_","")) %>% 
  separate(col = variable, into = c("test_result","gender_age"), sep = "_")

# Most válasszuk el a nemet a kortól.
# A nemhez kiemeljük a szöveg változó első karakterét.
# A korhoz a 2. karatertől a 4-ig.
who_tidy <-
  who_long %>% 
  mutate(gender = gender_age %>% substring(1, 1),
         age = gender_age %>% substring(2))

# Most megnézhetjük, hogy milyen különböző korcsoportjaink vannak.
who_tidy %>% 
  distinct(age)

# Feladat:
# Alakítsuk át az "age" változót karater változóvá a következő formátumba: 014 -> "0-14"
# Az adattábla leírásában megtalálhatod a kor változó leírását.

# Végül a spread() függvénnyel visszaalakíthatjuk széles formátumú adatokká.
who_tidy %>% 
  spread(age, value)

# Most a titanic adattáblán fogunk gyakorolni
library(titanic)

titanic_data <- titanic_train
?titanic_data

# Mennyi volt a hajón utazó utasok közül a férfiak és nők átlag életkora?

# Hozz létre egy age_group nevű változót, amiben a következő csoportokba kerülnek életkoruk szerint az utasok:
## 0-14
## 15-21
## 22-35
## 36-50
## 50-63
## 64+

# Nézd meg, hogy hányan élték túl a különböző osztályokon utazó utasok közül?

# Osztályonként melyik korcsoportban élték túl a legtöbben?