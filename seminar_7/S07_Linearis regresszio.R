
# Ennek az oranak a celja hogy megismerkedjunk a linearis regresszioval, annak logikajaval, es az ertelmezesehez szukseges alapfogalmakkal. Eloszor az ugynevezett "egyszeru" linearis regressziot (simple regression) fogjuk megismerni, ahol egy bejoslo valtozo alapjan becsuljuk meg egy kimeneti valtozo erteket. Miutan megismertuk az egyszeru regresszioval, tovabbmegyunk a tobbszoros regressziora, ahol altalanositjuk az egyszeru regressziorol nyert tudast olyan esetekre, ahol tobb prediktor (bejoslo valtozo) is szerepel a modellben.	

# ## Package-ek betoltese	

# Betoltjuk a kovatkazo package-eket:	


library(psych) # for describe	
library(gsheet) # to read data from google sheets	
library(car)# for scatter3d	
library(psych) # for describe	
library(lm.beta) # for lm.beta	
library(gridExtra) # for grid.arrange	
library(tidyverse) # for tidy code	



# ## Sajat funckiok betoltese	

# Alabb ket sajat funkciot fogunk betolteni. Az error_plotter() funkciot arra hasznaljuk majd hogy a linearis regresszioban fennmarado (rezidualis) hibat vizualizaljuk. A coef_table() funkciot pedig arra nasznaljuk majd hogy tablazatot generaljunk az eredmenyekbol.	
# A funkciok kodjat nem fontos megerteni, de erdemes oket betolteni hogy ponotosan reprodukalhasd az orai jegyzetben latottakat.	


	
	
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



# # Egyszeru linearis regresszio	

# ## Adatmenedzsment es adat bemutatasa 1	

# ### Adatok betoltese	

# Mondjuk, hogy egy turistak koreben gyakran latogatott cipoboltban dolgozunk, es mivel a vilagon sokfajta cipomeretet hasznalnak es az emberek gyakran nem tudjak a sajat europai cipomeretuket, szeretnenk a magassaguk alapjan megbecsulni, mekkora az europai cipomeretuk.	

# Az alabbi koddal betolthetjuk az adattablat, amiben a korabbi orakon felvett kerdoivekbol szerepelnek a magassag es cipomeret adatok.	


mydata = as_tibble(gsheet2tbl("https://docs.google.com/spreadsheets/d/1sPBXkgm7o4IsMrP55ZPk0v06U-qBSgRrmDkbiJLBe_g/edit?usp=sharing"))	


# ### Adatok ellenorzese	

# Szokas szerint az adatok ellenorzesevel kezdunk, pl. View(), describe(), es summary() funkciokkal.	


# descriptive statistics	
describe(mydata)	
	
mydata %>% 	
  summary()	
	
# histograms	
mydata %>% 	
  ggplot() +	
  aes(x = height) +	
  geom_histogram()	
	
mydata %>% 	
  ggplot() +	
  aes(x = shoe_size) +	
  geom_histogram()	
	
# scatterplot	
mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size) +	
  geom_point()	
	



# ## Bejoslas linearis modellel	
# ### Egyszeru linearis modell felepitese	

# A regreszio **bejoslasra** vagy becslesre valo. Vagyis szeretnenk megtudni egy valtozo erteket (ezt altalaban bejosolt valtozonak vagy kimeneti valtozonak nevezzuk) mas bejoslo (prediktor) valtozok erteke alapjan.	

# Az alabbi peldaban szeretnenk megbecsulni (bejosolni/prediktalni) az egyes szemelyek EU cipomeretet (ez a bejosolt/kimeneti valtozó) a szemely magassaganak ismereteben (ez a bejoslo/prediktor valotozo). Ehhez eloszor az elozetes adataink hasznalataval felepitunk egy regresszios modellt.	

# Az linearis regresszioban a kimeneti valtozo es a prediktor kozotti kapcsolatot egy egyenessel modellezzuk. A modell az az egyenes lesz ami a legkozelebb esik a pont diagram pontjaihoz.	


mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F)	


# A linearis regresszios modellt az **lm()** funkcioval epitjuk. Mindig ugy kell felepiteni, hogy a bejosolni kivant valtozoval kezdunk (shoe_size), majd a ~ jel utan irjuk a bejoslo valtozot (height). A kod vegen pedig azt specifikaljuk, melyik adattablaban talalhatoak ezek a valtozok a "data = ..." parameter megadasaval. A modellt elmentjuk egy objektumba (ezt most mod1-nek neveztuk el, de barminek elnevezhetnenk).	

# Az egyszeru linearis regresszional (simple linear regression) csak egy bejoslo valtozonk van. 	

# A linearis regresszioban tobb bejoslo valtozot is hasznalhatunk, ilyenkor tobbszoros linearis regresszionak nevezzuk az eljarast (multiple linear regression). Errol majd kesobb lesz szo.	


mod1 <- lm(shoe_size ~ height, data = mydata)	


# A regresszios modell megad egy matematikai egyenletet, amibe a prediktor valtozo erteket behelyettesitve megkaphatjuk a legjobb becslest a kimeneti valtozo ertekere. Ezt az egyenletet regresszios egyenletnek (regression equation) nevezzuk.	

# ### Regresszios egyenlet	

# A **regresszios egyenletet** igy formalizaljuk: Y = b0 + b1*X1, amelyben Y a kimeneti (bejosolt) valtozo becsult erteke, a b0 egy allando/konstans ertek, amit legtobbszor intercept-nek neveznek, a b1 a regresszios egyutthato, az x1 pedig a bejososlo (prediktor) erteke az adott szemelynel. 	

# Vagyis ugy kaphatunk egy becslest az Y bejosolt valotozo ertekere (height), ha a konstanshoz hozzaadjuk a regresszios egyutthato es a prediktor ertekenek szorzatat.    	

# Ha kilistazzuk a modell objektumot (mod1), akkor megkaphatjuk a **regresszios egyenletet** erre a modellre amit most epitettunk.	


mod1	


# Tegyuk fel hogy a regresszios egyelet elemei a kovetkezok:	

# - intercept (b0) = 3.74	
# - a height-hoz tartozo regresszios egyutthato (b1) = 0.21	

# Ezeket az adatokat a modell objektum kilistazasaval olvashatjuk le a Coefficients: reszbol.	

# Ez azt jelenti, hogy a cipomeretet bejoslo regresszios egyenlet a kovetkezo: 	

# shoe_size = 3.74 + 0.21 * height	

# vagyis egy 170 cm magas ember eseten a modell altal becsult cipomeret:	

# 3.74 + 0.21 * 170 = 39.44	

# ### Becsles a regresszios egyenlet alapjan	

# Ezt a szamitast nem kell kezzel vagy fejben megcsinalni, ehelyett hasznalhatod az R predict() funciojat a bejosolt ertek kiszamitasara barmilyen, vagy akar tobb prediktor-ertekre is.	

# A **predict()** funkcio hasznalatahoz meg kell adnunk egy adattablat (data.frame vagy tibble-t) ami a prediktor ertekeit tartalmazza, amit a kimeneti valtozo megbecslesere, bejoslasara szeretnenk hasznalni. 	



height = c(160, 170, 180, 190)	
height_df = as.data.frame(height)	
	
predictions = predict(mod1, newdata = height_df)	
	
height_df_with_predicted = cbind(height_df, predictions)	
height_df_with_predicted	


# Vagyuk eszre hogy a bejosolt ertekek **mind pontosan a regresszios egyenesre esnek**. Masszoval a regresszios egyenes minden lehetseges prediktorertekre megadja a kimeneti valtozo bejosolt erteket. 	


	
mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F) +	
  geom_point(data = height_df_with_predicted, aes(x = height, y = predictions), col = "red", size = 7)	


# **______Gyakorlas_______**	

# 1. Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **exam_score** (ZH eredmeny) a kimeneti valtozo es az **hours_of_practice_per_week** (hetente atlagosan hany orat gyakololt) a prediktor. A modell eredmenyet mentsd el egy objektumba.	
# 2. Ird le a regresszios fuggvenyt amivel bejosolhato a ZH eredmeny (exam_score).	
# 3. Ertelmezd a regresszios fuggvenyt. Aki tobbet gyakorol annak magasabb vagy alacsonyabb a ZH eredmenye? (Egy abra segithet)	
# 4. Ertelmezd a regresszios fuggvenyt. Aki egy oraval tobbet gyakorol hetente mint masok, annak mennyivel varhato hogy magasabb lesz az energiaszintje?	
# (Opcionális: 5. Ennek a modellnek a segitsegevel becsuld meg a ZH eredmenyet olyan embereknek akik heti 2, 5, vagy 8 orat gyakorolnak.)	

# **________________________**	

# ## Milyen jo a modellem? (modellilleszkedes)	

# ### Hogyan merheto a becslesi/bejoslasi hatekonysag?	

# A modell becslesi hatekonysagat tobb fele keppen lehet merni. A legkezenfekvobb modszer, hogy meghatarozzuk, a modell becslese mennyire esett tavol a valos bejosolni kivant ertekektol. Vagyis megmerjuk a modell figyelembevetele utan fennmarado "hibat".	

# Ezt konnyen megtehetjuk egy olyan adatbazisban, ahol rendelkezesunkre all a bejosolni kivant valtozo valos erteke, ugy hogy kivonjuk egymasbol a valos erteket es a modell altal becsult erteket. Ez a rezidualis (fennmarado) hiba, masneven **residual error**. 	


error_plotter(mod1, col = "blue")	


# Ha vesszuk az osszes ilyen hiba ertek abszoluterteket, es osszeadjuk oket, megkapjuk a modell rezidualis abszolut hiba (residual absolute difference - RAD) erteket.	

# Ennel azonban joval gyakoribb hogy a rezidualis hiba negyzetosszeget hasznaljak (**residual sum of squares** - RSS) a statisztikaban. Vagyis az egyes rezidualis hiba ertekeket negyzetre emelik, majd osszeadjak oket.	

# Az alabbi peldaban a mod1 eredeti adattablajanak magassagertekeit hasznaljuk a cipomeret becsult ertekenek kiszamitasara (predict(mod1)), es ezt vonjuk ki az ugyan ezen adattablaban szereplo valos  cimpomeret ertekekbol, igy kapjuk meg a rezidualis hibaertekeket. Majd egyenkent a negyzetuket vesszuk (RSS), es osszeadjuk oket a sum() fugvennyel.	


RSS = sum((mydata$shoe_size - predict(mod1))^2)	
RSS	


# ### Hasznos a modellunk?	

# Azt, hogy mennyire hasznos a modellunk (mennyit nyerunk azzal, hogy ezt a modellt hasznaljuk), meghatarozhatjuk ugy, hogy **osszehasonlitjuk** a rezidualis hibat abban az esetben **amikor a modellunket hasznaljuk** (vagyis amikor figyelembe vesszuk a prediktoraink erteket) egy olyan esettel, **amikor a prediktorokat egyalatalan nem vesszuk figyelembe**, csak a bejosolni kivant valtozo atlagat hasznaljuk a becslesre.	

# Az alabbi kodban epitunk egy olyan uj modellt, ahol nem veszunk figyelembe semmilyen masik valtozot, csak a cipomeret atlagat, es azt hasznaljuk fel a cipomeret becslesekent. (pl. ha tudjuk, hogy a populacioban az atlagos cipomeret 38, akkor mindenkinek ezt a cipomeretet becsuljuk majd, fuggetlenul attol, hogy milyen magas az illeto). Ezt a modellt **null modellnek** nevezzuk. Azt, hogy a bejosolt valtozo atlagat akarjuk becslesre hasznalni, ugy adhatjuk meg, hogy a ~ utan csak egy 1-est rakunk, nem irunk mas valtozonevet.	

# Ez persze nagy rezidualis hibahoz vezet (hiszen bar ez a populacioban az atlagos, megis a legtobb embernek nem pont 38-as a laba). A null modell altal produkalt rezidualis hibat ugyan ugy szamoljuk ki, mint a tobbi modellnel a residual sum of squared-et, viszont ennek van egy specialis neve is az irodalomban, ezt ugy hivjak, hogy **total sum of squares** (TSS), mert ez a lehetseges legegyszerubb meg ertelmes modell, ami altalaban nagy hibaval jar, igy ezt vesszuk a "teljes" hiba mennyisegnek, es ehhez viszonyitjuk a tobbi modell altal elert hibat.	

# Alabb kiszamoljuk a TSS-t. Lathato hogy a formula ugyan az mint az RSS eseten.	


mod_mean <- lm(shoe_size ~ 1, data = mydata)	
	
error_plotter(mod_mean, col = "red", x_var = "height") # visualize error	
	
TSS = sum((mydata$shoe_size - predict(mod_mean))^2)	
TSS	


# ### Mennyivel jobb a modellunk a null modellnel?	

# Azt, hogy mennyi informaciot nyertunk a kimeneti valtozo valtozekonysagarol (variance) a prediktorok figyelembevetelevel ahhoz kepest ha a null modellt vettuk volna figyelembe, az R^2 statisztika mutatja meg. Ennek a formulaja: 1-(RSS/TSS)	



R2 = 1-(RSS/TSS)	
R2	


# Tegyuk fel hogy az R^2 ebben az esetben 0.73. Ez azt jelenti, hogy a prediktorok figyelembevetelevel (a mi esetunkben ez a magassag), a cipomeret valtozekonysaganak 73%-at tudjuk megmagyarazni. 	

# R^2 = 1 azt jelenti, hogy a kimeneti valtozo variabilitasat teljesen meg tudjuk magyarazni a prediktorok ismereteben. 	
# R^2 = 0 azt jelenti, hogy a kimeneti valtozo variabilitasat egyaltalan nem magyarazzak meg a prediktorok	

# ### Hasznos a modellunk a populaciora nezve is?	

# Azt, hogy a modellunk hasznos-e a kimeneti valtozo bejoslasara populacio-szinten is, ugy tudjuk meghatarozni, hogy meghatarozzuk, a prediktorokat tartalmazo modell **szigifikansan jobb-e** mint a null modell a kimeneti valtozo becslesere?	

# Egy F tesztet hasznalhatunk a szignifikancia szint meghatarozosahoz. Ezt ugy kaphatjuk meg az R-ben hogy a ket modell altal produkalt rezidualis hibat az anova() funkcioval hasonlithatjuk ossze, melybe a null modell es a prediktorokat tartalamzo modell objektumot kell beletenni (akar tobbet mint ket modellt is lehet egyszerre). Itt az F-teszthez tartozo teszt statisztikat es p-erteket nezzuk, ha a szignifikanciara vagyunk kivancsiak.	


anova(mod_mean, mod1)	



# ### Model summary	

# A fentiekben lepesrol lepesre elvegeztuk a regresszio legfontosabb szamitasait sajat magunk altal irt koddal, hogy megertsetek, mi folyik egy linearis regresszio soran a "motorhazteto alatt". De ahogy sejthetitek, minderre az R-ben van egy gyorsabb es joval egyszerubb megoldas: 	

# A modell **summary()** kikeresevel mindez a fenti informacio megkaphato, es meg tobb is.	

# Itt megtalalod az R^2 erteket, a modell null modellel valo osszehasonlitasanak F teszt statisztikajat es szignifikanciajat, es meg a regresszios egyenletet elemeit is.	


summary(mod1)	
	


# A regresszios egyutthatok (regression coefficients) konfidencia intervallumat a confint() paranccsal lehet kilistazni. 	


confint(mod1)	


# A regresszios becsles konfidencia intervallumat pedig a geom_smooth()-al lehet vizualizalni.	


ggplot(mydata, aes(x = height, y = shoe_size))+	
  geom_point()+	
  geom_smooth(method='lm')	



# **______Gyakorlas_______**	

# 1. (Ezt nem kell megtenned ha ezt mar megtetted az elozo gyakorlasban, csak hasznald ugyan azt a model objektumot) Epits egy egyszeru linearis regresszio modellt az lm() fugvennyel amiben az **exam_score** (ZH eredmeny) a kimeneti valtozo es az **hours_of_practice_per_week** (hetente atlagosan hany orat gyakololt) a prediktor. A modell eredmenyet mentsd el egy objektumba.	
# 2. Listazd ki a model summary-t a summary() fugvennyel	
# 3. Olvasd le hogy a model ami tartalmazza az hours_of_practice_per_week prediktort szignifikansan jobb bejosloja-e az exam_score-nak mint a null modell.	
# 4. Hatarozd meg a regresszios egyutthatok konfidencia intervallumat a confint() fuggvennyel	

# **________________________**	


# # Tobbszoros linearis regresszio	

# ## Adatmenedzsment es adat bemutatasa 2	

# ### Az adatfajl betoltese: Lakasarak adattabla	

# Ebben a gyakorlatban lakasok es hazak arait fogjuk megbecsulni.	

# Egy **Kaggle**-rol szarmazo adatbazist hasznalunk, melyben olyan adatok szerepelnek, melyeket valoszinusithetoen alkalmasak **lakasok eladasi aranak bejoslasara**. Az adatbazisban az USA Kings County-bol szarmaznak az adatok (Seattle es kornyeke).	

# Az adatbazisnak csak egy kis reszet hasznaljuk (N = 200).	


data_house = read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_7/data_house_small_sub.csv")	


# ## Adatellenoryes	

# Mindig ellenorizd az adatok strukturajat es integritasat.	

# Eloszor atvaltjuk az USA dollar-t millio forint mertekegysegre, es a negyzetlab adatokat negyzetmeterre.	


data_house %>% 	
  summary()	
	
data_house = data_house %>% 	
  mutate(price_HUF = (price * 293.77)/1000000,	
         sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304	
         )	
	
	



# Egyszeru leiro statisztikak es abrak.	

# Kezdetben a lakasok arat a **sqm_living** (a lakas lakoreszenek alapterulete negyzetmeterben), es a **grade** (a lakas altalanos  minositese a King County grading system szerint, ami a lakas minoseget, poziciojat, a haz minoseget stb. is tartalmazza) prediktorok felhasznalasaval josoljuk majd be. Kesobb a **has_basement** (tartozik-e a lakashoz pince) valtozot is hasznaljuk majd. Szoval fokuszaljunk ezekre a valtozokra az adatellenorzes soran.	


	
# leiro statiszikaka	
describe(data_house)	
	
# hisztogramok	
data_house %>% 	
  ggplot() +	
  aes(x = price_HUF) +	
  geom_histogram( bins = 50)	
	
	
data_house %>% 	
  ggplot() +	
  aes(x = sqm_living) +	
  geom_histogram( bins = 50)	
	
data_house %>% 	
  ggplot() +	
  aes(x = grade) +	
  geom_bar() +	
  scale_x_continuous(breaks = 4:12)	
	
	
# scatterplot	
data_house %>% 	
  ggplot() +	
  aes(x = sqm_living, y = price_HUF) +	
  geom_point()	
	
data_house %>% 	
  ggplot() +	
  aes(x = grade, y = price_HUF) +	
  geom_point()	
	
# leiro statisztika	
table(data_house$has_basement)	
	
# violin plot	
data_house %>% 	
  ggplot() +	
  aes(x = has_basement, y = price_HUF)+	
  geom_violin() +	
  geom_jitter()	
	


# ## Tobbszoros regresszio	

# ### A regresszios modell felepitese (fitting a regression model)	

# A tobbszoros regresszios modellt ugyan ugy epeitjuk mint az egyszeru regresszios modellt, csak csak tobb prediktort is betehetunk a modellbe. Ezeket a prediktorvaltozokat + jellen valasztjuk el egymastol a regresszios formulaban.	

# Alabb **price_HUF** a bejosolt valtozo, es a **sqm_living** es a **grade** a prediktorok.	



mod_house1 = lm(price_HUF ~ sqm_living + grade, data = data_house)	


# A regresszios egyenletet a modell objektumon keresztul erhetjuk el:	


mod_house1	



# A tobbszoros regresszios modellek vizualizacioja nem olyan egyertelmu mint az egyszeru regresszios modelleke.	

# Az egyik megoldas hogy a paronkenti osszefuggeseket vizualizaljuk egyenkent, de ez nem ragadja meg a modell tobbvaltozos jelleget.	


# scatterplot	
plot1 = data_house %>% 	
  ggplot() +	
  aes(x = sqm_living, y = price_HUF) +	
  geom_point()+	
  geom_smooth(method = "lm")	
	
plot2 = data_house %>% 	
  ggplot() +	
  aes(x = grade, y = price_HUF) +	
  geom_point()+	
  geom_smooth(method = "lm")	
	
grid.arrange(plot1, plot2, nrow = 1)	


# Egy alternativa hogy egy haromdimenzios abran abrazoljuk a regresszios sikot.Bar ez szepen nez ki, de nem tul hasznos, es ez is csak ket prediktorvaltozoig mukodik, harom es tobb prediktor eseten mar egy tobbdimenzios terben kepzelheto csak el a regresszios felulet, ezert a vizualizaciora altalaban megis az paronkenti scatterplot-ot szoktuk hasznalni.	


# plot the regression plane (3D scatterplot with regression plane)	
scatter3d(price_HUF ~ sqm_living + grade, data = data_house)	
	


# ### Becsles (prediction)	

# Ugyan ugy ahogy az egyszeru regresszional, itt is kerhetjuk a prediktorok bizonyos uj ertekekeire a kimeneti valtozo ertekenek megbecsleset a predict() fuggveny segitsegevel.	

# Fontos, hogy a prediktorok ertekeit egy data.frame vagy tibble formatumban kell megadnunk, es a prediktorvaltozok valtozoneveinek meg kell egyeznie a regresszios modellben hasznalt valtozonevekkel.	


sqm_living = c(60, 60, 100, 100)	
grade = c(6, 9, 6, 9)	
newdata_to_predict = as.data.frame(cbind(sqm_living, grade))	
predicted_price_HUF = predict(mod_house1, newdata = newdata_to_predict)	
	
cbind(newdata_to_predict, predicted_price_HUF)	


# ### Hogyan kozoljuk az eredmenyeinket egy kutatasi jelentesben	

# Egy kutatsi jelentesben (pl. cikk, muhelymunka, ZH) a kovetkezo informaciokat kell leirni a regresszios modellrol:	

# Eloszor is le kell irni a regresszios **modell tulajdonsagait** (altalaban a "Modszerek" reszben):	

# "Egy linearis regresszios modellt illesztettem, melyben a lakas arat (millio HUF-ban) a lakas lakoreszenek teruletevel (m^2-ben) es a lakas King County lakas-minosites ertekevel becsultem meg." 	

# "I built a linar regression model in which I predicted housing price (in million HUF) with the size of the living area (in m^2) and King County housing grade as predictors."	

# Ezutan a **teljes modell bejoslasi hatekonysagat** kell jellemezni. Ezt a modellhez tartozo adjusted R^2 ertek (modositott R^2), es a modell-t a null-modellel osszehasonlito anova F-tesztjenek statiszikainak megadasaval szoktuk tenni (F-ertek, df, p-ertek). Mindezen informaciot a summary() funkcioval tudjuk lekerdezni. A modell illeszkedeset az AIC (Akaike information criterion) ertekkel is szoktuk jellemezni, amit az AIC() funcio ad meg.	

# Az APA publikacios kezikonyv alapjan minden szamot ket tizedesjegy pontossaggal kell megadni, kiveve a p erteket, amit harom tizedesjegy pontossaggal.	


sm = summary(mod_house1)	
sm	
	
AIC(mod_house1)	


# Vagyis az "Eredmenyek" reszben igy irnank a fenti pelda eredmenyeirol: 	

# "A tobbszoros regresszios modell mely tartalmazta a lakoterulet es a lakas minosites prediktorokat hatekonyabban tudta bejosolni a lakas arat mint a null modell. A modell a lakasar varianciajanak 0.35%-at magyarazta (F (2, 197) = 54.94, p < 0.001, Adj. R^2 = 0.35, AIC = 2137.06"	

# Ezen felul meg kell adnunk a **regresszios egyenletre es az egyes prediktorok becsleshez valo hozzajarulasara vontkozo adatokat**. Ezt altalaban egy osszefoglalo tablazatban szoktuk megadni, melyben a kovetkezo adatok szerepelnek prediktoronkent:	

# - regresszios egyutthato (regression coefficients, estimates) - summary()	
# - az egyutthatokhoz tartozo konfidencia intervallum (coefficient confidence intervals) - confint()	
# - standard beta ertekek (standardized beta values) - lm.beta() az lm.beta pakcage-ben	
# - a t-teszthez tartozo p-ertek (p-values of the t-test) -summary()	


	
confint(mod_house1)	
lm.beta(mod_house1)	


# A vegso tablazat valahogy igy nez majd ki (ennek az elkeszitesehez a fenti coef_table() sajat funkciot hasznaltam. Nem fontos ezt hasznalni, manualisan is ki lehet irogatni az eredmenyeket a kulonbozo tablazatokbol.):	


sm_table = coef_table(mod_house1)	
sm_table	


# ### regresszios egyutthato ertelmezese	

# A regresszios egyutthatot ugy lehet ertelmezni, hogy a prediktor ertekenek egy ponttal valo novekedese eseten a kimeneti valtozo erteke ennyivel valtozik. Pl. ha a sqm_living-hez tartozo regresszios egyutthato 0.38, az azt jelenti hogy minden egyes ujabb negyzetmeter teruletnovekedes 0.38 millio forint arvaltozassal jar.	

# ### az intercept-hez tartozo regresszios egyutthato ertelmezese	

# Az intercept egyutthatoja azt mutatja meg, hogy mi lenne a bejosolt (fuggo) valtozo becsult erteke, ha minden prediktor 0 erteket vesz fel. Ez nem mindig egy realis becsles, hiszen attol fuggoen hogy milyen prediktorokat hasznalunk, lehet hogy egy adott prediktoron a 0 ertek nem ertelmes. Ettol fuggetlenul az intercept matematikai ertelmezese mindig ugyan ez marad. Az intercept egyfajta allando ertek, ami fuggetlen a prediktorok erteketol.	

# ### standard beta ertelmezese	

# A regresszios egyutthato elonye, hogy a kimeneti valtozo mertekegysegeben van, es nagyon egyszeru ertelemzni. Ezert ez egy "nyers" hatasmeret mutato. Viszont a hatranya hogy az erteke a hozza tartozo prediktor valtozo skalajan mozog. Ez azt jelenti, hogy az egyes egyutthato ertekek nem konnyen osszehasonlithatoak, mert a prediktorok mas skalan mozognak. Pl. az sqm_living egyutthatoja alacsonyabb mint az grade egyutthatoja, de ez onmagaban nem mond arrol semmit, hogy melyik prediktornak van nagyobb szerepe a kimeneti valtozo bejoslasaban, mert a sqm_living skalaja sokkal kiterjedtebb (50-400 m^2) mint a grade skalaja (5-11).	

# Ahhoz hogy ossze tudjuk hasonlitani az egyes prediktorok becsleshez hozzaadott erteket, a ket egyutthatot ugyan arra a skalara kell helyeznunk, amit standardizalassal erhetunk el (ennek egyik modja hogy a prediktor valtozokat Z-transzformaljuk, es ezeket a Z-transformalt ertekeket tesszuk a modellbe mint prediktorokat). A standard Beta egy ilyen standardizalt mutato. Ez mar direkt modon osszehasonlithato a prediktorok kozott. Ebbol mar latszik hogy a sqm_living hozzaadott erteke a price_HUF bejoslasahoz nagyobb mint a grade hozzaadott erteke.	

# Amikor tobb prediktor van, ez nem feltetlenul jelenti azt, hogy ha egyenkent megneznenk a prediktorok korrelaciojat a kimeneti valtozoval, akkor ugyan ilyen osszefuggest kapnank. Ez az egyutthato es a std.Beta ertek a prediktor egesz modellben betoltott szerepet  jeloli, a tobbi prediktor bejoslo erejenek leszamitasaval. Vagyis elkepzelheto, hogy egy prediktor onmagaban jobban korrelal a kimeneti valtozoval mint barmelyik masik prediktor, viszont a modellben kisebb szerepet jatszik, mert a tobbi prediktor ugyan azt a reszet magyarazza a kimeneti valtozo varianciajanak, mint ez a prediktor.	

# **______Gyakorlas_______**	

# 1. Epits egy tobbszoros linearis regresszio modellt az lm() fugvennyel amiben az **price** a kimeneti valtozot becsuljuk meg. Hasznalhatod a **data_house** adatbazisban szereplo barmelyik valtozot felhasznalhatod a modellben, ami szerinted realisan hozzajarulhat a lakas aranak meghatarozasahoz.	
# 2. Hatarozd meg, hogy szignifikansan jobb-e a modelled mint a null modell (a teljese modell F-teszthez tartozo p-ertek alapjan)?	
# 3. Mekkora a teljes modell altal bejosolt varianciaarany (adj.R^2)?	
# 4. Melyik az a prediktor, mely a legnagyobb hozzadaott ertekkel bir a becslesben?	

# **________________________**	
