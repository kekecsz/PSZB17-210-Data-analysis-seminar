
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

# Beolvassuk a WHO altal 2020.09.28-an feltoltott COVID-19 adatokat a read_csv() funkcioval, es elmentjuk egy COVID_adat nevu objektumba. A **read_csv()** funkcio a tidyverse resze, es egybol tibble formatumban menti el az adatainkat.	


COVID_adat <- read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")	
	


# ## Adatok attekintese	

# Mindig erdemes azzal kezdeni, hogy **megismerkedunk az adat** szerkezetevel es tartalmaval.	

# A **tibble objektum** meghivasaval kapthatunk nemi informaciot az adattabla szerkezeterol. Lathatjuk hany sor es hany oszlop van az adattablaban, es lathatjuk milyen class-ba tartoznak (chr, dbl ...)	


COVID_adat	


# ## Leiro statisztikak	

# Ha az egyes valtozok **leiro statisztikaira** (descriptive statistics) vagyunk kivancsiak, kerhetjuk ezt a mar tanult modon.	

# Peldaul lekerhetjuk a valtozo alapveto legalacsonyabb es legmagasabb erteket, atlagat, medianjat, a kvartiliseket, es hogy hany hianyzo adat van (ha van) a **summary()** funkcioval (miutan a select funkcioval kivalasztottuk, melyik valtozora vagyunk kivancsiak)	


COVID_adat %>% 	
  select(total_cases) %>% 	
  summary()	


# Vagy megkapthatjuk ugyanezt az osszes valtozora, ha ugyanezt az egesz adattablara futtatjuk le. Persze a karakter osztalyba tartozo valtozoknal mindezeknek a leiro statisztikaknak nincs ertelme, ott csak a class informaciot kaptjuk az output-ban.	


COVID_adat %>% 	
  summary()	


# *______________________________* 	

# ### Gyakorlas	

# - Hany regisztralt eset volt osszesen Magyarorszagon a tegnapi napig (*total_cases*)?	
# - Mi volt a legmagasabb uj eset-szam Magyarorszagon (*new_cases*)?	

# *______________________________*	



# ## Megtobb leiro statisztika	

# A **Psych** package segitsegevel a **describe()** funkcio megtobb hasznos informaciot adhat.	
# Ez a funkcio elsosorban szam-valtozok leirasara szolgal, es karakter tipusu kategorikus valtozok eseten sok warning message-et ad, ezert erdemes a funciot csak a szam-valtozokra lefuttatni (ezt alabb a select() funkcioval erem el.)	


COVID_adat %>% 	
  select(-date, -iso_code, -continent, -location, -contains("tests"), -positive_rate) %>% 	
  describe()	



# *______________________________* 	

# ### Gyakorlas	

# - Mi az egy millio fore eso uj esetek (*new_cases_per_million*) ferdesegi mutatoja (skew/skewness)?	
# - Hany valid (nem NA) adat szerepel az adatbazisban az egy fore eso gdp-rol (*gdp_per_capita*)? 	

# *______________________________*	



# ## Faktorok	

# Nehany karaktervaltozonak csak **korlatozott mennyisegu eleme** lehet, mint peldaul a continent (North America, Asia, Africa, Europe, South America, Oceania). Ezeket megjelolhetjuk faktor (factor) osztalyu valtozokent, es akkor az R tobb informaciot fog adni rola.	

# A **levels()** funkcio megmutatja mik a faktorunk szintjei, de lathato ez akkor is ha csak meghivjuk a valtozot magat.	

# A **table()** funkcio pedig tablazatot keszit arrol, hogy az egyes csoportokban hany megfigyeles talalhato	

# Amikor kilistazzuk a faktor valtozot, akkor is kiirja az R a lista aljara, hogy milyen faktorszintek vannak. (Alabb csinalunk egy COVID_adat_tegnap valtozot, amivel csak a tegnapi adatokat nezzuk, hogy kisebb legyen az adattabla amivel dolgozunk.)	


COVID_adat <- COVID_adat %>% 	
              mutate(continent = factor(continent), 	
                     location = factor(location))	
	
levels(COVID_adat$continent)	
	
table(COVID_adat$continent)	
	
	
COVID_adat_tegnap = COVID_adat %>% 	
  filter(date == "2020-09-28")	
	
COVID_adat_tegnap$continent	
	


# Igy mar a fenti **summary()** funkcio is kiadja az **egyes faktorszintekrol** hogy hanyan tartoznak oda.	


COVID_adat_tegnap %>%	
  select(continent) %>% 	
  summary()	



# Van, hogy szeretnenk **kizarni** bizonyos **faktorszinteket** az elemzesbol. Pl. ha valamelyik faktor szintbol nagyon keves megfigyeles van, mondjuk Oceaniat, mondjuk mert ugy gondoljuk hogy az tulsagosan "elszigetelt" a vilag tobbi reszetol, oket lehet hogy szeretnenk kizarni a kesobbi elemzesekbol hogy egyszerusitsuk az eredmenyeink ertelmezeset. Ezt a mar korabban tanult **filter()** funkcio segitsegevel konnyeden megtehetjuk, azonban arra figyelnunk kell, hogy az R megjegyzi a faktorszinteket, es azt azt kovetoen is a **valtozohoz rendelve tartja**, miutan mar az adott faktorszintbol nincs egy megifgyeles sem az adattablaban. 	


COVID_adat_tegnap %>%	
  filter(continent != "Oceania") %>% 	
  select(total_cases, continent) %>% 	
  summary()	
	


# Igy ezeket a szinteket ejthetjuk a **droplevels()** funkcioval.	


COVID_adat_tegnap_noOceania = COVID_adat_tegnap %>%	
  filter(continent != "Oceania") %>% 	
  mutate(continent = droplevels(continent))	
	
	
	
COVID_adat_tegnap_noOceania %>% 	
  select(continent) %>% 	
  summary()	


# Elofordul, hogy egy **numerikus valtozot akarunk atalakitani faktorra**, pl. elkepzelheto hogy ossze akarjuk hasonlitani azokat az orszagokat ahol 5000 alatti a gdp_per_capita azokkal akinel e feletti, hogy hogyan kulonboznek a COVID adatok. 	



	
COVID_adat_tegnap %>%	
  select(gdp_per_capita, continent) %>% 	
  drop_na() %>% 	
  group_by(continent) %>% 	
  summarize(mean_gdp = mean(gdp_per_capita))	
	
	
COVID_adat_tegnap %>%	
  select(gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
  aes(x = gdp_per_capita) +	
  geom_density() + 	
  geom_vline(xintercept = 5000, linetype="dashed", 	
                color = "red", size=1.5)	
	


# ### Folytonos valtozok atkodolasa kategorikus valtozova	

# Ilyenkor hasznalhatjuk a **mutate()** es **case_when()** funkciok kombinaciojat hogy csinaljunk egy uj valtozot.	
# Ebbe a kodba beleepitettem a **factor()** funkciot is, hogy azonnal meghatarozzuk, hogy ez az uj valtozo egy faktor, es nem egy egyszeru karaktervektor. A factor() funkcio nelkul is lefut a kod, de akkor meg kellene egy kulon sor ahol megadjuk hogy ez egy faktorvaltozo.	



COVID_adat = COVID_adat %>%	
  mutate(gdp_per_capita_kat = factor(	
                                      case_when(gdp_per_capita < 5000 ~ "small",	
                                                gdp_per_capita >= 5000 & gdp_per_capita < 10000 ~ "medium",	
                                                gdp_per_capita > 10000 ~ "large")))	
levels(COVID_adat$gdp_per_capita_kat)	
	
# ugyanez a COVID_adat_tegnap -al	
	
COVID_adat_tegnap = COVID_adat_tegnap %>%	
  mutate(gdp_per_capita_kat = factor(	
                                      case_when(gdp_per_capita < 5000 ~ "small",	
                                                gdp_per_capita >= 5000 & gdp_per_capita < 10000 ~ "medium",	
                                                gdp_per_capita > 10000 ~ "large")))	


# ### Kategorikus valtozo ujrakodolasa	

# Hasonlo eset ha kategorikus valtozokat szeretnenk atkodolni. Mondjuk ha szeretnenk a deli felteket az eszaki feltekevel osszehasonlitani. Ezt a **recode()** funkcioval lehet megoldani.	


COVID_adat = COVID_adat %>%	
  mutate(continent_south_north = factor(recode(continent,	
                                            "Oceania" = "South",	
                                            "South America" = "South",	
                                            "Africa" = "South",	
                                            "Asia" = "North",	
                                            "Europe" = "North",	
                                            "North America" = "North")))	
                                     	
levels(COVID_adat$continent_south_north)	
	
COVID_adat_tegnap = COVID_adat_tegnap %>%	
  mutate(continent_south_north = factor(recode(continent,	
                                            "Oceania" = "South",	
                                            "South America" = "South",	
                                            "Africa" = "South",	
                                            "Asia" = "North",	
                                            "Europe" = "North",	
                                            "North America" = "North")))	
	



# ### Faktorszintek sorrendje, ordinalis valtozok	

# Amikor van ertelme a **sorrendisegnek** a faktorszintek kozott, **ordinalis valtozokrol** beszelunk (vagyis az egyik faktorszint alacsonyabb, vagy kisebb "erteku" mint a masik). Arra figyelnunk kell, hogy amikor faktorokat hozunk letre, az R automatikusan a faktorszintek neveinek **ABC sorrendje** alapjan rakja oket sorba, es az abrakon is igy szemlelteti majd oket.	



COVID_adat_tegnap %>%	
  ggplot() +	
  aes(x = gdp_per_capita_kat) +	
  geom_bar()	
	


# Ilyenkor erdemes meghatarozni a faktorszintek sorrendjet (**order**). Ezt legegyszerubben a factor() funkcion belul tehetjuk meg, az **ordered = T** beallitasaval, es a **levels =** resznel a szintek sorrendjenek meghatarozasaval.	


COVID_adat_tegnap = COVID_adat_tegnap %>%	
mutate(gdp_per_capita_kat = factor(gdp_per_capita_kat, ordered = T, levels = c(	
                                          "small",	
                                           "medium",	
                                           "large")))	
	


# Igy mar az R minden funkcioja tudni fogja, hogy egy ordinalis valtozorol van szo, ahol fontos a sorrend, es tudni fogja a sorrendet is.	


COVID_adat_tegnap %>%	
  ggplot() +	
  aes(x = gdp_per_capita_kat) +	
  geom_bar()	
	




# *______________________________* 	

# ### Gyakorlas	

# - szurd az adatokat ugy hogy csak a 2020-09-28-ai adatokkal dolgozzunk csak.	
# - csinalj egy uj kategorikus valtozot (nevezzuk ezt *new_cases_per_million_kat*-nak) a mutate() funkcio hasznalataval amiben azok az orszagok ahol a  *new_cases_per_million* valtozo 20 alatt van "small", ahol 20 vagy a felett van "large" kategoriaba keruljenek.	
# - figyelj oda hogy faktorkent jelold meg ezt az uj valtozot (Ezt lehet az elozo lepesben a mutate() funkcion belul, vagy egy kulon lepesben, de mindenkeppen a factor() vagy az as.factor() funkciokat erdemes hozza hasznalni)	
# - mentsd el ezt a valtozot az eredeti adatobjektumban ugy hogy kesobb is lehessen vele dolgozni 	

# - keszits egy tablazatot arrol, hogy hanyan esnek a *new_cases_per_million_kat* egyes kategoriaiba.	
# - Add meg a faktorszintek helyes sorrendjet: small, large (Ird felul a *new_cases_per_million_kat* korabbi valtozatat ezzel a valtozattal ahol a szintek mar helyes sorrendben vannak, vagy ezt a sorrendezest is bele vonhatod az eredeti funkcioba, amivel a valtozot generaltad)	
# - Ellenorizd, hogy valoban helyes sorrendben szerepelnek-e a faktor szintjei.	


# *______________________________*	



# ## Exploracio vizualizacion keresztul	

# ### Egyes valtozok vizualizacioja	

# Az egyes valtozok **abrak** (plot) segitsegevel is megvizsgalhatok.	
# A **kategorikus** valtozokat gyakran oszlopdiagrammal (**geom_bar**) abrazoljuk, 	

# Mig a **numerikus** valtozokat inkabb **dotplot** , **histogram**, vagy **density plot** segitsegevel szoktuk abrazolni.	

# Az egyes valtozok vizualizacioja es a leiro statisztikak atvizsgalasa elengedhetetlen hogy azonositsuk az esetleges adatbeviteli **hibakat es egyeb nemvart furcsasagokat** az adataink kozott.	

# **MINDING** ellenorizd az adataidat ezekkel a modszerekkel mielott komolyabb adatelemzesbe kezdesz, hogy meggyozodj rola, hogy az adatok tisztak es megfelenek az elvarasaidnak.	



COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = continent) +	
  geom_bar()	
	
	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = total_deaths_per_million) +	
  geom_dotplot(binwidth = 10)	
	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = total_deaths_per_million) +	
  geom_histogram()	
	
	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = total_deaths_per_million) +	
  geom_density()	
	


# *______________________________* 	

# ### Gyakorlas	

# Szurd az adatokat ugy hogy csak a 2020-09-07-en jeletett adatokkal dolgozzunk	

# Hasznald a fent tanult modszereket, hogy **azonositsd az COVID_adat adattablaban levo hibakat** vagy nem vart furcsasagokat.	

# - A vizualizacion tul a View(), describe(), es summary() funciokat erdemes hasznalni az adatok elso attekintesere 	
# - A numerikus (vagy eppen folytonos) valtozoknal vizsgald meg a minimum es maximum erteket es a hianyzo adatok mennyiseget, valamint az eloszlast.	
# - A kategorikus valtozoknal vizsgald meg az osszes faktorszintet es az egyes szintekhez tartozo megfigyelesek mennyiseget.	

# *______________________________*	


# ### A hibakat a kovetkezokeppen javithatjuk.	

# A **mutate()** es a **replace()** funkciok hasznalataval **cserelhetunk ki** ertekeket mas ertekekre. Azt, hogy ilyenkor hianyzo adatra (NA), vagy egy masik, valoszinu ertekre kell megvaltoztatni az erteket, a szituaciotol fogg. Altalaban a biztosabb megoldas ha hianyzo adatnak jeloljuk a kerdeses erteket (NA), de ez sok adatveszteshez vezethet. Ha eleg valoszinu hogy mi a helyes valasz, beirhatjuk, DE **minden javitast fel kell tuntetni** a kutatasi jelentesben (es a ZH soran is), hogy az olvaso szamara tiszta legyen, hogy itt egy adathelyettesites vagy kizaras tortent!	

# Mindig erdemes a javitott adatokat **uj adattablaba** elmenteni. A mi esetunkben az COVID_adat_corrected nevet adtuk a javitott objektumnak. Igy a nyers adataink megmaradnak, ami hasznos lehet kesobbi muveleteknel.	



	
COVID_adat_corrected <- COVID_adat %>%	
  mutate(new_cases = replace(new_cases,  new_cases=="-8261", NA))	
	


# Erdemes **megbizonyosodni rola**, hogy az adatcsere sikeres volt. Alabb az adatok vizualizaciojaval gyozodunk meg errol, de az adatok megjelenitesevel, vagy a leiro statisztikak lekerdezesevel is megteheto ez, ha az informativ.	


# hasznalhatnak meg az alabbiakat is arra, 	
# hogy megbizonyosodjunk abban, hogy sikeres volt a csere	
# View(COVID_adat_corrected)	
# describe(COVID_adat_corrected)	
# summary(COVID_adat_corrected$szocmedia_3)	
# COVID_adat_corrected$szocmedia_3	
	
old_plot <-	
  COVID_adat %>% 	
  filter(date == "2020-09-07", new_cases < 1000) %>% 	
  ggplot()+	
    aes(x = new_cases)+	
    geom_histogram()	
	
new_plot <-	
  COVID_adat_corrected %>% 	
  filter(date == "2020-09-07", new_cases < 1000) %>% 	
  ggplot()+	
    aes(x = new_cases)+	
    geom_histogram()	
	
	
grid.arrange(old_plot, new_plot, ncol=2)	
	




# ## Tobb valtozo kapcsolatanak felterkepezese	


# Tobb valtozo kapcsolatat is felterkepezhetjuk tablazatok es abrak segitsegevel.	

# ### Ket kategorikus (csoportosito) valtozo kapcsolatanak felterkepezese	

# **Feltaro elemzes**	

# Most vizsgaljuk meg azt, hogy 2020-09-28-an mi az osszefuggese a gdp kategorianak (*gdp_per_capita_kat*) a kontinenssel (*continent*) ahol az orszag elhelyezkedik. 	

# A legegyszerubb modja ket csoportosito valtozo kapcsolatanak megvizsgalasara a ket valtozo **kereszt-tablazatanak (crosstab)** elkezsitese a **table()** funkcioval.	



	
table(COVID_adat_tegnap$gdp_per_capita_kat, COVID_adat_tegnap$continent)	
	
	



# Sokszor ennel sokkal **szemleletesebb az abrak** (plot) hasznalata.	

# Erre az egyik lehetoseg a **stacked bar chart** (egymasra tornyozott oszlopdiagram, a **geom_bar()** geomot hasznaljuk) hasznalata. Itt az egyik valtozo kategoriai adjak meg hany oszlop lesz (ez a valtozo lesz az x tengelyen reprezentalva, igy ezt az "x =" reszen adhatjuk meg), a masik valtozo az oszlopokat szinekkel szegmentalja, ezt pedig a "**fill =**" reszen adhatjuk meg. 	



	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = continent, fill = gdp_per_capita_kat) +	
  geom_bar()	
	


# Ha az egyes faktorszinteken nagyon **kulonbozo mennyisegu megfigyeles** van, ez a megjelenites neha felrevezeto kovetkeztetesekhez vezethet, igy neha hasznosabb ha az oszlopok nem szamossagot (count), hanem **reszaranyt (proportion)** jelolnek. Ha ezt szeretnenk, ahelyett hogy uresen hagynank a geom_bar() funkciot, a kovetkezot adjuk meg: **geom_bar(position = "fill")**.	


	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = continent, fill = gdp_per_capita_kat) +	
  geom_bar(position = "fill")	
	



# *______________________________* 	

# ### Gyakorlas	

# Hasznald a fent tanult modszereket, hogy megvizsgald a COVID_adat_tegnap adatbazisban a **new_cases_per_million_kat** es a **continent** valtozok kozotti osszefuggest.	
# - hasznalj **geom_bar()** geomot a megjeleniteshez	
# - probald meg mind a **szamossagot**, mind a **reszaranyt** kifejezo abrat megvizsgalni geom_bar(position = "fill")	
# - milyen **kovetkeztetest** tudsz levonni az abrakrol?	


# *______________________________*	


	
# a fenti gyakorlashoz a new_cases_per_million_kat valtozot igy lehet legeneralni:	
	
COVID_adat = COVID_adat %>%	
  mutate(new_cases_per_million_kat = factor(	
                                      case_when(new_cases_per_million < 20 ~ "small",	
                                                new_cases_per_million >= 20 ~ "large"), ordered = T, levels = c("small", "large")))	
	
levels(COVID_adat$new_cases_per_million_kat)	
	
# ugyanez a COVID_adat_tegnap -al	
	
COVID_adat_tegnap = COVID_adat_tegnap %>%	
  mutate(new_cases_per_million_kat = factor(	
                                      case_when(new_cases_per_million < 20 ~ "small",	
                                                new_cases_per_million >= 20 ~ "large"), ordered = T, levels = c("small", "large")))	



# geom_bar() megjelenitesnel fontos hogy ha az egyes megfigyelesek **keves megfigyelesbol allnak**, az abra megteveszto lehet, mert az abra nem jelzi a megfigyelesek szamat es igy azt, hogy milyen biztosak lehetunk az eredmenyben. Ilyen esetekben az egyik kategoriat ki lehet venni az abrarol, vagy a **szamossagot es a reszaranyt abrazolo abrakat egymas mellet** lehet bemutatni, hogy igy kiegeszitsek egymast. Ehhez hasznalhatjuk a **grid.arrange()** funkciot.	



szamossag_plot <- 	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = continent, fill = gdp_per_capita_kat) +	
  geom_bar()	
	
reszarany_plot <- 	
COVID_adat_tegnap %>%	
ggplot() +	
  aes(x = continent, fill = gdp_per_capita_kat) +	
  geom_bar(position = "fill") +	
  ylab("proportion")	
	
grid.arrange(szamossag_plot, reszarany_plot, nrow=2)	
	



# A theme(legend.position) es a guides() funciok hasznalataval kontrollalhatjuk hogy hol es hogyan jelenjen meg a **jelmagyarazat** az abran. Az abra **interpretalhatosaga** attol fuggoen is **valtozhat**, hogy melyik valtozot tesszuk az x-tengelyre es melyiket szinkent abrazolva.	
# Az alabbi abrakon az egymillio fore vetitett uj esetek szamanak kapcsolatat nezzuk meg a gdp-vel. Mindket valtozo eseten a csoportositott valtozot (_kat) hasznaljuk.	



	
	
barchart_plot_3 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
  aes(x = new_cases_per_million_kat, fill = gdp_per_capita_kat) +	
  geom_bar()	
  	
	
barchart_plot_4 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
  aes(x = new_cases_per_million_kat, fill = gdp_per_capita_kat) +	
  geom_bar(position = "fill") +	
  ylab("proportion")	
	
grid.arrange(barchart_plot_3, barchart_plot_4, ncol=2)	
	
	
	
# a theme(legend.position) es a guides() funciok 	
# hasznalataval kontrollalhatjuk hogy hol es hogyan 	
# jelenjen meg a jelmagyarazat az abran	
	
barchart_plot_3 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
    aes(x = new_cases_per_million_kat, fill = gdp_per_capita_kat) +	
    geom_bar() +	
    theme(legend.position="bottom") +	
    guides(fill = guide_legend(title.position = "bottom"))	
  	
	
barchart_plot_4 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
  aes(x = new_cases_per_million_kat, fill = gdp_per_capita_kat) +	
  geom_bar(position = "fill") +	
  theme(legend.position="bottom") +	
  guides(fill = guide_legend(title.position = "bottom")) +	
  ylab("proportion")	
	
grid.arrange(barchart_plot_3, barchart_plot_4, ncol=2)	
	


# Ujabb modja a barchart segitsegevel valo megjelenitesnek ha az oszlopok nem egymasra tornyozva, hanem **egymas mellett** jelennek meg, vagy ha a masodik valtozo szerint **kulon paneleken (facet)** jelennek meg.	


	
barchart_plot_5 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
  aes(x = gdp_per_capita_kat, fill = new_cases_per_million_kat) +	
  geom_bar(position = "dodge")	
	
barchart_plot_6 <- 	
COVID_adat_tegnap %>%	
  select(new_cases_per_million_kat, gdp_per_capita_kat) %>% 	
  drop_na() %>% 	
ggplot() +	
  aes(x = gdp_per_capita_kat) +	
  geom_bar() +	
  facet_wrap(~ new_cases_per_million_kat)	
	
grid.arrange(barchart_plot_5, barchart_plot_6, nrow=2)	
	




# ### Egy kategorikus es egy numerikus valtozo kapcsolata	

# Vizsgaljuk meg hogy hogyan alakul az egy fore juto GDP kontinensenkent. A GDP ebben az esetben egy folytonos valtozó (gdp_per_capita), es ennek az osszefuggeset szeretnenk megvizsgalni egy kategorikus valtozoval (continent).	

# Az exploraciot kezdhetjuk leiro statisztikak lekerdezesevel csoportonkent. Peldaul ha arra vagyunk kivancsiak, milyen a GDP atlaga es szorasa kontinensenkent, ezt megvizsgalhatjuk a **group_by()** es a **summarize()** segitsegevel. 	


COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>% 	
  group_by(continent) %>% 	
    summarize(mean = mean(gdp_per_capita),	
              sd = sd(gdp_per_capita))	
	



# A ket valtozo kapcsolatat megvizsgalhatjuk **abrakkal** is. Pl. hasznalhatjuk a 	

# - **facet_wrap()** fuggvenyt egy **geom_histogram()** vagy **geom_dotplot()** -al kobinalva	
# - a **geom_boxplot()** -ot	
# - esetleg hasznalhatunk egy egymasra illesztett **geom_density()** plot-ot. 	
# - talan ebben az esetben a legtisztabb kepet a **geom_violin()** mutatja, ami a geom_boxplot() es a geom_density() keverekenek tekintheto. Ezt kiegeszithetunk egy **geom_point()** -al, hogy pontosan latsszon, hany megfigyelesen alapulnak az abra adatai.	

# Mindig erdemes **tobb megkozelitest** is hasznalni az adat-exploracio kozben, hogy minel reszletesebb kepet kaphassunk, es csokkentsuk a valoszinuseget hogy egyik vagy masik megkozelites hianyossagai felrevezetnek minket.	





	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = gdp_per_capita) +	
    geom_histogram() +	
    facet_wrap(~ continent)	



	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = gdp_per_capita) +	
    geom_dotplot() +	
    facet_wrap(~ continent)	
	



	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = continent, y = gdp_per_capita) +	
    geom_boxplot()	
	



	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = gdp_per_capita, fill = continent) +	
    geom_density(alpha = 0.3)	
	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = gdp_per_capita, fill = continent) +	
    geom_density()+	
  facet_wrap(~continent)	
	




	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = continent, y = gdp_per_capita, fill = continent) +	
    geom_violin() +	
    geom_jitter(width = 0.1)	




# A fenti abran latszik, hogy Azsiaban a legtobb orszagban viszonylag alacsony a gdp, viszont van nehany **kiurgo ertek**, az atlagot felhuzza ebben a csoportban.	


# Ha szeretnenk **kizarni az elemzesunkbol** az extrem ertekekt, a **filter()** funkcio beekelesevel a pipe-ba megepithetjuk a fenti abrankat es tablazatokat ugy, hogy csak a 50000-nel alancsonyabb GDP-ju orszagok keruljenek az abrara.	



	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  filter(gdp_per_capita < 50000) %>% 	
    ggplot() +	
      aes(x = continent, y = gdp_per_capita) +	
      geom_violin() +	
      geom_jitter(width = 0.1)	
	
COVID_adat_tegnap %>%	
  select(continent, gdp_per_capita) %>% 	
  drop_na() %>%	
  filter(gdp_per_capita < 50000) %>% 	
    group_by(continent) %>% 	
      summarize(mean = mean(gdp_per_capita),	
                sd = sd(gdp_per_capita))	
	


# Ha szeretnenk latni hogy a kisebb vagy nagyobb uj esetszammal jellemezheto orszagok (new_cases_per_million_kat) hogyan kulonboznek a GDP tekinteteben kontinensenkent akkor mar **harom valtozo** kapcsolatat kell abrazolnunk. Ehhez a facet_grid() funkciot lehet hasznalni, vagy kulonbozo esztetikai elemeket (aes()) lehet a kulonbozo valtozokhoz rendelni. (Az alabbi peldanal csak Europara es Eszak Amerikara korlatoztuk az adatbazist, hogy az abrak szemleletesebbek legyenek.)	





# *______________________________* 	

# ### Gyakorlas	

# Hasznald a fent tanult modszereket, hogy megvizsgald a **total_cases_per_million** es a **gdp_per_capita_kat** valtozok kozotti osszefuggest.	

# - hasznald a fenti geomokat, es keszits legalabb ket kulonbozo abrat mas-mas geomokkal	


# *______________________________*	


# ### Ket numerikus valtozo kapcsolata	

# **Ket numerikus valtozo** kozotti kapcsolat jellemzesere altalaban a korrelacios egyutthatot szoktuk hasznalni (cor()).	
# A **cor()** funkciot akar tobb mint ket valtozo paronkenti korrelaciojanak meghatarozasara is lehet hasznalni.	

# A **drop_na()** funkcioval kiejthetjuk azokat a megfigyeleseket, ahol a valtozok barmelyikeben hianyzo adat (NA) van. Ha ezt nem tesszuk meg, a cor() fuggveny NA eredmenyt adhna ha valamelyik valtozoban NA-val talalkozik.	



	
	
COVID_adat_tegnap %>%	
  select(new_cases_per_million, gdp_per_capita) %>% 	
  drop_na() %>%	
      cor()	
	
	
COVID_adat_tegnap %>%	
  select(new_cases_per_million, gdp_per_capita, hospital_beds_per_thousand) %>% 	
  drop_na() %>%	
      cor()	
	



# A numerikus valtozok kozotti kapcsolatot altalaban pont diagrammal szoktuk abrazolni (**geom_point()**)	

# A **geom_smooth()** layer hozzaadasaval kaphatunk a pontok kozott meghuzodo trendrol egy kepet. A kek vonal az ugyevezett trendvonal, a szurke sav a konfidencia intervallum. Ezekrol kesobb meg reszletesebben beszelunk majd	



	
COVID_adat_tegnap %>%	
  select(hospital_beds_per_thousand, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = hospital_beds_per_thousand, y = gdp_per_capita) +	
    geom_point()	
	
COVID_adat_tegnap %>%	
  select(hospital_beds_per_thousand, gdp_per_capita) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = hospital_beds_per_thousand, y = gdp_per_capita) +	
    geom_point() +	
    geom_smooth() 	


# *______________________________* 	

# ### Gyakorlas	

# Milyen eros a kapcsolat a aged_70_older es a gdp_per_capita kozott?	

# - hatarozd meg a korrelacios egyutthatot a valtozok kozott	
# - abrazold a valtozok kapcsolatat	


# *______________________________*	

# Tobb folytonos valtozo kapcsolata megjelenitheto peldaul ugy, hogy az egyik valtozot egy szinskalahoz rendeljuk az alabbi modon.	


COVID_adat_tegnap %>%	
  select(hospital_beds_per_thousand, gdp_per_capita, aged_70_older) %>% 	
  drop_na() %>%	
  ggplot() +	
    aes(x = hospital_beds_per_thousand, y = gdp_per_capita, col = aged_70_older) +	
    geom_point()+ 	
  scale_colour_gradientn(colours=c("green","black"))	
	

