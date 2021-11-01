
# ## Absztrakt	

# Ez a gyakorlat megmutatja majd, hogyan lehet kulonbozo prediktorokat tartalmazo modelleket osszehasonlitani egymassal. Demonstraljuk majd a hierarchikus regressziot. Nehany modell szelekcios modszerre is kiterunk majd, es megemlitjuk a "tulillesztes" (overfitting) fogalmat. Ezen felul megismerjuk majd hogyan hasznaljuk es ertelmezzuk a kulonbozo tipusu specialis prediktorokat a linearis regresszios modellekben.	


# ## Package-ek betoltese	


library(psych)	
library(gridExtra)	
library(tidyverse)	


# # Modell osszehasonlitas es Modellvalasztas	

# ## Adatmenedzsment es leiro statisztikak	

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

# A hierarchikus regresszioval (Hierarchical regression) meghatarozhatjuk, hogy kulonbozik-e ket modell egymastol a bejoslo hatekonysagukat tekintve, es ha igen, **mennyivel javul a bejoslo ero** egy bonyolultabb (tobb prediktort tartalmazo) modell hasznalataval, ahhoz kepest ha egy egyszerubb (kevesebb prediktort tartalmazo) modellt hasznalnank.	

# Mivel a hierarchikus regresszió gyakorlatilag ket regresszios modell (egy egyszerubb es egy osszetettebb) osszehasonlitasa, ezert most mi is ket regresszios modellt fogunk epiteni. 	


# ## Hieararchikus regresszio ket prediktor-blokkal	

# ### Modellepites	

# Eloszor epitunk egy egyszeru modellt amiben a haz vetelarat csak a *sqm_living* es a *grade* valtozok alapjan josoljuk be. 	



mod_house2 <- lm(price_mill_HUF ~ sqm_living + grade, data = data_house)	


# Majd epitunk egy bonyolultabb modellt, amiben a sqm_living es a grade prediktorokon kivul szerepelnek meg a lakas foldrajzi hosszusag es szelesseg adatai is (*long* es *lat*). 	



mod_house_geolocation = lm(price_mill_HUF ~ sqm_living + grade + long + lat, data = data_house)	


# Vegyuk eszre, hogy az egyszerubb modellben szereplo prediktorok egy **reszhalmazat** alkotjak a bonyolultabb modell prediktorainak. vagyis **a bonyolultabb modell minden prediktort tartalmaz az egyszerubb modellbol**, plusz meg nehany extra prediktort. Ezt ugy nevezzuk hogy "**nested models**" vagyis "**egymasba agyazott modellek**", hiszen a modellek ugy epulnek fel mint a matrjoska babak.	

# ### Modellosszehasonlitas	

# Az **adj. R Squared** mutato segitsegevel meghatarozhatjuk a ket modell altal megmagyarazott varianciaaranyt. Ezt a model summary kilistazasaval is megtehetjuk, de a model summary-bol csak ez az informacio is kinyerheto a $adj.r.squared hozzaadasaval az alabbi modon:	


summary(mod_house2)$adj.r.squared	
summary(mod_house_geolocation)$adj.r.squared	


# Ugy tunik, hogy a megmagyarazott varianciaarany magasabb lett azzal, hogy a modellhez hozzatettuk a geolokacioval kapcsolatos informaciot.	

# Most meghatarozhatjuk, hogy ez a bejosloeroben bekovetkezett **javulas szignifikans-e**. Ezt egyreszt a ket modell AIC modell-illeszkedesi mutatojanak osszehasonlitasaval tehetjuk meg.	

# Ha a ket **AIC** ertek kozotti kulonbseg nagyobb mint 2, a ket modell illeszkedese szignifikansan kulonbozik egymastol. Az alacsonyabb AIC kevesebb hibat es jobb modell illeszkedest jelent. Ha a kulonbseg nem eri el a 2-t, akkor a ket modell kozul barmelyiket megtarthatjuk. Ilyenkor altalaban azt a modellt tartjuk meg amelyik elmeletileg megalapozottabb, de ha nincs eros elmeletunk, akkor az egyszerubb modellt szoktuk megtartani (amelyikben kevesebb prediktor van).	



AIC(mod_house2)	
AIC(mod_house_geolocation)	


# Masreszt pedig az **anova() funkcio** segitsegevel osszehasonlithatjuk a ket modell residualis hibajat.  	

# Ha az anova() F-tesztje szignifikans, az azt jeletni, hogy a ket modell rezidualis hibaja szignifikansan kulonbozik egymastol.	



anova(mod_house2, mod_house_geolocation)	


# Az **AIC** mutato alapjan valo modell-osszehasonlitas **jobban elfogadott** a szakirodalomban, ezert ha az AIC es az anova osszehasonlitas kulonbozo eredmenyre vezet, akkor az AIC eredmenyet erdemes hasznalni.	

# Fontos, hogy az **anova osszehasonlitasnak az eredmenye csak akkor valid, ha egymasba agyazott (nested)** modellek osszehasonlitasara hasznaljuk oket, vagyis az egyik modell prediktorai a masik modell prediktorainak reszhalmazat alkotjak. 	

# Az AIC legtobbszor alkalmas nem beagyazott  modellek osszehasonlitasara is, (bar ezzel kapcsolatban nem teljes az egyetertes a szakirodalomban, a dolgozatokban elfogadott AIC-ot hasznalni nem beagyazott modellek osszehasonlitasara).	


# ## Hierarchikus regresszio tobb mint ket blokkal	

# A fenti folyamat ugyan ugy megismetelheto ha tobb mint ket blokkban adjuk hozza a prediktorokat a modellhez. 	

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

# Tedd hozza az iment epitett modellhez (mod_house_geolocation_cond) a haz epitesenek evet (yr_built) es a furdoszobak szamat (bathrooms) mint prediktorokat.	
# Ez az uj modell szignifikansan jobban illeszkedik az adatokhoz mint a korabbi modellek?	


# *______________________________*	

# **A modellvalasztas legfontosabb szabalya:**	

# Mindig azt a modellt valasztjuk, ami **elmeletileg alatamasztott** es/vagy korabbi kutatasi eredmenyek tamogatjak, mert az automatikus modellvalasztas rossz modellekhez vezet a tulillesztes (overfitting) miatt.	



# # Specialis prediktorok	

# ## Adatmenedzsment es leiro statisztikak	

# ### A fogyasi kutatas adatbazis betoltese	

# Az adatbazis egy olyan kutatas szimulalt adatait  tartalmazzam ahol kulonbozo kezelesek hatekonysagat teszteltek a sulyvesztesre tulsulyos szemelyeknel. 	

# Valtozok:	

# - ID - vizsgalati szemlely azonositojele	
# - Gender - nem	
# - Age - eletkor	
# - BMI_baseline - Body mass index (BMI) a kezeles elott	
# - BMI_post_treatment - Body mass index (BMI) a kezeles utan	
# - treatment_type - A kezeles amit a vizsgalati szemely kapott (no treatment - nem kapott kezelest; pill - etvagycsokkento gyogyszer; psychotherapy - kognitiv behavior terapia (CBT); treatment 3 - egy harmadik fajta kezeles, lasd lentebb)	
# - motivation - onbevallasos motivacioszint a fogyasra (0-10-es skalan, ahol a 0 extremen alacsony motivacio a fogyasra, a 10 pedig extremen magas motivacio a fogyasra)	
# - body_acceptance - a szemely mennyire erzi elegedettnek magat jelenleg testevel (-7 - +7, ahol a - 7 nagyon elegedetlen, a +7 nagyon elegedett)	



data_weightloss = read.csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_08/weight_loss_data.csv")	


# ### Adatellenorzes	

# Nezzuk at eloszor az altalunk hasznalt adattablat.	


data_weightloss %>% 	
  summary()	
	
describe(data_weightloss)	


# Szeretnenk megerteni a kulonbozo kezelestipusok hatasat a BMI-re. Vegezzunk feltaro elemzest az adatokon.	


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

# A kezeles tipus (treatment_type) egy kategorikus valtozo, a BMI pedig egy folytonos numerikus valtozo. Ahogy azt korabban tanultuk, egyik modja annak hogy kideritsuk, van-e kulonbseg csoportok kozott egy adott folytonos valtozo atlagos szintjeben, ha lefuttatunk egy **egyszempontos ANOVA**-t (aov()).	

# Az eredmeny elarulja, hogy a kezeles utani BMI atlaga szignifikansan kulonbozik a csoportok kozott (F (3, 236) = 26.51, p < 0.001), (ami azt jelenti, hogy legalabb ket csoport szignifikansan kulonbozik egymastol a BMI atlagaban a negy csoport kozul).	


anova_model = aov(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
summary(anova_model)	
	


# A linearis regresszional fontos, hogy a fuggo valtozo (a bejosolt valtozo) folytonos numerikus valtozo legyen. Viszont a modell prediktorai lehetnek akar folytonos, akar kategorikus valtozok (csoportosito valtozok mint pl. a kezeles a mi esetunkben).	

# Vagyis a fenti aov() modellt megepithetjuk lm() segitsegevel is ahogy az alabbi pelda is mutatja. A **teljes modell F-tesztje** ugyan azt az eredmenyt adja ki, mint az aov(). Vegyuk eszre hogy a funkcion kivul aov() vs. lm() **a ket modell szintaktikailag pontosan ugyan ugy epul fel**.	


mod_1 = lm(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
summary(mod_1)	
	


# A regresszios egyutthatok tablazata ebben az esetben maskepp nez ki a megszokotthoz kepest, hiszen majdnem minden kezelesi tipusnak kulon sora van.	

# ### Eredmenyek ertelmezese	

# Az egyes valtozokhoz tartozo regresszios egyutthatokat ugy ertelmezzuk altalaban, hogy **mekkora valtozast jelent a bejosolt valtozo ertekeben ha a prediktor valtozo erteke egy szinttel emelkedik**. 	

# Viszont a **nominalis** valtozok nem sorrendezettek, szoval nem tudjuk eldonteni, hogy hogyan rakjuk sorba a szinteket, hogy az egy szintnyi emelkedes hatasat megbecsuljuk. Ezt egy masik trukkel oldjuk meg: **dummy valtozokkal**. 	

# A dummy valtozok gyakorlatilag azt jelentik, hogy keszitunk uj valtozokat, ami **a faktorszint megletet (1), vagy hianyat (0) jelenti**. Vagyis lesz egy valtozo, ami akkor vesz fel 1-es erteket, ha valaki "pill"-t kapott, minden mas esetben 0 erteket vesz fel, lesz egy masik valtozo ami akkor vesz fel 1-es erteket amikor valaki "psychotherapy"-t kapott, minden masik esetben 0 erteket vesz fel, es lesz egy valtozo ami akkor vesz fel 1-es erteket amikor valaki "treatment_3"-t kapott, minden masik esetben 0 erteket vesz fel. 	

# **Az alapszintnek nem szoktunk kulon dummy valtozot csinalni**, mert az mar a tobbi dummy eredmenyebol evidens (ha minden masik dummy erteket 0, akkor az alapszint erteke 1). 	



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
	



# Ez a megoldas lehetove teszi, hogy a program **minden faktorszintet egyenkent hasonlitson az alapszinthez**. Ennek az eredmenyet latjuk a regresszios egyutthatok tablazataban. 	

# Az **intercept**-hez tartozo regresszios egyutthatot mindig ugy lehet ertelmezni, hogy ez mutatja a bejosolt valtozo (ebben az esetben a BMI) erteket abban az esetben, **ha minden prediktor valtozo nulla erteket vesz fel**. Mivel itt dummy valtozokkal dolgozunk, ez azt jelenti, hogy az alapszinten kivul minden mas szinthez tartozo dummy valtozo erteke 0. Vagyis mi az a BMI ertek, amit akkor varhatunk ha az ember se nem "pill"-t, se nem "psychotherapy"-t, se nem "treatment_3"-t kapott (vagyis a "no_treatment" csoportban volt).	

# A regresszios **egyutthatokat igy mar szokas szerint ertelmezhetjuk**, hogy abban az esetben ha az adott dummy valtozo erteke egy szinttel no (vagyis 0 helyett 1 lesz), akkor mekkora valtozast varhatunk a bejosolt valtozo ertekeben.	

# Az **lm() fuggveny mindezt elvegzi** helyettunk, nem kell manualisan dummy valtozokat generalni, de az fontos, hogy megertsuk, hogyan tortenik ez a folyamat. A kategorikus valtozoknak (pl. a mi esetunkben treatment type) nincs nulla erteke. Ezt az R ugy oldja meg, hogy a csoportosito valtozo (faktor) szintjei kozul kivalaszt egyet, ami az alapszint (**default level**), es azt veszi nullanak. 	

# Fontos, hogy ahogy korabban is, az alapszint ha nem rendelkezunk maskepp alapertelmezett modon a faktor szintjei kozul az **abc sorrendben legelso** lesz, a mi esetunkben ez a "no_treatment".	

# Vagyis 	

# - a "no_treatment" eseten 36.13 BMI-t varhatunk,	
# - ha valaki "pill"-t kap, akkor -2.08 BMI valtozast josolunk a "no_treatment"-hez kepest, 	
# - ha valaki "psychotherapy"-t kap -2 BMI valtozast josolunk a "no_treatment"-hez kepest,	
# - ha valaki "treatment_3"-t kap  -5.33 BMI valtozast josolunk a "no_treatment"-hez kepest.	


# *__________Gyakorlas___________*	

# Nyisd meg a data_house adattablat amivel a korabbi gyakorlatokon foglalkoztunk, es epits egy linearis regresszios modellt a lakas eladasi aranak (price) bejoslasara a kovetkezo prediktorokkal:  sqm_living, grade, has_basement. 	

# Ertelmezd a fentiek alapjan a regresszios egyutthatok tablazatat. 	
# - Mit jelent az intercept regresszios egyutthatoja? 	
# - Mit jelent a has_basement prediktorhoz tartozo regresszios egyutthato?	



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


# ## Ket valtozo interakciojanak beillesztese a modellbe	

# A treatment_3 valojaban egy olyan kondicio volt a kutatasban, ahol az emberek mind gyogyszeres, mind pszichoterapias kezelest kaptak.	

# Most atalakitjuk az adattablat, hogy ezt helyesen tukrozzek az iment generalt dummy valtozok. 	

# Ugy alakitom at a got_pill valtozot, hogy akkor is 1-es erteket vegyen fel, amikor "treatment_3" volt a treatment_type erteke, es a got_psychotherapy valtozot, hogy akkor is 1-es erteket vegyen fel, amikor "treatment_3" volt a treatment_type erteke. Igy a got_pill vatlozo azt jelenti, hogy az illeto kapott-e gyogyszert a kezelese soran, es a got_psychotherapy valtozo azt jelenti, az illeto kapott-e pszichoterapiat a kezelese soran.	



data_weightloss = data_weightloss %>% 	
  mutate(	
         got_pill = as.numeric(replace(got_pill, treatment_type == "treatment_3", "1")),	
         got_psychotherapy = as.numeric(replace(got_psychotherapy, treatment_type == "treatment_3", "1"))	
         )	
	


# Most feltehetjuk a kerdest, hogy **van-e interakcio** a gyogyszeres kezeles es a pszichoterapias kezeles kozott. 	

# ### Mit jelent az, hogy interakcio van valtozok kozott?	

# A klasszikus linearis regresszios modellekben azt feltetelezzuk, hogy az egyes prediktorok "hatasa" a bejosolt valtozora fuggetlen a tobbi prediktor erteketol. pl. a regresszios modellben amit igy irunk le: 	

# price ~ sqm_living + grade 	

# azt feltetelezzuk, hogy barmilyen erteket is vesz fel a lakas minosege (grade), a lakos meretenek a hatasa (sqm_living) valtozatlan marad.	

# Ha jo okunk van feltetelezni, hogy ez nem igy van, vagyis hogy **az egyes prediktorok hatasa fugg egy (vagy tobb) masik prediktor erteketol**, akkor **interakciorol** beszelunk, vagyis a prediktorvaltozok interakcioban vannak egymassal, es ez az interakcio (is) befolyasolja a kimeneti valtozora gyakorolt hatast, nem csak a valtozok egymastol fuggetlen hatasa.	

# A peldankban ez ugy jelenik meg, hogy feltetelezheto, hogy van hozzaadott erteke annak, hogy az emberek a ket kezelest egyszerre kaptak azon felul, amit a ket kezeles hatasa alapjan varnanak kulon-kulon. Masszoval, ugy feltetelezzuk, hogy az, hogy a pszichoterapianak mekkora a hatasa a BMI-re **attol fugg**, hogy az ember kap-e mellette gyogyszeres kezelest is, vagy sem.	

# ### Az interakcio beepitese a linearis regresszios modellbe	

# Ezt az interakciot a modellbe ugy tudjuk beepiteni, ha **a + helyett *-ot** rakunk a ket valtozo koze, amiknek az interakcioja erdekel mindket.	



mod_3_a = lm(BMI_post_treatment ~ got_pill * got_psychotherapy, data = data_weightloss)	
summary(mod_3_a)	
	


# Alternativ szintaxis: Egy masik szintaxissal is felirhatjuk ugyan ezt, ahol "got_pill * got_psychotherapy" helyett **"got_pill + got_psychotherapy + got_pill:got_psychotherapy"** irunk. Ez akkor lehet fontos, ha tobb mint ket valtozo valamilyen komplexebb interakcios mintazatat akarjuk modellezni ahol nem akarjuk minden mindennel valo interakciojat beepiteni a modellbe. Ez pontosan ugyan azt eredmenyezi mint a korabbi szintaxis, hiszen itt minden valtozo interakciojat beepitettuk a modellbe (csak ket prediktor valtozonk volt).	


mod_3_b = lm(BMI_post_treatment ~ got_pill + got_psychotherapy + got_pill:got_psychotherapy, data = data_weightloss)	
summary(mod_3_b)	
	


# ### Eredmenyek ertelmezese	

# Ahhoz hogy megertsuk, hogyan kell ertelmezni az eredmenyeket, erdemes egy marmadik modjat megnezni annak, hogy hogyan tudjuk ugyan azt a modellt leirni: Az alabbi kodban a ket prediktor valtozo erteket osszeszorzom, es ezt az erteket elmentem egy uj valtozoba. Ezt a szorzat erteket beepitjuk a modellunkbe mint egy uj prediktort. 	


	
data_weightloss = data_weightloss %>% 	
  mutate(got_pill_times_got_psychotherapy = got_pill * got_psychotherapy)	
	
mod_3_c = lm(BMI_post_treatment ~ got_pill + got_psychotherapy + got_pill_times_got_psychotherapy, data = data_weightloss)	
summary(mod_3_c)	
	


# Vegyuk eszre, hogy ez ugyan azt az eredmenyt adja, mint a korabbi modellek (mod_3_a es mod_3_b). Vagyis az interakcios tenyezohoz tartozo regresszios egyutthatot ugy ertelmezhetjuk, hogy abban az esetben, **ha a ket valtozo szorzata egyel magasabb** erteket vesz fel (a mi esetunkben ez csak akkor lesz 1, ha mind a got_pill, mind a got_psychoterapy erteke 1), milyen valtozast varhatunk a bejosolt valtozo ertekeben **AZON FELUL, amit a ket valtozo onallo hatasa alapjan varnank**. Ez azert van, mert mind a got_pill, mind a got_psychotherapy valtozok erteke 1 ebben az esetben, es azok hatasa (-2.08 es -2.00) igy mar bele van kalkulalva a modellbe. 	

# Vagyis ha mind a got_pill, mind a got_psychotherapy valtozok erteke 1, akkor azon felul hogy kifejtik egyenkent hatasukat, egy extra -1.25 BMI csokkenest varhatunk az eredmenyek alapjan. Mivel ebben a kutatasban a kivanatos kimenetel a BMI csokkenes, ezert igy elmondhatjuk hogy a ket kezelesegyutt alkalmazva **felerositi egymas hatasat**.	


# *__________Gyakorlas___________*	

# Epits egy modellt a data_weightloss adatbazison ahol a **BMI_post_treatment**-t becsuljuk meg a **motivation** es a **body_acceptance** prediktorokkal, a ket prediktor interakciojat is epitsd be a modellbe. 	

# Ertelmezd a regresszios egyutthatokat.	

# - Milyen valtozast varhatunk a BMI szintjeben ha a motivation szintje 1-el no?	
# - Milyen valtozast varhatunk a BMI szintjeben ha a body_acceptance szintje 1-el no?	
# - Van szignifikans interakcio a ket prediktor kozott?	
# - Hogyan ertemezhetjuk az interakciohoz tartozo regresszios egyutthatot?	


# *______________________________*	



# ## Hatvany prediktorok a nem-linearis osszefuggesek modellezesehez	

# A linearis regresszios modelleket eredetileg linearis osszefuggesek modellezesere talaltak ki, de egy kis matematikai trukkel elerhetjuk, hogy modellezzunk **nem-linearis osszefuggesek** is.	

# Az alabbi abra alapjan ugy tunik, hogy BMI_post_treatment es a body_acceptance osszefuggese nem teljesen linearis, hanem egy gorbe vonal jobban leirja a ket valtozo osszefuggeset.	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F, color = "red") +	
  geom_smooth(se = F, color = "green")	
  	


# Ezt ugy epithetjuk be a modellunkbe, hogy a prediktorok koze a body_acceptance melle annak **masodik hatvanyat** is betesszuk. Ezt a kovetkezo formula hozzadasaval tehetjuk a modellben: **+ I(body_acceptance^2)**.	

# Ha **osszehasonlitjuk** azt a modellt amiben szerepel ez a hatvanytenyezo azzal a modellel amiben ez nem szerepel (hieararchikus regresszio), azt talaljuk hogy ez az ugynevezett kvadratikus hatas (quadratic effect) szignifikans hozzaadott ertekkel bir a BMI bejoslasaban.	
#  	


mod_4 = lm(BMI_post_treatment ~ body_acceptance, data =  data_weightloss)	
summary(mod_4)	
	
mod_5 = lm(BMI_post_treatment ~ body_acceptance + I(body_acceptance^2), data =  data_weightloss)	
summary(mod_5)	
	
AIC(mod_4)	
AIC(mod_5)	
	


# Fontos, hogy amikor hatvagy-prediktorokat hasznalunk mindenkeppen tegyuk be a modellbe a prediktor **minden alacsonyabb hatvanyat is** egeszen az elso hatvanyig (ami maga az eredeti prediktor).	


mod_6 = lm(BMI_post_treatment ~ body_acceptance + I(body_acceptance^2)+ I(body_acceptance^3), data =  data_weightloss)	
summary(mod_6)	
AIC(mod_6)	


# A regresszios vonal igy nez ki ha csak az elso hatvany szerepel a modellben:	


data_weightloss = data_weightloss %>% 	
  mutate(pred_mod_4 = predict(mod_4),	
         pred_mod_5 = predict(mod_5),	
         pred_mod_6 = predict(mod_6))	
	
data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_4))	


# Igy amikor a masodik hatvany szerepel a modellben:	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_5))	


# Es igy amikor a harmadik hatvany szerepel a modellben:	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_6))	


# Lathato hogy **minel nagyobb hatvanyt illesztunk a modellbe, annal tob gorbuleti pontot engedunk** a regresszios egyenesnek. (A fenti abrak alapjan lathato hogy mindig egyel kevesebb gorbuleti (inflexios) pontot engedunk mint ahanyadik hatvanyt beletettuk a modellbe prediktorkent.)	

# Azonban a tul nagy felxibilitas nem celravazeto, mert minel felxibilisebb a modell, annal inkabb hajlamos arra, hogy a sajat mintankhoz illeszkedjen, es nem a populacioban megtalalhato osszefuggeseket ragadja meg. 	

# Ezt tulillesztesnek (**overfitting**) nevezzuk. Ezert legtobbszor nem teszunk a modellekbe haramdik hatvanynal nagyobb hatvanypediktort, es csak akkor hasznalunk hatvanyprediktorokat, amikor az elmeletileg megalapozottnak tunik.	



# *__________Gyakorlas___________*	

# Kiserletezz a lakasarakat tartalmazo adatbazissal. Gondold at, milyen valtozok jatszhatnak szerepet a lakasar meghatarozasaban, es hogy van-e ertelme interakciokat, vagy nem-linearis osszefuggeseket feltetelezni.	

# Probalj elerni a modellel 52%-nal magasabb adjusted R^2 erteket.	

# Ha szeretned a teljes adatbazist megszerezni, es szeretned latni, masok milyen modellekkel kiserletezte es milyen eredmenyesek voltak, a Kaggle-on megtalalod az ezzel az adatbazissal foglalkozo modelleket ezen a linken:	

# https://www.kaggle.com/harlfoxem/housesalesprediction/activity	


# *______________________________*	




