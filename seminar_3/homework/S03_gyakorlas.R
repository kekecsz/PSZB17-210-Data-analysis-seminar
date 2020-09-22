######################################
# Az 3. gyakorlat gyakorló script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20200912.R” !
## A beadási határidő minden héten vasárnap éjfél.


### Ismétlés: Adatkezelés a tidyverse-ben #

# 
# 1. Töltsd be a tidyverse csomagot!

# 2. Telepítsd és töltsd be a “gapminder” csomagot!


# A gapminder adatbázist fogjuk hazsnálni, 
# ami országonkánt 5 évente adatokat tartalmaz a lakosság méretéről,  
# a várható élettartamról, és az egy főre eső GDP-ről 1952-ig visszamenőleg.

# 3. Nézd meg a gapminder adattáblát hogy képet kapj arról, mi az adatok elnrednezése!
# (Használhatod a View és az str parancsokat például)

# 4. Szűrd meg az adatokat úgy hogy csak a 2007-ből (year) származó adatokkal dolgozzunk,
# és számold ki az átalagos várható életkort (lifeExp) kontinensenként (continent) 
# ezeken a 2007-es adatokon. 
# Ez alapján az eredmény alapján melyik kontinensen volt a legmagasabb 
# a várható életkor 2007-ben?

# 6. Nézd meg, hogy hány mérés tartozik az egyes országokhoz (country). 
# (Segítség: Minden mérés egy sor.)

# 7. Hogy könnyebben átlássuk a populációt, hozz létre egy “pop_thousand” nevű változót,
# amiben a meglévő populáció értékek (pop) el vannak osztva ezerrel. Az adattáblát amiben már
# ez az új változó is benne van mentsd el egy új objektumba amit 
# “gapminder_with_pop_thousand”-nak nevezz el.

### Adatvizualizáció #

# Használjuk a movies adatbázist a következő gyakorlófeladatokhoz.

load(url("https://stat.duke.edu/~mc301/data/movies.Rdata"))

# 8. Ábrázold az összefüggést az IMDB értékelések (imdb_rating) és a 
# között hogy egy adott filmre hány értékelés jött (imdb_num_votes).

# 9. Alakítsd úgy a fenti ábrát hogy a műfaj (genre) hatása is szerepeljen rajta.

# 10. Hozz létre egy ábrát, melyet egy "my_first_plot" nevű objektumhoz rendelj hozzá.
# Ezen az ábrán vizsgáld meg kritikusok által adott értékelás (critics_score) eloszlását.
# Tetszőleges geomot használhatsz. A ggplot2 cheatsheet segíthet kitalálni, melyik 
# a legjobb geom erre a célra. 
# https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# Tipp: a critics_score egy folytonos (continuous) változó. Mivel egy változó eloszlását 
# vizualizáljuk, ezért érdemes a cheatsheet "One Variable" dobozából választani geomot.

# 11. Most módosítsd az ábrát úgy, hogy legyen látható, hogy az eloszlás hogyan különbözik
# azoknál a filmeknél amiket jelöltek a legjobb film oszkárdíjra (best_pic_nom) azokhoz 
# képest amelyeket nem. Ehhez használj tetszőleges aes()-t, pl.: color, fill, linetype, 
# size. A ggplot2 cheatsheet segít hogy az általad választott geomnál melyik a releváns aes()


# 12. Ábrázold a nézői értékelés (audience_score) és a kritikusi értékelés 
# (critics_score) kapcsolatát egy pontdiagrammal úgy, hogy csak az 
# 1995-ben megjelent (thtr_rel_year) filmek szerepeljenek az ábrán.

# 13. Tedd rá a filmek címét az ábrára feliratként, 
# hogy minden ponton szerepeljen a film címe.

# 14. Most ábrázoljuk csak a legnagyobb bevételt behozó filmeket (top200_box == "yes"). 
# Nézzük meg, hogy melyik film milyen imdb pontot kapott (imdb_rating). A filmek címe (title) szerepeljen az egyik 
# tengelyen és legyen olvasható.
