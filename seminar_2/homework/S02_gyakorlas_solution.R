######################################
# Az 2. gyakorlat gyakorló script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20200912.R” !
## A beadási határidő minden héten vasárnap éjfél.


################### Ismétlés

# 1. Csinálj egy integer vektor objektumot, aminek a neve "number" 


number <- c(3, 4)


# 2. Ellenőrizd hogy mi az is.character(number) kód eredménye(!) milyen osztályba tartozik.

is.character(number)
class(is.character(number))

################### Alapvető funkciók és subsetting

# 3. Mentsd el a USArrests adattábla sorainak neveit egy új objektumként aminek az a neve 
#   hogy row_names

row_names = row.names(USArrests)
row_names


# 4. Egy fügvénnyel nézd meg hány elemből áll ez a row_names objektum

length(row_names)

# 5. Egy fügvénnyel nézd meg milyen ennek az objektumnak az osztálya

class(row_names)

# 6. Csinálj egy új objektumot, ami egy olyan adattáblát tartalmaz, ami 
#    a USArrests objektumnak csak az "UrbanPop" és "Rape" oszlopait tartalmazza
#    (legyen az objektum neve **USArrests_UrbanPop_Rape**).

USArrests_UrbanPop_Rape = USArrests[,c("UrbanPop", "Rape")]

# 7. Listázd ki az **USArrests_UrbanPop_Rape** adattáblának az utolsó 8 sorát

tail(USArrests_UrbanPop_Rape,8)

# 8. (EXTRA) Nézd meg hogy populáció hány százaléka lakik városokban "Colorado" és "Mississippi" államokban?

USArrests[c("Colorado","Mississippi"),"UrbanPop"]

################### Tidiverse alapfunkciók

# 9. Listázd ki, hogy a ToothGrowth adatbázisban ha csak azokat az aranyhörcsögöket 
#    nézzük amik aszkorbinsavval (supp == "VC")  kapták a c-vitamint, dózisonként (dose)
#    külön mekkora volt a fogméret (len, vagy len_cm). Mindezt egy chain-en belül csináld
#    meg a %>% operátor használatával
install.packages("dplyr")
install.packages("tidyverse")
library(tidyverse)
library(dplyr)

ToothGrowth %>% 
  filter(supp == "VC") %>% 
  group_by(dose) %>% 
  select(len) 
