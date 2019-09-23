# Negyedik óra

# Harmadik órai ismétlés

# Gratulálok! Befejeztük az ismétlést.

# Adatok tisztítása
library(tidyr)
library(tibble)

# A negyedik órához tartozó slide-okon találsz leírást a hosszú és széles adatformátumról.

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

# Adatok beolvasása R-be
# Kívülről is be tudunk olvasni adatok az R-be. Ehhez a "readr" nevű csomagot fogjuk használni.
# A "readr" csomag a "tidyverse" nevű csomagcsalád része, így ha azt telepítetted és betöltötted,
# akkr a "readr" csomagot nem kell külön betölteni.

# Gyakorlás képpen most mégis töltsd be a readr csomagot:

# Ahhoz, hogy értelmezhető formátumba tudjuk beolvasni az adatokat az R-be, fontos,
# hogy odafigyeljünk az adatfájlunk formátumára.

# Egy gyakori fájlformátum, amiben adatokat tárolnak a .csv (comma separated values).
# Ebben a formátumban az adatok szövegként vannak eltárolva,
# és a különböző változókat és értékeket vesszők választják el.

# A másik fontos tényező, amire az adatok beolvasásánál oda kell figyeljünk,
# hogy pontosan határozzuk meg az adatfájlunk helyét (path) a számítógépünkön.

# .csv fájlokat a readr csomag read_csv() függvényével tudunk beolvasni.
# Ennek első paramétere a fájlunk elérési útja. Ezt mindig "" között kell beírni!

# A saját számítógépeteken írjátok be a ti elérési utatok ahhoz, hogy a függvény működjön.
read_csv("dataset/.csv")

# A beolvasásnál nem rendeltük (assign) hozzá a beolvasott adatokat egy objektumhoz.
# Tehát most próbáljuk meg a következőt:
survey_data <- read_csv("dataset/.csv")

# Ahhoz, hogy elmentsük az adattáblánk .csv formátumban, használjuk a readr csomag write_csv függvényét.
# Először az objektum nevét írjuk be, amelyiket ki akarunk írni.
# Azután a helyet a számítógépen, ahova menteni akarjuk és a nevét a fájlnak a formátummal.
write_csv(survey_data, "dataset/my_first_saved_data.csv")

# .tsv formátumban is el tudjuk menteni a fájlt. Ehhez a write_tsv() függvényt használhatjuk.
# A .tsv (tab separated value) ugyanaz, mint a .csv csak vesszők helyett tabulátorral ("\t") vannak elválasztva az értékek.

write_tsv(survey_data, "dataset/my_first_saved_data.tsv")

# Fontos, hogy a magyar excelben nem vesszővel elválasztott értékeket ment el a program,
# ha a csv-be való mentést választjuk, hanem pontos vesszővel elválasztott értékeket.
# Ezek beolvasásához a read_csv2() függvényt használjuk.

# Ahhoz, hogy excel táblázatot olvassunk be, használjuk a "readxl" csomagot.
library(readxl)

read_xlsx(path = "dataset/my_first_saved_data.xlsx", sheet = 1)