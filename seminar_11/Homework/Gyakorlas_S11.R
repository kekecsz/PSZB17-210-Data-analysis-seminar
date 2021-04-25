######################################
# A 11. gyakorlat gyakorlo script-je #
######################################

# Totsd be a Human Styles Questionnaire adatbazist 

hsq <- read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_11/hsq.csv")

# 1. Szamitsd ki a Human Styles Questionnaire 32 kerdesenek korrelacios matrixat, es mentsd el egy objektumba.
# Figyelj oda hogy ordinalis valtozokrol van szo, ezert erdemes a mixedCor() funciot hasznalni erre a celra.

# 2. Az oran tanultak alapjan vizualizald a valtozok kozotti korrelaciot. Hasznalj tobb modszert is, 
# pl. ggcorr(), ggcorrplot() hc.order=TRUE-val kombinalva, vagy network_plot().



# Toltsd be a Big Five Inventory (bfi) adatbazist. A psych package-ben talalhato ez az adatbazis,
# ezert ezt a package-et be kell toltened. Ez az adatbazis 2800 szemely valaszait tartalmazza a 
# Big Five szemelyisegkerdoiv kerdeseire. 
# Az elso 25 oszlop a kerdoiv kerdeseire adott valaszokat tartalmazza, az utolso harom oszlop 
# (gender, education, es age) pedig demografiai kerdeseket tartalmaz. 
# A reszleteket az egyes itemekhez tartozo kerdesekrol es a valaszok kodolasarol
# elolvashatod ha lefuttatod a ?bfi parancsot.
# Ebben a feladatban csak az elso 25 oszlopot hasznald, az eredeti kerdoiv kerdeseit. 

library(psych)

data(bfi) # load the dataset

?bfi # view the description of the dataset

my_data_bfi = bfi[,1:25] # select the first 25 columns

# 3. Vegezz el feltaro faktorelemzest, es ez alapjan hatarozd meg, hany faktor megtartasa
# az idealis, mely faktorokra mely itemek toltenek leginkabb, es ez alapjan hogyan 
# nevezned el a faktorokat. 

# 4. Ird le egy comment-ben melyek a faktorstruktura altal leginkabb es a legkevesbe
# reprezentalt itemek?

