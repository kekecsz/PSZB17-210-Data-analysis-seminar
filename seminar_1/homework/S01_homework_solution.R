# Házi feladat

## Töltsd le ezt a kódot a saját számítógépedre
## A kész házi feladatot mentsd el a saját Drive mappádba. A fájl neve ez legyen: 
## Családnév Utónév házi feladat ÉÉÉÉHHNN, pl.: “Példa Géza házi feladat 20200912.R” ! 

# 1.feladat
## Hozz létre egy objektumot "my_first_vector" néven, amiben benne vannak a számok egytől 120-ig.
## (Segítség: Nem kell egyesével beírni a számokat. Az órai anyagban megtaláljátok a megfejtést.)

my_first_vector = 1:120

# 2.feladat
## Milyen típusú adat a "my_first_vector" nevű objektum?

class(my_first_vector)
typeof(my_first_vector)

# 3.feladat
## Ellenőrizd egy fügvénnyel, hogy tényleg 120 szám van-e benne.

length(my_first_vector)

# 4.feladat: EXTRA HÁZI (nem kötelező)
## Mentsd ki a "my_first_vector" első 20 elemét egy "my_second_vector" nevű obejktumba.

my_second_vector = my_first_vector[1:20]

# 5.feladat: EXTRA HÁZI (nem kötelező)
## Töltsd le a "tidyverse" nevű packaget és töltsd be.

install.packages("tidyverse")
library(tidyverse)
