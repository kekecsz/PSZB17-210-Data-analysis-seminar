
## **______Elokeszulet_______**

library(psych) # for describe
library(gsheet) # to read data from google sheets
library(tidyverse) # for tidy code

# read data
mydata = as_tibble(gsheet2tbl("https://docs.google.com/spreadsheets/d/1GXx2YoktyIdXLqKdm4f_MMWHUzXYgxWRRr3avYnWaew/edit?usp=sharing"))

# correct errors in dataset
mydata_corrected = mydata %>% 
  mutate(magassag = replace(magassag, magassag == 1.82, 182),
         cipomeret = replace(cipomeret, jelige == "___", 37))


## **______Feladatsor_1 - Eszeru linearis regresszio _______**
  
# 1. Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben 
## az **energiaszint_1** a kimeneti valtozo es az **alvas_altalaban_1** a prediktor. A modell eredmenyet mentsd el egy objektumba.

# 2. Ird le a regresszios fuggvenyt amivel bejosolhato az energiaszint.

# 3. Ertelmezd a regresszios fuggvenyt. Aki tobbet alszik annak 
# magasabb vagy alacsonyabb az energiaszintje? (Egy abra segithet)

# 4. Ertelmezd a regresszios fuggvenyt. Aki egy oraval tobbet alszik mint masok, 
# annak mennyivel varhato hogy magasabb lesz az energiaszintje?

# 5. Ennek a modellnek a segitsegevel becsuld meg az energiaszintjet olyan embereknek 
# akik altalaban 5, 7, vagy 9 orat alszanak.

# 6. Listazd ki a model summary-t a summary() fugvennyel

# 7. Olvasd le hogy a model ami tartalmazza az alvas_altalaban_1 prediktort 
# szignifikansan jobb bejosloja-e az energiaszintnek mint a null modell.

# 8. Hatarozd meg a regresszios egyutthatok konfidencia intervallumat a confint() fuggvennyel



## **______Feladatsor_2 - Tobbszoros linearis regresszio _______**

library(lm.beta) # for lm.beta
library(tidyverse) # for tidy format

# read data
data_house = read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_7/data_house_small_sub.csv")

# transform variables to Hungarian/European metrics
data_house = data_house %>% 
  mutate(price_HUF = (price * 293.77)/1000000,
         sqm_living = sqft_living * 0.09290304,
         sqm_lot = sqft_lot * 0.09290304,
         sqm_above = sqft_above * 0.09290304,
         sqm_basement = sqft_basement * 0.09290304,
         sqm_living15 = sqft_living15 * 0.09290304,
         sqm_lot15 = sqft_lot15 * 0.09290304
  )



# 9. Epits egy tobbszoros linearis regresszio modellt az lm() fugvennyel amiben az **price_HUF** a kimeneti valtozot becsuljuk meg. Hasznalhatod a **data_house** adatbazisban szereplo barmelyik valtozot felhasznalhatod a modellben, ami szerinted realisan hozzajarulhat a lakas aranak meghatarozasahoz.

# 10. Hatarozd meg, hogy szignifikansan jobb-e a modelled mint a null modell (a teljese modell F-teszthez tartozo p-ertek alapjan)?

# 11. Mekkora a teljes modell altal bejosolt varianciaarany (adj.R^2)?

# 12. Melyik az a prediktor, mely a legnagyobb hozzadaott ertekkel bir a becslesben?

