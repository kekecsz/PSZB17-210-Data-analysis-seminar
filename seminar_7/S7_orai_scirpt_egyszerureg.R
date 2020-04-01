# ---	
# title: "Linearis regresszio"	
# author: "Kekecs Zoltan"	
# date: "March 31 2020"	
# output:	
#   html_document: default	
#   word_document: default	
#   pdf_document: default	
# ---	
# 	
# 	
knitr::opts_chunk$set(echo = T, tidy.opts=list(width.cutoff=60), tidy=TRUE)	
# 	
# 	
# # A linearis regresszio alapjai	
# 	
# Ennek az oranak a celja hogy megismerkedjunk a linearis regresszioval, annak logikajaval, es az ertelmezesehez szukseges alapfogalmakkal.	
# 	
# A dokumentum legfrissebb valotzata itt talalhato:	
# https://osf.io/5a4kj/	
# 	
# 	
# ## Package-ek betoltese	
# 	
# Betoltjuk a kovatkazo package-eket:	
# 	
# 	
library(psych) # for describe	
library(gsheet) # to read data from google sheets	
library(tidyverse) # for tidy code	
# 	
# 	
# ## Sajat funckiok betoltese	
# 	
# Az alabbi funkcio csak az orai vizualizaciohoz kell, nem feltetlenul kell megerteni a tartalmat.	
# Ezt a funkciot arra hasznaljuk majd hogy a linearis regresszioban fennmarado (rezidualis) hibat vizualizaljuk.	
# 	
# 	
	
	
error_plotter <- function(mod, col = "black", x_var = NULL){	
  mod_vars = as.character(mod$call[2])	
  data = as.data.frame(eval(parse(text = as.character(mod$call[3]))))	
  y = substr(mod_vars, 1, as.numeric(gregexpr(pattern ='~',mod_vars))-2)	
  x = substr(mod_vars, as.numeric(gregexpr(pattern ='~',mod_vars))+2, nchar(mod_vars))	
  	
  data$pred = predict(mod)	
  	
  if(x == "1" & is.null(x_var)){x = "response_ID"	
  data$response_ID = 1:nrow(data)} else if(x == "1"){x = x_var}	
  	
  plot(data[,y] ~ data[,x], ylab = y, xlab = x)	
  abline(mod)	
  	
  for(i in 1:nrow(data)){	
    clip(min(data[,x]), max(data[,x]), min(data[i,c(y,"pred")]), max(data[i,c(y,"pred")]))	
    abline(v = data[i,x], lty = 2, col = col)	
  }	
  	
}	
# 	
# 	
# ## Adatmenedzsment es adat bemutatasa	
# 	
# ### Adatok betoltese	
# 	
# Mondjuk, hogy egy turistak koreben gyakran latogatott cipoboltban dolgozunk, es mivel a vilagon sokfajta cipomeretet hasznalnak es az emberek gyakran nem tudjak a sajat europai cipomeretuket, szeretnenk a magassaguk alapjan megbecsulni, mekkora az europai cipomeretuk.	
# 	
# Az alabbi koddal betolthetjuk az adattablat, amiben a korabbi orakon felvett kerdoivekbol szerepelnek a magassag es cipomeret adatok.	
# 	
# 	
mydata = as_tibble(gsheet2tbl("https://docs.google.com/spreadsheets/d/1GXx2YoktyIdXLqKdm4f_MMWHUzXYgxWRRr3avYnWaew/edit?usp=sharing"))	
# 	
# 	
# ### Adatok ellenorzese	
# 	
# Szokas szerint az adatok ellenorzesevel kezdunk, pl. View(), describe(), es summary() funkciokkal.	
# 	
# 	
# descriptive statistics	
describe(mydata)	
	
mydata %>% 	
  summary()	
	
# histograms	
mydata %>% 	
  ggplot() +	
  aes(x = magassag) +	
  geom_histogram()	
	
mydata %>% 	
  ggplot() +	
  aes(x = cipomeret) +	
  geom_histogram()	
	
# scatterplot	
mydata %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret) +	
  geom_point()	
	
# 	
# 	
# ### Adattisztitas es ellenorzes	
# 	
# Lathato hogy van egy ember aki centimeter helyett meterben adta meg a magassagat. Ezt javitjuk es ellenorizzuk hogy minden jol nez-e ki ezek utan.	
# 	
# 	
	
mydata_corrected = mydata %>% 	
  mutate(magassag = replace(magassag, magassag == 1.82, 182))	
	
# descriptive statistics	
describe(mydata_corrected)	
	
mydata_corrected %>% 	
  summary()	
	
# histograms	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag) +	
  geom_histogram()	
	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = cipomeret) +	
  geom_histogram()	
	
# scatterplot	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret) +	
  geom_point()	
	
	
# scatterplot with labels	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret, label = jelige) +	
  geom_point() +	
  geom_label(nudge_y = 0.5)	
	
# 	
# 	
# Van egy ember akinek a cipomeret erteke kiogro a tobbi adatban lathato trendbol a magassaggal valo osszehasonlitasban. A vizsgalati szemely jelezte hogy ez egy hibas adatbevitel volt, a helyes cipomeret 37, nem 47. Ezt javitjuk. 	
# 	
# (Altalaban ilyen beslo informacio nem all rendelkezesre, ilyen esetben a hasonli kiugro adatot vagy kizarnank teljesen az elemzesbol, vagy megtartanank hogy realis az ertek, de megjegyeznenk a kutatasi jelentesben/cikkben, hogy volt egy kiugro eset.)	
# 	
# 	
# 	
	
mydata_corrected = mydata_corrected %>% 	
  mutate(cipomeret = replace(cipomeret, jelige == "___", 37))	
	
# scatterplot	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret) +	
  geom_point()	
	
# 	
# 	
# 	
# ## Bejoslas linearis modellel	
# ### Egyszeru linearis modell felepitese	
# 	
# A regreszio **bejoslasra** vagy becslesre valo. Vagyis szeretnenk megtudni egy valtozo erteket (ezt altalaban bejosolt valtozonak vagy kimeneti valtozonak nevezzuk) mas bejoslo (prediktor) valtozok erteke alapjan.	
# 	
# Az alabbi peldaban szeretnenk megbecsulni (bejosolni/prediktalni) az egyes szemelyek EU cipomeretet (ez a bejosolt/kimeneti valtozó) a szemely magassaganak ismereteben (ez a bejoslo/prediktor valotozo). Ehhez eloszor az elozetes adataink hasznalataval felepitunk egy regresszios modellt.	
# 	
# A linearis regresszios modellt az **lm()** funkcioval epitjuk. Mindig ugy kell felepiteni, hogy a bejosolni kivant valtozoval kezdunk (cipomeret), majd a ~ jel utan irjuk a bejoslo valtozot (magassag). A kod vegen pedig azt specifikaljuk, melyik adattablaban talalhatoak ezek a valtozok a "data = ..." parameter megadasaval. A modellt elmentjuk egy objektumba (ezt most mod1-nek neveztuk el, de barminek elnevezhetnenk).	
# 	
# Az egyszeru linearis regresszional (simple linear regression) csak egy bejoslo valtozonk van. 	
# 	
# A linearis regresszioban tobb bejoslo valtozot is hasznalhatunk, ilyenkor tobbszoros linearis regresszionak nevezzuk az eljarast (multiple linear regression). Errol majd kesobb lesz szo.	
# 	
# 	
mod1 <- lm(cipomeret ~ magassag, data = mydata_corrected)	
# 	
# 	
# Az linearis regresszioban a kimeneti valtozo es a prediktor kozotti kapcsolatot egy egyenessel modellezzuk. A modell az az egyenes lesz ami a legkozelebb van a pont diagram pontjaihoz.	
# 	
# 	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F)	
# 	
# 	
# A regresszios modell megad egy matematikai egyenletet, amibe a prediktor valtozo erteket behelyettesitve megkaphatjuk a legjobb becslest a kimeneti valtozo ertekere. Ezt az egyenletet regresszios egyenletnek (regression equation) nevezzuk.	
# 	
# A **regresszios egyenletet** igy formalizaljuk: Y = b0 + b1*X1, amelyben Y a kimeneti (bejosolt) valtozo becsult erteke, a b0 egy allando/konstans ertek, amit legtobbszor intercept-nek neveznek, a b1 a regresszios egyutthato, az x1 pedig a bejososlo (prediktor) erteke az adott szemelynel. 	
# 	
# Vagyis ugy kaphatunk egy becslest az Y bejosolt valotozo ertekere (magassag), ha a konstanshoz hozzaadjuk a regresszios egyutthato es a prediktor ertekenek szorzatat.    	
# 	
# Ha kilistazzuk a modell objektumot (mod1), akkor megkaphatjuk a **regresszios egyenletet** erre a modellre amit most epitettunk.	
# 	
# 	
mod1	
# 	
# 	
# Tegyuk fel hogy a regresszios egyelet elemei a kovetkezok:	
# 	
# - intercept (b0) = -9.13	
# - a magassaghoz tartozo regresszios egyutthato (b1) = 0.28	
# 	
# Ezeket az adatokat a modell objektum kilistazasaval olvashatjuk le a Coefficients: reszbol.	
# 	
# Ez azt jelenti, hogy a cipomeretet bejoslo regresszios egyenlet a kovetkezo: 	
# 	
# cipomeret = -9.13 + 0.28 * magassag	
# 	
# vagyis egy 170 cm magas ember eseten a modell altal becsult cipomeret:	
# 	
# -9.13 + 0.28 * 170 = 38.47	
# 	
# Ezt a szamitast nem kell kezzel vagy fejben megcsinalni, ehelyett hasznalhatod az R predict() funciojat a bejosolt ertek kiszamitasara barmilyen, vagy akar tobb prediktor-ertekre is.	
# 	
# A predict() funkcio hasznalatahoz meg kell adnunk egy adattablat (data.frame vagy tibble-t) ami a prediktor ertekeit tartalmazza, amit a kimeneti valtozo megbecslesere, bejoslasara szeretnenk hasznalni. 	
# 	
# 	
# 	
magassag = c(150, 160, 170, 180, 190)	
magassag_df = as.data.frame(magassag)	
	
predictions = predict(mod1, newdata = magassag_df)	
	
magassag_df_with_predicted = cbind(magassag_df, predictions)	
magassag_df_with_predicted	
# 	
# 	
# Vagyuk eszre hogy a bejosolt ertekek mind pontosan a regresszios egyenesre esnek. Maszoval a regresszios egyenes minden lehetseges prediktorertekre megadja a kimeneti valtozo bejosolt erteket. 	
# 	
# 	
	
mydata_corrected %>% 	
  ggplot() +	
  aes(x = magassag, y = cipomeret) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F) +	
  geom_point(data = magassag_df_with_predicted, aes(x = magassag, y = predictions), col = "red", size = 7)	
# 	
# 	
# **______Gyakorlas_______**	
# 	
# 1. Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **energiaszint_1** a kimeneti valtozo es az **alvas_altalaban_1** a prediktor. A modell eredmenyet mentsd el egy objektumba.	
# 2. Ird le a regresszios fuggvenyt amivel bejosolhato az energiaszint.	
# 3. Ertelmezd a regresszios fuggvenyt. Aki tobbet alszik annak magasabb vagy alacsonyabb az energiaszintje? (Egy abra segithet)	
# 4. Ertelmezd a regresszios fuggvenyt. Aki egy oraval tobbet alszik mint masok, annak mennyivel varhato hogy magasabb lesz az energiaszintje?	
# 5. Ennek a modellnek a segitsegevel becsuld meg az energiaszintjet olyan embereknek akik altalaban 5, 7, vagy 9 orat alszanak.	
# 	
# **________________________**	
# 	
# ## Milyen jo a modellem? (modellilleszkedes)	
# 	
# ### Hogyan merheto a becslesi/bejoslasi hatekonysag?	
# 	
# A modell becslesi hatekonysagat tobb fele keppen lehet merni. A legkezenfekvobb modszer, hogy meghatarozzuk, a modell becslese mennyire esett tavol a valos bejosolni kivant ertekektol. Vagyis megmerjuk a modell figyelembevetele utan fennmarado "hibat".	
# 	
# Ezt konnyen megtehetjuk egy olyan adatbazisban, ahol rendelkezesunkre all a bejosolni kivant valtozo valos erteke, ugy hogy kivonjuk egymasbol a valos erteket es a modell altal becsult erteket. Ez a rezidualis (fennmarado) hiba, masneven **residual error**. 	
# 	
# 	
error_plotter(mod1, col = "blue")	
# 	
# 	
# Ha vesszuk az osszes ilyen hiba ertek abszoluterteket, es osszeadjuk oket, megkapjuk a modell rezidualis abszolut hiba (residual absolute difference - RAD) erteket.	
# 	
# Ennel azonban joval gyakoribb hogy a rezidualis hiba negyzetosszeget hasznaljak (**residual sum of squares** - RSS) a statisztikaban. Vagyis az egyes rezidualis hiba ertekeket negyzetre emelik, majd osszeadjak oket.	
# 	
# Az alabbi peldaban a mod1 eredeti adattablajanak magassagertekeit hasznaljuk a cipomeret becsult ertekenek kiszamitasara (predict(mod1)), es ezt vonjuk ki az ugyan ezen adattablaban szereplo valos  cimpomeret ertekekbol, igy kapjuk meg a rezidualis hibaertekeket. Majd egyenkent vagy az abszolutertekeuket (RAD), vagy a negyzetuket vesszuk (RSS), es osszeadjuk oket a sum() fugvennyel.	
# 	
# 	
RAD = sum(abs(mydata_corrected$cipomeret - predict(mod1)))	
RAD	
	
RSS = sum((mydata_corrected$cipomeret - predict(mod1))^2)	
RSS	
# 	
# 	
# ### Hasznos a modellunk?	
# 	
# Azt, hogy mennyire hasznos a modellunk (mennyit nyerunk azzal, hogy ezt a modellt hasznaljuk), meghatarozhatjuk ugy, hogy osszehasonlitjuk a rezidualis hibat abban az esetben amikor a modellunket hasznaljuk (vagyis amikor figyelembe vesszuk a prediktoraink erteket) egy olyan esettel, amikor a prediktorokat egyalatalan nem vesszuk figyelembe, csak a bejosolni kivant valtozo atlagat hasznaljuk a becslesre.	
# 	
# Az alabbi kodban epitunk egy olyan uj modellt, ahol nem veszunk figyelembe semmilyen masik valtozot, csak a cipomeret atlagat, es azt hasznaljuk fel a cipomeret becslesekent. (pl. ha tudjuk, hogy a populacioban az atlagos cipomeret 38, akkor mindenkinek ezt a cipomeretet becsuljuk majd, fuggetlenul attol, hogy milyen magas az illeto). Ezt a modellt **null modellnek** nevezzuk. Azt, hogy a bejosolt valtozo atlagat akarjuk becslesre hasznalni, ugy adhatjuk meg, hogy a ~ utan csak egy 1-est rakunk, nem irunk mas valtozonevet.	
# 	
# Ez persze nagy rezidualis hibahoz vezet (hiszen bar ez a populacioban az atlagos, megis a legtobb embernek nem pont 38-as a laba). A null modell altal produkalt rezidualis hibat ugyan ugy szamoljuk ki, mint a tobbi modellnel a residual sum of squared-et, viszont ennek van egy specialis neve is az irodalomban, ezt ugy hivjak, hogy **total sum of squares** (TSS), mert ez a lehetseges legegyszerubb meg ertelmes modell, ami altalaban azert nagy hibaval jar, igy ezt vesszuk a "teljes" hiba mennyisegnek, es ehhez viszonyitjuk a tobbi modell altal elert hibat.	
# 	
# Alabb kiszamoljuk a TSS-t. Lathato hogy a formula ugyan az mint az RSS eseten.	
# 	
# 	
mod_mean <- lm(cipomeret ~ 1, data = mydata_corrected)	
	
error_plotter(mod_mean, col = "red", x_var = "magassag") # visualize error	
	
TSS = sum((mydata_corrected$cipomeret - predict(mod_mean))^2)	
TSS	
# 	
# 	
# ### Mennyivel jobb a modellunk a null modellnel?	
# 	
# Azt, hogy mennyi informaciot nyertunk a kimeneti valtozo valtozekonysagarol (variance) a prediktorok figyeklembevetelevel ahhoz kepest ha a null modellt vettuk volna figyelembe, az R^2 statisztika mutatja meg. Ennek a formulaja: 1-(RSS/TSS)	
# 	
# 	
# 	
R2 = 1-(RSS/TSS)	
R2	
# 	
# 	
# Tegyuk fel hogy az R^2 ebben az esetben 0.81. Ez azt jelenti, hogy a prediktorok figyelembevetelevel (a mi esetunkben ez a magassag), a cipomeret valtozekonysaganak 81%-at tudjuk megmagyarazni. 	
# 	
# R^2 = 1 azt jelenti, hogy a kimeneti valtozo variabilitasat teljesen meg tudjuk magyarazni a prediktorok ismereteben. 	
# R^2 = 0 azt jelenti, hogy a kimeneti valtozo variabilitasat egyaltalan nem magyarazzak meg a prediktorok	
# 	
# ### Hasznos a modellunk a populaciora nezve is?	
# 	
# Azt, hogy a modellunk hasznos-e a kimeneti valtozo bejoslasara populacio-szinten is, ugy tudjuk meghatarozni, hogy meghatarozzuk, a prediktorokat tartalmazo modell **szigifikansan jobb-e** mint a null modell a kimeneti valtozo becslesere?	
# 	
# Egy F tesztet hasznalhatunk a szignifikancia szint meghatarozosahoz. Ezt ugy kaphatjuk meg az R-ben hogy a ket modell altal produkalt rezidualis hibat az anova() funkcioval hasonlithatjuk ossze, melybe a null modell es a prediktorokat tartalamzo modell objektumot kell beletenni (akar tobbet mint ket modellt is lehet egyszerre). Itt az F-teszthez tartozo teszt statisztikat es p-erteket nezzuk, ha a szignifikanciara vagyunk kivancsiak.	
# 	
# 	
anova(mod_mean, mod1)	
# 	
# 	
# 	
# ### Az egyszeru megoldas	
# 	
# A fentiekben lepesrol lepesre elvegeztuk a regresszio legfontosabb szamitasait sajat magunk altal irt koddal, hogy megertsetek, mi folyik egy linearis regresszio soran a "motorhazteto alatt". De ahogy sejthetitek, minderre az R-ben van egy gyorsabb es joval egyszerubb megoldas: 	
# 	
# A modell summary() kikeresevel mindez a fenti informacio megkaphato, es meg tobb is.	
# 	
# Itt megtalalod az R^2 erteket, a modell null modellel valo osszehasonlitasanak F teszt statisztikajat es szignifikanciajat, es meg a regresszios egyenletet elemeit is.	
# 	
# 	
summary(mod1)	
	
# 	
# 	
# A regresszios egyutthatok (regression coefficients) konfidencia intervallumat a confint() paranccsal lehet kilistazni. 	
# 	
# 	
confint(mod1)	
# 	
# 	
# A regresszios becsles konfidencia intervallumat pedig a geom_smooth()-al lehet vizualizalni.	
# 	
# 	
ggplot(mydata_corrected, aes(x = magassag, y = cipomeret))+	
  geom_point()+	
  geom_smooth(method='lm',formula=y~x)	
# 	
# 	
# 	
# **______Gyakorlas_______**	
# 	
# 1. (Ezt nem kell megtenned ha ezt mar megtetted az elozo gyakorlasban, csak hasznald ugyan azt a model objektumot) Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **energiaszint_1** a kimeneti valtozo es az **alvas_altalaban_1** a prediktor. A modell eredmenyet mentsd el egy objektumba mentsd.	
# 2. Listazd ki a model summary-t a summary() fugvennyel	
# 3. Olvasd le a model RSS-jet	
# 4. Olvasd le hogy a model ami tartalmazza az alvas_altalaban_1 prediktort szignifikansan jobb bejosloja-e az energiaszintnek mint a null modell.	
# 5. Hatarozd meg a regresszios egyutthatok konfidencia intervallumat a confint() fuggvennyel	
# 	
# **________________________**	
# 	
