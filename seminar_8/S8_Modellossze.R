

# # Modell osszehasonlitas es Modellvalasztas	

# ## Absztrakt	

# Ez a gyakorlat megmutatja majd, hogyan lehet kulonbozo prediktorokat tartalmazo modelleket osszehasonlitani egymassal. Demonstraljuk majd a hierarchikus regressziot. Nehany modell szelekcios modszerre is kiterunk majd, es megemlitjuk a "tulillesztes" (overfitting) fogalmat.	

# ## Adatmenedzsment es leiro statisztikak	

# ### Package-ek betoltese	


library(tidyverse)	



# ### A King County lakaseladas adattabla betoltese	

# Ebben a gyakorlatban lakasok es hazak arait fogjuk megbecsulni.	

# Egy Kaggle-rol szarmazo adatbazist hasznalunk, melyben olyan adatok szerepelnek, melyeket valoszinusithetoen alkalmasak lakasok aranak bejoslasara. Az adatbazisban az USA Kings County-bol szarmaznak az adatok (Seattle es kornyeke).	

# Az adatbazisnak csak egy kis reszet hasznaljuk (N = 200).	


# data from github/kekecsz/PSYP13_Data_analysis_class-2018/master/data_house_small_sub.csv. 	
data_house = read.csv("https://bit.ly/2DpwKOr")	


# ### Adatellenorzes	

# Mindig nezd at az altalad hasznalt adattablat. Ezt mar megtettuk az elozo gyakorlatban, igy ezt most itt mellozzuk, de a korabbi tapasztalatok alapjan atalakitjuk az arat (price) millio forintra, es a  negyzetlabban szereplo terulet ertekeket negyzetmeterre.	


data_house %>% 	
  summary()	
	
data_house = data_house %>% 	
  mutate(price_mill_HUF = (price * 293.77)/1000000,	
         sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304	
         )	
	
	
	
	


# ## Hierarchikus regresszio	

# A hierarchikus regresszioval (Hierarchical regression) meghatarozhatjuk, mennyivel javul a bejoslo ero egy bonyolultabb (tobb prediktort tartalmazo) modell hasznalataval ahhoz kepest ha egy egyszerubb (kevesebb prediktort tartalmazo) modellt hasznalnank.	

# Ehhez ket regresszios modellt fogunk epiteni. Az egyszerubb modellben szereplo prediktorok egy reszhalmazat alkotjak a bonyolultabb modell prediktorainak. (vagyis a bonyolultabb modell minden prediktort tartalmaz az egyszerubb modellbol, plusz meg nehany extra prediktort.)	

# ### Hieararchikus regresszio ket prediktor-blokkal	

# Eloszor epitunk egy egyszeru modellt amiben a haz vetelarat csak a sqm_living es a grade valtozok alapjan josoljuk be. 	



mod_house2 <- lm(price_mill_HUF ~ sqm_living + grade, data = data_house)	


# Majd epitunk egy bonyolultabb modellt, amiben a sqm_living es a grade prediktorokon kivul szerepelnek meg a lakas foldrajzi hosszusag es szelesseg adatai is (long es lat). 	



mod_house_geolocation = lm(price_mill_HUF ~ sqm_living + grade + long + lat, data = data_house)	


# Az adj. R Squared mutato segitsegevel meghatarozhatjuk a ket modell altal megmagyarazott varianciaaranyt. Ezt a model summary kilistazasaval is megtehetjuk, de a model summary-bol csak ez az informacio is kinyerheto a $adj.r.squared hozzaadasaval az alabbi modon:	


summary(mod_house2)$adj.r.squared	
summary(mod_house_geolocation)$adj.r.squared	


# Ugy tunik, hogy a megmagyarazott varianciaarany magasabb lett azzal, hogy a modellhez hozzatettuk a geolokacioval kapcsolatos informaciot.	

# Most meghatarozhatjuk, hogy ez a bejosloeroben bekovetkezett javulas szignifikans-e. Ezt egyreszt a ket modell AIC modell-illeszkedesi mutatojanak osszehasonlitasaval tehetjuk meg.	

# Ha a ket AIC ertek kozotti kulonbseg nagyobb mint 2, a ket modell illeszkedese szignifikansan kulonbozik egymastol. Az alacsonyabb AIC kevesebb hibat es jobb modell illeszkedest jelent. Ha a kulonbseg nem eri el a 2-t, akkor a ket modell kozul barmelyiket megtarthatjuk. Ilyenkor altalaban azt a modellt tartjuk meg amelyik elmeletileg megalapozottabb, de ha nincs eros elmeletunk, akkor az egyszerubb modellt szoktuk megtartani (amelyikben kevesebb prediktor van).	



AIC(mod_house2)	
AIC(mod_house_geolocation)	


# Masreszt pedig az anova() funkcio segitsegevel osszehasonlithatjuk a ket modell residualis hibajat.  	

# Ha az anova() F-tesztje szignifikans, az azt jeletni, hogy a ket modell rezidualis hibaja szignifikansan kulonbozik egymastol.	



anova(mod_house2, mod_house_geolocation)	




# Az AIC mutato alapjan valo modell-osszehasonlitas jobban elfogadott a szkirodalomban, ezert ha az AIC es az anova osszehasonlitas kulonbozo eredmenyre vezet, akkor az AIC eredmenyet erdemes hasznalni.	

# Fontos, hogy az anova osszehasonlitasnak az eredmenye csak akkor valid, ha egymasba agyazott (nested) modellek osszehasonlitasara hasznaljuk oket, vagyis az egyik modell prediktorai a masik modell prediktorainak reszhalmazat alkotjak. 	

# Az AIC legtobbszor alkalmas nem beagyazott  modellek osszehasonlitasara is, (bar ezzel kapcsolatban nem teljes az egyetertes a szakirodalomban, a dolgozatokban elfogadott AIC-ot hasznaéni nem beagyazott modellek osszehasonlitasara).	



# ### Hierarchikus regresszio tobb mint ket blokkal	

# A fenti folyamat ugyan így megismetelheto ha tobb mint ket blokkban adjuk hozza a prediktorokat a modellhez. 	

# Itt egy harmadik modellt epitunk, a "condition" prediktor hozzaadasaval.	


mod_house_geolocation_cond = lm(price_mill_HUF ~ sqm_living + grade + long + lat + condition, data = data_house)	



# A harom modellt kovetkezokeppen hasonlithatjuk ossze:	


# R^2	
summary(mod_house2)$adj.r.squared	
summary(mod_house_geolocation)$adj.r.squared	
summary(mod_house_geolocation_cond)$adj.r.squared	
	
# anova	
anova(mod_house2, mod_house_geolocation, mod_house_geolocation_cond)	
	
# AIC	
AIC(mod_house2)	
AIC(mod_house_geolocation)	
AIC(mod_house_geolocation_cond)	
	


# A fenti eredmenyek alapjan javult a bejoslo ereje a modellunknek a lakas allapotanak (condition) figyelembevetelevel?	

# *__________Gyakorlas___________*	

# Tedd hozza a modellhez az iment epitett modellhez (mod_house_geolocation_cond) a haz epitesenek evet (yr_built) es a furdoszobak szamat (bathrooms) mint prediktorokat.	
# Ez az uj modell szignifikansan jobban illeszkedik az adatokhoz mint a korabbi modellek?	


# *______________________________*	

# **A modellvalasztas legfontosabb szabalya:**	

# **Mindig azt a modellt valasztjuk, ami elmeletileg alatamasztott es/vagy korabbi kutatasi eredmenyek tamogatjak, mert az automatikus modellvalasztas rossz modellekhez vezet a tulillesztes (overfitting) miatt.**	






