
# # Ket valtozo kapcsolatanak vizsgalata, statisztikai inferencia	

# ## Az ora celja	

# Az ora celja hogy megismerkedjunk a **statisztikai inferencia alapjaival** ket valtozo kapcsolatanak elemzesen keresztul.	

# ## Package-ek betoltese	


if (!require("tidyverse")) install.packages("tidyverse")	
library(tidyverse) # for dplyr and ggplot2	


# ## Hipotezisteszteles	

# A statisztikai inferencia, es hipotezis teszteles soran az a celunk, hogy megallapitsuk, letezik-e egy bizonyos hatas vagy kapcsolat. De ezt a **null-hipotezis szignifikancia teszteles (NHST)** soran egy forditott logikaval tesszuk: azt allapitjuk meg, hogy **mekkora a valoszinusege hogy az altalunk megfigyelt adatot/trendet figyeljünk meg (vagy annal meg extremebb trendet), amennyiben a null-hipotezis igaz**.	

# Egy egyszeru pelda: az a sejtesem, hogy **egy penzerme cinkelt**, megpedig ugy hogy nagy valoszinuseggel **fej** legyen az eredmeny amikor feldobjuk. Ebben az esetben a **null-hipotezisem** az, hogy az **erme nem cinkelt**. Vagyis a null-hipotezis szerint ugyan akkora a valoszinusege fejet es irast kapni eredmenykent.	

# - H1: cinkelt erme (fej fele)	
# - H0: nem cinkelt erme, vagy iras fele cinkelt	

# Tegyuk fel hogy 10-szer feldobjuk az ermet, es 9-szer fejet dobunk. Mekkora a valoszinusege, hogy az erme cinkelt? Ezt nem tudjuk megmondani. Tobbek kozott azert sem mert nem tudjuk, mennyire lehet cinkelve. Viszont azt meg tudjuk mondani, hogy mekkora a valoszinusege, hogy ezt az eredmenyt kapnank, ha az erme **NINCS** cinkelve.	

# Annak a valoszinusege, hogy **legalabb 9-szer** (vagy tobbszor) fejet dobok **10 dobasbol** egy nem cinkelt ermevel, p = 0.0107 (**nagyjabol 1%**). (Ezt a kod reszt nem fontos meg megerteni, a lenyege hogy a pbinom() funkcioval kiszamoltuk a valoszinuseget, hogy 10 feldobasbol legalabb 9 fej lesz).	


	
probability_of_heads_if_H0_is_true <- 0.5	
	
heads <- 9	
total_flips <- 10	
probability_of_result = 1-pbinom(heads-1, total_flips, probability_of_heads_if_H0_is_true)	
	
probability_of_result	



# Ez a valoszinuseg **maskepp mondva** azt jelenti, hogy ha ugyan ezt a kiserletet 100 szor megismetelnenk (mindegyikben 10 feldobassal), akkor a 100 kiserletbol csak atlagosan 1-szer varnanak, hogy 9 vagy tobb fejet kapjunk. 	

# Ezt le is ellenorizhetjuk, ha **randomizalunk mondjuk 10.000 hasonlo kiserletet** az rbinom() funkcioval. Az abran lathato hogy csak a kiserletek igen kis szazalekaban kaptunk 9 vagy tobb "sikert". (Ezt a kodreszt sem fontos megerteni, a lenyege hogy az rbinom() funkcioval 10000-szer azt szimulaltuk, hogy egymas utan 10-szer feldobtunk egy ermet (vagyis hogy veletlenszeruen valasztottunk egy szamot 0 es 1 kozul), ez utan ezt abrazoltuk a ggplot-tal)	


successes = rbinom(n = 10000, size = 10, prob = 0.5)	
random_flips = data.frame(successes)	
	
ggplot(data = random_flips) +	
  aes(x = successes) +	
  geom_bar()+	
  scale_x_continuous(breaks = 0:10)+	
  geom_vline(xintercept = 8.5, col = "red", linetype = "dashed", size = 2)	
	
	


# Vagyis ez egy eleg meglepo (bar nem lehetetlen) eredmeny, ha az erme nem lenne cinkelve. Amikor NHST-t csinalunk, ez alapjan hozzuk meg a **dontesunket** arrol, hogy **elvetjuk-e** a null-hipotezist, vagy, kello cáfoló bizonyitek hijan **megtartjuk** azt.	

# A pszichologiaban altalaban **p < 0.05** hatarerteket hasznalunk a donteshozasban, vagyis ha egy olyan meglepo eredmenyt figyelunk meg, **aminek a valoszinusege kisebb mint 5% ha a null-hipotezis igaz, akkor elvetjuk a null-hipotezist**. Vagyis a fenti eredmeny eseten elvethetnek a hull-hipotezist, mert a megfigyelt eredmeny (vagy annal extremebb eredmeny) valoszinusege 1% (p = 0.01) ha a H0 igaz, ami kisebb mint 5% (p < 0.05).	





# ## Statisztikai tesztek	

# **Nem kell jonak lennunk valoszinusegszamitasbol** hogy jo statistzikai donteseket tudjunk hozni. A megfigyeles valoszinuseget a null-hipotezis helyesseget feltetelezve altalaban egy **statisztikai teszt** mondja meg nekunk. Ezen az oran ot statisztikai tesztet fogunk megismerni.	

# - binomialis teszt	
# - khi-negyzet teszt	
# - t-teszt	
# - egyszempontos ANOVA	
# - korrelacios teszt	



# ### binomialis teszt	

# A hipotezist, hogy az erme cinkelt, tesztelhetjuk a **binomialis teszttel**, aminek R-ben binom.test() a funkcioja. Az x helyere a megfigyelt "celmegfigyelesek" vagy "sikerek" szamat (a mi esetunkben a fejek szamat), az n helyere az osszes megfigyeles szamat, a p helyere pedig a **null-hipotezes** helyesseget feltetelezve a "celmegfigyelesek" eleresenek valoszinuseget kell beirni (mivel a hipotezisunk az hogy az erme cinkelt, az null hipotezisunk az, hogy az erme "nem cinkelt"). Ezt valoszinusegkent kell megadni, ami 0 es 1 kozotti szam (ahol a 0 azt jelenti hogy a megfigyelesek 0%-a lesz "siker", az 1 pedig azt hogy a megfigyelesek 100%-a lesz "siker", vagyis a 0.6 jelentese hogy a megfigyelesek 60%-a lesz "siker").	


	
binom.test(x = heads, n = total_flips, p = probability_of_heads_if_H0_is_true, alternative = "greater")	
	


# Ennek a tesztnek az eredmenye a kovetkezot mutatja:	

# - p-value: p-ertek, annak a valoszinusege, hogy az altalunk megfigyelt, vagy extremebb eredmenyt kapunk, feltetelezve hogy a null-hipotezis helyes. Altalaban ha ez az ertek 0.05 alatti, akkor elvetjuk a null-hipotezist.	
# - alternative hypothesis: Itt irja le, hogy mi volt a H1, ami a mi esetunkben az volt, hogy a fej valoszinusege nagyobb mint 0.5 (50%). Ez egyben azt is jelenti, hogy a null-hipotezisunk az volt, hogy a fej valoszinusege 0.5.	
# - 95 percent confidence interval (vagy roviden 95% CI): a 95%-os konfidencia intervallum. Ez azt jelenti, hogy ha a kiserletet sokszor megismeteljuk es ugyan igy kiszamoljuk a konfidencia intervallumot minden kiserletnel, az igy kapott konfidencia intervallumok 95%-a tartalmazni fogja a valos hatasmeretet (ami a mi esetunkben a "siker"/fej valoszinusege). Fontos, hogy nem tudjuk, hogy a mi konkrét kiserletunkban a konfidencia intervallum tartalmazza-e a valos hatasmeretet.	
# - sample estimates: A "siker" ("celmegfigyeles", a mi esetunkben a fej) valoszinusegenek becsult merteke a populacioban a megfigyelt valoszinuseg alapjan. Ez egy pontbecsles, ami mindig megegyezik a megfigyelt valoszinuseggel.	


# Az eredmenyt igy irhatjuk le:	

# "A kutatasunkban 9 fejet figyeltunk meg 10 penzfeldobasbol (90%). Ez alapjan ugy iteljuk, hogy annak a valoszinusege, hogy fejet dobunk az ermevel szignifikansan tobb mint 50%. A fej dobas valoszinusege 0.9 volt a mintaban (95% CI = 0.61, 1)."	


# ## Adatgeneralas az orahoz	

# Az alabbi kod **adatokat general** a szamunkra. Az adatgeneralashoz hasznlalt kod megertese ezen a szinten meg nem szukseges. 	


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
	
	



# Az adatok egy (kepzeletbeli) randomizalt kontrollalt klinikai kutatas eredmenyeibol szarmaznak, ahol a **pszichoterapia hatekonysagat** teszteltek. Olyan szemelyeket vontak be a kutatasba, akik egy **hurrikan aldozatai** voltak, es **szorongassal** kuszkodtek. A szemelyeknel felmertek a reziliancia (psziches ellenallokepesseg) szintjet, majd veletlenszeruen osztottak a szemelyeket egy kezelesi vagy egy kontrol csoportba. Ezt kovetoen a kezelesi csoport **pszichoterapiat kapott 6 heten keresztul** heti egyszer, mig a kontrol csoport nem kapott kezelest. A vizsgalat vegen megmertek a szemelyek **szorongasszintjet**, es a klinikai kriteriumok alapjan meghataroztak, hogy a szemely **gyogyultnak, vagy szorongonak** szamit-e.	

# Lathatjuk, hogy 8 valtozo van az adattablaban. 	

# - participant_ID - reszvevo azonositoja	
# - gender - nem	
# - group - csoporttagsag, ez egy faktor valtozo aminek ket szintje van: "treatment" (kezelt csoport), es "control" (kontrol csoport). A "treatment" csoport kapott kezelest, mig a "control" csoport nem kapott kezelest.	
# - resilience - reziliancia: a nehezsegekkel valo megkuzdes kepessege, ez egy szemlyes kepesseg, olyasmi mint a szemelyisegvonasok	
# - anxiety - szorongas szint	
# - health_status - a klinikai kriteriumok alapjan szorongonak vagy gyogyultnak tekintheto a szemely 	
# - home_ownership - lakhatasi helyzet: harom szintje van az alapjan hogy a szemely hol lakik: "friend" - baratnal vagy csaladnal lakik, "own" - sajat tulajdonu lakasban lakik, "rent" - berelt lakasban lakik, 	
# - height - magassag	

# ## Adatellenorzes	

# Mint mindig, elemzes elott **ellenorizzuk**, hogy az adattal minden rendben van-e!	



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

# A kutatas hipotezise a kovetkezok voltak:	

# 1. Tobb a ferfi mint a no ebben a klinikai mintaban (**gender** vs. 50%).	
# 2. A pszichoterapiat kapo csoportban a terapia utan kevesebb lesz a klinikai kriteriumok alapjan szorongonak szamito szemely (**health_status** vs. **group**)	
# 3. A terapias csoportban alacsonyabb lesz a szorongas atlaga a kutatas vegere mint a kontrol csoportban (**anxiety** vs. **group**)	
# 4. A reziliancia es a kutatas vegen mert szorongasszint negativ osszefuggest fog mutatni (vagyis aki reziliensebb, annal alacsonyabb szorongasszintet fognak merni a kutatas vegen)  (**anxiety** vs. **resilience**)	


# *________________________________*	

# *Gyakorlas*	

# Teszteld a hipotezist, hogy "Tobb a ferfi mint a no ebben a klinikai mintaban" (**gender** valtozo)	

# - Ezt ugyan ugy teheted meg, mint a fenti peldaban, hiszen a null-hipotezis az, hogy a ferfiak ("male") elvart valoszinusege 50% vagy kevesebb (p = 0.5). Szoval a ferfiak ekvivalensek a "fejekkel" a penzfeldobasos peldaban.	
# - Meg kell hataroznod a ferfiak szamat a mintaban, es a teljes mintaelemszamot, hogy ki tudd tolteni a binom.test() fuggveny parametereit.	
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
	


# Az eredmenyt igy irhatjuk le:	

# "Nem volt szignifikans elteres abban, hogy a kulonbozo lakhatasi csoportokban (baratnal, sajat lakasban, vagy berlemenyben lakok) milyen aranyban voltak azok akik meggyogyultak a kutatas vegere (X^2 = `r round(chisq.test(ownership_health_status_table)$statistic, 2)`, df = `r chisq.test(ownership_health_status_table)$parameter`, p = `r round(chisq.test(ownership_health_status_table)$p.value, 3)`)."	





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
	
data %>% 	
  ggplot() +	
    aes(x = gender, y = anxiety, fill = gender) +	
    geom_violin() +	
    geom_jitter(width = 0.2)	
	
	


# Lathatjuk a feltaro elemzes alapjan, hogy a nok szorongasszintje nagyobb valamivel mint a ferfiake atlagosan. Most nezzuk meg, ez a kulonbseg statisztikailag szignifikans-e.	

# Arra, hogy meghatarozzuk van-e kulonbseg ket csoport kozott valamilyen numerikus valtozo atlagaban, hasznalhatjuk a t-tesztet, t.test().	


	
t_test_results = t.test(anxiety ~ gender, data = data)	
t_test_results	
	
mean_dif = summary %>% 	
    summarize(mean_dif = mean[1] - mean[2])	
mean_dif	
	
	


# Az eredmenyt igy irhatjuk le:	

# "A ferfiak es nok szignifikansan kulonboztek a egymastol a szorongas szintjukben (t = `r round(t_test_results$statistic, 2)`, df = `r round(t_test_results$parameter, 2)`, p = `r round(t_test_results$p.value, 3)`. A csoportok szorongas szintjenek atlaga es szorasa a kovetkezo volt: "nok: `r round(summary$mean[1], 2)`(`r round(summary$sd[1], 2)`), ferfiak: `r round(summary$mean[2], 2)`(`r round(summary$sd[2], 2)`). A nok atlagosan `r round(mean_dif, 2)` ponttal voltak szorongobbak (95% CI = `r round(t_test_results$conf.int[1], 2)`, `r round(t_test_results$conf.int[2], 2)`)."	

# Ha egy kategorikus valtozon belul **harom vagy tobb csoportunk** is van, a t.test nem hasznalhato. Helyette hasznalhatjuk az **egyszempontos ANOVA**-t (one-way ANOVA) az aov() funkcioval. A formula ugyan ugy nez ki, mint a t-teszt eseten.	

# Mondjuk alabb azt teszteljuk hogy van-e kulonbseg a lakhatasi helyzet csoportjai kozott a szorongasszintben. Itt valojaban azt teszteljuk, hogy paronkent akarmelyik csoport kozott van-e szignifikans kulonsbeg.	


	
summary_home_ownership_vs_anxiety = data %>% 	
  group_by(home_ownership) %>% 	
    summarize(mean = mean(anxiety), sd = sd(anxiety))	
summary_home_ownership_vs_anxiety	
	
	
data %>% 	
  ggplot() +	
    aes(x = home_ownership, y = anxiety) +	
    geom_boxplot()	
	
	
ANOVA_result = aov(anxiety ~ home_ownership, data = data)	
summary(ANOVA_result)	
	



# Az eredmenyt igy irhatjuk le:	

# "A lakhatasi csoportonk szerint nem volt szignifikans kulonsbeg a szorongas atlagos szintjeben (F (`r round(summary(ANOVA_result)[[1]]$Df[1],2)` ,`r round(summary(ANOVA_result)[[1]]$Df[2],2)`) = `r round(summary(ANOVA_result)[[1]]$F[1],2)`, p = `r round(summary(ANOVA_result)[[1]][1,5],3)`). A szorongas atlagat es szorasat az egyes csoportok szerinti bontasban lasd az 1. tablazatban"	

# Alabb lathato, hogyan produkalnank a megfelelo tablazatot a szorongas atlagaval home_ownership csoportok szerint.	


# ### Egyoldalu vs. ketoldalu tesztek	

# Fontos, hogy ha van elozetes elkepzelesunk a hipotezisalkotaskor arrol, hogy **milyen iranyu** lesz a hatas, akkor **egy-oldalu (one-sided) tesztet** kell hasznalnunk az alapertelmezett ket-oldalu teszt helyett.	

# Peldaul tegyuk fel hogy amikor a hipotezisunket meghataroztuk (idealis esetben ez meg az adatgyujtes elott megtortenik), ugy gondoltuk, hogy a noknek magasabb lesz a szorongasszintjuk, mint a ferfiaknak. Ezt az alternative = "greater" parameterrel hatarozhatjuk meg.	

# Ha osszehasonlitjuk ezt az eredmenyt a korabbi t-teszt eredmenyevel, eszrevehetjuk hogy minden szam valtozatlan maradt, kiveve **a p-erteket, ami pontosan felere csokkent**, es a 95%-os konfidencia intervallumot, aminek a felso hatara most egy vegtelen nagy szam (inf).	

# A p-ertek azert felezodott meg, mert azzal, hogy meghataroztuk, melyik iranyban fog a ket csoport kulonbozni egymastol fele akkora lett az eselye hogy a most megfigyelt, vagy annal nagyobb kulonbseget kapunk a null-hipotezis helyesseget feltetelezve. Vagyis amikor tudjuk, milyen iranyu hatast varunk el, mindig erdemes egy-oldalu tesztet alkalmazni, mert ezzel no a statisztikai eronk.	

# Az egyoldalu tesztek eseten amikor az a hipotezisunk, hogy **a referencia-csoport** atlaga magasabb lesz, (alternative = "greater"), akkor a konfidencia intervallumnak csak az also hatarat szamoljuk ki. Ezert irja a teszt eredmenye hogy a 95% CI 1.11, Inf, vagyis felfele a vegtelensegig tart a konfidencia intervallum.	


	
summary = data %>% 	
  group_by(gender) %>% 	
    summarize(mean = mean(anxiety), sd = sd(anxiety))	
summary	
	
data %>% 	
  ggplot() +	
    aes(x = gender, y = anxiety, fill = gender) +	
    geom_violin() +	
    geom_jitter(width = 0.2)	
	
t_test_results_one_sided = t.test(anxiety ~ gender, data = data, alternative = "greater")	
t_test_results_one_sided	
	


# Az eredmenyt igy irhatjuk le:	

# "A ferfiak es nok szignifikansan kulonboztek a egymastol a szorongas szintjukben (t = `r round(t_test_results_one_sided$statistic, 2)`, df = `r round(t_test_results_one_sided$parameter, 2)`, p = `r round(t_test_results_one_sided$p.value, 3)`. A csoportok szorongas szintjenek atlaga es szorasa a kovetkezo volt: "nok: `r round(summary$mean[1], 2)`(`r round(summary$sd[1], 2)`), ferfiak: `r round(summary$mean[2], 2)`(`r round(summary$sd[2], 2)`). A nok atlagosan `r round(mean_dif, 2)` ponttal voltak szorongobbak (95% CI = `r round(t_test_results_one_sided$conf.int[1], 2)`, inf)."	


# Nezzuk meg, mi tortenne, ha azt tippeltuk volna a hipotezisalkotaskor, hogy a noknek alacsonyabb lesz a szorongasszintjuk. Ezt ugy hatarozhatjuk meg, hogy a t.test() funkcioban alternative = "less" parametert allitunk be.	

# A p-ertek itt majdnem eleri az 1-et, vagyis nagyon nagy a valoszinusege, hogy a null-hipotezis helyesseget feltetelezve ilyen, vagy ennel extremebb kulonbseget figyelunk meg. Nem is csoda, hiszen a null hipotezisunk itt az hogy a nok szorongasanak atlaga nem fog kulonbozni, vagy nagyobb lesz mint a ferfiake, es azt tapasztaltuk, hogy valoban nagyobb volt, vagyis a megfigyeles egyaltalan nem segit abban, hogy elutasitsuk a null-hipotezist. 	



	
t_test_results_one_sided = t.test(anxiety ~ gender, data = data, alternative = "less")	
t_test_results_one_sided	
	


# Azt is erdemes megjegyezni, hogy a "greater" es a "less" minding a kategorikus valtozo **referencia-szintjere** vonatkozik. Ha ezt nem allitottuk be maskepp, pl. a **factor (levels = )** funkcioval, akkor a referencia-szint az ABC sorrendben elorebb levo szint lesz. A fenti esetben a ket szint a "female" es a "male", amik kozul a "female" jon elobb ABC sorrendben. Ha azt tippeltuk volna, hogy az lenne a hipotezisunk, hogy a ferfiak ("male") szorongasszintje lesz magasabb, akkor alternative = "less"-t kellene beallitanunk, mert ezzel egyben azt tippeljuk, hogy a referenciaszint ("felame") atalaga lesz az alacsonyabb. Vagy at kellene allitani a referenciaszintet. 	



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


correlation_result = cor.test(data$resilience, data$height)		
correlation_result		
	


# Az eredmenyt igy irhatjuk le:	

# "A reziliencia es a magassag kozott nem talaltunk szignifikans egyuttjarast (r = `r round(correlation_result$estimate, 2)`, 95% CI = `r round(correlation_result$conf.int[1], 2)`, `r round(correlation_result$conf.int[2], 2)`, df = `r round(correlation_result$parameter, 2)`, p = `r round(correlation_result$p.value, 3)`)"	

# Hasonloan a t-teszthez, a korrelacios teszt eseteben is erdemes egyoldalu tesztet hasznalni amikor a hipotezisunk megmondja a kapcsolat iranyat is, nem csak azt, hogy van kapcsolat a ket valtozo kozott.	

# Peldaul feltetelezzuk, hogy a ket valtozo kozotti kapcsolat pozitiv lesz. Vagyis egy ember minel magasabb, annal magasabb a rezilienciaja. Ezt ugy adhatjuk meg a statisztikai teszt specifikaciojakor, hogy a formulahoz hozzatesszuk az alternative = "greater" parametert. Ha az eredmenyt osszehasonlitjuk az elozo korrelacios teszt eredmenyevel, lathatjuk, hogy a p-ertek is megvalozott. A konfidencia intervallumnak itt is csak az also hatara erdekes, a felso hatara a leeheto legmagasabb erteket veszi fel ilyenkor, ami a korrelacional 1.	


	
correlation_result_greater = cor.test(data$resilience, data$height, alternative = "greater")		
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

