# Harmadik óra

# Második órai ismétlés
## Telepítsd és töltsd be a "gapminder" csomagot!

## Töltsd be a gapminder adattáblát!

## Nézzük most csak a legfrissebb adatokat. Szűrd ki csak a 2007-ből (year) változó adatokat.

## Számold ki az átalagos várható életkort (lifeExp) kontinensenként (continent).

## Minden országhoz ugyanannyi mérés tartozik? Nézd meg, hogy hány mérés tartozik az egyes országokhoz.
## Segítség: Minden mérés egy sor.

## Hogy könnyebben átlássuk a populációt, hozz létre egy "pop_thousand" nevű változót,
## amiben a meglévő populáció értékek el vannak osztva ezerrel.

# Gratulálok! Befejeztük az ismétlést.

# Adatok ábrázolása

# Filmekről szóló adatokat fogunk ábrázolni
# Egyből az internetről olvassuk be az adatokat a környezetbe (environment)
load(url("https://stat.duke.edu/~mc301/data/movies.Rdata"))

# Nézzük meg az adattáblát
movies

# Telepítsük fel az ábrázoláshoz használt "ggplot2" nevű csomagot és töltsük be.
install.packages("ggplot2")
library(ggplot2)

# Segítséget a ggplot cheatsheeten találsz. Több csomaghoz is van ilyen, érdemes rájuk keresni!
# https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

# Mennyire értenek egyet a nézők a kritikusokkal?
# Hívjuk be az adatokat, amiket ábrázolni akarunk
ggplot(data = movies) + # A ggplotba a sorok végén "+" jelet használunk ahhoz, hogy új elemet adjunk hozzá az ábránkhoz
  aes(x = audience_score,
      y = critics_score) + # Az "aesthetics" paranccsal határozzuk meg, hogy az adattáblából melyik változókat akarjuk ábrázolni
  geom_point() # A "geom_" paranccsal rajzoljuk ki az aktuális ábrát (hogyan ábrázoljuk a választott változókat)

# Az ábránkat is, mint minden mást R-ben elmenthetünk egy objektumba
# Csak akkor fog megjelenni az ábra így, amikor meghívjuk az objektumot
plot1 <- 
  ggplot(data = movies) +
  aes(x = audience_score, y = critics_score, color = genre) + # Adjuk hozzá a műfajt, mint színt
  geom_point(aes(shape = mpaa_rating)) # A geom-hoz is hozzáadhatunk aesthetic-et, ha használjuk azon belül az aes() függvényt
# Most a pontok formáját változtatjuk meg asszerint, hogy milyen a korhatáros besorolása a filmnek
# A geom-on belül hozzáadott aes() csak az adott geom-ra vonatkozik

# Megnézhetjük az elkészített ábrát az objektum meghívásával
plot1

# Ha konstans értékeket akarsz használni, (tehát azt akarod, hogy NE az adatok határozzanak megy egy aesthetics-et, hanem az állandó legyen),
# akkor az aes() függvényen kívül meghatározhatod azt.
ggplot(data = movies) +
  aes(x = audience_score, y = critics_score, color = genre) +
  geom_point(shape = "+", aes(size = log10(imdb_num_votes))) # Viszont nem lehet ugyanaz az aesthetics állandó és változókon alapuló is

# Gyakorlás
## Nézzük meg, hogy van-e összefüggés az IMDB értékelések (imdb_rating) és az IMDB értékelések száma (imdb_num_votes) között.

## Nézd meg, hogy a műfaj (genre) releváns-e az előbbi összefüggésnél.

### Más geomok is vannak
# Egyszerű hisztogramm
ggplot(data = movies) +
  aes(x = runtime) + # Itt csak egy folyamatos változót kér az R
  geom_histogram()

# Egy sűrűségi ábra (density plot)
ggplot(data = movies) +
  aes(x = runtime, group = title_type, fill = title_type) +
  geom_density(alpha = .5) #Az alpha-val azt adjuk meg, hogy mennyire átlátszó az ábra, 0-1 közötti értéket vehet fel

# Doboz ábra
ggplot(data = movies) +
  aes(y = audience_score, x = mpaa_rating) +
  geom_boxplot() # A doboz ábra (boxplot) a mediánt mutatja középen, és az adatok szóródását körülötte

# Gyakorlás
## Hozz létre egy ábrát és mentsd el "my_first_plot" néven.
## Vizsgáld meg, hogy van-e összefüggés a film hossza (runtime) és a kritikusok által adott pontok között (critcs_score).
## Tetszőleges geomot használj hozzá.

# Hegedű ábra (ugyanaz, mint a doboz ábra) (violin plot)
ggplot(data = movies) +
  aes(y = audience_score, x = mpaa_rating, fill = mpaa_rating) +
  geom_violin()

# Vonal ábra (line plot)
ggplot(data = head(movies, 20)) + # Csak az első 20 értéket választjuk ki
  aes(y = imdb_rating, x = thtr_rel_year) +
  geom_line(size = 2) +
  geom_point(size = 5, color = "red") # Több geomot is használhatunk egyszerre
# Itt a méret és a szín állandó értékek

# Adatok előkészítése ábra készítésre
## A ggplot egy pipe végére is berakható, így előkészítheted az adatokat, amit ábrázolni akarsz
# Töltsük be a dplyr nevű csomagot
library(dplyr)

## Például válasszuk ki azokat a filmeket, amelyek 1995-ben jelentek meg.
movies %>% 
  filter(thtr_rel_year == 1995) %>% 
  ggplot() + # Figyelj rá, hogy a ggplot() függvény után már "+" jelet kell használni, és nem a pipe-ot!
  aes(x = critics_score,
      y = audience_score) +
  geom_point()

# Szöveg ábrára rakása
ggplot(data = head(movies, 20)) + 
  aes(y = imdb_rating, x = thtr_rel_year, label = title) +
  geom_line(size = 2) +
  geom_point(size = 5, color = "green") + 
  geom_text()

# Cimke (label)
ggplot(data = head(movies, 20)) + 
  aes(y = imdb_rating, x = thtr_rel_year, label = title) +
  geom_line(size = 2) +
  geom_point(size = 5, color = "blue") +
  geom_label()

# Gyakorlás
## Írjuk rá az 1995-ös filmeket ábrázoló ábrán lévő pontokra a film címét, amit ábrázolnak.


# Barplot
ggplot(data = tail(movies, 5)) + # Nézzük meg a listánkban lévő utolsó öt filmet
  aes(x = title, y = imdb_rating) +
  geom_col() # geom_bar is ugyanazt az eredményt adja

# Gyakorlás
## Hasonlítsuk össze, hogy egymáshoz képest a különböző film kritikákat leközlő oldalak (critics_rating) milyen pontokat adnak (critics_score).

# Pointrange
ggplot(data = tail(movies, 5)) + 
  aes(x = title, y = imdb_rating, ymin = imdb_rating - 1, ymax = imdb_rating + 1) +
  geom_pointrange()  

# Errorbar
ggplot(data = tail(movies, 5)) + 
  aes(x = title, y = imdb_rating) +
  geom_errorbar(aes(ymin = imdb_rating - 1, ymax = imdb_rating + 1))     

# Horizontális errorbar
ggplot(data = tail(movies, 5)) + 
  aes(y = title, x = imdb_rating) +
  geom_errorbarh(aes(xmin = imdb_rating - 1, xmax = imdb_rating + 1), height = .5)   

### Statisztikai transzformációk
# A ggplot automatikusan át tudja alakítani az adataid a megfelelő formátumba az ábrázoláshoz.
# Ezt úgy képzeld el, mintha magától összesítené az adatid a megfelelő szempontok alapján

# Nézzünk egy példát!
# Minden film barplotolva a műfajok mentén.
# Nem kell meghatározd az y tengelyt, mert a ggplot automatikusan kiszámolja, hogy hány érték tartozik az adott szemponthoz (count).
# Tehát a ggplot megszámolja, hogy hány film tartozik egy adott műfajhoz.
ggplot(data = movies) +
  aes(x = genre) +
  geom_bar()

# # Hozzáadhatunk egy nem lineáris trendet mutató vonalat
# Illetve a vonal körül szürkén a standard hiba látható
ggplot(data = movies) +
  aes(x = thtr_rel_year, y = imdb_num_votes) +
  geom_point() +
  geom_smooth()

# Házzadhatunk egy lineáris trendet mutató vonalat
# És levehetjük a standard hibát
ggplot(data = movies) +
  aes(x = thtr_rel_year, y = imdb_num_votes) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

### Pozíció (Position)
# Hozzunk létre egy halmozott barplotot (stacked bar), ami a mennyiséget mutatja
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "stack")

# De arányként (proportion) is megmutathatjuk a csoportok mennyisége közti összefüggést
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "fill")

# Vagy ábrázoljuk egymás mellett a mennyiséget, hogy könnyebben összehasonlíthatók legyenek a csoportok
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "dodge")

# A szétszórás (position jitter) segítségével random zajt adhatunk az adatokhoz, így az átfedéseket megszűntetve
# jobban látjuk az adatpontokat
ggplot(data = movies) +
  aes(x = genre, y = audience_score) +
  geom_point(position = "jitter")

### Koordináta rendszerek
# Cseréljük meg az x és y koordinátákat
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "dodge") +
  coord_flip()

# Gyakorlás
## Most ábrázoljuk a legnagyobb bevételt behozó filmeket csak.
## Nézzük meg, hogy melyik film milyen imdb pontot kapott. A filmek címe szerepeljen az egyik tengelyen és legyen olvasható.

# Polar ábra
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "fill") +
  coord_polar()

# Több ábra készítése egyszerre (faceting)
# A facetelésnél valamilyen adatokban lévő szempont alapján több ábrát vizsgálunk meg egyszerre
ggplot(data = movies) +
  aes(y = imdb_rating, x = imdb_num_votes) +
  geom_point(size = 2) +
  facet_wrap(~title_type) # Figyelj rá, hogy a faceteléshez felhasznált változó elé "~" jelet kell tenni!

# Két változót is használhatunk a faceteléshez, az első a sor, a második az oszlop
ggplot(data = movies) +
  aes(y = imdb_rating, x = runtime) +
  geom_point() +
  facet_grid(title_type ~ critics_rating)

### Témák használata (Themes)
# Több téma is van, amellyel meghatározhatjuk az ábra kinézetét
# Próbáljuk ki őket! Adjuk hozzá akármelyik eddig készített ábrához.
plot1 + theme_minimal()
plot1 + theme_light()
plot1 + theme_dark()

### Skálák (Scales)
# Folytonos (continuous) skála
ggplot(data = movies) +
  aes(y = genre, x = thtr_rel_month) +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 1:12)
# A breaks paraméterrel meghatározhatjuk, hogy melyik értékekné legyen (tick)

# Diszkrét (discrete) skála
ggplot(data = movies) +
  aes(x = genre, y = thtr_rel_month) +
  geom_point(size = 3) +
  coord_flip() +
  scale_y_discrete()

# Az skálát több aesthetic-hez is beállíthatjuk, mint a feltöltéshez (fill) és a színhez (color)
plot2 <-
  ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_fill_brewer(palette = "YlOrRd")

plot2

# Több színpaletta érhető el az interneten. Ezeket is használhatjuk, de mi magunk is készíthetünk ilyet.
# Mentsük el a hex színkódokat egy változóba szövegként:
my_palette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# Ez egy színvakok számára is használható paletta. Érdemes ilyet használni.

# Majd használjuk fel őket az ábránkon
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_fill_manual(values = my_palette) # nem a brewer, hanem a manual függvényt használjuk ilyenkor

### Metsük el az ábrát
# Mentsük el az ábrát egy objektumba ( <- ), utána használjuk a következő függvényt:
# ggsave(<objektum neve>, "<a file neve amibe mentsük>")
# Ha nem adod meg az objektum nevét, akkor az utolsó kinyomtatott ábrát menti el
ggsave(plot2, "film_plot_1.jpg")

# Húsvét tojás
install.packages("gganimate")
install.packages("gifski")
install.packages("png")
library(gifski)
library(png)
library(gganimate)

# Először csináljunk egy hagyományos ábrát
my_plot <- 
  ggplot(data = movies) +
  aes(x = imdb_rating,
      y = critics_score) +
  geom_point()

my_plot

# Majd animáljuk azt
my_anim_plot <- 
  my_plot +
  transition_states(genre,
                    transition_length = 2,
                    state_length = 1)

my_anim_plot
