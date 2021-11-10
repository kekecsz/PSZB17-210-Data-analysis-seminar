#####################################
# A 10. gyakorlat gyakorlo script-je #
#####################################


### Elokeszuletek

# toltsuk be a packageket

library(psych) # for describe
library(tidyverse) # for tidy code and ggplot	
library(lme4) # for lmer() mixed models
library(lmerTest)  # for significance test on lmer() mixed models
library(cAIC4) # for cAIC
library(r2glmm) # for r2beta
library(MuMIn) # for r.squaredGLMM

# toltsuk be a sajat funkciot a standardizalt beta kinyeresehez

stdCoef.merMod <- function(object) {
  sdy <- sd(getME(object,"y"))
  sdx <- apply(getME(object,"X"), 2, sd)
  sc <- fixef(object)*sdx/sdy
  se.fixef <- coef(summary(object))[,"Std. Error"]
  se <- se.fixef*sdx/sdy
  return(data.frame(stdcoef=sc, stdse=se))
}

# Olvassuk be az adatokat (egy .csv kiterjesztésű file-ból). Az adatokat az alábbi linkről tölthetjük le: "https://tinyurl.com/data-pain1".

# Ez az adatsor a műtét utáni fájdalom mértékéről, és az ezzel feltételezhetően összefüggő néhány egyéb értékekről tartalmaz információkat.

# Változóink:
  
# - ID: résztvevő azonosítója
# - pain1, pain2, pain3, pain4: A használt adatsorban a fájdalom a műtét utáni négy egymást követő napon volt mérve egy 0tól-10ig terjedő folytonos vizuális skálán.
# - sex: a résztvevő bejelentett neme
# - STAI_trait: A résztvevő State Trait Anxiety Inventroy-n elért pontszáma
# - pain_cat: fájdalom katasztrofizálása
# - cortisol_serum; cortisol_saliva: A kortizol egy a stress hatására előállított hormon. A kortizol szintet vérből és nyálból, közvetlenül a műtét után határozták meg.
# - mindfulness: A Mindfulness kérdőív alapján a résztvevőre jellemző Mindfulness érték
# - weight: résztvevő tömege kg-ban.
# - IQ: Résztvevő IQ-ja a műtét előtt egy héttel felvett IQ teszt alapján
# - household_income: résztvevő háztartásának bevétele USD-ben

read_csv("https://tinyurl.com/data-pain1")

### Feladatok

# 1. Alakítsuk adatainkat hosszú formátumúvá (célszerű a gather() vagy a melt() függvények valamelyikét használni erre a célra), hogy az egyes megfigyelések külön sorba kerüljenek.

# 2. Állítsunk össze egy kevert lineáris modellt, hogy amivel képesek vagyunk a műtét utáni fájdalom varianciájának lehető legjobb lefedésére. (A műtét utáni fájdalom meghatározásához tetszőleges fix prediktort választhatunk, amennyiben annak feltehetően van valami köze a fájdalom mértékéhez.) Mivel az adataink résztvevőnként klaszteres szerkezetet mutatnak, modellünkben vegyük figyelembe a résztvevők azonosítóját mint random effect prediktort. 

# 3. Kísérletezzünk mind a random intercept, mind pedig a random slope modellekkel, majd hasonlítsuk össze őket a cAIC() függvény felhasználásával.

# 4. Alkossunk olyan random intercept és random slope modelleket, ahol az egyetlen prediktor az idő (műtét óta eltellt napok száma). Vizualizáljuk a modelljeink alapján kapott regressziós vonalakat, minden résztvevőre külön-külön, és hasonlítsuk össze hogyan illeszkednek a megfigyeléseinkre. Van bármi előnye ha az időt külön változó hatásként vizsgáljuk a random slope modellben, vagy elegendő a random intercept használata?

# 5. Hasonlítsuk össze a modelleket a cAIC() alapján is!

# 6. Mi a marginális R^2 érték a random intercept modell esetében? A marginális R^2 konfidencia intervalluma alapján a modellünk szignifikánsan jobb-e mint a null modell?
