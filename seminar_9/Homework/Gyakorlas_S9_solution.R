#####################################
# A 8. gyakorlat gyakorlo script-je #
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


data <- read_csv("https://tinyurl.com/data-pain1")

view(data)
### Feladatok

# 1. Alakítsuk adatainkat hosszú formátumúvá (célszerű a gather() vagy a melt() függvények valamelyikét használni erre a célra), hogy az egyes megfigyelések külön sorba kerüljenek.

data_long = data %>% 
  gather(key = days, value = pain_rating, pain1:pain4) %>% 
  arrange(ID)

data_long

data_long = data_long %>% 	
  mutate(days = recode(days,	
                       "pain1" = 1,	
                       "pain2" = 2,	
                       "pain3" = 3,	
                       "pain4" = 4))	

view(data_long)
# 2. Állítsunk össze egy kevert lineáris modellt, hogy amivel képesek vagyunk a műtét utáni fájdalom varianciájának lehető legjobb lefedésére. (A műtét utáni fájdalom meghatározásához tetszőleges fix prediktort választhatunk, amennyiben annak feltehetően van valami köze a fájdalom mértékéhez.) Mivel az adataink résztvevőnként klaszteres szerkezetet mutatnak, modellünkben vegyük figyelembe a résztvevők azonosítóját mint random effect prediktort. 

mod_rnd_int_1 = lmer(pain_rating ~ days + pain_cat + cortisol_serum + cortisol_saliva + weight + (1 | ID), data = data_long)

# 3. Kísérletezzünk mind a random intercept, mind pedig a random slope modellekkel, majd hasonlítsuk össze őket a cAIC() függvény felhasználásával.

mod_rnd_int_1 = lmer(pain_rating ~ days + pain_cat + cortisol_serum + cortisol_saliva + weight + (1 | ID), data = data_long)
mod_rnd_slp_1 = lmer(pain_rating ~ days + pain_cat + cortisol_serum + cortisol_saliva + weight + (days|ID), data = data_long)

cAIC(mod_rnd_int_1)$caic
cAIC(mod_rnd_slp_1)$caic

# 4. Alkossunk olyan random intercept és random slope modelleket, ahol az egyetlen prediktor az idő (műtét óta eltellt napok száma). Vizualizáljuk a modelljeink alapján kapott regressziós vonalakat, minden résztvevőre külön-külön, és hasonlítsuk össze hogyan illeszkednek a megfigyeléseinkre. Van bármi előnye ha az időt külön változó hatásként vizsgáljuk a random slope modellben, vagy elegendő a random intercept használata?

mod_rnd_int_2 = lmer(pain_rating ~ days + (1|ID), data = data_long)
mod_rnd_slp_2 = lmer(pain_rating ~ days + (days|ID), data = data_long)

data_long$pred_int = predict(mod_rnd_int_2)

ggplot(data_long, aes(y = pain_rating, x = days,
                                      group = ID)) + geom_point(size = 3) + geom_line(color = "red",
                                                                                      aes(y = pred_int, x = days)) + facet_wrap(~ID, ncol = 5)

data_long$pred_slope = predict(mod_rnd_slp_2)

ggplot(data_long, aes(y = pain_rating, x = days,
                                      group = ID)) + geom_point(size = 3) + geom_line(color = "red",
                                                                                      aes(y = pred_slope, x = days)) + facet_wrap(~ID, ncol = 5)

# 5. Hasonlítsuk össze a modelleket a cAIC() alapján is!

cAIC(mod_rnd_int_2)$caic
cAIC(mod_rnd_slp_2)$caic

# 6. Mi a marginális R^2 érték a random intercept modell esetében? A marginális R^2 konfidencia intervalluma alapján a modellünk szignifikánsan jobb-e mint a null modell?

r2beta(mod_rnd_int_2)

# A marginális R^2 konfidencia intervalluma nem tartalmazza a nullát, ezért a modell szignifikánsan jobb mint a (prediktorok nélküli) null modell