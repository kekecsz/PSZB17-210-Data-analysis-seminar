##################################################################
#       PSZB17-210 - Adatelemzes gyakorlat ZH - 2020.12.08       #
##################################################################

# 1. toltsd be a ZH megoldasahoz hasznalt package-eket, ha szukseges, installald is a 
# package-eket betoltes elott - 1 pont

# (Vigyazz, hogy ha mind a car mind a tidyverse package-eket hasznalod,
# akkor a tidyverse pacakge-et toltsd be kesobb, mert kulonben a car package
# felulirja a recode() funkciot! Altalanossagban jo otlet mindig a tidyverse
# package-et betolteni utoljara)

# 2. Toltsd be az adatbazist amivel dolgozni fogunk az alabbi url-rol,  - 1 pont
# (ez egy .csv file): 
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/surgicalpain_dataset_20201130.csv"
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

# 4. jelold faktorkent a kategorikus valtozokat  - 1 pont

# 5. Vegezz az adatokon alapveto adatellenorzo muveleteket. - 4 pont
# Ellenorizd hogy vannak-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket.
# A javitasokat koddal csinald (hogy reprodukalhato es atlathato legyen, mit csinaltal pontosan).
# Ellenorizd, hogy sikerult-e minden adatot helyesen javitani (ez az ellenorzes is szerepeljen a kodban).
# A javitott adatfajlt mentsd el egy uj objektumba, es a kovetkezo lepesekben mar ezzel 
# a javitott adattablaval dolgozz.

# 6. A muteti fajdalomrol korabbi kutatasokbol tudjuk, hogy az eletkor es 
# a nem is befolyasolhatja. - 5 pont
# - Epits egy regresszios modellt, amiben a fajdalom szintjet az eletkor 
# es a nem prediktorok segitsegevel becsuljuk meg.
# - A modell szerint a nok vagy a ferfiak szamolnak be magasabb fajdalomrol? 
# - Ez alapjan a regresszios modell alapjan becsuld meg  mekkora a varhato fajdalomszintje
# egy 40 eves nonek, egy 45 eves nonek, es egy 25 eves ferfinak.

# 7. Az uj kutatas fo celja, hogy megtudjuk, pszichologiai valtozok figyelembevetele segithet-e 
# a fajdalom jobb bejoslasaban. Ennek a kerdesnek a megvalaszolasahoz hierarchikus regressziot
# fogunk hasznalni. - 6 pont
# - Eloszor is epits egy uj regresszios modellt, amiben a fajdalom
# bejoslasara az eletkor, nem, STAI_trait, pain_cat, cortisol_serum, 
# cortisol_saliva, es a mindfulness valtozokat hasznaljuk mint prediktorokat. 
# Ezek a prediktorok ugyanabban a modellben szerepeljenek.
# - Ezutan hasonlitsd ossze, hogy ez az uj modell, vagy a korabban epitett
# modell (amiben csak az eletkor es a nem szerepelt) illeszkedik jobban az adatokhoz
# az AIC modellilleszkedesi mutato alapjan.
# - Hatarozd meg, hogy a fajdalom varianciajanak hany szazalekat kepes magyarazni a regi
# es az uj modell.
# - Ezek alapjan vond le a kovetkeztetest, hogy szerinted erdemes-e figyelembe venni a
# pszichologiai tenyezoket (STAI_trait, pain_cat, cortisol_serum, cortisol_saliva, es 
# mindfulness) a fajdalom varhato szintjenek meghatarozasakor, vagy eleg csak a nemre
# es az eletkorra koncentralni? Indokold dontesedet a fenti adatokkal.
# - Mi az age (eltkor) valtozo regresszos egyutthatojanak konfidencia intervalluma az uj
# regresszios modellben, es ez alapjan milyen kovetkeztetest vonhatunk le a 
# prediktorral kapcsolatban?

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
# zh_2_[neved].R (pl. zh_2_kekecszoltan.R)

