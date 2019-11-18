#################################################################
#################################################################
#   Hazi feladat a modelosszehasonlitas es prediktorok temaban  #
#################################################################
#################################################################

# 1. Toltsd be a szukseges package-eket

library(tidyverse)

# 2. Toltsd be a King's County lakaseladasokkal foglalkozo adattablat ("https://bit.ly/2DpwKOr")

data_house = read.csv("https://bit.ly/2DpwKOr")

data_house %>% 
  summary()

# 3. Alakitsd at az adatokat ugy hogy dollar helyett forintban legyen a price valtozo, es negyzetlab helyett 
# negyzetmeterben szerepljenek az adatok (ez a kovetkezo valtozokat erinti: 
# sqft_living, sqft_lot, sqft_above, sqft_basement, sqft_living15, sqft_lot15) (1 negyzetlab = 0.ö9 m^2)

data_house = data_house %>% 
  mutate(price_mill_HUF = (price * 293.77)/1000000,
         sqm_living = sqft_living * 0.09290304,
         sqm_lot = sqft_lot * 0.09290304,
         sqm_above = sqft_above * 0.09290304,
         sqm_basement = sqft_basement * 0.09290304,
         sqm_living15 = sqft_living15 * 0.09290304,
         sqm_lot15 = sqft_lot15 * 0.09290304
  )

# 4. Az ingatlankozvetito ceg egyik ugyfelenek ket lakasa van. 
# Az egyik lakas paramaterei: A lakas Kings County-ban talalhato, 80 m^2 a lakoresz teruletu, 2 haloszoba es 2 furdoszoba van a lakasban, a grade erteke 7-es, es egy pince is tartozik hozza.
# A masik lakas parameterei: A lakas szinten Kings County-ban talalhato, 100 m^2 a lakoresz teruletu, 3 haloszoba es 2 furdoszoba van a lakasban, a grade erteke viszont csak 5-os, es nincs pinceje.
# Az ugyfel kerdese, hogy mennyi penzt ernek ezek a lakasok a piacon. Valaszold meg az ugyfel kerdeset
# egy regresszios modell alapjan.

mod_house = lm(price_mill_HUF ~ sqm_living + bedrooms + bathrooms + grade + has_basement, data = data_house)

client_data = as.data.frame(rbind(c(80, 2, 2, 7), 
                              c(100, 3, 2, 5)))
has_basement = c("has basement", "no basement")
clinet_data = cbind(client_data, has_basement)
names(clinet_data) = c("sqm_living", "bedrooms", "bathrooms", "grade", "has_basement")

predictions = predict(mod_house, newdata = clinet_data)

cbind(client_data, predictions)

# 5. Az ugyfel arra is kivancsi, hogy megeri-e renovaltatni a lakasait. Arra szamit, hogy a felujitott lakasok
# grade erteke 2 ponttal magasabb lesz. Mennyi erteknovekedesre szamithat e miatt?

coef(mod_house)["grade"]*2

### Varhatoan 39.49 millio forinttal emelkedik a lakasok ara azutan hogy 2 szinttel megno a "grade" ertekuk



# 6. Az ingatlankozvetito ceg azzal bizott meg, hogy a epits nekik egy uj bejoslo modellt, ami a leheto
# legjobban elorejelzi a lakas eladasi arat. Az adatbazis barmelyik valotozojat hasznalhatod prediktorkent, 
# es hasznalhatod a specialis prediktorok reszben tanult kulonbozo prediktorfajtakat is. Torekedj minel magasabb
# bejoslo erore (de ovakodj a tulillesztestol, ne engedj tul nagy felxibilitast a modellednek, pl. azzal hogy
# masodiknal magasabb hatvany-prediktort teszel a modellbe)!
# Ehhez a feladathoz valoszinuleg tobb modellt is ki fogsz probalni, a probalkozasaidat (amik lefutnak) 
# hagyd benne a kodban, hogy latsszon, milyen modellekkel probalkoztal.

mod_house_2 = lm(price_mill_HUF ~ sqm_living + bedrooms + bathrooms + grade + has_basement, data = data_house)
summary(mod_house_2)

mod_house_3 = lm(price_mill_HUF ~ sqm_living + bedrooms + bathrooms + grade + has_basement + condition, data = data_house)
summary(mod_house_3)

AIC(mod_house_2)
AIC(mod_house_3)

mod_house_FINAL = lm(price_mill_HUF ~ sqm_living + bedrooms + bathrooms + grade + has_basement + yr_built + lat * long, data = data_house)
summary(mod_house_FINAL)

AIC(mod_house_2)
AIC(mod_house_FINAL)

# 7. Az ingatlankozvetito ceg legnagyobb rivalisa eloallt a sajat bejoslo modelljevel. A kiszivargott
# informaciok alapjan ok ezt a modellt hasznaljak a vetelar bejoslasara: 
# lm(price_mill_HUF ~ sqm_living + grade + long + lat + condition, data = data_house)
# Hatarozd meg hogy az altalad az elozo feladatban epitett modell szignifikansan jobban
# illeszkedik-e az adatokhoz, mint a rivalisok modellje (kozold a ket modell adjusted R^2 mutatojat,
# es az osszehasonlitashoz hasznalt modellilleszkedesi mutatot)

mod_rival = lm(price_mill_HUF ~ sqm_living + grade + long + lat + condition, data = data_house)
summary(mod_rival)
AIC(mod_rival)
AIC(mod_house_FINAL)

### A mod_house_FINAL altal megmagyarazott varianciaarany 53.6%, mig a rivalis ceg mod_rival-ja altal megmagyarazott varianciaarany csak 50.66%.
### A mod_house_FINA szignifikansan jobb modell-illeszkedest mutat (AIC = 2076.88) a mod_rival-hoz kepest (AIC = 2085.33).

