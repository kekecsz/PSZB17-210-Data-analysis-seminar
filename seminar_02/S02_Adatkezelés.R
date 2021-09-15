
# # Adatmenedzsment	

# ## Absztrakt	

# Ezen a gyakorlaton megtanuljuk az adatkezelés alapjait az R programban. A gyakorlat bemutatja hogyan lehet adattáblát létrehozni és külső fájlból beolvasni, hogyan lehet az adattábla egyes részeire (bizonyos soraira vagy oszlopaira) hivatkozni (subsetting), és azt, hogy hogyan tudjuk az adatokat formázni és módosítani. 	



# ## Ismétlés	

# Az előző órán tanultuk hogy az R többféle **osztályt** és **típust** különböztet meg.	

# ### Vektorok:	

# - **karakter vektor (character):** "Ez egy karakter érték"	
# - **faktor (factor):** Egy olyan karater vektor ami csak rögzített értékeket vehet fel 	
# - **szám vektor (numeric):** 2 vagy 13.5. A szám vektornak két **típusa** van: *egész szám vektor (integer):* 2L (Az L mondja meg az R-nek, hogy az - előtte lévő számot, mint egész számot kezelje), vagy *racionális szám (double):* pl.: 13.5 	
# - **logikai vektor (logical):** csak TRUE vagy FALSE értékeket vehet fel (nagybetű is számít)	
# - **complex szám vektor (complex):** 1+5i	

# ### Komplexebb adatstruktúrák:	

# - **mátrix (matrix):** a vektorok egy táblázatot alkotnak. A mátrixban minden vektor/adat típusa csak ugyan az lehet.	
# - **adattábla (data.frame):** egy olyan mátrix, aminben megengedett hogy az oszlopokban egymáshoz képest más adat típus szerepeljen 	
# - **lista (list):** egy olyan vektor, aminek az elemei lehetnek más adatstruktúrák.	

# Az adat osztályát a **class()** függvénnyel tudjuk ellenőrizni, az adott osztályon belüli típusát pedig a **typeof()** függvénnyel.	

# De nem csak általánosságban tudjuk megnézni hogy milyen típusú változó egy objektum. Ha szeretnénk tudni hogy egy változó egy adott típusba tartozik-e, as **is.[változótípus]()** függvénnyel erre rákérdezhetünk. Így például az is.vector() kód rákérdez hogy az adott objektum vektor-e, és az is.integer() kód rákérdez hogy a változó integer típusú-e.	



number <- c(3, 4)	
	
class(number)	
typeof(number)	
	
is.numeric(number)	
is.integer(number)	
is.vector(number)	
	




# *_________________Gyakorlás__________________*	


# Ellenőrizd hogy az is.character(number) kód **eredménye** milyen osztályba tartozik.	


# *____________________________________________*	



# # Alapvető parancsok az adatok megismeréséhez	

# ## Combine függvény	

# A munkánk során erősen hagyatkozunk a c() függvényre. Ez azt jelenti, "combine", és azok az elemek amit a c()-n belül vannak, egy vektorba rendeződnek. 	


my_vector <- c(1, 3, 2, -3, 3)	
my_vector	


# Emlékezz vissza hogy a vektorokkal kapcsolatban az a megkötés, hogy **csak ugyan olyan típusú** adatok lehetnek a vektor elemei! Amikor megpróbálunk olyan elemeket kombinálni amik más típusúak, akkor az R kiválasztja az egyik típust, és olyan típusúként használja az összes elemet az új vektorban. Szám típusú adatok és karakter típusú adatok összekombinálásával karakter típusú elemeket kapunk.	

# A típusváltás akár az adott elem átalakításához is vezethet. Például logikai adatokat számadatokkal kombinálva egy számvektort kapunk, és ilyenkor a TRUE-ból 1, a FALSE-ból 0 lesz.	



my_other_vector <- c(1, 3, "two", "three")	
my_other_vector	
class(my_other_vector)	
	
my_new_vector <- c(1, 3, TRUE)	
my_new_vector	
class(my_new_vector)	


# Természetesen **vektor objektumokat is kombinálhatunk** a c() függvénnyel (a fenti megkötés figyelembevételéve).	


my_final_vector <- c(my_vector, my_new_vector)	
my_final_vector 	



# ## Beípített adattáblák	

# Az R-ben vannak előre **beépített adattáblák**. Ezekkel jól lehet gyakorolni az adatkezelést. 	

# Most az egyik ilyen beépített adatbázissal fogunk majd dolgozni, a **USArrests** adatbázissal, ami különböző bűntényekkel kapcsolatos letartóztatások statisztikáit tartalmazza az Egyesült Államok különböző államaira lebontva.	

# A ?USArrests parancs lefuttatásával további információkat kaphatsz az adatokról.	

# ## Nyers adatok és meta-adatok megtekintése	

# A következő parancsok futtatásával megnézhetjük a nyers adatokat táblázatos formában és meta-adatokat kaphatunk az adatbázisról.	



View(USArrests)	
	
USArrests	
	
?USArrests	
	


# ## Alapvető parancsok az adattábla struktúrájának megértéséhez	

# Az alábbi funkciók az adat objektumok struktúrális tulajdonságairól adnak információt.	

# - **str()**: információt ad arról hogy milyen olytályba tartozik az adott objektum, hány sora és hány oszlopa van, és az egyes oszlopokban milyen típusú adatokat tartalmaznak, és egy kis mintát is kapunk az adatokból.	
# - **names()** : oszlopok neveit listázza ki (column names, headers)	
# - **row.names()**: sorok/megfigyelések neveit adja meg	
# - **nrow()**: sorok száma	
# - **ncol()**: oszlopok száma	
# - **head()**: kilistázza az adattábla első x sorát (alapértelmezett 6 sor, de változtathatjuk)	
# - **tail()**: kilistázza az adattábla utolsó x sorát (alapértelmezett 6 sor, de változtathatjuk)	



str(USArrests) 	
	
names(USArrests)	
	
row.names(USArrests)	
	
nrow(USArrests)	
	
ncol(USArrests)	


# A head() és a tail() funkciókkal az adat első vagy utolsó valamennyi sorát nézhetjük meg. Alapértelmezettként 6, de megadhatunk más számot is. 	


head(USArrests)	
	
tail(USArrests, 10)	



# ## Hivatkozás objektumok rész-elemeire (Subsetting)	

# Gyakran előfordul hogy az objektumoknak csak egy részét szeretnénk használni. Mondjuk hogy szeretnénk a USArrests adatbázisban azt megvizsgálni hogy az USÁban átlagosan hány embert tartóztattak le gyilkosságért 1973-ban. A **mean()** funkcióval tudjuk az átlagot meghatárizni, de ennek csak numerikus vektor lehet a bemenete, adattábla objektumot nem adhatunk meg ebben a függvényben. Vagyis itt csak az adatbázisnak a **"Murder" oszlopára van szükségünk**.	

# Ennek a megoldására két lehetőségünk is van a base R-ben. Az egyik **a $ jel** használata. Ez viszonylag tiszta kódot eredményez, de kevésbé felxibilis mint a paraméterezés (lásd alább).	


USArrests$Murder	
class(USArrests$Murder)	
is.vector(USArrests$Murder)	
	
mean(USArrests$Murder)	
	


# A másik lehetőség a részelemek kiválasztására (subsetting-re) a **paraméterezés**. Ebben a megoldásban az objektum neve után egy szögletes zárójelet rakunk, és azon belül határozzuk meg, az objektum melyik részét szeretnénk megtartani, vagy éppen elvetni. 	


USArrests[,"Murder"]	
class(USArrests[,"Murder"])	
is.vector(USArrests[,"Murder"])	
	
mean(USArrests[,"Murder"])	


# Itt fontos, hogy ha többdimenziós objektumról van szó (mint például egy adattábla, data.frame), pontosan meg tudjuk jelölni, melyik dimenzió mentén szeretnénk az adott hivatkozást használni. Az általános szabály az, hogy a **szögletes zárójelben egy vesszővel elválasztva először a sorokra** vonatkozó kiválasztási szabályt adjuk meg, **majd a vessző után az oszlopokra** vonatkozó kiválasztási szabályt.	

# Így például a USArrests[2, "Murder"] azt jelenti, hogy a USArrests adattábla 2. sorában a "Murder" nevű oszlopban szereplő adatot szeretnénk használni.	

# Néhány további példa segíthet a megértésben:	


USArrests[5, "Assault"]	
USArrests[c("Illinois", "Arkansas"), "UrbanPop"]	
USArrests[c("Illinois", "Arkansas"), 2:4]	


# A paraméteres subsetting arra is lehetőséget ad, hogy **kizárjunk** bizonyos elemeket, amikre nincs szükségünk. Ezt általában a minusz jellel tehetjük meg. Sajnos itt a nevek használata nem olyan egyszerű mint a kiválasztásnál, így ilyenkor általában a sorok vagy oszlopok számaival dolgozunk.	

# Ez a függvény például kihagyja a negyediktől az ötvenedik sorig a sorokat (vagyis csak az első három sort hagyja meg), 	


USArrests[-c(4:50),]	


# Ez a parancs pedig ezen felül még kihagyja a második oszlopot is (az Assault oszlopot). Az alábbi két parancs ugyan azt éri el:	


USArrests[-c(4:50),-2]	
USArrests[-c(4:50),-which(names(USArrests) == "Assault")]	


# Az alábbi kód a %in% (within) operátor használatával teszi lehetővé hogy több nevet is megjelöltjünk, amit szeretnénk kizárni. Eredménye ekvivalens az alatta lévő sorral, ahol az oszlopok számát használjuk.	


USArrests[-c(4:50),-which(names(USArrests) %in% c("Murder", "Assault"))]	
USArrests[-c(4:50),-c(1,2)]	


# A számok használata könnyebbnek tűnhet a subsetting során. Mégis amikor lehet, érdemes név szerint szöveggel hivatkozni oszlopokra, mert ettől a kód érthetőbb lesz mások számára is, és ha változik az adattábla struktúrája, akkor is biztosított hogy ugyan azokat az oszlopokat fogjuk kiválasztani vagy kihagyni.	


# *_________________Gyakorlás__________________*	

# - Mentsd el a **USArrests** adattábla sorainak neveit egy új objektumként aminek az a neve hogy **row_names**	
# - egy fügvénnyel nézd meg hány elemből áll ez a **row_names** objektum	
# - egy fügvénnyel nézd meg milyen ennek az objektumnak az osztálya	
# - Csinálj egy új objektumot, ami egy olyan adattáblát tartalmaz, ami a **USArrests** objektumnak csak az "UrbanPop" és "Rape" oszlopait tartalmazza (legyen az objektum neve **USArrests_UrbanPop_Rape**).	
# - Listázd ki az **USArrests_UrbanPop_Rape** adattáblának az utolsó 8 sorát	
# - (EXTRA) Nézd meg hogy populáció hány százaléka lakik városokban "Colorado" és "Mississippi" államokban?	

# *____________________________________________*	


# # Tidyverse	

# Az adatkezelést az R közösség gyakran "Data wrangling"-nek nevezi. Ezt a base R funciókkal is meg lehet csinálni, de általában egy nagyobb adatelemzési projekt végére ez nehezen átlátható kódot eredményez. A tiszta és átlátható kódolás elősegítésére a **Tidyverse** package gyűjtemény használhatjuk. Ez olyan R package-ek gyűjteménye, melyek mind egy standardizált és átlátható kód-írási rendszert támogatnak. Az egésznek az alapja a tiszta adatmenedzsmentet elősegítő *dplyr pakcage*.	

# Először töltsük be a Tidyverse package-et a library() funkcióval. (Ha a package még nincs felinstallálva, akkor először fel kell installálni az install.packages() funkcióval, lásd az előző óra anyagát.)	



library(tidyverse)	


# Most hozzunk létre egy vektort néhány számmal.	


x <- c(55:120, 984, 552, 17, 650)	


# Az egyik legfontosabb eleme a Tidy kódolásnak a %>% (**pipe operátor**) használata. A pipe operátort arra találták ki hogy függvények sorát egymás után egyszerűen le lehessen futtatni egy rövid átlátható kód segítségével.	

# Például ha a fenti vektor átlagának 10-es alapú logaritmusát akarjuk kiszámolni, majd az eredményt egy tizedesjegy pontossággal megadni, használhatjuk a round(log(mean(x)), digits = 1) függvény-sorozatot, de a sok egymásba foglalt zárójel miatt a kód nehezen átlátható. Ehelyett alább látható hogy a %>% segítségével ugyanezt hogyan lehet megoldani. Az alábbi kódban jobban látható mit milyen sorrendben csináltunk az adattal.	

# A pipe-ot talán elképzelhetjük úgy mint egy csővezetéket vagy futószalagot, ami egy gyár különböző munkaállomásain vezeti végig a terméket. Az adat a termék, a függvények pedig a munkaállomások, és a pipe azt jelenti, hogy a pipe utáni függvény bemenete a pipe előtti eredmény legyen. Így a kódon tisztán látható, hogy az x vektor volt a kiindulópontunk, és hogy azon sorrendben milyen funkciókat hajtottunk végre hogy megkapjuk a végeredményt.	

# *- - - - - - - - - - - TIPP  - - - - - - - - - - *	

# A %>% operátort a **Ctrl + Shift + M** gombok megnyomásával gyorsan beírhatod, ha nem akarod a karaktereket egyenként begépelni.	

# *- - - - - - - - - - - - - - - - - - - - - - - - *	

# Ezt függvények láncba kapcsolásának, vagy chaining-nek is hívják.	


round(log(mean(x)), digits = 1)	
	
	
x %>%	
  mean() %>%	
    log() %>% 	
      round(digits = 1)	
	
	



# ## A négy dplyr alapfunkció	

# A dplyr pakcage-ben 4 alapvető funció van, amit mindenképpen ismerni kell:	

# - **filter()**: ezzel választjuk ki melyik megfigyelésekkel (sorokkal) szeretnénk dolgozni	
# - **mutate()**: módosíthatunk meglévő adatokat, vagy létrehozhatunk új adatokat az adattáblában	
# - **group_by()**: valamilyen szempont szerint tudjuk csoportosítani az adataink. **FONTOS: a group_by() használata után az R a csoportokonként külön végzi el a láncban később jövő függvényeket.**	
# - **summarise()**: összesíti az adatokat valamilyen másik függvény szerint	

# ### Példák az alkalmazásra:	

# Most a ToothGrowth nevű beépített adattáblát fogjuk használni, hogy megtanuljuk a függvények használatát.	

# A ?ToothGrowth parancs lefuttatásával a következő információt olvashatjuk az adatbázisról:	

# *"The response is the length of odontoblasts (cells responsible for tooth growth) in 60 guinea pigs. Each animal received one of three dose levels of vitamin C (0.5, 1, and 2 mg/day) by one of two delivery methods, orange juice or ascorbic acid (a form of vitamin C and coded as VC)."*	

# Az adatbázisban található változók:	

# - len (numeric): Tooth length	
# - supp (factor): Supplement type (VC or OJ).	
# - dose (numeric):	Dose of vitamin C in milligrams/day	


# **filter()**: Válasszunk ki azokat az eseteket, ahol narancslével adták be a C-vitamint:	


ToothGrowth %>%	
  filter(supp == "OJ")	


# **mutate()**: Hozzunk létre egy új oszlopot, ami nem mm-ben, hanem cm-ben tárolja a fogak hosszát	

# *- - - - - - - - - - - TIPP  - - - - - - - - - - *	

# Fontos, hogy a módosítások csak akkor mentődnek ha az eredményt egy objektumhoz rendeljük! Egyébként az eredményeket kilistázza az R, de nem tartja meg őket.	

# *- - - - - - - - - - - - - - - - - - - - - - - - *	

# Az alábbi függvényben csinálunk egy új változót, aminek a neve **len_cm**. (Ezt az új változót bármi másnak is elnevezhettük volna.)	

# Vedd észre hogy a parancs eredményét egy új objektumba (**my_ToothGrowth**) mentettük, hogy később még tudjunk dolgozni azzal az adattáblával amiben szerepel a len_cm nevű változó is.	


my_ToothGrowth <- ToothGrowth %>%	
  mutate(len_cm = len / 10)	


# **summarise()**: Most nézzük meg, hogy mennyi a fogak átlag hossza cm-ben.	


my_ToothGrowth %>%	
  summarise(mean_len_cm = mean(len_cm))	


# A summarise után a **mean_len_cm** azt jelenti, hogy ezt az összefoglaló adatot egy mean_len_cm nevű változóként szeretnénk tárolni. A kód a "mean_len_cm = " rész nélkül is lefut, ekkor a program maga választ egy változónevet ennek az adatnak.	

# A summarise() függvényben az n() függvényt használva meg tudjuk számolni azt is, hogy **hány eset (sor) van**. Mivel ez még mindig egy összefoglaló statisztika, a betehetjük ezt is a summarise() függvénybe egy vesszővel elválasztva a mean()-től. Az eredmény egy táblázat lesz. Itt már jobban látszik, mi értelme van elnevezni a különböző összesítő statisztikákat, hiszen így a kilistázott eredményt könnyebb értelmezni, ha általunk adott változónevek alatt szerepelnek az adatok.	


	
my_ToothGrowth %>%	
  summarise(mean_len_cm = mean(len_cm),	
            n_cases = n())	



# A **group_by()** függvényt használva az R a csoportokon belül végzi el a summarise()-ban előírt függvényeket.	


ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
    group_by(supp) %>%	
      summarise(mean_len_cm = mean(len_cm),	
                cases = n())	


# ## Egyéb hasznos dplyr funkciók	

# **select()**: Változók kiválasztása	

# Kiválaszhatunk bizonyos változókat, ha csak azokat szeretnénk megtartani. A mínusz jellel pedig törölhetünk egy adott változót. Választhatunk pozíció alapján is változót, de ez kevésbé ajánlott mert nehezebben érthető kódot eredményez, és később a bemeneti adat változásaival hibákhoz is vezethet. A select() függvénynek vannak segítő függvényei is, mint például a starts_with(), amivel szöveg részletek alapján tudunk választani több változót.	


ToothGrowth %>%	
  select(supp, len) %>% 	
  summary()	
	
ToothGrowth %>%	
  select(-dose)	
	
ToothGrowth %>% 	
  select(1, 2) 	
	
ToothGrowth %>% 	
  select(2:3)	
	
ToothGrowth %>%	
  select(starts_with("d", ignore.case = TRUE)) 	



# **arrange**: Értékek sorba rendezése bizonyos változók alapján	

# Egy bizonyos változó értékei mentén sorba is rendezhetjük az adatokat. 	


ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
    group_by(supp) %>%	
      summarise(mean_len_cm = mean(len_cm),	
                cases = n()) %>% 	
        arrange(mean_len_cm)	


# Ha a mínusz jelet a változó elé rakjuk, akkor csökkenő sorrendbe rakja az értékeket, növekvő helyett.	


ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
    group_by(supp) %>%	
      summarise(mean_len_cm = mean(len_cm),	
                cases = n()) %>% 	
        arrange(-mean_len_cm)	


# **rename()**: A átnevezhetünk változókat	


ToothGrowth %>%	
  rename(new_name = dose)	



# ## Változók újrakódolása	

# **recode()**: diszkrét változókat tudunk vele újra kódolni.	


ToothGrowth %>% 	
  mutate(dose_recode = recode(dose, 	
                              "0.5" = "small",	
                              "1.0" = "medium",	
                              "2.0" = "large"))	




# **case_when()**: diszkrét változókat tudunk vele generlálni akár folytonos akár diszkrét változókból.	

ToothGrowth %>% 	
  mutate(dose_descriptive = case_when(dose == 0.5 ~ "small",	
                                      dose > 0.5 ~ "medium_to_large"))	



#                                       	
# *_________________Gyakorlás__________________*	

# - Listázd ki, hogy a ToothGrowth adatbázisban ha csak azokat az aranyhörcsögöket nézzük amik aszkorbinsavval (supp == "VC")  kapták a c-vitamint, dózisonként (dose) külön mekkora volt a fogméret (len, vagy len_cm). Mindezt egy chain-en belül csináld meg a %>% operátor használatával	


# *____________________________________________*	


# ## A tidyverse limitációi	

# Nem minden funkció alkalmazható Tidyverse-ben, de a legtöbb funkciónak van egy Tidyverse-kompatibilis változata valamelyik package-ben.	

# Például a sima összeadás és kivonás függvények nem használhatóak önállóan a %>% után. (Ez általában akkor jelent problémát amikor a matematikai művelettel kezdődik a sor. Amint a matematikai művelet valamilyen funció után következik akkor már általában lefut.)	




	
x %>%	
  mean() %>%	
    log() %>% 	
      round(digits = 1) %>% 	
        -3 %>% 	
          +5 %>% 	
            /2	


# A magrittr package-ben található subtract(), add(), divide_by() stb. függvények lehetőséget adnak az ilyen alapvető matematikai műveletek Tidy kódban való megírására:	


library(magrittr)	
	
	
x %>%	
  mean() %>%	
    log() %>% 	
      round(digits = 1) %>% 	
        subtract(3) %>% 	
          add(5) %>% 	
            divide_by(2)	
	
	





# ## A mutate() függvény változatai (ajánlott anyag)	

# A mutate függvény különböző változataival több változót is megváltozhtathatunk egyszerre! A mutate_all() az összes változót egyszerre megváltoztathatjuk	


ToothGrowth %>% 	
  mutate_all(.funs = list(~ as.character(.)))	


# A mutate_at bizonyos változókra használ egy függvényt	


ToothGrowth_factor <- 	
  ToothGrowth %>% 	
    mutate_at(list(~ as.factor(.)), .vars = vars(supp, dose))	
	


# Most leelenőrizhetjük, hogy tényleg faktor típusra változtattuk-e a supp és dose változókat.	


is.factor(ToothGrowth_factor$dose)	


# A mutate_if() függvény csak azokra a változókra használ egy függvényt, amelyek eleget tesznek egy feltételnek.	


ToothGrowth %>% 	
  mutate_if(.predicate = is.factor, .funs = list( ~ stringr::str_to_lower(.)))	








