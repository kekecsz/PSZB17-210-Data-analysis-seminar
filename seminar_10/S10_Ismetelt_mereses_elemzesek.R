
# # Absztrakt	

# Ez a gyakorlat az ismetelt mereses elemzessekkel foglalkozik. Amikor az elemzesunkben ugyan attol a vizsgalati szemelytol tobb adat is szerepel ugyan abbol a valtozobol, ismetelt mereses elemzest vegzunk (pl. a szemely kezeles elotti es utani depresszio szintje).	

# # Adatmenedzsment es leiro statisztikak	

# ## Package-ek betoltese	

# A kovetkezo package-ekre lesz szukseg a gyakorlathoz:	


library(psych) # for describe	
library(tidyverse) # for tidy code and ggplot		
library(lme4) # for lmer() mixed models	
library(lmerTest)  # for significance test on lmer() mixed models	
library(cAIC4) # for cAIC	
library(r2glmm) # for r2beta	
library(MuMIn) # for r.squaredGLMM	



# ## Sajat funkcio	

# Ezzel a funkcioval kinyerhetjuk a standardizalt Beta egyutthatot a kevert modellekbol.	
# Ez a funkcio innen lett atemelve: 	
# https://stackoverflow.com/questions/25142901/standardized-coefficients-for-lmer-model	


stdCoef.merMod <- function(object) {	
  sdy <- sd(getME(object,"y"))	
  sdx <- apply(getME(object,"X"), 2, sd)	
  sc <- fixef(object)*sdx/sdy	
  se.fixef <- coef(summary(object))[,"Std. Error"]	
  se <- se.fixef*sdx/sdy	
  return(data.frame(stdcoef=sc, stdse=se))	
}	



# ## Sebgyogyulas adat betoltese	

# A gyakorlat soran a sebgyogyulas adatbazissal fogunk dolgozni. Ez egy szimulat adatbazis, ami a mutet soran ejtett bemetszesek gyogyulasat vizsgaljuk annak fuggvenyeben hogy a paciensek ágya milyen kozel van az ablakhoz, es hogy mennyi napfeny eri oket a felepules idoszak alatt. Ez a kutatas azt az elmeletet teszteli, hogy a korhazi betegeknek szukseguk van a kulvilaggal valo kapcsolatra ahhoz hogy gyorsan felepuljenek. Egy ablak ami a szabadba nyilik megteremtheti ezt a kapcsolatot a kulvilaggal, ezert a kutatasunk azt vizsgalja, hogy befolyasolja-e a sebgyogyulas merteket az, hogy a szemelynek milyen kozel van az ágya a legkozelebbi ablakhoz. Az elmelet egy valtozata azt allitja, hogy az ablak nem csak a kulvilaggal valo szorosabb kapcsolat megteremtesen keresztul vezet gyorsabb gyogyulashoz, hanem azon keresztul is hogy tobb napfenyt enged a szobaba, es az elmelet szerint a napfeny is jotekony hatassal van a gyogyulasra. 	

# Valtozok az adatbazisban:	

# - ID: azonosito kod	
# - day_1, day_2, ..., day_7: A mutet utani 1-7. napon egy orvos megvizsgalta a pedeg bemetszesi sebeit, es ertekelte azokat egy standardizalt seb-allapot ertekkel. Minel nagyobb ez az ertek, annal nagyobb vagy rosszabb allapotu a seb (pl. gyulladt). Minden szemelynek mind a 7 naphoz kulon seb-allapot ertek tartozik.	
# - distance_window: A szemely agyahoz legkozelebbi ablak tavolsaga az agytol meterben.	
# - location: A korhazi szarny, ahol a paciens agya van. Ket allasu faktor valtozo: szintjei "north wing" es "south wing" (a "south wing"-ben tobb napfeny eri a pacienseket, ez a valtozo azert fontos). 	



data_wound = read_csv("https://raw.githubusercontent.com/kekecsz/PSYP13_Data_analysis_class-2018/master/data_woundhealing_repeated.csv")	
	
# asign ID and location as factors	
data_wound = data_wound %>% 	
  mutate(ID = factor(ID),	
         location = factor(location))	
	


# ## Adatellenorzes	

# Vizsgaljuk meg az adattablat a View(), describe(), es table() fukciok segitsegevel. Fontos, hogy az adattablaban jelenleg minden adat amit egy adott szemelytol gyujtottek **egy sorban talalhato**. 	



View(data_wound)	
	
# descriptives	
describe(data_wound)	
table(data_wound$location)	
	


# Vizualizalhatjuk is az adatokat. (Az alabbi abra elkeszitesehez eloszor a day1-day7 valtozokban kulon-kulon kiszamoljuk az atlagokat es a standard hibat, majd a standard hibat megszorozva 1.96-al megkapjuk a konfidencia intervallumot. Vegul mindezt egy uj adat objektumba tesszuk, es a geom_errorbar, geom_point, es geom_line segitsegevel vizualizaljuk. Lathato hogy a seb allapot ertek egyre csokken ahogy telnek a napok.)	



# designate which are the repeated varibales	
repeated_variables = c("day_1", "day_2", "day_3",	"day_4", "day_5",	"day_6",	"day_7")	
	
# explore change over time	
wound_ratings = describe(data_wound[,repeated_variables])$mean	
repeated_CIs = describe(data_wound[,repeated_variables])$se*1.96	
days = as.numeric(as.factor(repeated_variables))	
days = as.data.frame(days)	
data_for_plot = cbind(days, wound_ratings, repeated_CIs)	
	
data_for_plot %>% 	
  ggplot() +	
  aes(x = days, y = wound_ratings) +	
  geom_errorbar(aes(ymin=wound_ratings-repeated_CIs, ymax=wound_ratings+repeated_CIs), width=.1) +	
  geom_point() +	
  geom_line()	
	



# # Ismetelt meresek eredmenyenek vizsgalata kevert linearis modellekkel	

# ## Klaszteres szerkezet keresese az adatokban	

# Vizsgaljuk meg a tovabbiakban a sebgyogyulasra vonatkozo ismetelt meresek eredmenyeit! Ehhez eloszor mentsuk el az adatokhoz tartozo **valtozoneveket egy repeated_variables** elnevezesu objektumba, hogy kesobb konnyen hivatkozhassunk rajuk az alltalunk irt fuggvenyekben! 	

# A valtozok kozotti korrelaciot a cor() fuggvennyel tudjuk megvizsgalni. Figyeljuk meg, hogy az ismetelt meresek adatponjai kozott **eros korrelacio fedezheto fel**, azaz az egyes seb-allapot ertekekre vonatkozo megfigyelesek **nem fuggetlenek egymastol**. Ez varhato is, hiszen a seb-allapot ertek, az eredeti bemetszes merete es a seb gyogyulasanak uteme mind fuggenek a vizsgalt betegtol. Adataink tehat csoportokba tomorulnek (klaszterekbe), hasonloan a korabbi peldankhoz. Azonban mig ott osztaly szerinti klaszterek fordultak elo, itt most a klaszterek maguk a resztvevok.	


# correlation of repeated variables	
	
data_wound %>% 	
  select(repeated_variables) %>% 	
  cor()	


# ## Az adattabla atformazasa szelesbol hosszu formatumba	

# A klaszteres szerkezetből kifolyólag hasonlóan kevert modellekkel elemezhetjük adatainkat mint ahogy azt a bántalmazással kapcsolatos adatsornál tettük. Ehhez azonban először **át kell rendeznünk az adatainkat**, hogy használhassuk a lineáris kevert modell (lmer()) függvényt.	

# Jelenleg a dataframe-ünk minden sora egy adott pácienshez tartozó seb-állapot értékre vonatkozó 7 megfigyelésből áll (vagyis az adatgyüjtés alatt napi egy). Ezt az elrendezést **wide format**-nak nevezik (széles formátum).	

# Az lmer() függvény megfelelő működéséhez az adattábla minden sorához csak egyetlen megfigyelés tartozhat. Jelen esetben ez azt jelentené, hogy az egyes résztvevőkhöz tartozó sorok száma 1 helyett 7 kell legyen. Így az ID, distance_window, és location változók az adott pácienshez tartozó sorokban megegyeznek majd, és csak az egyes seb-állapot értekek különböznek majd, melyekhez minden sorban mindössze egyetlen oszlop tartozna így. Ezt az elrendezést általában **long format**-nak hívjuk (hosszú formátum).	

# A fenti átalakítás elvégzésének egy egyszerű módja, ha a **gather()** függvényt alkalmazzuk a tidyr csomagból. 	

# 1. meghatározunk egy változónevet, amiben az **ismételt megfigyelések indexét** tároljuk majd az új formátumú adabázisban. Ez nálunk az alábbi példában "days"-nek neveztük el (**key = days**).	
# 2. meghatározunk egy változónevet, amiben az **ismételten megfigyelt adatok** kerülnek majd. Mivel nekünk a megfigyelt adatunk a seb állapota, ezért ezt "wound_rating"-nek neveztük el (**value = wound_rating**).	
# 3. meghatározzuk, hogy a jelenleg használt széles formátumban **mely oszlopok tartalmazzák az ismételten megfigyelt adatot**. Ez a széles adatbázisunkban a day_1, day_2 ... day_7 oszlopok. Ezt a tidyverse-ben könnyen lerövidíthetjuk, a **day_1:day_7** kifejezés a day_1 és day_7 közötti oszlopok neveit jelöli.	

# Az **arrange()** függvény használatával az adatok rendezhetőek a hozzájuk tartozó azonosító ("ID") alapján. Bár az adott feladat elvégzéséhez nem sükséges rendezni az adatainkat, de mégis segít a hosszú formátum átláthatóbbá tételében.	

# Az eredeti adatokat változatlanul hagyva most is **új objektumot** hozunk létre adatainknak, a már megszokott módon. Az új objektum neve data_wound_long lesz.	


	
data_wound_long = data_wound %>% 	
  gather(key = days, value = wound_rating,  day_1:day_7) %>% 	
  arrange(ID) 	
	
data_wound_long	


# A fontos megjegyezni, hogy a 'days' változó jelenleg a széles formátumból származó változó neveket tartalmazza ('day_1', 'day_2' stb.). Az egyszerűbb kezelhetőség érdekében ezeket egyszerűen az egyes napokat jelölő számokra (1-7) cseréljük. Ezt legkönyebben a mutate() és **recode()** fügvényekkel valósíthatjuk meg.	


	
# change the days variable to a numerical vector	
data_wound_long = data_wound_long %>% 	
  mutate(days = recode(days,	
                       "day_1" = 1,	
                       "day_2" = 2,	
                       "day_3" = 3,	
                       "day_4" = 4,	
                       "day_5" = 5,	
                       "day_6" = 6,	
                       "day_7" = 7	
                       ))	


# Tekintsük most meg, hogyan néz ki az új dataframe-ünk!	


View(data_wound_long)	


# ## Kevert lineáris modell kialakítása	

# Most, hogy megfelelő alakba hoztuk adatainkat, előállíthatjuk az előrejelzésekhez szükséges modellt. Ezzel a modellel a műtét utáni nap (days), az ablaktól való távolság ('distance_window') és északi vagy déli elhelyezés ('location') alapján megbecsülhető lesz a seb-állapot érték ('wound_rating').	

# Mivel az előrejelzésünk kimenete a résztvevők szerinti klaszteres szerkezetet mutat, ezért a **random effect prediktor** a résztvevő **azonosítója ('ID')** lesz. Az korábbi gyakorlathoz hasonlóan, most is két modellt fogunk illeszteni, a random intercept és a random slope modelleket.	

# Említést érdemel, hogy a **random intercept model** esetében azt feltételezzük, hogy minden résztvevő eltér a teljes vagy baseline seb-állapot értékeit tekintve, de a fix hatás prediktorok ('days', 'distance_window', és 'location') azonosak az egyes résztvevők esetében. Ezzel szemben, a **random slope model** esetében nem csak a baseline seb-állapot érték, de a fix hatás prediktorok is résztvevőnként változóak.	

# Mivel 3 különböző fix hatás prediktor is rendelkezésünkre áll, ezért alkalmazhatjuk a random slope modellt, ami a prediktorok mellett a résztvevőkből származó random hatástól is függeni fog. **A random effect-et a "+ (days|ID)" alakban tehetjük a modellhez**. Ez a kifejezés azt jelenti hogy a modellünkben megengedjük hogy idő múlásának hatása más és más legyen résztvevőnként a seb gyógyulására. Másnéven **az emberek különbözhetnek abban, egy nap alatt mennyit gyógyul a sebük**.	

# További lehetőségként felmerül, hogyha a másik két prediktor szerinti véletlen meredekséget is szeretnénk bevezetni a modellbe, akkor azt a + (days|ID) + (distance_window|ID) + (location|ID) kifejezéssel érhetjük el, ha azt szeretnénk hogy ne legyen köztük korreláció, és a  + (days + distance_window + location|ID) kifejezéssel, ha azt szeretnénk hogy korreláljanak. Most maradjunk egyelőre a korábban leírt, egyszerűbb  + (days|ID) modellnél.	


mod_rep_int = lmer(wound_rating ~ days + distance_window + location + (1|ID), data = data_wound_long)	
mod_rep_slope = lmer(wound_rating ~ days + distance_window + location + (days|ID), data = data_wound_long)	
	


# ## Az eltérő modellek összehasonlítása	

# Hasonlítsuk most össze a különbőző modellek alapján alkotott előrejelzéseket!	

# A könnyebb összehasonlíthatóság kedvéért, vizualizáljuk adatainkat! Ehhez először tároljuk el predikciónk eredményeit egy új változóban, majd ábrázolhatjuk az egyes előrejelzett értékeket a valódi értékek függvényében, az egyes (random intercept és random slope) modellekre vonatkozó külön-külön ábrákon. 	

# (Az alábbiakban létrehoztunk egy másolatot az adatokat tartalmazó objektumról, hogy az eredeti adatok változatlanul megmaradhassanak.)	



data_wound_long_withpreds = data_wound_long	
data_wound_long_withpreds$pred_int = predict(mod_rep_int)	
data_wound_long_withpreds$pred_slope = predict(mod_rep_slope)	
	
# random intercept model	
ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_int, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	
	
# random slope and intercept model	
ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_slope, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	
	


# Látható, hogy az eltérő modellek alapján kapott eredmények között nincs számottevő eltérés.	

# A cAIC() és anova() függvények segítségével további megállapításokat tehetünk az egyes modellek illeszkedéséről, ami egy újabb lehetséges szempont lehet a modellek összehasonlításánál. 	


cAIC(mod_rep_int)$caic	
cAIC(mod_rep_slope)$caic	
	
anova(mod_rep_int, mod_rep_slope)	



# A fenti módszerek egyikével se találunk jelentős eltérést a két modell használata között, így a jelenlegi minta esetén semmiféle előnnyel sem jár a random slope módszer. Ez persze magában még nem elegendő ahhoz, hogy feltételezhessük, hogy más mintánál is hasonló lenne a helyzet. Látható tehát, hogy az adatelemzés során fontos tisztában lennünk a korábbi kutatások eredményeivel, és a vizsgált kérdéskörre vonatkozó elméletekkel.	

# Jelenleg,-híjján bármiféle korábbi ismeretnek,- folytassuk a random intercept modell használatával.	

# ## A modell kiegészítése a napokból származó négyzetes járulékkal	

# Az egyes ábrákat vizsgálva megfigyelhetjük, hogy a napok és a seb-állapot értékek közötti összefüggés nem lineáris. A sebek látszólag gyorsabban gyógyulnak az első néhány napban, mint később.	

# A nem lineáris viselkedés figyelembevétele érdekében, adjuk hozzá a napokból származó négyzetes járulékot a modellünkhöz!	


mod_rep_int_quad = lmer(wound_rating ~ days + I(days^2) + distance_window + location + (1|ID), data = data_wound_long)	


# Mentsük előrejelzéseinket egy új dataframe-be, amely a korábbi előrejelzéseket is tartalmazza!	


data_wound_long_withpreds$pred_int_quad = predict(mod_rep_int_quad)	


# Most pedig hasonlítsuk össze a négyzetes tagokkal bővített, és az eredeti modellt a modellek összehasonlításánál korábban tárgyalt módon!	


data_wound_long_withpreds$pred_int_quad = predict(mod_rep_int_quad)	
	
plot_quad = ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_int_quad, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	



plot_quad	
	
cAIC(mod_rep_int)$caic	
cAIC(mod_rep_int_quad)$caic	
	
anova(mod_rep_int, mod_rep_int_quad)	


# Az összehasonlítás alapján úgy tűnik, hogy a négyzetes tagokat is megengedő modell előrejelzései lényegesen pontosabbak mint a csak lineáris tagokat használóé.	

# Mivel modellünk látszólag jól illeszkedik az adatokra, nem bővítjük tovább tagokkal azt.	

# A négzetes elemek felhasználásából következően várható, hogy problémák fognak jelentkezni a collinearitás tekintetében. A 'days' változó centrálásával ez a probléma a model diagnosztika c. gyakorlatban tárgyalt módon kiküszöbölhető, hiszen megszünteti a 'days' és 'days^2' közötti korrelációt.	

# Végezzük el a centrálást, és illesszük újra modellünket az így kapott prediktorokat használva.	


	
data_wound_long = data_wound_long %>% 	
  mutate(days_centered = days - mean(days))	
	
mod_rep_int_quad = lmer(wound_rating ~ days_centered + I(days_centered^2) + distance_window + location + (1|ID), data = data_wound_long)	


# Az előző gyakorlathoz hasonlóan kérjük eredményeink bemutatását!	



# Marginal R squared	
r2beta(mod_rep_int_quad, method = "nsj", data = data_wound_long)	
	
# marginal and conditional R squared values	
r.squaredGLMM(mod_rep_int_quad)	
	
# Conditional AIC	
cAIC(mod_rep_int_quad)$caic	
	
# Model coefficients	
summary(mod_rep_int_quad)	
	
# Confidence intervals for the coefficients	
confint(mod_rep_int_quad)	
	
# standardized Betas	
stdCoef.merMod(mod_rep_int_quad)	


# Mielőtt elfogadnánk eredményeinket véglegesnek, mindig futassunk modell diagnosztikát is. Ennek módjára a következő gyakorlatban fogunk kitérni.	

# **_____________Gyakorlás (opcionális)______________**	

# Olvassuk be a műtéti fájdalom adatsort!	

# Ez az adatsor a műtét utáni fájdalom mértékéről, és az ezzel feltételezhetően összefüggő néhány egyéb értékekről tartalmaz információkat.	

# Változóink:	

# - ID: résztvevő azonosítója	
# - pain1, pain2, pain3, pain4: A használt adatsorban a fájdalom a műtét utáni négy egymást követő napon volt mérve egy 0tól-10ig terjedő folytonos vizuális skálán.	
# - sex: a résztvevő bejelentett neme	
# - STAI_trait: A résztvevő State Trait Anxiety Inventroy-n elért pontszáma	
# - pain_cat: fájdalom katasztrofizálása	
# - cortisol_serum; cortisol_saliva: A kortizol egy a stress hatására előállított hormon. A kortizol szintet vérből és nyálból, közvetlenül a műtét után határozták meg.	
# - mindfulness: A Mindfulness kérdőív alapján a résztvevőre jellemző Mindfulness érték	
# - weight: résztvevő tömege kg-ban.	
# - IQ: Résztvevő IQ-ja a műtét előtt egy héttel felvett IQ teszt alapján	
# - household_income: résztvevő háztartásának bevétele USD-ben	


# Gyakorló feladatok:	

# 1. Olvassuk be az adatokat (egy .csv kiterjesztésű file-ból). Az adatokat az alábbi linkről tölthetjük le: "https://tinyurl.com/data-pain1".	
# 2. Alakítsuk adatainkat hosszú formátumúvá (célszerű a gather() vagy a melt() függvények valamelyikét használni erre a célra), hogy az egyes megfigyelések külön sorba kerüljenek.	
# 3. Állítsunk össze egy kevert lineáris modellt, hogy amivel képesek vagyunk a műtét utáni fájdalom varianciájának lehető legszélesebb körű lefedésére. (A műtét utáni fájdalom meghatározásához tetszőleges fix prediktort választhatunk, amennyiben annak feltehetően van valami köze a fájdalom mértékéhez.) Mivel adataink a résztvevők szerinti klaszteres szerkezetet mutatnak, modellünkben vegyük figyelembe a résztvevők azonosítója szerinti véletlen hatást. 	
# 4. Kísérletezzünk mind a random intercept, mind pedig a random slope modellekkel, majd hasonlítsuk össze őket a cAIC() függvény felhasználásával.	
# 5. Alkossunk olyan random intercept és random slope modelleket, ahol az egyetlen prediktor az idő (műtét óta eltellt napok száma). Vizualizáljuk a modelljeink alapján kapott regressziós vonalakat, minden résztvevőre külön-külön, és hasonlítsuk össze hogyan illeszkednek a megfigyeléseinkre. Van bármi előnye ha az időt külön változó hatásként vizsgáljuk a random slope modellben?	
# 6. Hasonlítsuk össze az 5. pont modelljeit a cAIC() függvény eredményei alapján is!	
# 7. Mi a határ R^2 érték a random intercept modell esetében? Pontosabb-e a konfidencia intervallum alapján a fájdalom előrejelzésében ez a modell, mint a null modell?	



# **_______________________________________________**	


