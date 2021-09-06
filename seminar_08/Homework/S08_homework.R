#################################################################
#################################################################
#   Hazi feladat a modelosszehasonlitas es prediktorok temaban  #
#################################################################
#################################################################

# 1. Toltsd be a szukseges package-eket

# 2. Toltsd be a King's County lakaseladasokkal foglalkozo adattablat ("https://bit.ly/2DpwKOr")

# 3. Alakitsd at az adatokat ugy hogy dollar helyett forintban legyen a price valtozo, es negyzetlab helyett 
# negyzetmeterben szerepljenek az adatok (ez a kovetkezo valtozokat erinti: 
# sqft_living, sqft_lot, sqft_above, sqft_basement, sqft_living15, sqft_lot15) (1 negyzetlab = 0.09 m^2)
# (ezt a kodot megtalalod az orai anyagokban is)

# 4. Az ingatlankozvetito ceg egyik ugyfelenek ket lakasa van. 
# Az egyik lakas paramaterei: A lakas Kings County-ban talalhato, 80 m^2 a lakoresz teruletu, 2 haloszoba es 2 furdoszoba van a lakasban, a grade erteke 7-es, es egy pince is tartozik hozza.
# A masik lakas parameterei: A lakas szinten Kings County-ban talalhato, 100 m^2 a lakoresz teruletu, 3 haloszoba es 2 furdoszoba van a lakasban, a grade erteke viszont csak 5-os, es nincs pinceje.
# Az ugyfel kerdese, hogy mennyi penzt ernek ezek a lakasok a piacon. Valaszold meg az ugyfel kerdeset
# egy regresszios modell alapjan.

# 5. Az ugyfel arra is kivancsi, hogy megeri-e renovaltatni a lakasait. Arra szamit, hogy a felujitott lakasok
# grade erteke 2 ponttal magasabb lesz. Mennyi erteknovekedesre szamithat e miatt?

# 6. Az ingatlankozvetito ceg azzal bizott meg, hogy a epits nekik egy uj bejoslo modellt, ami a leheto
# legjobban elorejelzi a lakas eladasi arat. Az adatbazis barmelyik valotozojat hasznalhatod prediktorkent, 
# es hasznalhatod a specialis prediktorok reszben tanult kulonbozo prediktorfajtakat is. Torekedj minel magasabb
# bejoslo erore (de ovakodj a tulillesztestol, ne engedj tul nagy felxibilitast a modellednek, pl. azzal hogy
# masodiknal magasabb hatvany-prediktort teszel a modellbe)!

# 7. Az ingatlankozvetito ceg legnagyobb rivalisa eloallt a sajat bejoslo modelljevel. A kiszivargott
# informaciok alapjan ok ezt a modellt hasznaljak a vetelar bejoslasara: 
# lm(price_mill_HUF ~ sqm_living + grade + long + lat + condition, data = data_house)
# Hatarozd meg hogy az altalad az elozo feladatban epitett modell szignifikansan jobban
# illeszkedik-e az adatokhoz, mint a rivalisok modellje (kozold a ket modell adjusted R^2 mutatojat,
# es az osszehasonlitashoz hasznalt modellilleszkedesi mutatot)
