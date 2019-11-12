### Hazi feladat

# Package-ek
library(tidyverse)
library(lm.beta)

# sajat funkciok
# ez a regresszios prediktorokrol szolo tablazat koddal valo kilistazasahoz valo, nem kotelezo ezt hasznalni, ehelyett manualisan is ki lehet irni az adatokat
coef_table = function(model){
  require(lm.beta)
  mod_sum = summary(model)
  mod_sum_p_values = as.character(round(mod_sum$coefficients[,4], 3))	
  mod_sum_p_values[mod_sum_p_values != "0" & mod_sum_p_values != "1"] = substr(mod_sum_p_values[mod_sum_p_values != "0" & mod_sum_p_values != "1"], 2, nchar(mod_sum_p_values[mod_sum_p_values != "0" & mod_sum_p_values != "1"]))	
  mod_sum_p_values[mod_sum_p_values == "0"] = "<.001"	
  
  
  mod_sum_table = cbind(as.data.frame(round(cbind(coef(model), confint(model), c(0, lm.beta(model)$standardized.coefficients[c(2:length(model$coefficients))])), 2)), mod_sum_p_values)	
  names(mod_sum_table) = c("b", "95%CI lb", "95%CI ub", "Std.Beta", "p-value")	
  mod_sum_table["(Intercept)","Std.Beta"] = "0"	
  return(mod_sum_table)
}

# 1. toltsd be a lakasarak adatbazist (az oran hasznalt valtozatat itt talalod: https://bit.ly/2DpwKOr)
data_house = read_csv("https://bit.ly/2DpwKOr")	

# 2. Alakitsd at az adatokat ugy hogy dollar helyett forintban legyen a price valtozo (1 USD nagyjabol 294 HUF), 
# es negyzetlab helyett negyzetmeterben szerepljenek az adatok (ez a kovetkezo valtozokat erinti: 
# sqft_living, sqft_lot, sqft_above, sqft_basement, sqft_living15, sqft_lot15) (1 negyzetlab = 0.09 m^2)

data_house = data_house %>% 	
  mutate(price_mill_HUF = (price * 294)/1000000,	
         sqm_living = sqft_living * 0.09,	
         sqm_lot = sqft_lot * 0.09,	
         sqm_above = sqft_above * 0.09,	
         sqm_basement = sqft_basement * 0.09,	
         sqm_living15 = sqft_living15 * 0.09,	
         sqm_lot15 = sqft_lot15 * 0.09,	
  )	

# 3. futtass le egy korrelacios tesztet hogy meghatarozd, van-e egyuttjaras a lakas ara es a lakas allapota (condition) kozott (cor.test())

data_house %>% 
  ggplot() +
  aes(x = condition, y = price_mill_HUF) +
  geom_point()

cor1 = cor.test(data_house$price_mill_HUF, data_house$condition)
cor1 

# 4. Illessz egy egyszeru regresszios modellt amelyben a lakas arat (price) josolod be a lakas allapotaval (condition)

mod_1 = lm(price_mill_HUF ~ condition, data = data_house)
summary(mod_1)

# 5. Hasonlitsd ossze a teljes model F-teszt p-erteket, a condition regresszios egyutthatojahoz tartozo p-erteket, es a korrelacios teszt p-erteket. Mit veszel eszre?

# az F-teszt p-ertek es a korrelacio p-erteke megegyezik
summary(mod_1)
cor1$p.value

# 6. Hasonlitsd ossze az R^2 mutatot es a korrelacios egyutthato negyzetet. Mit veszel eszre?

# R^2 es r negyzetenek osszehasonlitasa
# a ket ertek ugyan az
summary(mod_1)
cor1$estimate ^ 2

# 7. Most javitsd ezt a modelt ujabb prediktorok hozzaadasaval (hasznalj legalabb 3 prediktort a modellben).
mod_2 = lm(price_mill_HUF ~ condition + sqm_living + grade + yr_built, data = data_house)
summary(mod_2)

# 8. Mekkora a modell altal megmagyarazott varianciaarany?

### A modell az eladasi ar varianciajanak 42.94%-at magyarazza (ezt az Adjusted R-squared mutato alapjan adtam meg)
### az Adjusted R-squared mutatot egyebkent a model summary-bol a kovetkezo keppen is ki lehet nyerni:
summary(mod_2)$adj.r.squared

# 9. Hasonlitsd ossze az egyszeru regresszios modell bejoslo erejet a tobbszoros regresszios modell bejoslo erejevel. (Hasznald az anova()) funkciot, igy: anova(model1, model2)) Szignifikansan jobb a bejoslo ereje a tobbszoros regresszios modellnek?
### igen, a tobbszoros regresszios modell (mod_2) bejoslo ereje szignifikansan jobb mint az egyszeru regresszios modelle (mod_1)
anova(mod_1, mod_2)


# 10. Ird le a tobbszoros regresszios modell eredmenyet a gyakorlati jegyzet alapjan. Szerepeljen benne mindaz az informacio a teljes modellrol es a prediktorokrol amit a gyakorlati jegyzet javasol.

### A tobbszoros regresszios modell mely tartalmazta a lakoterulet (sqm_living), a lakas minosites (grade), es a haz epitesenk eve (yr_built) prediktorokat 
### hatekonyabban tudta bejosolni a lakas arat mint a null modell. A modell a lakasar varianciajanak 42.94%-at magyarazta 
### (F (4, 195) = 38.44, p < .001, Adj. R^2 = 0.43, AIC = 2113.74).

AIC(mod_2)

confint(mod_2)
lm.beta(mod_2)

coef_table(mod_2)
