# 1. Toltsd be a szukseges package-eket. - 1/1 pont
#
# (Vigyazz, hogy ha mind a car mind a tidyverse package-eket hasznalod,
# akkor a tidyverse pacakge-et toltsd be kesobb, mert kulonben a car package
# felulirja a recode() funkciot!)

# 2. Toltsd be az adatbazist amivel dolgozni fogunk az alabbi url-rol,  - 1/1 pont
# (ez egy .csv file): 
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/ZH_data_reexam.csv"
# 
# Olvasd el figyelmesen az adat leirasat, mert az adatok ismerete szukseges az alabbi feladatok megoldasahoz
#
# Az adatok szimulalt adatok. Egy klinikai kutatas eredmenyeibol szarmaznak, 
# ahol a kutatok a mutet utani fajdalom bejoslasara szerettek volna egy hatekony
# modellt epiteni.
#
# A kutatasban 160 felnott vett reszt akik bolcsessegfog-muteten estek at. A mutet 
# elott kozvetlenul a muteti varoban kerdoiveket toltottek ki, majd 5 perccel a 
# mutet elott ver es nyalmintat vettek tolunk, melybol megallapitottak a cortisol
# szintjuket (lasd lentebb a valtozok leirasat). A mutet utan 5 oraval megkerdeztek
# oket arrol, mekkora a fajdalomszintjuk.
#
# - ID - kategorikus valtozo: resztvevo azonosito
# - pain - a fajdalomszint. Erteke 0 (nincs fajdalom) es 10 (elkepzelheto 
# legnagyobb fajdalom) kozott mozoghat.
# - sex - kategorikus valtozo: nem (szintejei ebben az adabazisban: female - no, male - ferfi)
# - age - eletkor
# - STAI_trait - szorongasszint a State Trait Anxiety Inventory - T teszt alapjan.
# erteke 20 es 80 kozott mozoghat, minek magasabb, annal nagyobb a szorongasszint.
# - pain_cat - Fajdalom-katasztrofizacio szintje a Pain Catastrophizing Scale alapjan.
# erteke 0 es 52 kozott mozoghat. Minel nagyobb az ertek, a szemely annal inkabb
# hajlamos a fajdalmas ingereket fenyegeteskent kezelni, fajdalom erzet eseten
# tehetetlennek erezni magat, es a fajdalommal kapcsolatos gondolati betoresekre.
# - cortisol_serum - A kortizol hormon szintje a verplazmabol kimutatva. A kortizol
# egy stresszhormon. A verbol mert kortizolt tekintik altalaban a fiziologiai stressz
# egyik legjobb mutatojanak. 
# - cortisol_saliva - A kortizol hormon szintje a nyalbol kimutatva. A kortizol
# egy stresszhormon. A nyalbol mert kortizolt kevesbe megbizhato mutatoja a
# fiziologiai stressznek, mint a verbol kimutatott kortizol szint, de megis
# gyakran hasznaljak, hiszen konnyebb nyalmintat venni, mint vermintat.
# - mindfulness - A mindfulness szintje a Mindful Attention Awareness 
# Scale (MAAS) alapjan. Erteke 1 es 6 kozott mozoghat, magasabb ertekek magasabb
# mindfulness szintre utalnak.
# - weight - testsuly
# 
# A kutatok celja a mutet utani fajdalomszint minel jobb leirasa.

# 3. jelold faktorkent a kategorikus valtozokat  - 1/1 pont

# 4. Vegezz az adatokon alapveto adatellenorzo muveleteket. - 4/4 pont
# Ellenorizd hogy vannak-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket.
# A javitasokat koddal csinald (hogy reprodukalhato es atlathato legyen, mit csinaltal pontosan).
# Ellenorizd, hogy sikerult-e minden adatot helyesen javitani (ez az ellenorzes is szerepeljen a kodban).
# A javitott adatfajlt mentsd el egy uj objektumba, es a kovetkezo lepesekben mar ezzel a javitott adattablaval dolgozz.

# 5. A muteti fajdalomrol korabbi kutatasokbol tudjuk, hogy az eletkor es 
# a nem is befolyasolhatja. - 5/5 pont
# - Epits egy regresszios modellt, amiben a fajdalom szintjet az eletkor 
# es a nem prediktorok segitsegevel becsuljuk meg.
# - A modell szerint a nok vagy a ferfiak szamolnak be magasabb fajdalomrol? Ird le, ezt mibol
# kovetkeztetted ki.
# - Ez alapjan a regresszios modell alapjan becsuld meg  mekkora a varhato fajdalomszintje
# egy 30 eves nonek, egy 70 eves nonek, es egy 45 eves ferfinak.

# 6. Az uj kutatas fo celja, hogy megtudjuk, pszichologiai valtozok figyelembevetele segithet-e 
# a fajdalom jobb bejoslasaban. Ennek a kerdesnek a megvalaszolasahoz hierarchikus regressziot
# fogunk hasznalni. - 6/6 pont
# - Eloszor is epits egy uj regresszios modellt, amiben a fajdalom
# bejoslasara az eletkor, nem, STAI_trait, pain_cat, cortisol_serum, 
# cortisol_saliva, es a mindfulness valtozokat hasznaljuk mint prediktorokat. 
# Ezek a prediktorok mind egy modellben szerepeljenek.
# - Ezutan hasonlitsd ossze, hogy ez az uj modell, vagy a korabban epitett
# modell (amiben csak az eletkor es a nem szerepelt) illeszkedik jobban az adatokhoz
# az AIC modellilleszkedesi mutato alapjan.
# - Hatarozd meg, hogy a fajdalom varianciajanak hany szazalekat kepes magyarazni a regi
# es az uj modell.
# - Ezek alapjan vond le a kovetkeztetest, hogy szerinted erdemes-e figyelembe venni a
# pszichologiai tenyezoket (STAI_trait, pain_cat, cortisol_serum, cortisol_saliva, es 
# mindfulness) a fajdalom varhato szintjenek meghatarozasakor, vagy eleg csak a nemre
# es az eletkorra koncentralni? Indokold dontesedet a fenti adatokkal.
# - Mi a STAI_trait valtozo regresszos egyutthatojanak konfidencia intervalluma, es
# ez alapjan milyen kovetkeztetest vonhatunk le a prediktorral kapcsolatban?


# A kovetkezo feladatban az Animal Rights Scale (ARQ) adatbazissal dolgozunk majd.
# Eloszor is toltsd be az adatbazist. 
# Az adatbazis errol a linkrol elerheto (ez egy .csv file):
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/animalrights.csv"
#
# Az ARQ egy olyan kerdoiv ami a szemely allatok jogaival kapcsolatos attitudjet
# hivatott felmerni. A kitoltoknek egy 1-5 foku skalan kell megitelnie, hogy mennyire ert egyet
# a kerdoiv allitasaival (1 - nagyon nem ertek egyet, 5 - nagyon egyetertek). A kerdoivben olyan
# allitasok szerepelnek mint "Az allatok jogainak megseretesenek minosul ha egy allatot
# fogsagban tartanak az ember haziallatakent." vagy "A vadaszok fontos szerepet jatszanak
# a szarvaspopulacio szabalyozasaban" (forditott tetel).
#
# Az adatbazisban talalhato vatlozok:
# - ar1, ar2, ar3, ..., ar28: Az adatbazisban az ARQ itemeire adott valaszok az 
# elso 28 oszlopban szerepelnek, az ar1-tol az ar28 oszlopokokig. (A kerdoiv 28 kerdesenek 
# szovege itt talalhato: http://core.ecu.edu/psyc/wuenschk/Animals/Anim-Rights-Q.htm)
# - sex: nem, ez egy faktor valtozo melyenk ket szintje van az adatbazisban: 1: no, 2: ferfi
# - party: azt mutatja, hogy a szemely onbevallasa alapjan melyik nagy amerikai partot tamogatja
# ez egy faktor valtozo, melynek nagy szintje van: 1: Demokrata, 2: Republikanus, 
# 3: Mas (vagyis valamelyik masik nagy partot tamogatja), 4: Egyik sem (vagyis egyik 
#  partot sem tamogatja)
# - liberal: Ez egy numerikus valtozo, minel magasabb ez a pontszam, a szemely annal inkabb
# liberalis nezeteket vall (1 - nagyon konzervativ, 5 - nagyon liberalis). 
#
# 7. Az Animal Rights Scale (ARQ) itemei mogott - 12/12 pont
# megbuvo latens faktorok feltarasat vegezzuk majd el feltaro faktorelemzes segitsegevel. 
# Az adatbazisban az ARQ itemeire adott valaszok az elso 28 oszlopban szerepelnek. 
# Fontos, hogy a faktorelemzesbe csak ezek a valtozok keruljenek bele, es az adatbazisban
# szereplo tobbi valtozo ne keruljon a faktorelemzesbe. 
#
# - Eloszor keszitsd el az ARQ itemeinek korrelacios matrixat (itt a "Polychoric Correlation"-t
# kell hasznalni, mert az kerdoivre adott valaszok ordinalis skalajuak) es mentsd el egy
# objektumba. Ha a mixedCor() vagy a polychoric() funkciot hasznalod, 
# erdemes meghatarozni a correct = 0 parametert, egyebkent egy figyelmeztetest fogsz kapni. 
# (Ha esetleg nem sikerlune a korrelacios matrix elkeszitese, a korrelacios matrixot
# beolvashatod a kovetkezo paranccsal (ezt el kel mentened egy objektumba):
# read.csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/plycor_arq.csv")
# Ha igy olvasod be a korrelacios matrixot, akkor a ggcorrplot() hibauzenetet fog adni,
# szoval hasznalj egy mas vizualizacios modszert.
# - Vegezd el a faktorextrakciot. Hasznalj oblique faktorrotaciot (faktorforgatast).
# Hasznald a principal axis factoring faktorextrakcios modszert. Epits ket modellt, az egyikben 
# legyen a faktorok szama 2, a masikban 4. 
# - Szamold ki mindket modellben hogy mekkora a valtozok atlagos kommunalitasa, es hogy hany
# valtozo kommunalitasa 0.4 alatti. Ezek alapjan melyik modell reprezentalja 
# jobban a valtozokat?
# - Vizualizald annak a modellnek a faktorstrukturajat es a faktortolteseit
# amelyik a nagyobb atlagos kommunalitast mutatta
# - Mely valtozo toltese a legmagasabb a valtozokat legjobban reprezentalo faktoron?


































# 8. Vegezz modelldiagnosztikai elemzeseket a linearis regresszio elofelteteleinek
# tesztelesere az uj modellen (ami a pszichologiai valtozokat is tartalmazza 
# prediktorkent). - 9 pont
#
# - A kommentekben jelezd hogy az adott elemzessel eppen melyik elofeltetelt teszteled.
# - Minden elofeltetelnel jelezd, hogy talaltal-e az elofeltetel serulesere utalo 
# jelet vagy sem. (Azt is ird le ha nem talaltal ilyen jelet!) A multikollinearitas
# feltetelenek ellenorzesekor hasznald a 3-as vif hatarerteket a problematikus
# valtozok azonositasara.
# - Ha talalsz jelet barmely elofeltetel serulesere, ird le, hogy hogyan kezelned
# az adott feltetel seruleset (most nem kell elvegezni ezeket a muveleteket, csak
# ird le, mi lenne a valasztott megoldasod.)

# 9. Melyik a pszichologiai tenyezoket is figyelembe vevo modellben a 
# legbefolyasosabb es a legkevesbe befolyasos prediktor? 
# Indokold a valaszod. - 3 pont

#
# 10. Toltsd fel a teljesen megoldott ZH kodjat a hazi feladatokhoz 
# is hasznalt sajat google drive folderedbe. A File neve legyen 
# pot_pot_zh_2_[neved].R (pl. pot_pot_zh_2_kekecszoltan.R)









# 1. Toltsd be a szukseges package-eket. - 1/1 pont
#
# (Vigyazz, hogy ha mind a car mind a tidyverse package-eket hasznalod,
# akkor a tidyverse pacakge-et toltsd be kesobb, mert kulonben a car package
# felulirja a recode() funkciot!)


# 2. Toltsd be az Animal Rights Scale (ARQ) adatbazist. - 1/1 pont
# Ez egy olyan adatbazis errol a linkrol elerheto (ez egy .csv file)
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/animalrights.csv"
#
# Az ARQ egy olyan kerdoiv ami a szemely allatok jogaival kapcsolatos attitudjet
# hivatott felmerni. A kitoltoknek egy 1-5 foku skalan kell megitelnie, hogy mennyire ert egyet
# a kerdoiv allitasaival (1 - nagyon nem ertek egyet, 5 - nagyon egyetertek). A kerdoivben olyan
# allitasok szerepelnek mint "Az allatok jogainak megseretesenek minosul ha egy allatot
# fogsagban tartanak az ember haziallatakent." vagy "A vadaszok fontos szerepet jatszanak
# a szarvaspopulacio szabalyozasaban" (forditott tetel).
#
# Az adatbazisban talalhato vatlozok:
# - ar1, ar2, ar3, ..., ar28: Az adatbazisban az ARQ itemeire adott valaszok az 
# elso 28 oszlopban szerepelnek, az ar1-tol az ar28 oszlopokokig. (A kerdoiv 28 kerdesenek 
# szovege itt talalhato: http://core.ecu.edu/psyc/wuenschk/Animals/Anim-Rights-Q.htm)
# - sex: nem, ez egy faktor valtozo melyenk ket szintje van az adatbazisban: 1: no, 2: ferfi
# - party: azt mutatja, hogy a szemely onbevallasa alapjan melyik nagy amerikai partot tamogatja
# ez egy faktor valtozo, melynek nagy szintje van: 1: Demokrata, 2: Republikanus, 
# 3: Mas (vagyis valamelyik masik nagy partot tamogatja), 4: Egyik sem (vagyis egyik 
#  partot sem tamogatja)
# - liberal: Ez egy numerikus valtozo, minel magasabb ez a pontszam, a szemely annal inkabb
# liberalis nezeteket vall (1 - nagyon konzervativ, 5 - nagyon liberalis). 


# 3. A sex es a party valtozokat kodold ujra, ugy hogy a szamok helyett a kovetkezo faktornevek
# szerepeljenek:
# sex: 1 - male, 2 - female
# party: 1 - democrat, 2 - republican, 3 - other, 4 - none)
# ezeket a valtozokat jelold meg faktorkent.
# ezentul ezzel az ujrakodolt adatbazissal dolgozz. 
# - 2/2 pont



# 4. Ebben a feladatban a liberalissag bejoslasara kell majd egy modellt epitened. - 5/5 pont
# - Epits egy linearis regresszios modellt annak a bejoslasara, hogy a szemely mennyire 
# liberalis (liberal valtozo). A modellben hasznald bejoslokoent a sex, party, es
# ar5 valtozokat prediktorkent. 
# - A modell szerint a demokrata partot tamogato vagy a republikanus partot tamogato
# szemelyek a liberalisabbak? A modell szerint azok a liberalisabbak, akik egyik partot
# sem tamogatjak, vagy azok, akik a republikanus partot tamogatjak? 
# Ird le, hogy ezeket a kovetkezteteseket mi alapjan vontad le. 





# A kovetkezo ket feladatban (5. es 6. feladat) az Animal Rights Scale (ARQ) itemei mogott 
# megbuvo latens faktorok feltarasat vegezzuk majd el feltaro faktorelemzes segitsegevel. 
# Az adatbazisban az ARQ itemeire adott valaszok az elso 28 oszlopban szerepelnek. 
# Fontos, hogy a faktorelemzesbe csak ezek a valtozok keruljenek bele, es az adatbazisban
# szereplo tobbi valtozo ne keruljon a faktorelemzesbe. 

# 5. Ebben a feladatban a feltaro faktorelemzes elokesziteset fogjuk elvegezni. - 10/10 pont
#
# - Eloszor keszitsd el az ARQ itemeinek korrelacios matrixat (itt a "Polychoric Correlation"-t
# kell hasznalni, mert az kerdoivre adott valaszok ordinalis skalajuak) es mentsd el egy
# objektumba. Ha a mixedCor() vagy a polychoric() funkciot hasznalod, 
# erdemes meghatarozni a correct = 0 parametert, egyebkent egy figyelmeztetest fogsz kapni. 
# (Ha esetleg nem sikerlune a korrelacios matrix elkeszitese, a korrelacios matrixot
# beolvashatod a kovetkezo paranccsal (ezt el kel mentened egy objektumba):
# read.csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/plycor_arq.csv")
# Ha igy olvasod be a korrelacios matrixot, akkor a ggcorrplot() hibauzenetet fog adni,
# szoval hasznalj egy mas vizualizacios modszert.)
# - Vizualizald a korrelacios matrixot legalabb egy vizualizacios modszerrel 
# - Vizsgald meg az adatok faktoralhatosagat, es ird le, ez alapjan mi a velemenyed
# az adatok faktoralhatosagarol
# - Vizsgald meg, hogy a tobbvaltozos normalis eloszlas feltetele teljesul-e, es ha nem,
# ird le, ezt hogyan lehet kezelni a faktorextrakcio soran. 
# - Hatarozd meg az idealis faktorszamot a scree teszt es a parallel teszt alapjan. Ird le,
# ezek a tesztek hany faktor extrakciojat javasoljak. 



# 6. Vegezd el a feltaro faktorelemzest az ARQ tetelei mogott rejlo latens
# faktorok felderitesere. - 11/11 pont
# - Vegezd el a faktorextrakciot. Hasznalj ortogonalis faktorrotaciot (faktorforgatast).
# A faktorextrakcios modszer kivalasztasanal vedd figyelembe hogy teljesult-e
# a tobbvaltozos normalis eloszlas feltetele. Epits ket modellt, az egyikben 
# legyen a faktorok szama 2, a masikban 5. 
# - Szamold ki mindket modellben hogy mekkora a valtozok atlagos kommunalitasa, es hogy hany
# valtozo kommunalitasa 0.4 alatti. Ezek alapjan melyik modell reprezentalja 
# jobban a valtozokat?
# - Vizualizald annak a modellnek a faktorstrukturajat es a faktortolteseit
# amelyik a nagyobb atlagos kommunalitast mutatta
# - Mely valtozok toltese negativ az oket legjobban reprezentalo faktoron (csak azokra
# az esetekre koncentralj, ahol a faktortoltes abszoluterteke legalabb 0.5)?



# 7. Toltsd fel a teljesen megoldott ZH kodjat a hazi feladatokhoz 
# is hasznalt sajat google drive folderedbe. A file neve legyen 
# potzh_2_[neved].R (pl. potzh_2_kekecszoltan.R)



