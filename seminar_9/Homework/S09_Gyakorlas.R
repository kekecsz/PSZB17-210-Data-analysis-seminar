#####################################
# A 10. gyakorlat gyakorlo script-je #
#####################################


### Elokeszuletek

# toltsuk be a packageket

library(psych) # for describe
library(car) # for residualPlots, vif, pairs.panels, ncvTest
library(lmtest) # bptest
library(sandwich) # for coeftest vcovHC estimator
library(boot) # for bootstrapping
library(tidyverse) # for tidy code

# az alábbi saját funkció is hasznos lehet ha bootstrappinggel szeretnél 
# konfidencia intervallumot számolni a modell paraméterekhez (nem biztos hogy szukség lesz rá)

# function to obtain regression coefficients
# source: https://www.statmethods.net/advstats/bootstrapping.html
bs_to_boot <- function(model, data, indices) {
  d <- data[indices,] # allows boot to select sample 
  fit <- lm(formula(model), data=d)
  return(coef(fit)) 
}

# function to obtain adjusted R^2
# source: https://www.statmethods.net/advstats/bootstrapping.html (partially modified)
adjR2_to_boot <- function(model, data, indices) {
  d <- data[indices,] # allows boot to select sample 
  fit <- lm(formula(model), data=d)
  return(summary(fit)$adj.r.squared)
}


# Computing the booststrap BCa (bias-corrected and accelerated) bootstrap confidence intervals by Elfron (1987)
# This is useful if there is bias or skew in the residuals.

confint.boot <- function(model, data = NULL, R = 1000){
  if(is.null(data)){
    data = eval(parse(text = as.character(model$call[3])))
  }
  boot.ci_output_table = as.data.frame(matrix(NA, nrow = length(coef(model)), ncol = 2))
  row.names(boot.ci_output_table) = names(coef(model))
  names(boot.ci_output_table) = c("boot 2.5 %", "boot 97.5 %")
  results.boot = results <- boot(data=data, statistic=bs_to_boot, 
                                 R=1000, model = model)
  
  for(i in 1:length(coef(model))){
    boot.ci_output_table[i,] = unlist(unlist(boot.ci(results.boot, type="bca", index=i))[c("bca4", "bca5")])
  }
  
  return(boot.ci_output_table)
}



# toltsuk be az adatokat (egy .csv kiterjesztésű file-ból).

data_house = read.csv("https://bit.ly/2DpwKOr")

data_house %>% 
  summary()

# végezzuk el az adatokon a szokásos átalakitásokat hogy a mértékegységeket könnyebb legyen értelmezni

data_house = data_house %>% 
  mutate(price_mill_HUF = (price * 293.77)/1000000,
         sqm_living = sqft_living * 0.09290304,
         sqm_lot = sqft_lot * 0.09290304,
         sqm_above = sqft_above * 0.09290304,
         sqm_basement = sqft_basement * 0.09290304,
         sqm_living15 = sqft_living15 * 0.09290304,
         sqm_lot15 = sqft_lot15 * 0.09290304
  )

### Feladatok

# 1. Épits egy olyan lineáris modellt, amiben az ingatlan eladási árát próbáljuk megbecsülni (price_mill_HUF)
# melyet az “sqm_living”, “sqm_living15”, “yr_built”, és “condition” prediktorok alapján jósolunk be.


# 2. Végezzünk modell diagnoztikát ezen a modellen a modelldiagnosztika gyakorlati órán tanultak alapján.
# 2.a. Határozd meg mely előfeltevések (assumptions) azok, amikkel kapcsolatban probléma merülhet fel
# 2.b. Ahol releváns, korrigáld a problémát az órán tanultak alapján 
