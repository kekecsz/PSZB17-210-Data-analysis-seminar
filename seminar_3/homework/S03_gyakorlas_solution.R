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
library(tidyverse)

# 2. Telepítsd és töltsd be a “gapminder” csomagot!

library(gapminder)

# A gapminder adatbázist fogjuk hazsnálni, 
# ami országonkánt 5 évente adatokat tartalmaz a lakosság méretéről,  
# a várható élettartamról, és az egy főre eső GDP-ről 1952-ig visszamenőleg.

# 3. Nézd meg a gapminder adattáblát hogy képet kapj arról, mi az adatok elnrednezése!
# (Használhatod a View és az str parancsokat például)

View(gapminder)
str(gapminder)

# 4. Szűrd meg az adatokat úgy hogy csak a 2007-ből (year) származó adatokkal dolgozzunk,
# és számold ki az átalagos várható életkort (lifeExp) kontinensenként (continent) 
# ezeken a 2007-es adatokon. 
# Ez alapján az eredmény alapján melyik kontinensen volt a legmagasabb 
# a várható életkor 2007-ben?

gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
  summarize(lifeExp = mean(lifeExp))


# 6. Nézd meg, hogy hány mérés tartozik az egyes országokhoz (country). 
# (Segítség: Minden mérés egy sor.)

gapminder %>%
  group_by(country) %>% 
  summarize(n = n())

# 7. Hogy könnyebben átlássuk a populációt, hozz létre egy “pop_thousand” nevű változót,
# amiben a meglévő populáció értékek (pop) el vannak osztva ezerrel. Az adattáblát amiben már
# ez az új változó is benne van mentsd el egy új objektumba amit 
# “gapminder_with_pop_thousand”-nak nevezz el.

gapminder_with_pop_thousand = gapminder %>%
  mutate(pop_thousand = pop/1000)
gapminder_with_pop_thousand

### Adatvizualizáció #

# Használjuk a movies adatbázist a következő gyakorlófeladatokhoz.

load(url("https://stat.duke.edu/~mc301/data/movies.Rdata"))

# 8. Ábrázold az összefüggést az IMDB értékelések (imdb_rating) és a 
# között hogy egy adott filmre hány értékelés jött (imdb_num_votes).

movies %>% 
  ggplot()+
  aes(x = imdb_rating, y = imdb_num_votes) +
  geom_point()

# 9. Alakítsd úgy a fenti ábrát hogy a műfaj (genre) hatása is szerepeljen rajta.

movies %>% 
  ggplot()+
  aes(x = imdb_rating, y = imdb_num_votes, color = genre) +
  geom_point()


# 10. Hozz létre egy ábrát, melyet egy "my_first_plot" nevű objektumhoz rendelj hozzá.
# Ezen az ábrán vizsgáld meg kritikusok által adott értékelás (critics_score) eloszlását.
# Tetszőleges geomot használhatsz. A ggplot2 cheatsheet segíthet kitalálni, melyik 
# a legjobb geom erre a célra. 
# https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# Tipp: a critics_score egy folytonos (continuous) változó. Mivel egy változó eloszlását 
# vizualizáljuk, ezért érdemes a cheatsheet "One Variable" dobozából választani geomot.

my_first_plot = movies %>% 
  ggplot()+
    aes(x = critics_score) +
    geom_density()
my_first_plot

# 11. Most módosítsd az ábrát úgy, hogy legyen látható, hogy az eloszlás hogyan különbözik
# azoknál a filmeknél amiket jelöltek a legjobb film oszkárdíjra (best_pic_nom) azokhoz 
# képest amelyeket nem. Ehhez használj tetszőleges aes()-t, pl.: color, fill, linetype, 
# size. A ggplot2 cheatsheet segít hogy az általad választott geomnál melyik a releváns aes()

my_first_plot +  aes(color = best_pic_nom)


# 12. Ábrázold a nézői értékelés (audience_score) és a kritikusi értékelés 
# (critics_score) kapcsolatát egy pontdiagrammal úgy, hogy csak az 
# 1995-ben megjelent (thtr_rel_year) filmek szerepeljenek az ábrán.

movies %>% 
  filter(thtr_rel_year == 1995) %>% 
  ggplot() +
  aes(x = audience_score, y = critics_score) +
  geom_point()


# 13. Tedd rá a filmek címét az ábrára feliratként, 
# hogy minden ponton szerepeljen a film címe.

movies %>% 
  filter(thtr_rel_year == 1995) %>% 
  ggplot() +
  aes(x = audience_score, y = critics_score, label = title) +
  geom_point() +
  geom_label()


# 14. Most ábrázoljuk csak a legnagyobb bevételt behozó filmeket (top200_box == "yes"). 
# Nézzük meg, hogy melyik film milyen imdb pontot kapott (imdb_rating). A filmek címe (title) szerepeljen az egyik 
# tengelyen és legyen olvasható.
movies %>% 
  filter(top200_box == "yes") %>% 
ggplot() +
  aes(x = title, y = imdb_rating) +
  geom_bar(stat = "identity") +
  coord_flip()


