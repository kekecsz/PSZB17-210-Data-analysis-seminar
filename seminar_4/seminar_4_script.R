
# # 4. Ora - Adatexploracio	

# Az ora celja az adatexploracios modszerek elsajatitasa.	

# ## Package-ek betoltese	

# A kovetkező package-ekre lesz szuksegunk	


if (!require("gridExtra")) install.packages("gridExtra")	
library(gridExtra) # for grid.arrange	
if (!require("psych")) install.packages("psych")	
library(psych) # for describe	
if (!require("tidyverse")) install.packages("tidyverse")	
library(tidyverse) # for dplyr and ggplot2	
	
	


# ## Adatok betoltese	

# Beolvassuk az orai kerdoiv adatait a read_csv funkcioval, es elmentjuk egy orai_adat nevu objektumba. A read_csv() funkcio a tidyverse resze, es egybol tibble formatumban menti el az adatainkat	


orai_adat <- read_csv("https://tinyurl.com/statgyak2019-seminar-4-data")	
	


# ## Adatok attekintese	

# Mindig erdemes azzal kezdeni, hogy **megismerkedunk az adat** szerkezetevel es tartalmaval.	

# A **tibble objektum** meghivasaval kapthatunk nemi informaciot az adattabla szerkezeterol. Lathatjuk hany sor es hany oszlop van az adattablaban, es lathatjuk milyen class-ba tartoznak (chr, dbl ...)	


orai_adat	


# Ha az egyes valtozok **leirostatisztikaira** (descriptive statistics) vagyunk kivancsiak, kerhetjuk ezt a mar tanult modon.	

# Peldaul lekerhetjuk a valtozo alapveto legalacsonyabb es legmagasabb erteket, atlagat, medianjat, a kvartiliseket, es hogy hany hianyzo adat van (ha van) a **summary()** funkcioval (miutan a select funkcioval kivalasztottuk, melyik valtozora vagyunk kivancsiak)	


orai_adat %>% 	
  select(jegy_tipp) %>% 	
  summary()	


# Vagy megkapthatjuk ugyanezt az osszes valtozora, ha ugyanezt az egesz adattablara futtatjuk le. Persze a karakter osztalyba tartozo valtozoknal mindezeknek a leiro statisztikaknak nincs ertelme, ott csak a class informaciot kaptjuk az output-ban.	


orai_adat %>% 	
  summary()	


# *______________________________* 	

# ### Gyakorlas	

# - Hany orat gyakorolt az az ember, aki a legtobb orat gyakorolta a masodik es a harmadik ora kozott (*stat_gyakorlas_3* valtozo)?	
# - Mekkora volt az atlagos energiaszint az elso es mekkora a harmadik oran (*energiaszint_1* es *energiaszint_3* valtozok)? 	

# *______________________________*	



# ## Megtobb leiro statisztika	

# A **Psych** package segitsegevel a **describe()** funkcio megtobb hasznos informaciot adhat	


describe(orai_adat)	



# *______________________________* 	

# ### Gyakorlas	

# - Mi a statisztika gyakorlas ferdesegi mutatoja (skew/skewness) (*stat_gyakorlas_3* valtozo)?	
# - Hanyan valaszoltak az energia szint kerdesre az elso es a harmadik oran (*energiaszint_1* es *energiaszint_3* valtozok)? 	

# *______________________________*	



# ## Faktorok	

# Nehany karaktervaltozonak csak **korlatozott mennyisegu eleme** lehet, mint peldaul a nem (ferfi, no, egyeb), vagy az eletkor (0-22 vagy 23+) a mi kerdoivunkben. Ezeket megjelolhetjuk faktor (factor) osztalyu valtozokent, es akkor az R tobb informaciot fog adni rola.	

# A **levels()** funkcio megmutatja mik a faktorunk szintjei, de lathato ez akkor is ha csak meghivjuk a valtozot magat.	

# A **table()** funkcio pedig tablazatot keszit arrol, hogy az egyes csoportokban hany megfigyeles talalhato	


orai_adat <- orai_adat %>% 	
              mutate(nem = factor(nem), 	
                     eletkor = factor(eletkor),	
                     memoriateszt_hely = factor(memoriateszt_hely))	
	
levels(orai_adat$nem)	
	
orai_adat$nem	
	
table(orai_adat$eletkor)	
table(orai_adat$nem)	
	




# Igy mar a fenti **summary()** funkcio is kiadja az **egyes faktorszintekrol** (no, ferfi) hogy hanyan tartoznak oda.	


orai_adat %>%	
  select(nem) %>% 	
  summary()	



# Van, hogy szeretnenk **kizarni** bizonyos **faktorszinteket** az elemzesbol. Pl. ha valamelyik faktor szintbol nagyon keves megfigyeles van, mondjuk 23 even feluli eletkoruakbol, oket lehet hogy szeretnenk kizarni a kesobbi elemzesekbol hogy egyszerusitsuk az eredmenyeink ertelmezeset. Ezt a mar korabban tanult **filter()** funkcio segitsegevel konnyeden megtehetjuk, azonban arra figyelnunk kell, hogy az R megjegyzi a faktorszinteket, es azt azt kovetoen is a **valtozohoz rendelve tartja**, miutan mar az adott faktorszintbol nincs egy megifgyeles sem az adattablaban. 	


orai_adat %>%	
  filter(eletkor != "23+") %>% 	
  select(eletkor) %>% 	
  summary()	


# Igy ezeket a szinteket ejteni szoktuk a **droplevels()** funkcioval.	


orai_adat %>%	
  filter(eletkor != "23+") %>% 	
  select(eletkor) %>% 	
  droplevels() %>% 	
  summary()	


# Elofordul, hogy egy **numerikus valtozot akarunk atalakitani faktorra**, pl. elkepzelheto hogy ossze akarjuk hasonlitani azokat akik 6 vagy kevesebb orat alszanak altalaban azokkal akik 7 vagy 8, vagy meg tobb orat alszanak. 	


orai_adat %>%	
  ggplot() +	
  aes(x = alvas_altalaban_1) +	
  geom_bar() +	
  geom_vline(xintercept = c(6.5, 8.5), linetype="dashed", 	
                color = "red", size=1.5)	
	


# Ilyenkor hasznalhatjuk a **mutate()** es **recode()** funkciok kombinaciojat hogy csinaljunk egy uj valtozot. 	
# Ebbe a kodba beleepitettem a **factor()** funkciot is, hogy azonnal meghatarozzuk, hogy ez az uj valtozo egy faktor, es nem egy egyszeru karaktervektor. A factor() funkcio nelkul is lefut a kod, de akkor meg kellene egy kulon sor ahol megadjuk hogy ez egy faktorvaltozo.	


orai_adat = orai_adat %>%	
  mutate(alvas_altalaban_kat_1 = factor(	
                                        recode(	
                                          alvas_altalaban_1,	
                                          "5" = "keves",	
                                          "6" = "keves",	
                                          "7" = "eleg",	
                                          "8" = "eleg",	
                                          "9" = "sok"	
                                          )	
                                        ))	
	
	
levels(orai_adat$alvas_altalaban_kat_1)	
	


# ### Faktorszintek sorrendje, ordinalis valtozok	

# Amikor van ertelme a **sorrendisegnek** a faktorszintek kozott, **ordinalis valtozokrol** beszelunk (vagyis az egyik faktorszint alacsonyabb, vagy kisebb "erteku" mint a masik). Arra figyelnunk kell, hogy amikor faktorokat hozunk letre, az R automatikusan a faktorszintek neveinek **ABC sorrendje** alapjan rakja oket sorba, es az abrakon is igy szemlelteti majd oket.	


orai_adat %>%	
  ggplot() +	
  aes(x = alvas_altalaban_kat_1) +	
  geom_bar()	
	


# Ilyenkor erdemes meghatarozni a faktorszintek sorrendjet (**order**). Ezt legegyszerubben a factor() funkcion belul tehetjuk meg, az **ordered = T** beallitasaval, es a **levels =** resznel a szintek sorrendjenek meghatarozasaval.	


orai_adat = orai_adat %>%	
mutate(alvas_altalaban_kat_1 = factor(alvas_altalaban_kat_1, ordered = T, levels = c(	
                                          "keves",	
                                           "eleg",	
                                           "sok")))	
	


# Igy mar az R minden funkcioja tudni fogja, hogy egy ordinalis valtozorol van szo, ahol fontos a sorrend, es tudni fogja a sorrendet is.	


orai_adat %>%	
  ggplot() +	
  aes(x = alvas_altalaban_kat_1) +	
  geom_bar()	




# *______________________________* 	

# ### Gyakorlas	

# - Csinalj egy kategorikus valtozot az elso orai hangulat alapjan (*hangulat_1* valotozo) ugy, hogy harom csoport alakuljon ki: 0-3 - rossz, 4-6 - kozepes, 7-10 - jo. (Emlekeztetoul: ezt a mutate() es a recode() funkciokkal tudod peldaul elerni.) Ezt az uj valtozot nevezd el *hangulat_kat_1* -nek, es az ezt az uj valtozot is tartalmazo adattablat mentsd el *orai_adat_harmashangulat_1* neven.	


# - Fontos, hogy a *hangulat_kat_1* valtozot faktor valotozokent jelold meg. (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)	


# - Keszits egy tablazatot arrol, hogy hanyan esnek a *hangulat_kat_1* egyes kategoriaiba.	


# - Add meg a faktorszintek helyes sorrendjet: rossz, kozepes, jo (Ird felul a *hangulat_kat_1* korabbi valtozatat ezzel a valtozattal ahol a szintek mar helyes sorrendben vannak)	


# - Nezd meg a faktor szintjeit, hogy valoban helyes sorrendben szerepelnek-e	


# *______________________________*	





# ## Exploracio vizualizacion keresztul	

# ### Egyes valtozok vizualizacioja	

# Az egyes valtozok **abrak** (plot) segitsegevel is megvizsgalhatok.	
# A **kategorikus** valtozokat gyakran oszlopdiagrammal (**geom_bar**) abrazoljuk, 	

# Mig a **numerikus** valtozokat inkabb **dotplot** , **histogram**, vagy **density plot** segitsegevel szoktuk abrazolni.	

# Az egyes valtozok vizualizacioja es a leiro statisztikak atvizsgalasa elengedhetetlen hogy azonositsuk az esetleges adatbeviteli **hibakat es egyeb nemvart furcsasagokat** az adataink kozott.	

# **MINDING** ellenorizd az adataidat ezekkel a modszerekkel mielott komolyabb adatelemzesbe kezdesz, hogy meggyozodj rola, hogy az adatok tisztak es megfelenek az elvarasaidnak.	



orai_adat %>%	
ggplot() +	
  aes(x = memoriateszt_hely) +	
  geom_bar()	
	
	
orai_adat %>%	
ggplot() +	
  aes(x = cipomeret) +	
  geom_dotplot()	
	
orai_adat %>%	
ggplot() +	
  aes(x = cipomeret) +	
  geom_histogram()	
	
	
orai_adat %>%	
ggplot() +	
  aes(x = cipomeret) +	
  geom_density()	
	


# *______________________________* 	

# ### Gyakorlas	

# Hasznald a fent tanult modszereket, hogy **azonositsd az orai_adat adattablaban levo hibakat** vagy nem vart furcsasagokat.	

# - A vizualizacion tul a View(), describe(), es summary() funciokat erdemes hasznalni az adatok elso attekintesere 	
# - A numerikus (vagy eppen folytonos) valtozoknal vizsgald meg a minimum es maximum erteket es a hianyzo adatok mennyiseget, valamint az eloszlast.	
# - A kategorikus valtozoknal vizsgald meg az osszes faktorszintet es az egyes szintekhez tartozo megfigyelesek mennyiseget.	

# *______________________________*	



	
	


# ### A hibakat a kovetkezokeppen javithatjuk.	

# A **mutate()** es a **replace()** funkciok hasznalataval **cserelhetunk ki** ertekeket mas ertekekre. Azt, hogy ilyenkor hianyzo adatra (NA), vagy egy masik, valoszinu ertekre kell megvaltoztatni az erteket, a szituaciotol fogg. Altalaban a biztosabb megoldas ha hianyzo adatnak jeloljuk a kerdeses erteket (NA), de ez sok adatveszteshez vezethet. Ha eleg valoszinu hogy mi a helyes valasz, beirhatjuk, DE **minden javitast fel kell tuntetni** a kutatasi jelentesben (es a ZH soran is), hogy az olvaso szamara tiszta legyen, hogy itt egy adathelyettesites vagy kizaras tortent!	

# Mindig erdemes a javitott adatokat **uj adattablaba** elmenteni. A mi esetunkben az orai_adat_corrected nevet adtuk a javitott objektumnak. Igy a nyers adataink megmaradnak, ami hasznos lehet kesobbi muveleteknel.	



	
orai_adat_corrected <- orai_adat %>%	
  mutate(szocmedia_3 = replace(szocmedia_3,  szocmedia_3=="youtube", NA))	
	
orai_adat_corrected = orai_adat_corrected %>%	
  mutate(magassag = replace(magassag,  magassag == 1.82, 182))	
	
orai_adat_corrected = orai_adat_corrected %>%	
  mutate(cipomeret = replace(cipomeret, cipomeret == 47, 37))	
	


# Erdemes **megbizonyosodni rola**, hogy az adatcsere sikeres volt. Alabb az adatok vizualizaciojaval gyozodunk meg errol, de az adatok megjelenitesevel, vagy a leiro statisztikak lekerdezesevel is megteheto ez, ha az informativ.	


# hasznalhatnak meg az alabbiakat is arra, 	
# hogy megbizonyosodjunk abban, hogy sikeres volt a csere	
# View(orai_adat_corrected)	
# describe(orai_adat_corrected)	
# summary(orai_adat_corrected$szocmedia_3)	
# orai_adat_corrected$szocmedia_3	
	
old_plot_szocmedia_3 <-	
  orai_adat %>% 	
  ggplot()+	
    aes(x = szocmedia_3)+	
    geom_bar()	
	
new_plot_szocmedia_3 <-	
  orai_adat_corrected %>% 	
  ggplot()+	
    aes(x = szocmedia_3)+	
    geom_bar()	
	
grid.arrange(old_plot_szocmedia_3, new_plot_szocmedia_3, ncol=2)	
	
old_plot_magassag <-	
  orai_adat %>% 	
  ggplot()+	
    aes(x = magassag)+	
    geom_histogram()	
	
new_plot_magassag <-	
  orai_adat_corrected %>% 	
  ggplot()+	
    aes(x = magassag)+	
    geom_histogram()	
	
	
grid.arrange(old_plot_magassag, new_plot_magassag, ncol=2)	
	
	
old_plot_cipomeret <-	
  orai_adat %>%	
  filter(magassag>2) %>% 	
  ggplot()+	
    aes(x = cipomeret, y = magassag)+	
    geom_point() +	
    geom_smooth()	
	
new_plot_cipomeret <-	
  orai_adat_corrected %>%	
  filter(magassag>2) %>% 	
  ggplot()+	
    aes(x = cipomeret, y = magassag)+	
    geom_point() +	
    geom_smooth()	
	
grid.arrange(old_plot_cipomeret, new_plot_cipomeret, ncol=2)	
	





# ## Tobb valtozo kapcsolatanak felterkepezese	


# Tobb valtozo kapcsolatat is felterkepezhetjuk tablazatok es abrak segitsegevel.	

# ### Ket kategorikus (csoportosito) valtozo kapcsolatanak felterkepezese	

# **Generaljunk kategorikus valtozokat**	

# Az elso oran jelentett **hangulat_1** valtozobol csinalunk egy kategorikus valtozot, az faktorszintek a kovetkezok lesznek: 0-3 - "rossz", 4-6 - "kozepes", 7-10 - "jo". Ezt ugyan abba az adattablaba hangulat_kat_1 neven mentjuk el sorrendezett faktorkent a fent tanultak alapjan. Mindehez a mutate(), recode(), es factor() funkciokat hasznaljuk.	


	
orai_adat_corrected %>% 	
  select(hangulat_1) %>% 	
  summary()	
	
orai_adat_corrected <- orai_adat_corrected %>% 	
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
  	
orai_adat_corrected %>% 	
  select(hangulat_kat_1) %>% 	
  summary	
	


# Hasonlokeppen kepzunk **szocmedia_1** valtozobol egy kategorikus valtozot, ahol azok akik 0 vagy 1 orat hasznaljak a szocialis mediat, a "nem rendszeres", azok akik 2 vagy tobb orat hasznaljak a szocialis mediat, a "nem rendszeres" kategoriaba (faktorszintre) esnek majd.	

# **Itt nem szukseges az ordered** = T es a levels = beallitasa, mert csak ket faktorszint van, es az ABC sorrend mar alapbol az intuitiv modon a "nem rendszeres" kategoriat teszi elsonek.	


table(orai_adat_corrected$szocmedia_1)	
	
orai_adat_corrected <- orai_adat_corrected %>% 	
  mutate(szocmedia_kat_1 = factor(recode(szocmedia_1,	
                                 "0" = "nem rendszeres",	
                                 "1" = "nem rendszeres",	
                                 "2" = "rendszeres",	
                                 "3" = "rendszeres",	
                                 "4" = "rendszeres",	
                                 "5" = "rendszeres",	
                                 "6" = "rendszeres"	
                                 )))	
  	
orai_adat_corrected %>% 	
  select(szocmedia_kat_1) %>% 	
  summary	
	
	



# Az elso oran kertunk egy tippet arrol, hogy az egyes emberek milyen jegyet fognak kapni a kurzus vegen az adatelemzes oran (**jegy_tipp** valtozo). Mivel itt szamban kertuk a valaszt, ez jelenleg egy numerikus valtozo, de csinaljunk most belole egy **kategorikus valtozot**, mert osszesen harom fajta tipp erkezett: 3 - "kozepes", 4 - "jo", 5 - "kivalo"	


table(orai_adat_corrected$jegy_tipp)	
	
orai_adat_corrected <- orai_adat_corrected %>% 	
  mutate(jegy_tipp_kat = factor(recode(jegy_tipp,	
                                 "3" = "kozepes (3)",	
                                 "4" = "jo (4)",	
                                 "5" = "kivalo (5)"	
                                 ), ordered = T, levels = c("kozepes (3)", "jo (4)", "kivalo (5)")))	
  	
orai_adat_corrected %>% 	
  select(jegy_tipp_kat) %>% 	
  summary()	
	
	



# **Feltaro elemzes**	

# Most vizsgaljuk meg azt, hogy az, hogy az emberek mennyit alszanak altalaban (**alvas_altalaban_kat_1**) hogyan fugg ossze azzal, hogy mennyit hasznaljak a szocialis mediat (**szocmedia_kat_1**).	


# A legegyszerubb modja ket csoportosito valtozo kapcsolatanak megvizsgalasara a ket valtozo **kereszt-tablazatanak (crosstab)** elkezsitese a **table()** funkcioval.	



	
table(orai_adat_corrected$alvas_altalaban_kat_1, orai_adat_corrected$szocmedia_kat_1)	
	
	



# Sokszor ennel sokkal **szemleletesebb az abrak** (plot) hasznalata.	

# Erre az egyik lehetoseg a **stacked bar chart** (egymasra tornyozott oszlopdiagram, a **geom_bar()** geomot hasznaljuk) hasznalata. Itt az egyik valtozo kategoriai adjak meg hany oszlop lesz (ez a valtozo lesz az x tengelyen reprezentalva, igy ezt az "x =" reszen adhatjuk meg), a masik valtozo az oszlopokat szinekkel szegmentalja, ezt pedig a "**fill =**" reszen adhatjuk meg. 	



	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = alvas_altalaban_kat_1, fill = szocmedia_kat_1) +	
  geom_bar()	
	


# Ha az egyes faktorszinteken nagyon **kulonbozo mennyisegu megfigyeles** van, ez a megjelenites neha felrevezeto kovetkeztetesekhez vezethet, igy neha hasznosabb ha az oszlopok nem szamossagot (count), hanem **reszaranyt (proportion)** jelolnek. Ha ezt szeretnenk, ahelyett hogy uresen hagynank a geom_bar() funkciot, a kovetkezot adjuk meg: **geom_bar(position = "fill")**.	


	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = alvas_altalaban_kat_1, fill = szocmedia_kat_1) +	
  geom_bar(position = "fill")	
	




# *______________________________* 	

# ### Gyakorlas	

# Hasznald a fent tanult modszereket, hogy megvizsgald a **jegy_tipp_kat** es a **hangulat_kat_1** valtozok kozotti osszefuggest.	
# - hasznalj **geom_bar()** geomot a megjeleniteshez	
# - probald meg mind a **szamossagot**, mind a **reszaranyt** kifejezo abrat megvizsgalni geom_bar(position = "fill")	
# - milyen **kovetkeztetest** tudsz levonni az abrakrol?	


# *______________________________*	



	
# az y tengelyen megvaltoztathatjuk a beosztast 	
# a scale_y_continuous(breaks = c(...))) funkcio hozzaadasaval	
# a masodik abran az y tengelynek megvaltoztatjuk a feliratat	
	
jegy_tipp_kat_hangulat_kat_plot_1 <-	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = jegy_tipp_kat, fill = hangulat_kat_1) +	
  geom_bar() +	
  scale_y_continuous(breaks = c(2, 4, 6, 8, 10, 12))	
	
jegy_tipp_kat_hangulat_kat_plot_2 <-	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = jegy_tipp_kat, fill = hangulat_kat_1) +	
  geom_bar(position = "fill") +	
  ylab("proportion")	
	
grid.arrange(jegy_tipp_kat_hangulat_kat_plot_1, jegy_tipp_kat_hangulat_kat_plot_2, nrow = 2)	
	



# Ennel a megjelenitesnel fontos hogy ha az egyes megfigyelesek **keves megfigyelesbol allnak**, az abra megteveszto lehet, mert az abra nem jelzi a megfigyelesek szamat es igy azt, hogy milyen biztosak lehetunk az eredmenyben. Ilyen esetekben az egyik kategoriat ki lehet venni az abrarol, vagy a **szamossagot es a reszaranyt abrazolo abrakat egymas mellet** lehet bemutatni, hogy igy kiegeszitsek egymast. Ehhez hasznalhatjuk a **grid.arrange()** funkciot.	



alvas_altalaban_szocmedia_plot_1 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = alvas_altalaban_kat_1, fill = szocmedia_kat_1) +	
  geom_bar()	
	
alvas_altalaban_szocmedia_plot_2 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = alvas_altalaban_kat_1, fill = szocmedia_kat_1) +	
  geom_bar(position = "fill")	
	
grid.arrange(alvas_altalaban_szocmedia_plot_1, alvas_altalaban_szocmedia_plot_2, nrow=2)	
	



# Az abra **interpretalhatosaga** attol fuggoen is **valtozhat**, hogy melyik valtozot tesszuk az x-tengelyre es melyiket szinkent abrazolva.	



	
	
alvas_altalaban_szocmedia_plot_3 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = szocmedia_kat_1, fill = alvas_altalaban_kat_1) +	
  geom_bar()	
  	
	
alvas_altalaban_szocmedia_plot_4 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = szocmedia_kat_1, fill = alvas_altalaban_kat_1) +	
  geom_bar(position = "fill") +	
  ylab("proportion")	
	
grid.arrange(alvas_altalaban_szocmedia_plot_3, alvas_altalaban_szocmedia_plot_4, ncol=2)	
	
	
	
# a theme(legend.position) es a guides() funciok 	
# hasznalataval kontrollalhatjuk hogy hol es hogyan 	
# jelenjen meg a jelmagyarazat az abran	
	
alvas_altalaban_szocmedia_plot_3 <- 	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = szocmedia_kat_1, fill = alvas_altalaban_kat_1) +	
    geom_bar() +	
    theme(legend.position="bottom") +	
    guides(fill = guide_legend(title.position = "bottom"))	
  	
	
alvas_altalaban_szocmedia_plot_4 <- 	
orai_adat_corrected %>%	
  ggplot() +	
  aes(x = szocmedia_kat_1, fill = alvas_altalaban_kat_1) +	
  geom_bar(position = "fill") +	
  theme(legend.position="bottom") +	
  guides(fill = guide_legend(title.position = "bottom")) +	
  ylab("proportion")	
	
grid.arrange(alvas_altalaban_szocmedia_plot_3, alvas_altalaban_szocmedia_plot_4, ncol=2)	
	



# Ujabb modja a barchart segitsegevel valo megjelenitesnek ha az oszlopok nem egymasra tornyozva, hanem **egymas mellett** jelennek meg, vagy ha a masodik valtozo szerint **kulon paneleken (facet)** jelennek meg.	


	
alvas_altalaban_szocmedia_plot_1 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = alvas_altalaban_kat_1, fill = szocmedia_kat_1) +	
  geom_bar(position = "dodge")	
	
alvas_altalaban_szocmedia_plot_2 <- 	
orai_adat_corrected %>%	
ggplot() +	
  aes(x = szocmedia_kat_1) +	
  geom_bar() +	
  facet_wrap(~ alvas_altalaban_kat_1)	
	
grid.arrange(alvas_altalaban_szocmedia_plot_1, alvas_altalaban_szocmedia_plot_2, nrow=2)	
	




# ### Egy kategorikus es egy numerikus valtozo kapcsolata	

# Vizsgaljuk meg a **magassag** osszefuggeset azzal, hogy ez emberek mit tippeltek, milyen jegyet fognak kapni az elso oran (**jegy_tipp**).	

# Ezt megtehetjuk az atlagok csoportonkenti attekintesevel a **group_by()** es a **summarize(mean())** segitsegevel. 	


orai_adat_corrected %>%	
  group_by(jegy_tipp_kat) %>% 	
    summarize(mean = mean(magassag))	
	
	



# A ket valtozo kapcsolatat megvizsgalhatjuk **abrakkal** is. Pl. hasznalhatjuk a 	

# - **facet_wrap()** fuggvenyt a egy **geom_histogram()** vagy **geom_dotplot()** -al kobinalva	
# - a **geom_boxplot()** -ot	
# - esetleg hasznalhatunk egy egymasra illesztett **geom_density()** plot-ot. 	
# - talan ebben az esetben a legtisztabb kepet a **geom_violin()** mutatja, ami a geom_boxplot() es a geom_density() keverekenek tekintheto. Ezt kiegeszithetunk egy **geom_point()** -al, hogy pontosan latsszon, hany megfigyelesen alapulnak az abra adatai.	

# Mindig erdemes **tobb megkozelitest** is hasznalni az adat-exploracio kozben, hogy minel reszletesebb kepet kaphassunk, es csokkentsuk a valoszinuseget hogy egyik vagy masik megkozelites hianyossagai felrevezetnek minket.	





	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = magassag) +	
    geom_histogram() +	
    facet_wrap(~ jegy_tipp_kat)	



	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = magassag) +	
    geom_dotplot(binwidth = 6) +	
    facet_wrap(~ jegy_tipp_kat)	
	



	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = jegy_tipp_kat, y = magassag) +	
    geom_boxplot()	
	



	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = magassag, fill = jegy_tipp_kat) +	
    geom_density(alpha = 0.3)	
	




	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = jegy_tipp_kat, y = magassag) +	
    geom_violin() +	
    geom_point()	




# A fenti abran latszik, hogy bar az atlagok a fenti tablazatban kulonboztek, a maguknak kivalo pontot josolok tobbsege 170 cm koruli, de van ket **kiurgo magassagu szemely**, aki az atlagot felhuzza ebben a csoportban.	


# Az is elkepzelheto hogy egy **nemi hatast** latunk az eredmenyekben, hiszen a ferfiak magasabbak, es elkepzelheto, hogy nagyobb az adatelemzessel kapcsolatos onbizalmuk is. Probaljuk meg a **ferfiakra es a nokre kulon elkesziteni az abrat**.	

# Itt mar **harom valtozo** kapcsolatat abrazoljuk, amihez a facet_grid() funkciot lehet hasznalni, vagy kulonbozo esztetikai elemeket (aes()) lehet a kulonbozo valtozokhoz rendelni.	




	
	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = magassag) +	
    geom_density() +	
    facet_grid(jegy_tipp_kat ~ nem)	
	
	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = magassag, fill = jegy_tipp_kat, size = nem, lty = nem) +	
    geom_density(alpha = 0.3)	
	
	



# Ha szeretnenk **kizarni az elemzesunkbol** ezeket az extrem ertekekt, a **filter()** funkcio beekelesevel a pipe-ba megepithetjuk a fenti abrankat es tablazatokat ugy, hogy csak a 185 cm-nel alacsonyabb emberekre fogkuszalunk.	

# Igy mar eltunik a korabbi atlagok kozotti kulonbseg.  	



	
orai_adat_corrected %>%	
  filter(magassag < 185) %>% 	
    ggplot() +	
      aes(x = jegy_tipp_kat, y = magassag) +	
      geom_violin() +	
      geom_point()	
	
orai_adat_corrected %>%	
  filter(magassag < 185) %>% 	
    group_by(jegy_tipp_kat) %>% 	
      summarize(mean = mean(magassag))	
	








# *______________________________* 	

# ### Gyakorlas	

# Hasznald a fent tanult modszereket, hogy megvizsgald a **jegy_tipp_kat** es a **hangulat_1** valtozok kozotti osszefuggest.	

# - hasznald a fenti geomokat, es keszits legalabb ket kulonbozo abrat mas-mas geomokkal	


# *______________________________*	



	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = hangulat_1) +	
    geom_dotplot(aes(fill = jegy_tipp_kat), position = "dodge")	
	
	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = hangulat_1, fill = jegy_tipp_kat) +	
    geom_density(alpha = 0.3)	
	
	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = jegy_tipp_kat, y = hangulat_1) +	
    geom_violin() +	
    geom_jitter(width = 0.2)	
	
  	



# ### Ket numerikus valtozo kapcsolata	

# **Ket numerikus valtozo** kozotti kapcsolat jellemzesere altalaban a korrelacios egyutthatot szoktuk hasznalni (cor()).	
# A **cor()** funkciot akar tobb mint ket valtozo paronkenti korrelaciojanak meghatarozasara is lehet hasznalni.	

# A **drop_na()** funkcioval kiejthetjuk azokat a megfigyeleseket, ahol a valtozok barmelyikeben hianyzo adat (NA) van. Ha ezt nem tesszuk meg, a cor() fuggveny NA eredmenyt adhna ha valamelyik valtozoban NA-val talalkozik.	



	
	
orai_adat_corrected %>%	
  select(c(alvas_tegnap_1, alvas_tegnap_3)) %>% 	
    drop_na() %>% 	
      cor()	
	
	
orai_adat_corrected %>%	
  select(c(alvas_altalaban_1, alvas_tegnap_1, alvas_tegnap_3)) %>% 	
    drop_na() %>% 
    cor()	
	



# A numerikus valtozok kozotti kapcsolatot altalaban pont diagrammal szoktuk abrazolni (**geom_point()**)	

# A **geom_smooth()** layer hozzaadasaval kaphatunk a pontok kozott meghuzodo trendrol egy kepet. A kek vonal az ugyevezett trandvonal, a szurke sav a konfidencia intervallum. Ezekrol kesobb meg reszletesebben beszelunk majd	



	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = alvas_tegnap_1, y = alvas_tegnap_3) +	
    geom_point()	
	
orai_adat_corrected %>%	
  ggplot() +	
    aes(x = alvas_tegnap_1, y = alvas_tegnap_3) +	
    geom_point() +	
    geom_smooth() 	


# *______________________________* 	

# ### Gyakorlas	

# Milyen eros a kapcsolat a magassag es a cipomeret kozott?	

# - hatarozd meg a korrelacios egyutthatot a *magassag* es *cipomeret* valtozok kozott	
# - abrazold a *magassag* es *cipomeret* valtozok kapcsolatat	


# *______________________________*	


# Tobb folytonos valtozo kapcsolata megjelenitheto peldaul ugy, hogy az egyik valtozot egy szinskalahoz rendeljuk az alabbi modon.	


plot_szines <- ggplot(data = mtcars, aes(x = wt, y = mpg, col = hp)) + 	
  geom_point() 	
plot_szines + 	
  scale_colour_gradientn(colours=c("green","black"))	



