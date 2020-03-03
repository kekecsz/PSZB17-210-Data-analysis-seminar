## Házi feladat

# 1.feladat
## A házifeladat elkészítéséhez telepítsd és töltsd be a "tidyverse", és a "gapminder" nevű csomagokat.
library(tidyverse)
library(gapminder)

# 2.feladat
## Számold ki, hogy mekkora volt átlagos várható életkor (lifeExp) kontinensenként (continent) 2007-ben. 
## (A mean() funkcióval tudod az átlagot kiszámolni)

gapminder %>% 
  group_by(continent) %>% 
  summarize(mean = mean(lifeExp))

# 3.feladat:
## Szűrd az adatbázist úgy hogy csak az 1967-ből származó adatokkal dolggozzunk 
## és azokkal az adatokkal ahol az emberenkénti GDP (gdpPercap) kisebb mint 50000.
## ezen a szűrt adatbázison ábrázold a várható élettartam és a gdpPercap
## összefüggését egy pontdiagramon (scatterplot).
## Az egyes megfigyelések (pontok) a kontinensek szerint legyenek beszínezve.

gapminder %>%
  filter(year == "1967", gdpPercap < 50000) %>% 
  ggplot() +
  aes(x = gdpPercap, y = lifeExp, color = continent) +
  geom_point()


# 4.feladat:
## Ábrázold a 2007-es évben az emberenkénti GDP-t (gdpPercap) kontinensenként egy sűrűségi ábrán (density plot).

gapminder %>%
  filter(year == 2007, gdpPercap < 50000) %>% 
  ggplot() +
  aes(x = gdpPercap, fill = continent) +
  geom_density()


# 5.feladat:
## Ábrézold egy doboz ábrát (boxplot) használva, hogy milyen a várható élettartam eloszlása 
## kontinensenként 1952-ben. 
## Minden "doboznak" legyen ugyan az a színe (válassz egy színt ami nem fehér).
## Hogy jól látsszon, mennyi adatpontból származnak az adatok, rakd rá az ábrára az egyes adatpontokat is.
## Az ábrát kétféle módon is készítsd el, egyszer a geom_point() másszor a geom_jitter() használatával rakd
## az ábrára az adatpontokat (a width = ) paraméterrel tudod kontrollálni, milyen távolságra szórja a pontokat
## a geom_jitter().

gapminder %>%
  filter(year == "1952") %>% 
  ggplot() +
  aes(x = continent, y = lifeExp) +
  geom_boxplot(color = "orange", fill = "orange") +
  geom_point()

gapminder %>%
  filter(year == "1952") %>% 
  ggplot() +
  aes(x = continent, y = lifeExp) +
  geom_boxplot(color = "orange", fill = "orange") +
  geom_jitter(width = .2)


# 6.feladat:
## Számold ki az átlagos várható élettartamot kontinensenként külön minden mérési évre, majd ábrázold
## ezt az átlagos várható élettartam változását az évek során egy vonal ábrával (geom_line) úgy, hogy
## a színek a különböző országokat ábrázolják. 

gapminder %>%
  group_by(year, continent) %>% 
  summarize(mean = mean(lifeExp)) %>% 
  ggplot() +
  aes(x = year, y = mean, color = continent) +
  geom_line()

# 7.feladat: 
## Értelmezd az ábrát. Ez alapján melyik kontinensen nőtt leginkább a várható élettartam 1952 és 2007 között?

#### Az ábra alapján úgy tűnik ázsiában

## Melyik kontinensen látható leginkább törés a várható élettartam növekedésében?

#### Az ábra alapján úgy tűnik Afrikában.
