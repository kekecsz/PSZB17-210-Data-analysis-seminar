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
  geom_point(aes(shape = mpaa_rating)) # A geom-hoz is hozzáadhatunk aestheticet, ha használjuk azon belül az aes() függvényt
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

# Barplot
ggplot(data = tail(movies, 5)) + # Use the last 5 movies
  aes(x = title, y = imdb_rating) +
  geom_col() # geom_bar is ugyanazt az eredményt adja

# Pointrange
ggplot(data = tail(movies, 5)) + # Use the last 5 movies
  aes(x = title, y = imdb_rating, ymin = imdb_rating - 1, ymax = imdb_rating + 1) +
  geom_pointrange()  

# Errorbar
ggplot(data = tail(movies, 5)) + 
  aes(x = title, y = imdb_rating) +
  geom_errorbar(aes(ymin = imdb_rating - 1, ymax = imdb_rating + 1))     

# Horizontális errorbar
ggplot(data = tail(movies, 5)) + # Az utolsó 5 filmet használjuk
  aes(y = title, x = imdb_rating) +
  geom_errorbarh(aes(xmin = imdb_rating - 1, xmax = imdb_rating + 1), height = .5)   

### Statisztikai transzformációk
# A ggplot automatikusan át tudja alakítani az adataid a megfelelő formátumba az ábrázoláshoz.
# Ezt úgy képzeld el, mintha magától összesítené az adatid a megfelelő szempontok alapján

# Nézzünk egy példát!
# Minden film barplotolva a műfajok mentén.
# Nem kell meghatározd az y tengelyt, mert a ggplot automatikusan kiszámolja, hogy hány érték tartozik az adott szemponthoz (count).
# Tehát a ggplot megszámolja, hogy hány film tartozik egy adott műfajhoz.
# Aggregating and summarising data may help to understand, but inevitably causes data loss
ggplot(data = movies) +
  aes(x = genre) +
  geom_bar()

# Adds a non-linear trendline and standard error as default
ggplot(data = movies) +
  aes(x = thtr_rel_year, y = imdb_num_votes) +
  geom_point() +
  geom_smooth()

# You can also add a linear model trend ("lm"), and remove the standad error
ggplot(data = movies) +
  aes(x = thtr_rel_year, y = imdb_num_votes) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

### Pozíció (Position)
# Make a stacked bar chart that shows absolute counts
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "stack")

# You can also make the plot proportional
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "fill")

# Or present the count next to each other, so everything is comparable
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "dodge")

# Position jitter slightly scatters the data points so they become more visible. Scattering is random
ggplot(data = movies) +
  aes(x = genre, y = audience_score) +
  geom_point(position = "jitter")

### Coordinate systems
# Flip x and y
ggplot(data = movies) +
  aes(x = genre, group = critics_rating, fill = critics_rating) +
  geom_bar(position = "dodge") +
  coord_flip()

# Polar plot
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

### Metsük el az ábrát
# Mentsük el az ábrát egy objektumba ( <- ), utána használjuk a következő függvényt:
# ggsave(<objektum neve>, "<a file neve amibe mentsük>")
# Ha nem adod meg az objektum nevét, akkor az utolsó kinyomtatott ábrát menti el
ggsave(plot2, "film_plot_1.jpg")