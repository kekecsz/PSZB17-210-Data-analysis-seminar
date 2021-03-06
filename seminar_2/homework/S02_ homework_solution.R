# Házi feladat

# 1.feladat
## A házifeladat elkészítéséhez telepítsd és töltsd be a "dplyr" és a "titanic" nevű csomagokat.

# 2.feladat
## Az alábbi kóddal töltsd be a "titanic_train" nevű adattáblát és mentsd el egy "titanic_data" nevű objektumba.
## Ha problémát jelentenek a hiányzó adatok (NA), akkor érdemes a drop_na() fügvényt használni 
## azoknak a soroknak a kizárására amik hiányzó adatot tartalmaznak.
library(tidyverse)
library(titanic)

titanic_data <- titanic_train %>% 
  drop_na()


# 3.feladat
## A Titanic korának lenagyobb hajója volt. De hányan utaztak rajta? Számold ki az órán tanült függvényekkel.

titanic_data %>% 
  summarize(n = n())

# 4.feladat:
## Hányan élték túl a katasztrófát és hányan vesztették az életüket?
## Számold ki mindkét értéket és mentsd el egy "titanic_survived" nevű objektumba.
## Segítség: Ha valaki túlélte a katasztrófát, az 1-es értéket kap a "survived" változóban, aki nem az 0-ás értéket.

titanic_survived = titanic_data %>%
  group_by(Survived) %>%
  summarize(cases = n())  
titanic_survived

# 5.feladat:
## Ahhoz, hogy érthetőbb legyen az előbb kiszámolt eredmény, kódold át a 0-ás értéket "elhunyt"-ra,
## az 1-es értéket "tulelte"-re a "Survived" változóban a "titanic_survived" objektumban.

titanic_survived = titanic_survived %>% 
  mutate(Survived = recode(Survived,
                           "0" = "elhunyt",
                           "1" = "tulelte"))
titanic_survived

# 6.feladat:
## A "titanic_data" adattáblából szűrd ki csak az első osztályon utazókat.
## Az, hogy ki melyik osztályon utazik a "Pclass" változóban van.

titanic_data %>% 
  filter(Pclass == 1)

# 7.feladat:
## Rakd sorrendbe az utasokat asszerint, hogy ki mennyit fizetett a jegyért növekvő sorrendben ("Fare").

titanic_data %>% 
  arrange(Fare)

# 8.feladat:
## A "Fare" változóban dollárban van a jegyek ára. Mennyibe kerülnének most ezek a jegyek forintban?
## Számold ki (1 dollár = 300 forint), és mentsd el egy új változóba "Fare_HUF".

titanic_data_with_Fare_HUF = titanic_data %>% 
  mutate(Fare_HUF = Fare*300)

titanic_data_with_Fare_HUF
