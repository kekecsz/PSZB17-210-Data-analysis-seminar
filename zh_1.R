# 1. toltsd be a ZH megoldasahoz hasznalt package-eket, ha szukseges, installald is a 
# package-eket betoltes elott (az alabbi feladatok a tidyverse es a psych packagekkel megoldhatoak) - 1 pont

# 2. toltsd be az adatot errol az URL-rol (ez egy .csv file). - 1 pont
#"https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-1/data_ZH_1.csv"
#
# Olvasd el figyelmesen az adat leirasat, mert az adatok ismerete szukseges az alabbi feladatok megoldasahoz
#
# Az adatok szimulalt adatok, de kepzeljuk el hogy egy randomizalt 
# kontrollalt kutatas eredmenyeibol szarmaznak, ahol a halolaj tabletta hatasat
# teszteltek varandos noknel a gyermekuk intelligencia hanyadosara (IQ). 
# Ez egy utankoveteses vizsgalat volt, ahol eloszor veletlenszeruen vagy egy kiserleti vagy
# egy kontrol csoportba soroltak a resztvevo varandos noket. A kiserleti csoportban ("halolaj" csoport)
# a nok naponta egy halolaj tablettat fogyasztottak a masodik trimesztertol a szulesig.
# A kontrol csoportban("kontrol" csoport) pedig nem fogyasztottak halolaj tablettat. 
# Azt is rogzitettek, hogy a varandos no nagyvarosban vagy videken lakik, hogy milyen a vegzettsege,
# es hogy mekkora az IQ-ja.
# Amikor a gyermekek elerte 18-adik eletevet, a kutatok felkerestek oket, es felmertek
# az IQ-jukat.
#
# Az adatok kozott 5 valtozo szerepel:
# - csoport - A resztvevo no csoporttagsaga: ez egy faktor valtozo aminek ket szintje lehet: "halolaj" (kiserleti csoport), es "kontrol" (kontrol csoport).
# - anya_lakohely - A resztvevo varandos no lakhelye a csoportba sorolas napjan: ez egy faktor valtozo aminek ket szintje lehet: "videk", es "nagyvaros".
# - anya_vegzettseg - A resztvevo varandos no legmagasabb iskolai vegzettsege a csoportba sorolas napjan: ez egy faktor valtozo aminek harom szintje lehet: "alapfoku", "kozepfoku", es "felsofoku".
# - IQ - a varandos no gyermekenek IQ-ja amikor 18 eves lett: ez egy numerikus valtozo ami 50 es 150 kozotti ertekeket vehet fel. 
# - anya_IQ - a varandos no sajat IQ-ja a csoportba sorolas napjan: ez egy numerikus valtozo ami 50 es 150 kozotti ertekeket vehet fel. 
#

# 3. Jelold faktorkent a faktor valtozokat (a fenti leiras alapjan) - 1 pont

# 4. Jelold sorrendezett (ordinalis) valtozokent az "anya_vegzettseg" valtozot ugy,
# hogy a kovetkezo legyen a faktorszintek sorrendje: "alapfoku", "kozepfoku", "felsofoku" - 1 pont

# 5. Vegezz az adatokon alapveto adatellenorzo muveleteket. - 7 pont
# Ellenorizd hogy vannak-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket.
# A javitasokat koddal csinald (hogy reprodukalhato es atlathato legyen, mit csinaltal pontosan).
# Ellenorizd, hogy sikerult-e minden adatot helyesen javitani (ez az ellenorzes is szerepeljen a kodban).
# Ha a javitas soran vannak olyan faktorszintek amikbol mar nem marad egy megfigyeles sem, ejtsd ezeket a
# faktorszinteket a droplevels() funcioval
# A javitott adatfajlt mentsd el egy uj objektumba, es a kovetkezo lepesekben mar ezzel a javitott adattablaval dolgozz.

# 6. Teszteld a kovetkezo hipotezisekben felsorol hipoteziseket.
# Minden egyes hipotezis eseten eloszor vegezz leiro elemzest a megfelfelo tablazatokkal vagy osszegzo adatokkal, es abrakkal.
# Az elemzes elvegzese utan roviden ird le hogy hogyan ertelmezed az eredmenyeket.
# A szoveges elemzesben mindig szerepeljenek a relevans szamszeru adatok is, mint pl. 
# teszt-statisztika erteke, szabadsagfok, p-ertek, es amikor ez relevans, a hatas meretenek pontbecslese es konfidencia intervalluma
#
# Hipotezis 1. A kiserleti csoport tagjainak gyermekeinek magasabb az IQ atlaga, mint a kontrol csoport tagjainak gyermekeinek az IQ atlaga - 5 pont
#
# Hipotezis 2. Van egyuttjaras az anyak es a gyermekeik IQ szintje kozott. - 4 pont
#
# Hipotezis 3. Van osszefugges az anya lakohelye es az anya iskolai vegzettsege kozott - 4 pont
#
# Hipotezis 4. Azoknak az anyaknak, akiknek felsofoku volt az iskolai vegzettseguk, atlagosan magasabb 
# IQ-ju gyermekei lettek, mint azoknak az anyaknak, akiknek alapfoku vagy kozepfoku vegzettsoguk volt
# (Ennek a hipotezisnek a helyes tesztelesehez elkepzelheto hogy csinalnod kell 
# egy uj valtozot az anya_vegzettseg valtozobol) - 6 pont
#
# 7. Toltsd fel a teljesen megoldott ZH kodjat a hazi feladatokhoz is hasznalt sajat google drive folderedbe. A File neve legzen zh_1_[neved].R (pl. zh_1_kekecszoltan.R)


