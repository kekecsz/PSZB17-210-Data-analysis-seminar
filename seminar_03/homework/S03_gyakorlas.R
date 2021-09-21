######################################
# Az 3. gyakorlat gyakorló script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20210921.R” !


### Ismétlés: Adatkezelés a tidyverse-ben #

# 
# 1. Töltsd be a tidyverse csomagot!

### Adatvizualizáció #

# Használjuk a lovoo adatbázist a következő gyakorlófeladatokhoz.

lovoo_data <- read.csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_03/lovoo_v3_users_api-results.csv")


lovoo_data <- lovoo_data %>% 
  mutate(isOnline = factor(isOnline),
         verified = factor(verified),
         isNew = factor(isNew))

# 2.a Szűrd az adatokat úgy, hogy csak azoknak a felhasználóknak az adata látsszon, akik nyitottak a randizásra (flirtInterests_date == "true")
# 2.b Ábrázold az összefüggést az életkor (age) és a profilmegtekintések száma (counts_profileVisits) között egy pontdiagrammon.
# 2.c Az ábrán az is szerepeljen, hogy a profil külső forrásból megerősített-e (verified).
# 2.d Illessz egy trendvonalat is az ábrára (geom_smooth), amin belül a method = "lm"-paramétert használd.



# 3.a Szűrd az adatokat, hogy csak a külső forrásból megerősített felhasználók adatai szerepeljenek benne (verified == 1)
# 3.b Hozz létre egy ábrát, melyet egy "my_first_plot" nevű objektumhoz rendelj hozzá. Ezen az ábrán vizsgáld meg a feltöltött képek számának (counts_pictures) eloszlását. Tetszőleges geomot használhatsz. A ggplot2 cheatsheet segíthet kitalálni, melyik a legjobb geom erre a célra. 
# https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf
# Tipp: a counts_pictures egy folytonos (continuous) változó. Mivel egy változó eloszlását vizualizáljuk, ezért érdemes a cheatsheet "One Variable" dobozából választani geomot.
# 3.c Most módosítsd az ábrát úgy, hogy legyen látható, hogy az eloszlás milyen az új felhasználóknál és a reégieknél (isNew) Ehhez használj tetszőleges aes()-t, pl.: color, fill, linetype, size. A ggplot2 cheatsheet segít hogy az általad választott geomnál melyik a releváns aes()


