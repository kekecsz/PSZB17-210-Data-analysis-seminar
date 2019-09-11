# Második óra

# Adattáblák (Data frames)
# Az R-ben vannak előre beépített adattáblák is. Próbáljunk betölteni egyet!

data("USArrests") # A data() függvény betölti az előre beépített adattáblát. Ez az USA-ban történt letartóztatásokról szól.
USArrests  # Nézzük meg az adattáblát

# Ha ez egy kicsit zavarosnak tűnik, nyisd meg az adattáblát máshogy:
View(USArrests)

str(USArrests) # ENézzük meg az adattábla struktúráját, hogy milyen változók vannak benne, hány megfigyelés stb.
# 'data.frame':	50 obs. of  4 variables:
# $ Murder  : num  13.2 10 8.1 8.8 9 7.9 3.3 5.9 15.4 17.4 ...
# $ Assault : int  236 263 294 190 276 204 110 238 335 211 ...
# $ UrbanPop: int  58 48 80 50 91 78 77 72 80 60 ...
# $ Rape    : num  21.2 44.5 31 19.5 40.6 38.7 11.1 15.8 31.9 25.8 ...

head(USArrests) # Nézzük meg az első 5 sorát
tail(USArrests, 10) # Vagy az utolsó 10 sorát

names(USArrests) # Adattábla változóinak nevei
row.names(USArrests) # A megfigyelések (observation) nevei
nrow(USArrests) # Megfigyelések száma

# Feltáró adatelemzés

# Nyissunk meg konkrét változókat az adattáblában
# Két fő lehetséges útja van ennek:
# Lehet úgy kezelni az adattáblát, mintha egy két dimenziós változó lenne:
USArrests[1:10, c("Murder","Assault","Rape")]

# Ezen felül használhatod a "$" jelet is, hogy meghívj egy konkrét változót az adattáblából
USArrests$Assault

# Ahhoz, hogy egy számszerűsített összefoglalást kapjunk a [Murder] változóról a USArrests adattáblában
summary(USArrests$Murder)

# Ábrázoljuk egy pont diagrammon a városi lakosság száma és a gyilkosságok miatti letartóztatások száma közötti összefüggést
plot(x = USArrests$UrbanPop, y = USArrests$Murder)

# Hozzunk létre egy lineáris modelt (későbbi órákon részletesen lesz erről szó, most a két változó közti asszociáció vizsgálatára használjuk)
USArrest_lm <- lm(USArrests$Murder ~ USArrests$UrbanPop) # Egy complex objektumot kapunk eredméynek, de minket csak az lm változó érdekel.

abline(USArrest_lm$coefficients, lty = "dashed", col = "red") # Rakjuk rá a lináris összefüggést ábrázoló piros vonalat az ábránkra.