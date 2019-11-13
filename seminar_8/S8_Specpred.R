
# # Specialis prediktorok	

# ## Absztrakt	

# Ebben a gyakorlatban megismerjuk majd hogyan hasznaljuk es ertelmezzuk a kulonbozo tipusu prediktorokat a linearis regresszios modellekben.	

# ## Adatmenedzsment es leiro statisztikak	

# ### Package-ek betoltese	


library(tidyverse)	
library(psych)	
library(gridExtra)	



# ### A fogyasi kutatas adatbazis betoltese	

# Az adatbazis egy olyan kutatas szimulalt adatait  tartalmazzam ahol kulonbozo kezelesek hatekonysagat teszteltek a sulyvesztesre tulsolyos szemelyeknel. 	

# Valtozok:	
# ID - vizsgalati szemlely azonositojele	
# Gender - nem	
# Age - eletkor	
# BMI_baseline - Body mass index (BMI) a kezeles elott	
# BMI_post_treatment - Body mass index (BMI) a kezeles utan	
# treatment_type - A kezeles amit a vizsgalati szemely kapott (no treatment - nem kapott kezelest; pill - etvagycsokkento gyogyszer; psychotherapy - kognitiv behavior terapia (CBT); treatment 3 - egy harmadik fajta kezeles, lasd lentebb)	
# motivation - onbevallasos motivacioszint a fogyasra (0-10-es skalan, ahol a 0 extremen alacsony motivacio a fogyasra, a 10 pedig extremen magas motivacio a fogyasra)	
# body_acceptance - a szemely mennyire erzi elegedettnek magat jelenleg testevel (-7 - +7, ahol a - 7 nagyon elegedetlen, a +7 nagyon elegedett)	



# data from github/kekecsz/PSYP13_Data_analysis_class-2018/master/data_house_small_sub.csv. 	
data_weightloss = read.csv("https://tinyurl.com/weightloss-data")	


# ### Adatellenorzes	

# Nezzuk at eloszor az altalunk hasznalt adattablat.	


data_weightloss %>% 	
  summary()	
	
describe(data_weightloss)	
	
fig_1 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_baseline, x = treatment_type) +	
  geom_boxplot()	
  ylim(c(20, 45))	
	
fig_2 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = treatment_type) +	
  geom_boxplot()	
  ylim(c(20, 45))	
	
grid.arrange(fig_1, fig_2, nrow=1)	
	


# Ebben a gyakorlatban szeretnenk megerteni a kulonbozo kezelestipusok hatasat a BMI-re. Vegezzunk feltaro elemzest az adatokon.	


fig_1 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_baseline, x = treatment_type) +	
  geom_boxplot()	
  ylim(c(20, 45))	
	
fig_2 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = treatment_type) +	
  geom_boxplot()	
  ylim(c(20, 45))	
	
grid.arrange(fig_1, fig_2, nrow=1)	
	
data_weightloss %>% 	
  group_by(treatment_type) %>% 	
    summarize(mean_pre = mean(BMI_baseline),	
              sd_pre = sd(BMI_baseline),	
              mean_post = mean(BMI_post_treatment),	
              sd_post = sd(BMI_post_treatment))	
	


# ## Kategorikus valtozok mint prediktorok	

# Mivel ugy tunik, a csoportok osszehasonlithatoak voltak a kezeles elott, fokuszaljunk most a kezeles utani BMI-re (BMI_post_treatment).	

# A kezeles tipus (treatment_type) egy kategorikus valtozo, a BMI pedig egy folytonos numerikus valtozo. Ahogy azt korabban tanultuk, egyik modja annak hogy kideritsuk, van-e kulonbseg csoportok kozott egy adott folytonos valtozo atlagos szintjeben, ha lefuttatunk egy egyszempontos ANOVA-t (aov()).	

# Az eredmeny elarulja, hogy a kezeles utani BMI atlaga szignifikansan kulonbozik a csoportok kozott (F (3, 236) = 26.51, p < 0.001), (ami azt jelenti, hogy legalabb ket csoport szignifikansan kulonbozik egymastol a BMI atlagaban a negy csoport kozul).	


anova_model = aov(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
summary(anova_model)	
	


# A linearis regresszional fontos, hogy a fuggo valtozo (a bejosolt valtozo) folytonos numerikus valtozo legyen. Viszont a modell prediktorai lehetnek akar folytonos, akar kategorikus valtozok (csoportosito valtozok mint pl. a kezeles a mi esetunkben).	

# Vagyis a fenti aov() modellt megepithetjuk lm() segitsegevel is ahogy az alabbi pelda is mutatja. A teljes modell F-tesztje ugyan azt az eredmenyt adja ki, mint az aov().	


mod_1 = lm(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
summary(mod_1)	
	


# A regresszios egyutthatok tablazata ebben az esetben maskepp nez ki a megszokotthoz kepest, hiszen majdnem minden kezelesi tipusnak kulon sora van. 	

# Az egyes valtozokhoz tartozo regresszios egyutthatokat pedig ugy ertelmezzuk altalaban, hogy mekkora valtozast jelent a bejosolt valtozo ertekeben ha a prediktor valtozo erteke egy szinttel emelkedik. Viszont a nominalis valtozok nem sorrendezettek, szoval nem tudjuk eldonteni, hogy hogyan rakjuk sorba a szinteket, hogy az egy szintnyi emelkedes hatasat megbecsuljuk. Ezt egy masik trukkel oldjuk meg: dummy valtozokkal. A dummy valtozok gyakorlatilag azt jelentik, hogy keszitunk uj valtozokat, ami a faktorszint megletet (1), vagy hianyat (0) jelenti. Vagyis lesz egy valtozo, ami akkor vesz fel 1-es erteket, ha valaki "pill"-t kapott, minden mas esetben 0 erteket vesz fel, lesz egy masik valtozo ami akkor vesz fel 1-es erteket amikor valaki "psychotherapy"-t kapott, minden masik esetben 0 erteket vesz fel, es lesz egy valtozo ami akkor vesz fel 1-es erteket amikor valaki "treatment_3"-t kapott, minden masik esetben 0 erteket vesz fel. Az alapszintnek nem szoktunk kulon dummy valtozot csinalni, mert az mar a tobbi dummy eredmenyebol evidens (ha minden masik dummy erteket 0, akkor az alapszint erteke 1). 	



data_weightloss = data_weightloss %>% 	
  mutate(	
         got_pill = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "1",	
                           "psychotherapy" = "0",	
                           "treatment_3" = "0"),	
         got_psychotherapy = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "0",	
                           "psychotherapy" = "1",	
                           "treatment_3" = "0"),	
         got_treatment_3 = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "0",	
                           "psychotherapy" = "0",	
                           "treatment_3" = "1")	
         )	
	
mod_2 = lm(BMI_post_treatment ~ got_pill + got_psychotherapy + got_treatment_3, data = data_weightloss)	
summary(mod_2)	
	



# Ez a megoldas lehetove teszi, hogy a program minden valtozoszintet egyenkent hasonlitson az alapszinthez. Ennek az eredmenyet latjuk a regresszios egyutthatok tablazataban. 	

# Az intercept-hez tartozo regresszios egyutthatot mindig ugy lehet ertelmezni, hogy ez mutatja a bejosolt valtozo (ebben az esetben a BMI) erteket abban az esetben, ha minden prediktor valtozo nulla erteket vesz fel. Mivel itt dummy valtozokkal dolgozunk, ez azt jelenti, hogy az alapszinten kivul minden mas szinthez tartozo dummy valtozo erteke 0. Vagyis mi az a BMI ertek, amit akkor varhatunk ha az ember se nem "pill"-t, se nem "psychotherapy"-t, se nem "treatment_3"-t nem kapott.	

# A regresszios egyutthatokat igy mar szokas szerint ertelmezhetjuk, hogy abban az esetben ha az adott dummy valtozo erteke egy szinttel no (vagyis 0 helyett 1 lesz), akkor mekkora valtozast varhatunk a bejosolt valtozo ertekeben.	

# Az R mindezt elvegzi helyettunk, nem kell nekunk manualisan dummy valtozokat generalni, de az fontos, hogy megertsuk, hogyan tortenik ez a folyamat. De a kategorikus valtozoknak (pl. a mi esetunkben treatment type) onmagaban nincs nulla erteke. Ezt az R ugy oldja meg, hogy a csoportosito valtozo szintjei kozul kivalaszt egyet, ami az alapszint (default level), es azt veszi nullanak. Ahogy korabban is, az alapszint ha nem rendelkezunk maskepp alapertelmezett modon a faktor szintjei kozul az abc sorrendben legeleso lesz, a mi esetunkben ez a "no_treatment".	

# Vagyis 	

# - a "no_treatment" eseten 36.13 BMI-t varhatunk,	
# - ha valaki "pill"-t kap, akkor -2.08 BMI valtozast josolunk, 	
# - ha valaki "psychotherapy"-t kap -2 BMI valtozast josolunk,	
# - ha valaki "treatment_3"-t kap  -5.33 BMI valtozast josolunk.	


# *__________Gyakorlas___________*	

# Nyisd meg a data_house adattablat amivel a korabbi gyakorlatokon foglalkoztunk, es epits egy linearis regresszios modellt a lakas eladasi aranak (price) bejoslasara a kovetkezo prediktorokkal:  sqm_living, grade, has_basement. Ertelmezd a fentiek alapjan a regresszios egyutthatok tablazatat. Mit jelent az intercept regresszios egyutthatoja? Mit jelent a has_basement prediktorhoz tartozo regresszios egyutthato?	



data_house = read.csv("https://bit.ly/2DpwKOr")	
	
data_house = data_house %>% 	
  mutate(price_mill_HUF = (price * 293.77)/1000000,	
         sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304	
         )	
	




# *______________________________*	


# ### Ket valtozo interakciojanak beillesztese a modellbe	

# A treatment_3 valojaban egy olyan kondicio volt a kutatasban, ahol az emberek mind gyogyszeres, mind pszichoterapias kezelest kaptak.	

# Most atalakitjuk az adattablat, hogy ezt helyesen tukrozzek az iment generalt dummy valtozok.	


data_weightloss = data_weightloss %>% 	
  mutate(	
         got_pill = replace(got_pill, treatment_type == "treatment_3", "1"),	
         got_psychotherapy = replace(got_psychotherapy, treatment_type == "treatment_3", "1")	
         )	
	


# Most feltehetjuk a kerdest, hogy van-e interakcio a gyogyszeres kezeles es a pszichoterapias kezeles kozott, vagyis van-e valami hozzaadott erteke annak, hogy az emberek a ket kezelest egyszerre kaptak azon felul, amit a ket kezeles hatasa alapjan varnanak kulon-kulon.	

# Ezt az interakciot a modellbe ugy tudjuk beepiteni, ha a + helyett *-ot rakunk a ket valtozo koze, amiknek az interakcioja erdekel mindket.	

# c	

# Itt az interakcios tenyezohoz tartozo regresszios egyutthatot ugy ertelmezhetjuk, hogy abban az esetben, ha a ket valtozo szorzata egyel magasabb erteket vesz fel (a mi esetunkben ez csak akkor lesz 1, ha mind a got_pill, mind a got_psychoterapy erteke 1), milyen valtozast varhatunk a bejosolt valtozo ertekeben AZON FELUL, amit a ket valtozo onallo hatasam felul varnank. Ez azert van, mert mind a got_pill, mind a got_psychotherapy valtozok erteke 1 ebben az esetben, es azok hatasa (-2.0833 es -2.0000) igy mar bele van kalkulalva a modellbe. Vagyis ha mind a pill, mind a got_pill, mind a got_psychotherapy valtozok erteke 1, akkor azon felul hogy kifejtik egyenkent hatasukat, egy extra -1.2500 BMI csokkenest varhatunk az eredmenyek alapjan.	


# *__________Gyakorlas___________*	

# A data_house adatokon epits egy linearis regresszios modellt a lakas eladasi aranak (price) bejoslasara a kovetkezo prediktorokkal:  sqm_living, grade, lat, long. De ahelyett hogy csak a fohatasokat nezned, kalkulald be a lat es long interakciojanak hatasat is! Ertelmezd az interakciohoz tartozo regresszios egyutthatot annak tudataban, hogy a latitude ertek minel magasabb, annal inkabb eszakra van a hely, es a longitude ertek minel magasabb annal inkabb keletre van a hely.	


# *______________________________*	



# ### Hatvany prediktorok a nem-linearis osszefuggesek modellezesehez	



data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_smooth()	
	
mod_4 = lm(BMI_post_treatment ~ body_acceptance + I(body_acceptance^2), data =  data_weightloss)	
summary(mod_4)	
	




# ```	


















# Categorical variables can be included in models just like continuous variables. Here, we include the variable has_basement as a predictor, which is a categorical variable that has two levels: 'has basement' and 'no basement'. In this case, the intercept can be interpreted as the predicted value for all continuous predictor values as 0, and the has_basement variable at its default level: 'has basement'. The regression coefficient for has_basement indicates how much price is predicted to change if the apartment has no basement compared to if it has basement.	


mod_cat = lm(price ~ sqft_living + grade + has_basement, data = data_house)	
	
summary(mod_cat)	



# The default level (reference level) of categorical variables is the level earliest in the alphabet. For this reason, the reference level of the variable has_basement is "has basement". For more intuitive interpretation, it would make sense to change the reference level to "no basement", so that the model coefficient for this variable would be positive, and it would indicate how much price increase would a basement mean for the apartment sales.	

# This can be done with the relevel() function. We have to re-run the model for this change to take effect in the model object.	



data_house$has_basement = relevel(data_house$has_basement, ref = "no basement")	
	
mod_cat = lm(price ~ sqft_living + grade + has_basement, data = data_house)	
summary(mod_cat)	


# Now it is apparent from the model summary that if an apartment has a basement, this means a `r  format(round(coef(mod_cat)["has_basementhas basement"]), digits = 2)` USD increase in price compared to apartments which do not have a basement (the reference level).	

# ## Higher order terms	

# If you suspect that there is non-linear relationship between the outcome and some predictor, you can try to include a second or third order term.	

# For example, here we can see that the relationship of price and grade is not entirely linear.	


plot(price ~ grade, data = data_house)	


# So we build a model including the second order term of grade, to account for a quadratic relationsip.	

# Unless you know what you are doing, always add the first order term in the model as well, like here:	


mod_house_quad <- lm(price ~ grade + I(grade^2), data = data_house)	
summary(mod_house_quad)	
	
ggplot(data_house, aes(x = grade, y = price))+	
  geom_point()+	
  geom_smooth(method='lm',formula=y~x+I(x^2))	


# ## Interactions	

# A relationship of different predictors can also be modelled, if you suspect that the association of a predictor and the outcome might depend on the value of another predictor.	

# For example here we first build a model where we include the effect of geographic location (longitude and latitude) in the model (mod_house_geolocation), and next, we include the interaction of longitude and latitude in the model, because we suspect that these parameters might influence each others association with price.	


mod_house_geolocation = lm(price ~ sqft_living + grade + long + lat, data = data_house)	
summary(mod_house_geolocation)	
	
mod_house_geolocation_inter2 = lm(price ~ sqft_living + grade + long * lat, data = data_house)	
summary(mod_house_geolocation_inter2)	


# Note that the adjusted R squared did not increase substancially due to the inclusion of the interaction term, so it might not be so useful to take into account the interaction, it might be enoug to take into account the main effects of longitude and latitude. This needs to be further evaluated with model comparison. See the exercise related to that.	








# *__________Gyakorlas___________*	

# Experiment with different models based on your theories about what could influence housing prices.	

# Try to increase the adjusted R^2 above 52%.	
# If you want to get access to the whole dataset or get ideas on which model works best, go to Kaggle, check out the top kernels, and download the data.	
# https://www.kaggle.com/harlfoxem/housesalesprediction/activity	


# *______________________________*	


