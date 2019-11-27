
# 1. Toltsd be a package-eket

library(tidyverse)
library(lme4)
library(r2glmm)
library(cAIC4)

# to get std. beta
stdCoef.merMod <- function(object) {	
  sdy <- sd(getME(object,"y"))	
  sdx <- apply(getME(object,"X"), 2, sd)	
  sc <- fixef(object)*sdx/sdy	
  se.fixef <- coef(summary(object))[,"Std. Error"]	
  se <- se.fixef*sdx/sdy	
  return(data.frame(stdcoef=sc, stdse=se))	
}	

# 2. Olvasd be az adatokat (.csv fajl) errol a linkrol: "https://tinyurl.com/data-pain1"
# Ez az adattabla a mutet utani fajdalomrol tartalmaz adatokat, es olyan valtozokrol, amik
# kapcsolatban lehetnek a mutet utani (posztoperativ) fajdalomszinttel.
# Valtozok:
# - ID: a vizsgalati szemely azonositoja
# - pain1, pain2, pain3, pain4: Ebben a kutatasban a mutet napjan (pain1), es az azt koveto 
#   harom napban (pain2, pain3, pain4) megkertek a vizsgalati szemelyeket hogy ertekelje az
#   altala erzett fajdalom szintjet egy 0-10 vizualis analog skalan (minel magasabb, annal
#   nagyobb a fajdalom)
# - sex: nem
# - STAI_trait: A State Trait Anxiety Inventroy - t teszten elert pontertek, ami a vonasszorongas szintjet mutatja
# - pain_cat: Fajdalom-katasztrofizalas kerdoiven elert pontszam. Minel nagobb az erteke, a szemely
#   annal hajlamosabb arra hogy nagy jelentoseget es kovetkezmenyt tulajdonitson a fajdalomnak
# - cortisol_serum; cortisol_saliva: a cortisol egy stresszhormon. Ennek a szintjet mertek
#   a vizsgalati szemelyeknel a mutet utan azt kovetoen hogy megkerdeztek a fajdalomszintjukrol.
#   ezt a valtozot mind a verbol (serum), mind a nyalbol (saliva) mertek.
# - mindfulness: A mindfulness kerdoiven elert ertek, minel magasabb az erteke, a szemely annal
#   inkabb hajlamos az esemenyeket itelkezes nelkuli elfogadassal szemlelni es kezelni.
# - weight: testsuly kilogrammban
# - IQ: A szemely erteke egy intelligenciteszten a mutet elott egy hettel
# - household_income: a viszgalati szemely haztartasanak osszesitett bevetele UA dollarban

data_pain = read_csv("C:\\Users\\Lenovo\\Documents\\Statgyak\\seminar_9\\home_sample_5.csv")

# 3. Alakitsd at az adatokat szeles formatumbol (wide format) hosszu formatumba (long format).
# Vagyis a fajdalomszint minden megfigyelese legyen kulon sorban. Ehhez hasznalhatod a gather()
# vagy a melt() funkciot

data_pain_long = data_pain %>% 
  gather(pain1:pain4, key = time, value = pain) %>% 
  arrange(ID)

data_pain_long = data_pain_long %>% 
  mutate(time = recode(time,
                       "pain1" = 1,
                       "pain2" = 2,
                       "pain3" = 3,
                       "pain4" = 4))

# 4. Epits egy kevert regresszios modellt amiben a fajdalom szintje a bejosolt valtozo.
# A modellben szerepeljen az ido (a muteti nap) mint fix hatasu prediktor. Szinten szerepeljen
# a modellben a vizsgalati szemelyt random hataske random intercept-kent 
# (de ne legyen megengedve a random slope).

mod1 = lmer(pain ~ time + (1|ID), data = data_pain_long)


# 5. A modell fix hatasu prediktora a fajdalom varianciajanak hany szazalekat tudja megmagyarazni? 
# Szignifikansan jobb bejosloja a fajdalomnak ez a modell mint a null modell?

r2beta(mod1)

### a modell ami tartalmazza a time prediktort szignifikansan jobb mint a null modell, 
### a fix hatasu prediktor a fajdalom varianciajanak 45.1%-at magyarazza (marginal R^2 = 0.45 (95%CI = 0.29, 0.60)). 

# 6. Milyen az ido hatasa a fajdalomra? Ird le a legfontosabb adatokat a fajdalom regresszios egyutthatojaru\ol:
# (regresszios egyutthato, 95%-os konfidencia intervallum, standardizalt beta)

mod1
confint(mod1)
stdCoef.merMod(mod1)

### Az intercepthez tartozo regresszios egyutthato szignifikansan nagyobb mint 
### nulla (b = 5.3 (95% CI = 0.54, 1.17)), csakugy mint a time prediktor egyutthatoja
### (b = -0.66 (95% CI = -0.80, -0.52), std.Beta =  -0.57). A regresszios egyutthato
### alapjan a fajdalom ertek minden nappal atlagosan 0.66 ponttal csokken.

# 7. Epits egy random slope modellt is a fentiekhez hasonloan: Itt mar legyen megengedett,
# hogy az ido hatasa kulonbozzon egyenenkent a fajdalomra.

mod2 = lmer(pain ~ time + (time|ID), data = data_pain_long)

# 8. Hasonlitsd ossze a random slope es random intercept modellek illeszkedeset a cAIC segitsegevel. Melyik modell
# illeszkedik jobban?

cAIC(mod1)$caic
cAIC(mod2)$caic

### a random slope modell illeszkedese az adatokra szignifikansan jobb.
### azonban a modell nem konvergalt ("Model failed to converge with max|grad| = 0.00231649 (tol = 0.002, component 1)")
### ez azt jelentheti hogy az adatbazisban nincs eleg adat a random slope modell megfelelo illesztesehez.
