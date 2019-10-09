# ---	
# title: "Seminar_5"	
# author: "Zoltan Kekecs"	
# date: "9 oktober 2019"	
# output: html_document	
# ---	


	


# # Ket valtozo kapcsolatanak vizsgalata, statisztikai inferencia	

# ## Az ora celja	

# Az ora celja hogy megismerkedjunk a statisztikai inferencia alapjaival ket valtozo kapcsolatanak elemzesen keresztul.	

# ## Package-ek betoltese	


if (!require("tidyverse")) install.packages("tidyverse")	
library(tidyverse) # for dplyr and ggplot2	


# ## Adatgeneralas az orahoz	

# Az alabbi kod adatokat general a szamunkra. Az adatgeneralashoz hasznlalt kod megertese ezen a szinten meg nem szukseges. 	


n_per_group = 40	
	
base_height_mean = 164	
base_height_sd = 10	
base_anxiety_mean = 18	
base_anxiety_sd = 2	
resilience_mean = 7	
resilience_sd = 2	
	
treatment_effect = - 3	
resilience_effect = - 0.8	
	
gender_bias = 0.7	
gender_effect = - 1	
gender_effect_on_height = 12	
	
	
treatment <- rep(c(1, 0), each = n_per_group)	
set.seed(1)	
	
gender_num <- rbinom(n = n_per_group * 2, size = 1, prob = 0.7)	
gender <- NA	
gender[gender_num == 0] = "female"	
gender[gender_num == 1] = "male"	
	
set.seed(2)	
home_ownership <- sample(c("own", "rent", "friend"), n_per_group * 2, replace = T)	
	
set.seed(3)	
resilience <- rnorm(mean = resilience_mean, sd = resilience_sd, n = n_per_group*2)	
	
set.seed(6)	
anxiety_base <- rnorm(mean = base_anxiety_mean, sd = base_anxiety_sd, n = n_per_group*2)	
anxiety <- anxiety_base + treatment * treatment_effect + resilience * resilience_effect + gender_num * gender_effect	
participant_ID <- paste0("ID_", 1:(n_per_group*2))	
	
set.seed(5)	
height_base <- rnorm(mean = base_height_mean, sd = base_height_sd, n = n_per_group*2)	
height <- height_base + gender_num * gender_effect_on_height	
	
	
group <- rep(NA, n_per_group*2)	
group[treatment == 0] = "control"	
group[treatment == 1] = "treatment"	
	
health_status <- rep(NA, n_per_group*2)	
health_status[anxiety < 11] = "cured"	
health_status[anxiety >= 11] = "anxious"	
	
data <- data.frame(participant_ID)	
data = cbind(data, gender, group, resilience, anxiety, health_status, home_ownership, height)	
data = as_tibble(data)	
	
data = data %>% 	
  mutate(gender = factor(gender))	
	
data = data %>% 	
  mutate(group = factor(group))	
	
data = data %>% 	
  mutate(health_status = factor(health_status))	
	
data = data %>% 	
  mutate(home_ownership = factor(home_ownership))	
	
data	
	
cor(height_base, resilience)	
	



# ## Adatellenorzes	

# Mint mindig, elemzes elott ellenorizzuk, hogy az adattal minden rendben van-e!	

# Lathatjuk, hogy 8 valtozo van az adattablaban. 	

# - participant_ID - reszvevo azonositoja	
# - gender - nem
# - group - csoporttagsag, ez egy faktor valtozo aminek ket szintje van: "treatment" (kezelt csoport), es "control" (kontrol csoport). A "treatment" csoport kapott kezelest, mig a "control" csoport nem kapott kezelest.	
# - resilience - reziliancia: a nehezsegekkel valo megkuzdes kepessege, ez egy szemlyes kepesseg, olyasmi mint a szemelyisegvonasok	
# - anxiety - szorongas szint	
# - health_status - a klinikai kriteriumok alapjan szorongonak vagy gyogyultnak tekintheto a szemely 	
# - home_ownership - lakhatasi helyzet: harom szintje van az alapjan hogy a szemely hol lakik: "friend" - baratnal vagy csaladnal lakik, "own" - sajat tulajdonu lakasban lakik, "rent" - berelt lakasban lakik, 
# - height - magassag


# Mondjuk hogy az adatok egy randomizalt kontrollalt klinikai kutatas eredmenyeibol szarmaznak, ahol a pszichoterapia hatekonysagat teszteltek. Olyan szemelyeket vontak be a kutatasba, akik egy hurrikan aldozatai voltak, es szorongassal kuszkodtek. A szemelyeknel felmertek a reziliancia szintjet, majd veletlenszeruen osztottak a szemelyeket egy kezelesi vagy egy kontrol csoportba. Ezt kovetoen a kezelesi csoport pszichoterapiat kapott 6 heten keresztul heti egyszer, mig a kontrol csoport nem kapott kezelest. A vizsgalat vegen megmertek a szemelyek szorongasszintjet, es a klinikai kriteriumok alapjan meghataroztak, hogy a szemely gyogyulnak, vagy szorongonak szamit-e.	




data	
	
data %>% 	
  summary()	
	
data %>% 	
  ggplot() +	
    aes(x = resilience) +	
    geom_histogram()	
	
data %>% 	
  ggplot() +	
    aes(x = anxiety) +	
    geom_histogram()	
	
data %>% 	
  ggplot() +	
    aes(x = health_status) +	
    geom_bar()	
	
set.seed(Sys.time())	


# ## Hipotezisek	

# Vizsgaljuk meg kutatasban szereplo valtozok osszefuggeset a hipotezisek menten.	

# Erre eloszor feltaro elemzest hasznalunk.	

# A kutatas hipotezise a kovetkezok voltak:	

# 1. Tobb a ferfi mint a no ebben a klinikai mintaban (**gender** vs. 50%).	
# 2. A pszichoterapiat kapo csoportban a terapia utan kevesebb lesz a klinikai kriteriumok alapjan szorongonak szamito szemely (**health_status** vs. **group**)	
# 3. A terapias csoportban alacsonyabb lesz a szorongas atlaga a kutatas vegere mint a kontrol csoportban (**anxiety** vs. **group**)	
# 4. A reziliancia es a kutatas vegen mert szorongasszint negativ osszefuggest fog mutatni (vagyis aki reziliensebb, annal alacsonyabb szorongasszintet fognak merni a kutatas vegen)  (**anxiety** vs. **resilience**)	


# ## Hipotezisteszteles	

# A statisztikai inferencia, es hipotezis teszteles soran az a celunk, hogy megallapitsuk, letezik-e egy bizonyos hatas vagy kapcsolat. De ezt a **null-hipotezis szignifikancia teszteles (NHST)** soran egy forditott logikaval tesszuk: azt allapitjuk meg, hogy mekkora a valoszinusege hogy az altalunk megfigyelt eredmenyt (vagy annal meg extremebb eredmenyt) kapjunk, amennyiben a null-hipotezis igaz.	

# Egy egyszeru pelda: az a sejtesem, hogy egy penzerme cinkelt, megpedig ugy hogy nagy valoszinuseggel fej legyen az eredmeny amikor feldobjuk. Ebben az esetben a null-hipotezisem az, hogy az erme nem cinkelt, vagyis ugyan akkora a valoszinusege fejet es irast kapni eredmenykent, ha feldobjuk.	

# - H1: cinkelt erme	
# - H0: nem cinkelt erme	

# Tegyuk fel hogy 10-szer feldobjuk az ermet, es 9-szer fejet dobunk. Mekkora a valoszinusege, hogy az erme cinkelt? Ezt nem tudjuk megmondani. Tobbek kozott azert sem mert nem tudjuk, mennyire lehet cinkelve. Viszont azt meg tudjuk mondani, hogy mekkora a valoszinusege, hogy ezt az eredmenyt kapnank, ha az erme **NINCS** cinkelve.	

# Annak a valoszinusege, hogy legalabb 9-szer (vagy tobbszor) fejet dobok 10 dobasbol egy nem cinkelt ermevel, p = 0.0107 (nagyjabol 1%). 	


	
probability_of_heads_if_H0_is_true <- 0.5	
	
heads <- 9	
total_flips <- 10	
probability_of_result = 1-pbinom(heads-1, total_flips, probability_of_heads_if_H0_is_true)	
	
probability_of_result	



# Ez a valoszinuseg maskepp leforditva azt jelenti, hogy ha ugyan ezt a kiserletet 100 szor megismetelnenk (mindegyikben 10 dobassal), akkor a 100 kiserletbol csak atlagosan 1-szer varnanak, hogy 9 vagy tobb fejet kapjunk. 	

# Ezt le is ellenorizhetjuk, ha randomizalunk mondjuk 10.000 hasonlo kiserletet az rbinom() funkcioval. Az abran lathato hogy csak a kiserletek igen kis szazalekaban kaptunk 9 vagy tobb "sikert". 	


successes = rbinom(n = 10000, size = 10, prob = 0.5)	
random_flips = data.frame(successes)	
	
library(ggplot2)	
	
ggplot(data = random_flips) +	
  aes(x = successes) +	
  geom_bar()+	
  scale_x_continuous(breaks = 0:10)+	
  geom_vline(xintercept = 8.5, col = "red", linetype = "dashed", size = 2)	
	
	


# Vagyis ez egy eleg meglepo (bar nem lehetetlen) eredmeny, ha az erme nem lenne cinkelve. Amikor NHST-t csinalunk, ez alapjan hozzuk meg a dontesunket arrol, hogy **elvetjuk-e** a null-hipotezist, vagy, kello bizonyitek hijan **megtartjuk** azt.	

# A pszichologiaban altalaban **p < 0.5** hatarerteket hasznalunk a donteshozasban, vagyis ha egy olyan meglepo eredmenyt figyelunk meg, aminek a valoszinusege kisebb mint 5% ha a null-hipotezis igaz, akkor elvetjuk a null-hipotezist. Vagyis a fenti eredmeny eseten elvethetnek a hull-hipotezist, mert a megfigyelt eredmeny vagy annal extremebb eredmeny valosinusege 1% (p = 0.01), ami kisebb mint 5% (p < 0.05).	


# ## Statisztikai tesztek	

# A megfigyeles valoszinuseget a null-hipotezis helyesseget feltetelezve altalaban egy statisztikai teszt mondja meg nekunk. Ezen az oran negy statisztikai tesztet fogunk megismerni.	

# - binomialis teszt	
# - khi-negyzet teszt	
# - korrelacios teszt	
# - t-teszt	

# ### binomialis teszt	

# A fenti hipotezist pl. tesztelhetjuk a **binomialis teszttel**, aminek R-ben binom.test() a funkcioja. Az x helyere a megfigyelt "celmegfigyelesek" vagy "sikerek" szamat (a mi esetunkben a fejek szamat), az n helyere az osszes megfigyeles szamat, a p helyere pedig a null-hipotezes helyesseget feltetelezve a "celmegfigyelesek" eleresenek valoszinuseget kell beirni. Ezt valoszinusegkent kell megadni, ami 0 es 1 kozotti szam (0 = 0% esely, 1 = 100% esely)	


	
binom.test(x = heads, n = total_flips, p = probability_of_heads_if_H0_is_true, alternative = "greater")	
	


# Ennek a tesztnek az eredmenye a kovetkezot mutat:	

# - p-value: p-ertek, annak a valoszinusege, hogy az altalunk megfigyelt, vagy extremebb eredmenyt kapunk, feltetelezve hogy a null-hipotezis helyes. Altalaban ha ez az ertek 0.05 alatti, akkor elvetjuk a null-hipotezist.	
# - alternative hypothesis: Itt irja le, hogy mi volt a H1, ami a mi esetunkben az volt, hogy a fej valoszinusege nagyobb mint 0.5 (50%). Ez egyben azt is jelenti, hogy a null-hipotezisunk az volt, hogy a fej valoszinusege 0.5 VAGY KISEBB.	
# - 95 percent confidence interval (vagy roviden 95% CI): a 95%-os konfidencia intervallum. Ez azt jelenti, hogy ha a kiserletet sokszor megismeteljuk es ugyan igy kiszamoljuk a konfidencia intervallumot minden kiserletnel, az igy kapott konfidencia intervallumok 95%-a tartalmazni fogja a valos hatasmeretet (ami a mi esetunkben a "siker" valoszinusege). Fontos, hogy nem tudjuk, hogy a mi kiserletunkban a konfidencia intervallum tartalmazza-e a valos hatasmeretet.	
# - sample estimates: A "siker" ("celmegfigyeles", a mi esetunkben a fej) valoszinusegenek becsult merteke a populacioban a megfigyelt valoszinuseg alapjan. Ez egy pontbecsles, ami mindig megegyezik a megfigyelt valoszinuseggel.	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat

# *________________________________*	

# *Gyakorlas*	

# Teszteld a hipotezist, hogy "Tobb a ferfi mint a no ebben a klinikai mintaban" (**gender** valtozo)	

# - Ezt ugyan ugy teheted meg, mint a fenti peldaban, hiszen a null-hipotezis az, hogy a ferfiak ("male") elvart valoszinusege 50% vagy kevesebb (p = 0.5). Szoval a ferfiak ekvivalensek a "fejekkel" a penzfeldobasos peldaban.	
# - Meg kell hataroznod a ferfiak szamat a mintaban, es a teljes mintaelemszamot, hogy ki todd tolteni a binom.test() fuggveny parametereit.	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


# *________________________________*	


# ## Ket kategorikus valtozo kapcsolata: Khi-negyzet proba (Chi-squared test)	

# A Khi-negyzet proba ket kategorikus valtozo kapcsolatat hivatott megvizsgalni.	

# Peldaul megvizsgalhatjuk, hogy van-e kapcsolat abban, hogy a szemelyek lakhatasi helyzete (**home_ownership**) es a kozott, hogy a kutatas vegen az egyes szemelyek meggyogyultak-e (**health_status**).	

# Eloszor feltaro elemzest vegzunk:	

# - tablazatot rajzolunk a ket valtozo kapcsolatarol	
# - abrat keszitunk (pl. geom_bar)	


	
table(data$home_ownership, data$health_status)	
	
data %>% 	
  ggplot() +	
    aes(x = home_ownership, fill = health_status) +	
    geom_bar(position = "dodge")	
	


# Ez utan elvegezzuk a Khi-negyzet probat. Ehhez eloszor keszitenunk kell egy tablazatot a ket valtozo kapcsolatarol, amit egy uj objektumban elmentunk.	

# A Khi-negyzet proba azt a null-hipotezist teszteli, hogy a csoportokban ugyan olyan a masik kategorikus valtozo eloszlasa (vagyis a mi esetunkben a null hipotezis hogy ugyan olyan aranyban gyogyulnak meg akik baratnal laknak, akiknak sajat lakasuk van, es akik berlik a lakast).	


	
ownership_health_status_table = table(data$home_ownership, data$health_status)	
ownership_health_status_table	
	
chisq.test(ownership_health_status_table)	
	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat




# *________________________________*	

# *Gyakorlas*	

# Teszteld a 2. hipotezist, hogy "A pszichoterapiat kapo csoportban a terapia utan kevesebb lesz a klinikai kriteriumok alapjan szorongonak szamito szemely" (**health_status** vs. **group**)	

# - Ezt ugyan ugy teheted meg, mint a fenti peldaban, hiszen a null-hipotezis az, hogy nincs kulonbseg a csoporttagsag szerint (treatment vs. control) abban hogy milyen aranyban gyogyultak meg a kutatas vegere.	
# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a table() funkcioval es egy abraval (mondjuk geom_bar() hasznalataval) 	
# - A tablazatot mentsd el egy uj objektumba	
# - Ez utan vegezd el a tesztet, chisq.test()	
# - Es ird le a fentiek szerint az eredmenyeket.	


# *________________________________*	


# ## Egy numerikus valtozo atlaganak kolunbsege csoportok kozott: anova es t-teszt	

# Tesztelhetjuk peldaul, hogy van-e kulonbseg a nemek kozott (**gender**) a kutatas vegen mert szorongas szintjeben (**anxiety**).	

# Eloszor szokas szerint feltaro elemzest vegzunk atlagok csoportonkenti osszehasonlitasaval es abraval. Erre pl. remek a geom_boxplot() es a geom_density()	


	
summary = data %>% 	
  group_by(gender) %>% 	
    summarize(mean = mean(anxiety), sd = sd(anxiety))	
summary	
	
data %>% 	
  ggplot() +	
    aes(x = gender, y = anxiety) +	
    geom_boxplot()	
	
data %>% 	
  ggplot() +	
    aes(x = anxiety, fill = gender) +	
    geom_density(alpha = 0.3)	
	
	


# Lathatjuk a feltaro elemzes alapjan, hogy a nok szorongasszintje nagyobb valamivel mint a ferfiake atlagosan. Most nezzuk meg, ez a kulonbseg statisztikailag szignifikans-e.	

# Arra, hogy meghatarozzuk van-e kulonbseg ket csoport kozott valamilyen numerikus valtozo atlagaban, hasznalhatjuk a t-tesztet, t.test().	


	
t_test_results = t.test(anxiety ~ gender, data = data)	
t_test_results	
	
mean_dif = summary %>% 	
    summarize(mean_dif = mean[1] - mean[2])	
mean_dif	
	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat

# Ha egy kategorikus valtozon belul tobb csoportunk is van, hasznalhatjuk az egyszempontos ANOVA-t (one-way ANOVA) az aov() funkcioval a t.test() helyett. A formula amit be kell irni ugyan ugy nez ki, mint a t-teszt eseten.	

# Mondjuk alabb azt teszteljuk hogy van-e kulonbseg a lakhatasi helyzet csoportjai kozott a szorongasszintben. Itt valojaban azt teszteljuk, hogy paronkent akarmelyik csoport kozott van-e szignifikans kulonsbeg.	


	
ANOVA_result = aov(anxiety ~ home_ownership, data = data)	
summary(ANOVA_result)	
	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat

# Alabb lathato, hogyan produkalnank a megfelelo tablazatot a szorongas atlagaval home_ownership csoportok szerint.	


	
summary_home_ownership_vs_anxiety = data %>% 	
  group_by(home_ownership) %>% 	
    summarize(mean = mean(anxiety), sd = sd(anxiety))	
summary_home_ownership_vs_anxiety	


# ### Egyoldalu vs. ketoldalu tesztek	

# Fontos, hogy ha van elozetes elkepzelesunk a hipotezisalkotaskor arrol, hogy milyen iranyu lesz a hatas, akkor egy-oldalu (one-sided) tesztet kell hasznalnunk az alapertelmezett ket-oldalu teszt helyett.	

# Peldaul tegyuk fel hogy amikor a hipotezisunket meghataroztuk (idealis esetben ez meg az adatgyujtes elott megtortenik), ugy gondoltuk, hogy a noknek magasabb lesz a szorongasszintjuk, mint a ferfiaknak. Ezt az alternative = "greater" parameterrel hatarozhatjuk meg.	

# Ha osszehasonlitjuk ezt az eredmenyt a korabbi t-teszt eredmenyevel, eszrevehetjuk hogy minden szam valtozatlan maradt, kiveve a p-erteket, ami pontosan felere csokkent, es a 95%-os konfidencia intervallumot, aminek a felso hatara most egy vegtelen nagy szam (inf).	

# A p-ertek azert felezodott meg, mert azzal, hogy meghataroztuk, melyik iranyban fog a ket csoport kulonbozni egymastol fele akkora lett az eselye hogy a most megfigyelt, vagy annal nagyobb kulonbseget kapunk a null-hipotezis helyesseget feltetelezve. Vagyis amikor tudjuk, milyen iranyu hatast varunk el, mindig erdemes egy-oldalu tesztet alkalmazni, mert ezzel no a statisztikai eronk.	

# Az egyoldalu tesztek eseten amikor az a hipotezisunk, hogy a referencia-csoport atlaga magasabb lesz, (alternative = "greater"), akkor a konfidencia intervallumnak csak az also hatarat szamoljuk ki. Ezert irja a teszt eredmenye hogy a 95% CI 1.11, Inf, vagyis felfele a vegtelesegig tart a konfidencia intervallum.	


	
t_test_results_one_sided = t.test(anxiety ~ gender, data = data, alternative = "greater")	
t_test_results_one_sided	
	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat


# Nezzuk meg, mi tortenne, ha azt tippeltuk volna a hipotezisalkotaskor, hogy a noknek alacosnyabb lesz a szorongasszintjuk. Ezt ugy hatarozhatjuk meg, hogy a t.test() funkcioban alternative = "less" parametert allitunk be.	

# A p-ertek itt majdnem eleri az 1-et, vagyis nagyon nagy a valoszinusege, hogy a null-hipotezis helyesseget feltetelezve ilyen, vagy ennel extremebb kulonbseget figyelunk meg. Nem is csoda, hiszen a null hipotezisunk itt az hogy a nok szorongasanak atlaga nem fog kulonbozni, vagy nagyobb lesz mint a ferfiake, es azt tapasztaltuk, hogy valoban nagyobb volt, vagyis a megfigyeles egyaltalan nem segit abban, hogy elutasitsuk a null-hipotezist. 	



	
t_test_results_one_sided = t.test(anxiety ~ gender, data = data, alternative = "less")	
t_test_results_one_sided	
	


# Azt is erdemes megjegyezni, hogy a "greater" es a "less" minding a kategorikus valtozo referencia-szintjere vonatkozik. Ha ezt nem allitottuk be maskepp, pl. a factor (levels = ) funkcioval, akkor a referencia-szint az ABC sorrendben elorebb levo szint lesz. A fenti esetben a ket szint a "female" es a "male", amik kozul a "female" jon elobb ABC sorrendben. Ha azt tippeltuk volna, hogy az lenne a hipotezisunk, hogy a ferfiak ("male") szorongasszintje lesz magasabb, akkor alternative = "less"-t kellene beallitanunk, mert ezzel egyben azt tippeljuk, hogy a referenciaszint ("felame") atalaga lesz az alacsonyabb. Vagy at kellene allitani a referenciaszintet. 	



# *________________________________*	

# *Gyakorlas*	

# Teszteld a 3. hipotezist, hogy "A terapias csoportban alacsonyabb lesz a szorongas atlaga a kutatas vegere mint a kontrol csoportban" (**anxiety** vs. **group**)	

# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a summarize(mean(), sd()) funkciokkal, es keszitsunk abrat, mondjuk geom_boxplot() segitsegevel.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Melyik tesztet erdemes hasznalni, az egyvaltozos ANOVA-t, vagy a t-tesztet? (gondolj arra, hogy hany csoport (szint) van a kategorikus valtozon belul)	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


# *________________________________*	

# ## Ket numerikus valtozo kozotti kapcsolat, korrelacio, cor.test()	

# Vizsgaljuk meg, van-e egyuttjaras a reziliencia (**resilience**) es a magassag (**height**) kozott.	

# Eloszor vegezzunk feltaro elemzest a korrelacios egyutthato kiszamitasaval, es egy pontdiagrammal. Hasznaljunk geom_point() es geom_smooth() geomokat egyszerre, es hasznaljuk az "lm" modszert a trendvonal megrajzolasara.	


	
data %>% 	
  select(resilience, height) %>% 	
    cor()	
	
data %>% 	
  ggplot() +	
    aes(x = resilience, y = height) +	
      geom_point() +	
      geom_smooth(method = "lm")	
	


# A ket valtozo fuggetlennek tunik egymastol a feltaro elemzes alapjan, de elkepzelheto, hogy a hatas, barmilyen kicsit is, megis statisztikailag szignifikans, szoval vegezzuk el a statisztikai tesztet is.	

# Ezt a pearson korrelacios teszt segitsegevel tehetjuk meg, cor.test() a kovetkezo keppen:	


	
correlation_result = cor.test(resilience, height, data = data)	
correlation_result	
	


# Arrol hogy az eredmenyt hogy irhatjuk le, lasd az orai anyag pdf valtozatat

# Hasonloan a t-teszthez, a korrelacios teszt eseteben is erdemes egyoldalu tesztet hasznalni amikor a hipotezisunk megmondja a kapcsolat iranyat is, nem csak azt, hogy van kapcsolat a ket valtozo kozott.	

# Peldaul feltetelezzuk, hogy a ket valtozo kozotti kapcsolat pozitiv lesz. Vagyis egy ember minel magasabb, annal magasabb a rezilienciaja. Ezt ugy adhatjuk meg a statisztikai teszt specifikaciojakor, hogy a formulahoz hozzatesszuk az alternative = "greater" parametert. Ha az eredmenyt osszehasonlitjuk az elozo korrelacios teszt eredmenyevel, lathatjuk, hogy a p-ertek is megvalozott. A konfidencia intervallumnak itt is csak az also hatara erdekes, a felso hatara a leeheto legmagasabb erteket veszi fel ilyenkor, ami a korrelacional 1.	


	
correlation_result_greater = cor.test(resilience, height, data = data, alternative = "greater")	
correlation_result_greater	
	




# *________________________________*	

# *Gyakorlas*	

# Teszteld a 4. hipotezist, hogy "A reziliancia es a kutatas vegen mert szorongasszint negativ osszefuggest fog mutatni (vagyis aki reziliensebb, annal alacsonyabb szorongasszintet fognak merni a kutatas vegen)" (**anxiety** vs. **resilience**)	

# - Eloszor vegezzunk egy feltaro elemzest a korrelacios egyutthato meghatarozasaval es egy pontdiagrammal a ket valtozo kapcsolatarol.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


# *________________________________*	


# ### A statisztikai tesztek eredmenyenek kozleserol altalaban	

# A statisztikai tesztek eredmenyenek kozlese soran a kovetkezo informaciokat szoktuk megadni altalanossagban. Ez tesztrol tesztre valtozhat, de az alabbiak kozul minel tobb informaciot megadnunk, annal jobb.	

# - az eredmeny szoveges leirasa	
# - teszt-statisztika	
# - szabadsagfok (ez egyszeru teszteknel altalaban az elemszammal is megadhato)	
# - p-ertek	
# - hatas merteke (parameterbecsles)	
# - hatasmertek 95%-os konfidencia intervalluma	

