#################################################################
#################################################################
#  Hazi feladat a fokomponenselemzes es faktorelemzes temaban   #
#################################################################
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



fviz_loadnings_with_cor <- function(mod, axes = 1, loadings_above = 0.4){
  require(factoextra)
  require(dplyr)
  require(ggplot2)
  
  
  
  if(!is.na(as.character(mod$call$call)[1])){
    if(as.character(mod$call$call)[1] == "PCA"){
      contrib_and_cov = as.data.frame(rbind(mod[["var"]][["contrib"]], mod[["var"]][["cor"]]))
      
      vars = rownames(mod[["var"]][["contrib"]])
      attribute_type = rep(c("contribution","correlation"), each = length(vars))
      contrib_and_cov = cbind(contrib_and_cov, attribute_type)
      contrib_and_cov
      
      plot_data = cbind(as.data.frame(cbind(contrib_and_cov[contrib_and_cov[,"attribute_type"] == "contribution",axes], contrib_and_cov[contrib_and_cov[,"attribute_type"] == "correlation",axes])), vars)
      names(plot_data) = c("contribution", "correlation", "vars")
      
      plot_data = plot_data %>% 
        mutate(correlation = round(correlation, 2))
      
      plot = plot_data %>% 
        ggplot() +
        aes(x = reorder(vars, -contribution), y = contribution, gradient = correlation, label = correlation)+
        geom_col(aes(fill = correlation)) +
        geom_hline(yintercept = mean(plot_data$contribution), col = "red", lty = "dashed") + scale_fill_gradient2() +
        xlab("variable") +
        coord_flip() +
        geom_label(color = "black", fontface = "bold", position = position_dodge(0.5))
      
      
    }
  } else if(!is.na(as.character(mod$Call)[1])){
    
    if(as.character(mod$Call)[1] == "fa"){
      loadings_table = mod$loadings %>% 
        matrix(ncol = ncol(mod$loadings)) %>% 
        as_tibble() %>% 
        mutate(variable = mod$loadings %>% rownames()) %>% 
        gather(factor, loading, -variable) %>% 
        mutate(sign = if_else(loading >= 0, "positive", "negative"))
      
      if(!is.null(loadings_above)){
        loadings_table[abs(loadings_table[,"loading"]) < loadings_above,"loading"] = NA
        loadings_table = loadings_table[!is.na(loadings_table[,"loading"]),]
      }
      
      if(!is.null(axes)){
        
        loadings_table = loadings_table %>% 
          filter(factor == paste0("V",axes))
      }
      
      
      plot = loadings_table %>% 
        ggplot() +
        aes(y = loading %>% abs(), x = reorder(variable, abs(loading)), fill = loading, label =       round(loading, 2)) +
        geom_col(position = "dodge") +
        scale_fill_gradient2() +
        coord_flip() +
        geom_label(color = "black", fill = "white", fontface = "bold", position = position_dodge(0.5)) +
        facet_wrap(~factor) +
        labs(y = "Loading strength", x = "Variable")
    }
  }
  
  
  
  
  
  
  return(plot)
  
}

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
# elemzest.

bfi_mixedCor = mixedCor(my_data_bfi, c=NULL, p=1:25)
bfi_correl = bfi_mixedCor$rho

# 4. Vizualizald a korrelaciokat legalabb egy vizualizacios modszerrel

ggcorrplot(bfi_correl, p.mat = cor_pmat(bfi_correl), hc.order=TRUE, type='lower')

ggcorr(bfi_correl)
network_plot(bfi_correl, min_cor=0.6)

# 5. Hatarozd meg hogy faktorizalhatoak-e az adatok a Kaiser-Meyer-Olkin
# teszt alapjan. Indolkold meg a dontesedet.

KMO(bfi_correl)


### igen, mert a KMO osszerteke 0.85, es az egyes itemekhez tartozo KMO ertek is
### magasabb 0.6-nal.

# 6. Ellenorizd hogy az adatok tobbvaltozos normalis eloszlast kovetnek-e. 
# Az eredmeny alapjan hataroz meg, melyik faktorextrakcios modszert fogod hasznalni.

result <- mvn(my_data_bfi, mvnTest = "hz")
result$multivariateNormality

mvnorm.kur.test(na.omit(my_data_bfi))
mvnorm.skew.test(na.omit(my_data_bfi))

### nem, a normalitas feltetele serult, ezert a paf 
## faktorextrakcios modszert hasznalom majd.


# 7. Hatarozd meg az idealis faktorszamot

fa.parallel(bfi_correl, n.obs = nrow(my_data_bfi),
            fa = "fa", fm = "pa")

nfactors(bfi_correl, n.obs = nrow(my_data_bfi))

### itt tobb lehetseges jo megoldas is van, 4-6 faktoring indikolt a dontes

# 8. Vegezd el a faktorextrakciot az altalad valasztott modszerrel es faktorszammal.
# Epits ket kulonbozo modellt, az egyikben ortoginalis, a masikat oblique
# faktorrotaciot hasznalva.

EFA_mod_ortogonal <- fa(bfi_correl, nfactors = 5, fm="pa", rotate = "varimax")
EFA_mod_oblique <- fa(bfi_correl, nfactors = 5, fm="pa", rotate = "oblimin")

# 9. Ellenorizd a kommunalitasokat. Mekkora az talagos kommunalitas?

as.data.frame(sort(EFA_mod_ortogonal$communality, decreasing = TRUE))

mean(EFA_mod_ortogonal$communality)

# 10. Vizualizald a ket modell altal produkalt faktorstrukturat es a faktortolteseket
# a ?bfi parancs segitsegevel nezheted meg az egyes valtozokhoz tartozo pontos
# kerdeseket.
# Mi a kulonbseg a ket faktorszerkezet kozott?

fa.diagram(EFA_mod_ortogonal)
fa.diagram(EFA_mod_oblique)



fviz_loadnings_with_cor(EFA_mod_ortogonal, axes = 1, loadings_above = 0.4)
fviz_loadnings_with_cor(EFA_mod_oblique, axes = 1, loadings_above = 0.4)

fviz_loadnings_with_cor(EFA_mod_ortogonal, axes = 2, loadings_above = 0.4)
fviz_loadnings_with_cor(EFA_mod_oblique, axes = 2, loadings_above = 0.4)

fviz_loadnings_with_cor(EFA_mod_ortogonal, axes = 3, loadings_above = 0.4)
fviz_loadnings_with_cor(EFA_mod_oblique, axes = 3, loadings_above = 0.4)

fviz_loadnings_with_cor(EFA_mod_ortogonal, axes = 4, loadings_above = 0.4)
fviz_loadnings_with_cor(EFA_mod_oblique, axes = 4, loadings_above = 0.4)

### A varimax forgatassal kapott faktorstruktura kicsit tisztabb, es konnyebben
### ertelmezheto, mivel korrelalatlanok a faktorok. A direct oblimin forgatassal
### a PA1 es a PA5 faktorok korrelalnak.


