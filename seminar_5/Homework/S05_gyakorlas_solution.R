######################################
# Az 5. gyakorlat gyakorló script-je #
######################################

## Töltsd le ezt a kódot.
## Oldd meg a feladatokat úgy hogy a kódot amit a megoldáshoz használsz az adott
## feladat kommentje alá másolod.
## A kész gyakorlófeladatot mentsd el a saját Drive mappádba. 
## A fájl neve ez legyen: 
## Családnév Utónév gyakorlófeladat ÉÉÉÉHHNN, pl.: “Példa Géza gyakorlófeladat 20200912.R” !
## A beadási határidő minden héten vasárnap éjfél.


# 
# 1. Töltsd be a tidyverse csomagot!

library(tidyverse)

# 2. Töltsd be az adatokat. Ezt a 
# https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/S05_orai_adat.csv 
# url-ről tudod betölteni. Használd a betöltéshez a read.csv() vagy a read_csv() funkciókat.

data = read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/S05_orai_adat.csv ")

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

# 3. Teszteld a hipotezist, hogy "Tobb a ferfi mint a no ebben a klinikai mintaban" (**gender** valtozo)	

# - Ezt ugyan ugy teheted meg, mint az orai peldaban, hiszen a null-hipotezis az, hogy a ferfiak ("male") elvart valoszinusege 50% vagy kevesebb (p = 0.5). Szoval a ferfiak ekvivalensek a "fejekkel" a penzfeldobasos peldaban.	
# - Meg kell hataroznod a ferfiak szamat a mintaban, es a teljes mintaelemszamot, hogy ki tudd tolteni a binom.test() fuggveny parametereit.	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	

data %>% 
  ggplot() +
    aes(x = gender) +
    geom_bar()

data %>% 
  filter(gender == "male") %>%
  summarize(n = n())

binom.test(x = 55, n = nrow(data), p = 0.5, alternative = "greater")

### A mintaban a ferfiak aranya 68.75% (95% CI 0.59, 1) volt, ez szignifikansan tobb (p < 0.001) mint
### a nok aranya. 

# 4. Teszteld a 2. hipotezist, hogy "A pszichoterapiat kapo csoportban a terapia utan kevesebb lesz a klinikai kriteriumok alapjan szorongonak szamito szemely" (**health_status** vs. **group**)	

# - Ezt ugyan ugy teheted meg, mint az orai peldaban, hiszen a null-hipotezis az, hogy nincs kulonbseg a csoporttagsag szerint (treatment vs. control) abban hogy milyen aranyban gyogyultak meg a kutatas vegere.	
# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a table() funkcioval es egy abraval (mondjuk geom_bar() hasznalataval) 	
# - A tablazatot mentsd el egy uj objektumba	
# - Ez utan vegezd el a tesztet, chisq.test()	
# - Es ird le a fentiek szerint az eredmenyeket.

group_health_status_table = table(data$group, data$health_status)
group_health_status_table

group_health_status_table[1,1]/sum(group_health_status_table[1,])
group_health_status_table[2,1]/sum(group_health_status_table[2,])

data %>% 
  ggplot() +
  aes(x = group, fill = health_status) +
  geom_bar(position = "dodge")


chisq.test(group_health_status_table)

### Szignifikáns különbség van a klinikai kriteriumok alapjan szorongo szemelyek aranyaban a
### a kiserleti es a kontroll csoport kozott (X^2 = 6.30, df = 1, p = 0.012). A kezelesi csoportban
### kevesebb kisebb volt a szorongok aranya mint a kontroll csoportban 
### (kezelsesi csoport: 0.25 vs. kontroll csoport: 0.55).


# 5. Teszteld a 3. hipotezist, hogy "A terapias csoportban alacsonyabb lesz a szorongas atlaga a kutatas vegere mint a kontrol csoportban" (**anxiety** vs. **group**)	

# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a summarize(mean(), sd()) funkciokkal, es keszitsunk abrat, mondjuk geom_boxplot() segitsegevel.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Melyik tesztet erdemes hasznalni, az egyvaltozos ANOVA-t, vagy a t-tesztet? (gondolj arra, hogy hany csoport (szint) van a kategorikus valtozon belul)	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	

data %>% 
  ggplot() +
  aes(x = group, y = anxiety) +
  geom_boxplot()

anxiety_group_table = 
  data %>% 
  group_by(group) %>% 
  summarize(mean = mean(anxiety),
            sd = sd(anxiety))
anxiety_group_table

anxiety_group_table[1,2] - anxiety_group_table[2,2]

t.test(anxiety ~ group, data = data, alternative = "greater")

### A kezelesi es a kontroll csoport szignifikansan kulonbozott a szorongas atlagos szintjeben
### (t = 4.13, df = 75.20, p < 0.01, kezelesei = 9.04, kontroll = 11.4). A ket csoport atlagai 
### kozt 2.34 pontnyi kulonbseg volt (95% CI 1.398821, Inf).

# 6. Teszteld a 4. hipotezist, hogy "A reziliancia es a kutatas vegen mert szorongasszint negativ osszefuggest fog mutatni (vagyis aki reziliensebb, annal alacsonyabb szorongasszintet fognak merni a kutatas vegen)" (**anxiety** vs. **resilience**)	

# - Eloszor vegezzunk egy feltaro elemzest a korrelacios egyutthato meghatarozasaval es egy pontdiagrammal a ket valtozo kapcsolatarol.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


data %>% 
  ggplot() +
  aes(x = resilience, y = anxiety) +
  geom_boxplot()

data %>% 
  select(resilience, anxiety) %>% 
  cor()

cor.test(data$resilience, data$anxiety, alternative = "less")

### A reziliencia es a szorongas szignifikans negative egyuttjarast mutat (r = -0.50, df = 78, p < 0.001).
### A korrelacio merteke -0.50 (95% CI -1, -0.37) volt. 

