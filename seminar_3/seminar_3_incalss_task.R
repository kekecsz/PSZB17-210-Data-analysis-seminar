# Harmadik óra

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

# A mutate() függvény változatai

# A mutate függvény különböző változataival több változót is megváltozhtathatunk egyszerre!
# A mutate_all() az összes változót egyszerre megváltoztathatjuk
ToothGrowth %>% 
  mutate_all(.funs = list(~ as.character(.)))

# A mutate_at bizonyos változókra használ egy függvényt
ToothGrowth_factor <-
  ToothGrowth %>% 
  mutate_at(.funs = list(~ as.factor(.)), .vars = vars(supp, dose))

# Most leelenőrizhetjük, hogy tényleg faktor típusra változtattuk-e a supp és dose változókat.
is.factor(ToothGrowth_factor$dose)

# És megnézhetjük a faktor változó különböző szintjeit
levels(ToothGrowth_factor$dose)

# A mutate_if() függvény csak azokra a változókra használ egy függvényt, amelyek eleget tesznek egy feltételnek.
ToothGrowth %>% 
  mutate_if(.predicate = is.factor, .funs = list( ~ stringr::str_to_lower(.)))