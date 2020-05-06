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


