#####################################
# A 8. gyakorlat gyakorlo script-je #
#####################################


### Elokeszuletek

# toltsuk be a packageket

library(tidyverse)

# housing adatok betoltese es atalakitasa

data_house = read.csv("https://bit.ly/2DpwKOr")

data_house %>% 
  summary()

data_house = data_house %>% 
  mutate(price_mill_HUF = (price * 293.77)/1000000,
         sqm_living = sqft_living * 0.09290304,
         sqm_lot = sqft_lot * 0.09290304,
         sqm_above = sqft_above * 0.09290304,
         sqm_basement = sqft_basement * 0.09290304,
         sqm_living15 = sqft_living15 * 0.09290304,
         sqm_lot15 = sqft_lot15 * 0.09290304
  )

# kezdeti housing predikcios modell epites

mod_house_geolocation_cond = lm(price_mill_HUF ~ sqm_living + grade + long + lat + condition, data = data_house)

# weightloss adatok betoltese

data_weightloss = read.csv("https://tinyurl.com/weightloss-data")

### Gyakorlofeladat - modellosszehasonlitas

# 1. Tedd hozza a modellosszehasonlitas reszben elpitett modellhez (mod_house_geolocation_cond)
# a haz epitesenek evet (yr_built) es a furdoszobak szamat (bathrooms) mint prediktorokat.

# 2. Ez az uj modell szignifikansan jobban illeszkedik az adatokhoz mint a korabbi modellek?


### Gyakorlofeladat - specialis prediktorok

# 1. A data_house adattablat hasznalva epits egy linearis regresszios modellt a lakas eladasi
# aranak (price) bejoslasara a kovetkezo prediktorokkal:  sqm_living, grade, has_basement.

# 2. Ertelmezd a fentiek alapjan a regresszios egyutthatok tablazatat. 
# 2.a. Mit jelent az intercept regresszios egyutthatoja? 
# 2.b. Mit jelent a has_basement prediktorhoz tartozo regresszios egyutthato?

# 3. Epits egy modellt a data_weightloss adatbazison ahol a **BMI_post_treatment**-t becsuljuk meg 
# a **motivation** es a **body_acceptance** prediktorokkal, a ket prediktor interakciojat is epitsd be a modellbe. 

# 4. Ertelmezd a regresszios egyutthatokat.
# 4.a. Milyen valtozast varhatunk a BMI szintjeben ha a motivation szintje 1-el no?
# 4.b. Milyen valtozast varhatunk a BMI szintjeben ha a body_acceptance szintje 1-el no?
# 4.c. van szignifikans interakcio a ket prediktor kozott?
# 4.d. Hogyan ertemezhetjuk az interakciohoz tartozo regresszios egyutthatot?

# 5. A haz eladasi arakat tartalmazo adatbazison kiserletezz kulonbozo modellekkel a sajat elmeleteid
# alapjan hogy mi befolyasolhatja a hazak/lakasok arat. Probald meg az adjusted R^2-et 52% fole novelni.
# Ha szeretnel az eredeti teljes adatbazishoz hozzaferest kapni amin ellenorizheted melyik modell mukodik legjobban,
# a Kaggle-on megtalalod az eredeti adatokat, es masok regresszios modelljeit. https://www.kaggle.com/harlfoxem/housesalesprediction/activity




