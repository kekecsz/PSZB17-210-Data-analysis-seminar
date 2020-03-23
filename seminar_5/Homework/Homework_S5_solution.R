# toltsd be a hazi feladat megoldasahoz hasznalt package-eket 
# (az alabbi feladatok a tidyverse es a psych packagekkel megoldhatoak)

library(tidyverse) # for dplyr and ggplot2	
library(psych) # for dplyr and ggplot2	

# toltsd be az adatot errol az URL-rol (ez egy .csv file) a mar korabban megismert adatbeolvaso funkcioval:
#"https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/Homework/homework_data.csv"
#
# Az adatok szimulalt adatok, de kepzeljuk el hogy egy randomizalt 
# kontrollalt klinikai kutatas eredmenyeibol szarmaznak, ahol a 
# pszichoterapia hatekonysagat teszteltek. Olyan szemelyeket vontak 
# be a kutatasba, akik egy hurrikan aldozatai voltak, es szorongassal 
# kuszkodtek. A szemelyeknel felmertek a reziliancia szintjet, majd 
# veletlenszeruen osztottak a szemelyeket egy kezelesi vagy egy 
# kontrol csoportba. Ezt kovetoen a kezelesi csoport pszichoterapiat 
# kapott 6 heten keresztul heti egyszer, mig a kontrol csoport nem 
# kapott kezelest. A vizsgalat vegen megmertek a szemelyek 
# szorongasszintjet, es a klinikai kriteriumok alapjan meghataroztak,
# hogy a szemely gyogyulnak, vagy szorongonak szamit-e.	
#
# Lathatjuk, hogy 10 valtozo van az adattablaban. 	
#
# - participant_ID - reszvevo azonositoja	
# - gender - nem
# - group - csoporttagsag, ez egy faktor valtozo aminek ket szintje van: "treatment" (kezelt csoport), es "control" (kontrol csoport). A "treatment" csoport kapott kezelest, mig a "control" csoport nem kapott kezelest.	
# - resilience - reziliancia: a nehezsegekkel valo megkuzdes kepessege, ez egy szemlyes kepesseg, olyasmi mint a szemelyisegvonasok	
# - anxiety - szorongas szint	
# - health_status - a klinikai kriteriumok alapjan szorongonak vagy gyogyultnak tekintheto a szemely 	
# - home_ownership - lakhatasi helyzet: harom szintje van az alapjan hogy a szemely hol lakik: "friend" - baratnal vagy csaladnal lakik, "own" - sajat tulajdonu lakasban lakik, "rent" - berelt lakasban lakik, 
# - height - magassag
# - has_children - egy kategorikus valtozo ami arrol informal minket hogy a szemelynek-e gyermekei (has_children) vagy nincsenek (no_children) 
# - left_before_hurricane - egy numerikus valtozo ami azt mutatja meg, hany nappal a hurrikan elott hagyta el az otthonat a szemely (0, 1, 2, vagy 3)

data <- read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/Homework/homework_data.csv")
data

# jelold faktorkent azokat a valtozokat, amiket faktor valtozonak itelsz

data = data %>% 
  mutate(gender = factor(gender),
         group = factor(group),
         health_status = factor(health_status),
         home_ownership = factor(home_ownership),
         has_children = factor(has_children))

# Vegezz az adatokon alapveto adatellenorzo muveleteket (mondjuk a summary, es describe fuggvenyekkel, es abrakkal, ha szukseges)
# Ellenorizd hogy vannake-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket. (Egyes adatpontok atjavitasara peldat a nagyedik orai script-ben es hazi feladatban talalsz)
# Van olyan, hogy egy numerikus valtozot karaktervektorkent eszlel az R, ha van benne akar egy szoveges ertek is. Ilyenkor a szoveges ertek szamra vagy NA-ra cserelese utan is karaktervektor marad a valtozo. Ebben az esetben a hiba javitasa utan erdemes az adott valtozot az as.numeric() fugvennyel numerikus valtozokent megjelolni.
# Erdemes ellenorizni, hogy sikerult-e minden adatot helyesen javitani azzal, hogy ujra lefuttatjuk az adatellenorzo muveleteket.

data %>% 
  summary()

table(data$height)
table(data$home_ownership)

data_corrected = data %>% 
  mutate(height = as.numeric(replace(height,  height == "about 190", 190)),
         home_ownership = droplevels(replace(home_ownership,  home_ownership == "won", "own")))

data_corrected %>% 
  summary()

# Teszteld a kovetkezo hipoteziseket: 
# Minden egyes hipotezis eseten eloszor vegezz leiro elemzest a megfelfelo tablazatokkal es abrakkal.
# Az elemzes elvegzese utan roviden ird le hogy hogyan ertelmezhetjuk az eredmenyeket.
# Az egyes statisztikai tesztek eredmenyenek leirasahoz hasznald az irai jegyzet pdf. valtozatat:
# https://osf.io/4tvd2/

# Hipotezis 1. Azok, akiknek van gyermeke (**has_children**), atlagosan magasabb szorongassal
# jellemezhetoek, mint azok akiknek nincs gyermeke

## feltaro
data_corrected %>% 
  group_by(has_children) %>% 
  summarize(mean = mean(anxiety), sd = sd(anxiety))

data_corrected %>% 
  ggplot() +
    aes(x = has_children, y = anxiety) +
    geom_violin() +
    geom_jitter()

## hipotezeistesztelo elemzes
t.test(anxiety ~ has_children, data = data_corrected, alternative = "greater" )

mean_difference = 10.90375 - 10.07366 
mean_difference

## ertelmezes

# Nem talaltunk arra bizonyitekot, hogy azok, akiknek van gyermeke magasabb szorongassal rendelkezne (10.90, sd = 2.88) mint azok akinek nincs gyermeke (10.07, sd = 3.68) (t = 1.13, df = 77.99, p = 0.131). Az atlagok kozotti kulonbseg 0.83 (95% CI = -0.39, inf) volt.


# Hipotezis 2. A vizsgalati szemelyek tobb mint 50%-a gyogyultnak mondhato a kutatas vegere (**health_status**)

## feltaro

data_corrected %>% 
  select(health_status) %>% 
  summary()
  
percentage_cured = 45/(35 + 45)
percentage_cured

## hipotezis teszt
binom.test(x = 45, n = 35 + 45, alternative = "greater")

## ertelmezes

# Nem talaltunk bizonyitekot arra, hogy a vizsgalati szemelyek tobb mint 50%-a gyogyultnak mondhato lenne (p = 0.157). 
# A 80 vizsgalati szemelyek kozul 45 (56%) volt gyogyult.


# Hipotezis 3. Van kapcsolat a lakhatasi helyzet (**home_ownership**) es a kozott 
# hogy a szemelynek van-e gyermeke (**has_children**)



table_home_ownership_has_children = table(data_corrected$home_ownership, data_corrected$has_children)
table_home_ownership_has_children


data_corrected %>% 
  ggplot() +
  aes(x = has_children, fill = home_ownership) +
  geom_bar(position = "dodge")

data_corrected %>% 
  ggplot() +
  aes(x = has_children, fill = home_ownership) +
  geom_bar(position = "fill")

## hipotezis teszt

chisq.test(table_home_ownership_has_children)

## ertelmezes

# Szignifikans osszefuggest talaltunk a lakhatasi helyzet es a kozott hogy a szemelynek van-e gyermeke (X^2 = 20.92, df = 2, p < 0.001).
# Akinek van gyermeke, inkabb sajat ingatlanban lakott, mig akinek nem volt gyermeke, nagyobb aranyban laktak egy baratnal vagy a csaladjuk ingatlanjaban. Az alabbi tablazatban lathatok a reszletek:
table_home_ownership_has_children

# Hipotezis 4. Azok, akiknek a hurrikan napjan hagytak el az otthonukat 
# (vagyis akiknel a **left_before_hurricane** erteke 0), atlagosan 
# szorongobbak a kutatas vegen, mint akik hamarabb hagytak el az 
# otthonukat (vagyis akiknel a **left_before_hurricane** erteke 1, 2, vagy 3) 
# (Ennek a hipotezisnek a helyes tesztelesehez elkepzelheto hogy csinalnod kell 
# egy uj valtozot a left_before_hurricane valtozobol)

## recode

data_corrected = data_corrected %>% 
  mutate(left_onthedayof_hurricane = recode(left_before_hurricane,
                                            "0" = "hurrikan_napjan",
                                            "1" = "nem_a_hurrikan_napjan",
                                            "2" = "nem_a_hurrikan_napjan", 
                                            "3" = "nem_a_hurrikan_napjan"))
## feltaro

data_corrected %>% 
  group_by(left_onthedayof_hurricane) %>% 
  summarize(mean = mean(anxiety), sd = sd(anxiety))

data_corrected %>% 
  ggplot() +
  aes(x = left_onthedayof_hurricane, y = anxiety) +
  geom_violin() +
  geom_jitter()


## hipotezis teszteles

t.test(anxiety ~ left_onthedayof_hurricane, data = data_corrected, alternative = "greater")

mean_difference = 12.697042 - 8.587553 
mean_difference
## Ertelmezes

# Azok, akik a hurrikan napjan hagytak el otthonukat, szignifikansan szorongobbak voltak (12.70(2.79)), mint azok, akik korabban hagytak el otthonukat (8.59(2.58)) (t = 6.78, df = 72.29, p < 0.01). Az atlagok kozotti elteres a ket csoportban 4.11 (95% CI = 3.10, Inf) szorongaspont volt.
