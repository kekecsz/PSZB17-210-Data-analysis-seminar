#' ---	
#' title: "Seminar_4_homework_solution"	
#' author: "Zoltan Kekecs"	
#' date: "September 30, 2019"	
#' output: html_document	
#' ---	
#' 	
#' 	
#' 	
#' 	
#' - Toltsd be a szukseges package-eket. (Az alabbi feladatok megoldhatok a tidyverse es a psych package-ekkel)	
#' 	
#' 	
library(gridExtra) # for grid.arrange	
library(tidyverse) # for dplyr and ggplot2	
library(psych) # for describe	
	
#' 	
#' 	
#' - Olvasd be az adatokat errol az URL-rol (ez egy .csv file):	
#' 	
#' "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_4/Orai_kerdoives_adatok%20-%20ora_1_3.csv"	
#' 	
#' 	
orai_adat <- read_csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_4/Orai_kerdoives_adatok%20-%20ora_1_3.csv")	
	
#' 	
#' 	
#' - Vegezd el az adattisztitast a kovetkezo koddal:	
#' 	
#' 	
	
orai_adat_corrected = orai_adat %>%	
  mutate(szocmedia_3 = replace(szocmedia_3,  szocmedia_3=="youtube", NA))	
	
orai_adat_corrected = orai_adat_corrected %>%	
  mutate(magassag = replace(magassag,  magassag == 1.82, 182))	
	
orai_adat_corrected = orai_adat_corrected %>%	
  mutate(cipomeret = replace(cipomeret, cipomeret == 47, 37))	
	
#' 	
#' 	
#' - Hatarozd meg az elso orai hangulat atlagat (*hangulat_1* valotzo).	
#' 	
#' 	
orai_adat_corrected %>% 	
  summarize(mean = mean(hangulat_1))	
#' 	
#' 	
#' - Csinalj egy kategorikus valtozot az elso orai hangulat alapjan ugy, hogy harom csoport alakuljon ki: 0-3 - rossz, 4-6 - kozepes, 7-10 - jo. (Emlekeztetoum: ezt a mutate() es a recode() funkciokkal tudod peldaul elerni.) Ezt az uj valtozot nevezd el *hangulat_kat_1* -nek, es az ezt az uj valtozot is tartalmazo adattablat mentsd el *orai_adat_harmashangulat_1* neven.	
#' 	
#' 	
#' - Fontos, hogy a *hangulat_kat_1* valtozot faktor valotozokent jelold meg. (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)	
#' 	
#' - Add meg a faktorszintek helyes sorrendjet: rossz, kozepes, jo	
#' 	
#' 	
#' 	
#' 	
	
orai_adat_harmashangulat_1 <- orai_adat_corrected %>% 	
  mutate(hangulat_kat_1 = factor(recode(hangulat_1,	
                                 "0" = "rossz",	
                                 "1" = "rossz",	
                                 "2" = "rossz",	
                                 "3" = "rossz",	
                                 "4" = "kozepes",	
                                 "5" = "kozepes",	
                                 "6" = "kozepes",	
                                 "7" = "jo",	
                                 "8" = "jo",	
                                 "9" = "jo",	
                                 "10" = "jo"	
                                 ), ordered = T, levels = c("rossz", "kozepes", "jo")))	
	
#' 	
#' 	
#' - Keszits egy tablazatot arrol, hogy hanyan esnek a *hangulat_kat_1* egyes kategoriaiba. Ebben a tablazatban ellenorizd hogy a faktor szintjei valoban helyes sorrendben szerepelnek-e. 	
#' 	
#' 	
	
orai_adat_harmashangulat_1 %>% 	
  select(hangulat_kat_1) %>% 	
  table()	
	
	
#' 	
#' 	
#' - Keszits egy ujabb adat objektumot, amiben nincsenek benne a "rossz" hangulatuak (mondjuk a filter() segitsegevel), mondjuk legyen a neve *orai_adat_ketteshangulat_1*. Ezutan keszits egy tablazatot arrol, hogy az egyes faktorszintekre a *hangulat_kat_1* valtozon belul hany megfigyeles esik.	
#' 	
#' 	
#' 	
	
orai_adat_ketteshangulat_1 <- orai_adat_harmashangulat_1 %>% 	
  filter(hangulat_kat_1 != "rossz")	
	
orai_adat_ketteshangulat_1 %>%	
  select(hangulat_kat_1) %>% 	
  table()	
 	
	
#' 	
#' 	
#' 	
#' - Ejtsd a nem hasznalt faktorszinteket (a droplevels() funkcioval). Ird felul a *orai_adat_ketteshangulat_1*  objektumon belul a *hangulat_kat_1* korabbi valtozatat ezzel az modositott valatozoval, ahol mar nincsenek meg a felesleges szintek. Ehhez a mutate() funkcion belul kell a droplevels() funkciot hasznalni. Amint ez kesz van, keszits egy tablazatot arrol, hogy az egyes faktorszintekre a *hangulat_kat_1* valtozon belul hany megfigyeles esik, igy ellenorizd hogy eltunt a "rossz" faktorszint.	
#' 	
#' 	
#' 	
	
orai_adat_ketteshangulat_1 = orai_adat_ketteshangulat_1 %>%	
  mutate(hangulat_kat_1 = droplevels(hangulat_kat_1))	
	
orai_adat_ketteshangulat_1 %>% 	
  select(hangulat_kat_1) %>% 	
    table()	
	
#' 	
#' 	
#' - Terjunk vissza a *orai_adat_harmashangulat_1* objektum hasznalatahoz (amiben a rossz hangulatuak is benne vannak). Most a *hangulat_kat_1* valtozo es a *valasztott_szam* valtozo kapcsolatat vizsgaljuk majd. Eloszor is jelenitsd meg hogy a *hangulat_kat_1* egyes kategoriaiban (roszz, kozepes jo) mekkora az emberek altal valasztott szamok atlaga (*valasztott_szam* valtozo).	
#' 	
#' 	
#' 	
	
orai_adat_harmashangulat_1 %>% 	
  group_by(hangulat_kat_1) %>% 	
    summarize(mean = mean(valasztott_szam))	
	
	
#' 	
#' 	
#' - Ez utan abrazold a hangulat *hangulat_kat_1* es a *valasztott_szam* valtozok kapcsolatat abrakon. Rajzolj legalabb ket abrat amin mas geomokat hasznalsz.	
#' 	
#' 	
#' 	
	
fig_1 <- orai_adat_harmashangulat_1 %>% 	
ggplot() +	
  aes(x = hangulat_kat_1, y = valasztott_szam) + 	
  geom_boxplot()	
fig_1	
	
fig_2 <- orai_adat_harmashangulat_1 %>% 	
ggplot() +	
  aes(x = valasztott_szam, fill = hangulat_kat_1) + 	
  geom_density(alpha = 0.3)	
	
fig_3 <- orai_adat_harmashangulat_1 %>% 	
ggplot() +	
  aes(x = valasztott_szam, fill = hangulat_kat_1) + 	
  geom_dotplot(position = "dodge", binwidth = 0.5) +	
  scale_x_continuous(breaks = c(2, 4, 6, 8, 10))	
	
grid.arrange(fig_2, fig_3)	
	
fig_4 <- orai_adat_harmashangulat_1 %>% 	
ggplot() +	
  aes(x = valasztott_szam) + 	
  geom_histogram() +	
  facet_wrap(~ hangulat_kat_1)	
fig_4	
	
#' 	
#' 	
#' - A fenti atlagok es tablazat alapjan milyen kovetkeztetest vonsz le a hangulat es a valasztott szam osszefuggeserol? Ird le roviden egy kommentben.	
#' 	
#' ### ugy tunik hogy a jobb hangulat magasabb valasztott szammal jar egyutt, de a rossz hangulatuak kozott nagyon keves a megfigyeles, ezert az adatokat ovatosan kell ertelmezni.	
#' 	
#' 	
#' - Hatarozd mega korrelacios egyutthatot az elso orai es a harmadik orai hangulat kozott (*hangulat_1* es *hangulat_3* valtozok).	
#' 	
#' 	
#' 	
	
orai_adat_harmashangulat_1 %>%	
  select(c(hangulat_1, hangulat_3)) %>% 	
  drop_na() %>% 	
    cor()	
	
#' 	
#' 	
#' 	
#' - Abrazold a *hangulat_1* es *hangulat_3* valtozok kozotti kapcsolatot egy pontdiagrammal. Illessz egy trendvonalat is az abrara. 	
#' 	
#' 	
	
fig_5 <- orai_adat_harmashangulat_1 %>% 	
ggplot() +	
  aes(x = hangulat_1, y = hangulat_3) + 	
  geom_point() +	
  geom_smooth(method = "lm")	
fig_5	
#' 	
#' 	
#' - A korrelacios egyutthato es az abra alapjan milyen a kapcsolat a *hangulat_1* es *hangulat_3* valtozok kozott? Ird le roviden egy comment-ben.	
#' 	
#' ### Akik magas hangulaterteket irtak az elso oran, azok altalaban a harmadik oran is magas hangulaterteket irtak. Akik az elso oran kozepes hangulatot jeleztek, azok kozott tobben is alacsony hangulatot jeleztek a harmadik oran. Elkepzelheto egy nem-linearis osszefugges. De nagyon keves a megfigyeles.	
#' 	
