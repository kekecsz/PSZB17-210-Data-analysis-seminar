#################################################################
#################################################################
#            Hazi feladat a modeldiagnosztika temaban           #
#################################################################
#################################################################

# 1. Toltsd be a szukseges package-eket. Pl. az alabbi packagekre szukseged lehet:
library(tidyverse)
library(car) # for residualPlots, vif, pairs.panels, ncvTest
library(psych) # for describe	
library(boot) # for bootstrapping	
library(lmboot) # for wild bootsrapping
library(lmtest) # for bptest
library(sandwich) # for coeftest vcovHC estimator	

# 2. Toltsd be az alabbi bootstrapping hasznalatahoz szukseges sajat funkciokat. (Ezekhez
# szukseg lesz a boot package-re is.)

### function to obtain regression coefficients	
### source: https://www.statmethods.net/advstats/bootstrapping.html	
bs_to_boot <- function(model, data, indices) {	
  d <- data[indices,] # allows boot to select sample 	
  fit <- lm(formula(model), data=d)	
  return(coef(fit)) 	
}	

### function to obtain adjusted R^2	
### source: https://www.statmethods.net/advstats/bootstrapping.html (partially modified)	
adjR2_to_boot <- function(model, data, indices) {	
  d <- data[indices,] # allows boot to select sample 	
  fit <- lm(formula(model), data=d)	
  return(summary(fit)$adj.r.squared)	
}	


### Computing the booststrap BCa (bias-corrected and accelerated) bootstrap confidence intervals by Elfron (1987)	
### This is useful if there is bias or skew in the residuals.	

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

# Computing the booststrapped confidence interval for a linear model using wild bottstrapping as descibed by Wu (1986) <doi:10.1214/aos/1176350142>

wild.boot.confint <- function(model, data = NULL, B = 1000){
  if(is.null(data)){
    data = eval(parse(text = as.character(model$call[3])))
  }
  
  wild_boot_estimates = wild.boot(formula(model), data = data, B = B)
  
  result = t(apply(wild_boot_estimates[[1]], 2, function(x) quantile(x,probs=c(.025,.975))))
  
  return(result)
  
}

# 3. Toltsd be a youtube nezettsegi adattablat. 
#
# Ez az adattabla kulonbozo az USA-ban feltoltott YouTube videokrol tartalmaz adatokat innen:
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_10/USvideos_sample.csv"
# mint peldaul:
# views: megtekintesek szama
# likes: "like"-ok szama
# dislikes: "dislike"-ok szama
# comment_count: megjegyzesek szama
# az adatbazisrol bovebb informaciot itt talaltok: https://www.kaggle.com/datasnaek/youtube-new/data#USvideos.csv

# 4. Vegezz feltaro elemzest a likes, dislikes, es comment_count valtozok views valtozoval
# valo osszefuggesevel kapcsolatban: milyen a valtozok kozotti korrelacio, hogyan fest a
# valtozok kapcsolata pontdiagramon

# 5. Epits egy linearis regresszios modellt a views valtozo becslesere a likes, 
# dislikes, es a comment_count valtozokkal mint prediktorokkal

# 6. Ird le a regresszio 4 oran tanult elofeltetelet.

# 7. Ellenorizd a rezidualisok normalitasat. Serult a normalitas feltetele a modeldiagnosztika alapjan?

# 8. Ha serult a normalits feltetele, kezeld azt az oran tanultak szerint

# 9. Ellenorizd a homoszkedaszticitas feltetelet. Serult a homoszkedaszticitas feltetele a modeldiagnosztika alapjan?

# 10. Ha serult a homoszkedaszticitas feltetele, kezeld azt az oran tanultak szerint

# 11. Ellenorizd a multikollinearits hianyat. Talalhatunk multikollinearitasra utalo jelet a modeldiagnosztika alapjan?

# 12. Ha talalhatunk multikollinearitasra utalo jelet a modeldiagnosztika alapjan,  kezeld azt az oran tanultak szerint

# 13. Ellenorizd a linearitas feltetelet. Talalhatunk nem linearis kapcsolatra utalo jelet a modeldiagnosztika alapjan?

# 14. Ha talalsz a linearitas serulesere utalo jelet, kezed azt az oran tanultak alapjan

