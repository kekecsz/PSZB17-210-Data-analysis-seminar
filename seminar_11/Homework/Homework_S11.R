
#################################################################
#  Hazi feladat a fokomponenselemzes es faktorelemzes temaban   #
#################################################################


# 1. Toltsd be a szukseges package-eket, es sajat funkciokat. 
# Az alabbi package-ekre peldaul szukseged lehet:

library(tidyverse) # for tidy code
library(GGally) # for ggcorr
library(corrr) # network_plot
library(ggcorrplot) # for ggcorrplot
library(FactoMineR) # multiple PCA functions
library(factoextra) # visualisation functions for PCA (e.g. fviz_pca_var)
library(paran) # for paran

library(psych) # for the mixedCor, cortest.bartlett, KMO, fa functions
library(GPArotation) # for the psych fa function to have the required rotation functionalities
library(MVN) # for mvn function
library(ICS) # for multivariate skew and kurtosis test


# 2. Toltsd be a Big Five Inventory (bfi) adatbazist. 
# 
# Ez a psych package-be beepitett adatbazis, ami 2800 szemely valaszait 
# tartalmazza a Big Five szemelyisegkerdoiv kerdeseira. Az elso 25 oszlop a kerdoiv kerdeseire
# adott valaszokat tartalmazza, az utolso harom oszlop (gender, education, es age) pedig
# demografiai kerdeseket tartalmaz
#
# A reszleteket az egyes itemekhez tartozo kerdesekrol es a valaszok kodolasarol elolvashatod
# ha lefuttatod a ?bfi parancsot.

?bfi

data(bfi)
my_data_bfi = bfi[,1:25]

# 3. Ebben a hazi feladatban az a feladatod, hogy vegezz feltaro faktorelemzest
# az adatokon, es hatarozd meg az itemek mogott megbuvo latens faktorokat. 
# 
# Eloszor keszitsd el az adatok korrelacios matrixat (itt is a "Polychoric Correlation"-t
# kell hasznalni, mert az kerdoivre adott valaszok ordinalis skalajuak). Mentsd el ezt a
# korrelacios matrixot egy onjektumba, es innen ezen a korrelacios matrixon futtasd a faktor-
# elemzest. Ha a mixedCor() funkciot hasznalod a korrelacios matrix eloallitasara, annak
# a $rho komponenseben talalod a korrelacios matrixot.

# 4. Vizualizald a korrelaciokat legalabb egy vizualizacios modszerrel

# 5. Hatarozd meg hogy faktorizalhatoak-e az adatok a Kaiser-Meyer-Olkin
# teszt alapjan. Indolkold meg a dontesedet.

# 6. Ellenorizd hogy az adatok tobbvaltozos normalis eloszlast kovetnek-e. 
# Az eredmeny alapjan hataroz meg, melyik faktorextrakcios modszert fogod hasznalni.

# 7. Hatarozd meg az idealis faktorszamot

# 8. Vegezd el a faktorextrakciot az altalad valasztott modszerrel es faktorszammal.
# Epits ket kulonbozo modellt, az egyikben ortoginalis, a masikat oblique
# faktorrotaciot hasznalva.

# 9. Ellenorizd a kommunalitasokat. Mekkora az talagos kommunalitas?

# 10. Vizualizald a ket modell altal produkalt faktorstrukturat es a faktortolteseket
# a ?bfi parancs segitsegevel nezheted meg az egyes valtozokhoz tartozo pontos
# kerdeseket.
# Mi a kulonbseg a ket faktorszerkezet kozott?



