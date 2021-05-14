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

# 7. A kovetkezo feladatban az Animal Rights Scale (ARQ) adatbazissal dolgozunk majd.- 13/13 pont

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
# Ebben a feladatban az Animal Rights Scale (ARQ) itemei mogott
# megbuvo latens faktorok feltarasat vegezzuk majd el feltaro faktorelemzes segitsegevel. 
# Az adatbazisban az ARQ itemeire adott valaszok az elso 28 oszlopban szerepelnek. 
# Fontos, hogy a faktorelemzesbe csak ezek a valtozok keruljenek bele, es az adatbazisban
# szereplo tobbi valtozo ne keruljon a faktorelemzesbe. 
#
# Vegezd el a feltaro faktorelemzest az ARQ tetelei mogott rejlo latens
# faktorok felderitesere.

# Eloszor is toltsd be az adatbazist. 
# Az adatbazis errol a linkrol elerheto (ez egy .csv file):
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/animalrights.csv"

# Az skala 28 itemenek polychoric korrelacios matrixa az alabbi linken elerheto: 
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/plycor_arq.csv"

# - Vizsgald meg, hogy a tobbvaltozos normalis eloszlas feltetele teljesul-e.
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

# 8. Toltsd fel a teljesen megoldott ZH kodjat a hazi feladatokhoz 
# is hasznalt sajat google drive folderedbe. A File neve legyen 
# zh_2_pot_[neved].R (pl. zh_2_pot_kekecszoltan.R)




