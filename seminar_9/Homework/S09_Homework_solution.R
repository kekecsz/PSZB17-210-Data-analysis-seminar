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
# Ez az adattabla kulonbozo az USA-ban feltoltott YouTube videokrol tartalmaz adatokat
# mint peldaul:
# views: megtekintesek szama
# likes: "like"-ok szama
# dislikes: "dislike"-ok szama
# comment_count: megjegyzesek szama
# az adatbazisrol bovebb informaciot itt talaltok: https://www.kaggle.com/datasnaek/youtube-new/data#USvideos.csv


mydata = read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_10/USvideos_sample.csv")


# 4. Vegezz feltaro elemzest a likes, dislikes, es comment_count valtozok views valtozoval
# valo osszefuggesevel kapcsolatban: milyen a valtozok kozotti korrelacio, hogyan fest a
# valtozok kapcsolata pontdiagramon

mydata %>% 
  select(views,likes, dislikes, comment_count) %>% 
  cor()

mydata %>%
  ggplot()+
  aes(x = likes, y = views) +
  geom_point()

mydata %>%
  ggplot()+
  aes(x = dislikes, y = views) +
  geom_point()

mydata %>%
  ggplot()+
  aes(x = comment_count, y = views) +
  geom_point()


# 5. Epits egy linearis regresszios modellt a views valtozo becslesere a likes, 
# dislikes, es a comment_count valtozokkal mint prediktorokkal



mod1 = lm(views ~ likes + dislikes + comment_count, data = mydata)
summary(mod1)

# 6. Ird le a regresszio 4 oran tanult elofeltetelet.

# * **Normalit?s**: A  modell rezidualisai norm?leloszl?st k?vetnek	
# * **Linearit?s**: A prediktor ?s az eredm?ny k?z?tt line?ris kapcsolat kell legyen	
# * **Homoszkedaszticit?s**: A rezidualisok varianci?ja minden ?rt?kre hasonl? a prediktorok?hez	
# * **Nincs kollinearit?s**: egyetlen prediktor sem hat?rozhat? meg a t?bbi prediktor line?ris kombin?ci?jak?nt.	


# 7. Ellenorizd a rezidualisok normalitasat. Serult a normalitas feltetele a modeldiagnosztika alapjan?


mod1 %>% 	
  plot(which = 2)	


describe(resid(mod1))

# histogram	
residuals_mod1 = enframe(resid(mod1))	
residuals_mod1 %>% 	
  ggplot() +	
  aes(x = value) +	
  geom_histogram()	

### Igen, serul a normalitas feltetele.

# 8. Ha serult a normalits feltetele, kezeld azt az oran tanultak szerint

### egy lehetseges megoldas: a kofidencia intervallumokat bootstrappinggel hatarozzuk meg. 

### bootstrapped confidence intervals for the model coefficients	
confint.boot(mod1)	
### regular adjusted R squared	
summary(mod1)$adj.r.squared	
### bootstrapping with 1000 replications 	
results.boot <- boot(data=mydata, statistic=adjR2_to_boot, 	
                     R=1000, model = mod1)	
### get 95% confidence intervals for the adjusted R^2	
boot.ci(results.boot, type="bca", index=1)

### egy masik lehetseges megoldas: log() transzformaljuk az adatokat, hogy kozelitsunk a normalis eloszlashoz

mydata = mydata %>%
  mutate(views_log = log(views+1),
         likes_log = log(likes+1),
         dislikes_log = log(dislikes+1),
         comment_count_log = log(comment_count+1))

mod2 = lm(views_log ~ likes_log + dislikes_log + comment_count_log, data = mydata)
summary(mod2)

# QQ plot	
mod2 %>% 	
  plot(which = 2)	


describe(resid(mod2))

# histogram	
residuals_mod2 = enframe(resid(mod2))	
residuals_mod2 %>% 	
  ggplot() +	
  aes(x = value) +	
  geom_histogram()	


# 9. Ellenorizd a homoszkedaszticitas feltetelet. Serult a homoszkedaszticitas feltetele a modeldiagnosztika alapjan?



mod1 %>% 	
  plot(which = 3)	

mod1 %>% 	
  ncvTest() # NCV test	

mod1 %>% 	
  bptest() # Breush-Pagan test	

### Igen, serul a homoszkedaszticitas feltetele

# 10. Ha serult a homoszkedaszticitas feltetele, kezeld azt az oran tanultak szerint


### egyik lehetseges megoldas: log() transzformaljuk az adatokat

mydata = mydata %>%
  mutate(views_log = log(views+1),
         likes_log = log(likes+1),
         dislikes_log = log(dislikes+1),
         comment_count_log = log(comment_count+1))

mod2 = lm(views_log ~ likes_log + dislikes_log + comment_count_log, data = mydata)
summary(mod2)


mod2 %>% 	
  plot(which = 3)	

mod2 %>% 	
  ncvTest() # NCV test	

mod2 %>% 	
  bptest() # Breush-Pagan test	


### egy masik lehetseges megoldas: sandwitch estimators thasznalunk
# compute robust SE and p-values	
mod1_sandwich_test = coeftest(mod1, vcov = vcovHC, type = "HC")	
mod1_sandwich_test	

mod1_sandwich_se = unclass(mod1_sandwich_test)[,2]	

# compute robust confidence intervals	
CI95_lb_robust = coef(mod1)-1.96*mod1_sandwich_se
CI95_ub_robust = coef(mod1)+1.96*mod1_sandwich_se

cbind(mod1_sandwich_test, CI95_lb_robust, CI95_ub_robust)	


# 11. Ellenorizd a multikollinearits hianyat. Talalhatunk multikollinearitasra utalo jelet a modeldiagnosztika alapjan?


vif(mod1)

### Igen, serul a multikollinearitas feltetele

# 12. Ha talalhatunk multikollinearitasra utalo jelet a modeldiagnosztika alapjan,  kezeld azt az oran tanultak szerint

### Mivel ez adat-multikollinearitas, ezert kizarjuk az egyik prediktort: comment_count

mod3 = lm(views ~ likes + dislikes, data = mydata)
summary(mod3)

### ez utan mar nincs szamottevo multikollinearitas
vif(mod3)

# 13. Ellenorizd a linearitas feltetelet. Talalhatunk nem linearis kapcsolatra utalo jelet a modeldiagnosztika alapjan?


mod3 %>% 	
  residualPlots()	



### A likes valtozonal van indikacio nem-linearis kapcsolatra, de ez ugy tunik hogy elsosroban kiugro ertekeknek koszonheto.


# 14. Ha talalsz a linearitas serulesere utalo jelet, kezed azt az oran tanultak alapjan
### Itt donthetnenk ugy hogy maradunk a liearis modellnel, vagy hogy kizarjuk az extrem eseteket
### amik a nem-linearitasert felelosek, de bevonhatunk hatvanyprediktorokat is a modellbe. Esetleng
### meg lehet probalni az ket modellt illeszteni az adatbazis ket felere, az egyik modell
### az "atlagos" videok nezettsegenek leirasara szolgalna, mig a masik az extremen sokat likeolt
### videok nezettsegerol szolna.

### egy lehetseges megoldas hogy a kutatasi jelentesben jelezzuk hogy volt egy
### indikacio a likes es a views kozott egy U alaku osszefuggesre, de a vizualis elemzes alalpjan
### ez az osszefugges nem volt eros, ezert tovabbra is a linearis modellt hasznaltuk.


