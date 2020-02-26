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

# Húsvéti tojás
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


