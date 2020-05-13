# 1. Toltsd be a szukseges package-eket. - 1/1 pont
#
# (Vigyazz, hogy ha mind a car mind a tidyverse package-eket hasznalod,
# akkor a tidyverse pacakge-et toltsd be kesobb, mert kulonben a car package
# felulirja a recode() funkciot!)

# 2. Toltsd be az adatbazist amivel dolgozni fogunk az alabbi url-rol,  - 1/1 pont
# (ez egy .csv file): 
# "https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-2/univeristy_salary_inst.csv"

# Olvasd el figyelmesen az adat leirasat, mert az adatok ismerete szukseges az alabbi feladatok megoldasahoz

# Az adatok amerikai egyetemek Assistant Professor, Associate Professor es Professor munkakort betolto tanarainak 9 havi
# fizeteset mutatjak a 2008-09 tanevben. Az adatokat azert gyujtottek, hogy ellenorizni tudjak, nincs a ferfi es noi alkalmazottak kozt berkulonbseg.
# A ZH kedveert kisse modositottuk az adattablat, igy az nem az eredeti adatokat tartalmazza.

# rank: faktor valtozo "AsstProf" (adjunktus), "AssocProf" (docens), "Prof" (egyetemi tanar) szintekkel
# discipline: faktor valtozo A ("elmeleti" tanszekek) es B ("alkalmazott" tanszekek).
# yrs.since.phd: numerikus valtozo, a phd fokozat megszerzese ota eltelt ido
# yrs.service: numerikus valtozo, a palyan toltott evek szama
# sex: faktor valtozo "Female" es "Male" szintekkel.
# salary: 9 havi fizetes dollarban.
# institution: a szemely munkahelye (az egyetem neve ahol a szemely dolgozik, 10 kulonbozo egyetemrol szarmaznak valaszadok)

# 3. jelold faktorkent a kategorikus valtozokat  - 1/1 pont

# 4. Vegezz az adatokon alapveto adatellenorzo muveleteket. - 4/4 pont
# Ellenorizd hogy vannak-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket.
# A javitasokat koddal csinald (hogy reprodukalhato es atlathato legyen, mit csinaltal pontosan).
# Ellenorizd, hogy sikerult-e minden adatot helyesen javitani (ez az ellenorzes is szerepeljen a kodban).
# Ha a javitas soran vannak olyan faktorszintek amikbol mar nem marad egy megfigyeles sem, ejtsd ezeket a
# faktorszinteket a droplevels() funcioval
# A javitott adatfajlt mentsd el egy uj objektumba, es a kovetkezo lepesekben mar ezzel a javitott adattablaval dolgozz.

# 5. Teszteld a kovetkezo hipotezist: Az egyetemi tanárok ("Prof") tobbet keresnek mint akik meg 
# nem egyetemi tanarok ("AsstProf" vagy "AssocProf"). A statisztikai teszt elvegzese elott vegezz
# feltaro (exploratoros) elemzest - 5/5 p

# 6. Ebben a feladatbansorban egy regresszios modellt kell majd epitened, es
# annak felhasznalasaval kell majd kulonbozo feladatokat elvegezned. - 13/13 p

# Az egyetemnek szukos a koltsegvetese, de muszaj felvennie meg egy tanart az egyik tanszekre. 
# A kovetkezo szemelyek jonnek szoba:
# Az elso jelentkezonek 8 eve van phd-ja, es 12 eve van a szakamajaban, jelenleg docens ("AssocProf") egy elmeleti tanszeken ("A")
# A masodik jelentkezo 15 eve kapta meg a phd fokozatot, 20 eve van a palyan, jelenleg egyetemi tanar ("Prof") egy elmeleti tanszeken ("A")
# A harmadik jelentkezo 2 eve kapta meg a phd-jat, es 7 eve van a palyan, jelenleg adjunktus ("AsstProf") egy alkalmazott tanszeken ("B")
# A dekan szeretne fizetes-ajanlatot adni a jelentkezoknek. 
# Epits egy regresszios modellt a fizetes becslesere, amiben figyelembe veszed a yrs.since.phd,
# a yrs.service a rank es a discipline prediktorokat is.

# 6.a. Becsuld meg a modell alapjan hogy mi lehet a jelenlegi fizetese a fenti harom jelentkezonek.

# 6.b. A prediktorok kozul melyiknek van a legnagyobb a hozzaadott bejoslo ereje a modellben, es
# melyik prediktornak a legksebb a hozzadott bejoslo ereje?

# 6.c. Ellenorizd a rezidualisok normalitasat a fenti modellben.
# Vannak olyan jelek amik arra utalnak hogy serul a rezidualisok normalitasanak feltetele? Ha igen, mik ezek?

# 6.d. Ird le egy kommentben hogy milyen megoldast valasztanal a normalitas serulesenek
# kezelesere ebben a modellben.

# 6.e Ellenorizd a homoszkedaszticitast a fenti modellben.
# Vannak olyan jelek amik arra utalnak hogy serul a homoszkedaszticitas feltetele?
# Ha igen, mik ezek?

# 6.f. Ird le egy kommentben hogy milyen megoldast valasztanal a homoszkedaszticitas serulesenek
# kezelesere ebben a modellben.

# 7. Epits egy olyan modellt, ami a fenti prediktorkon kivul figyelembe veszi a 
# szemely nemet (sex) is a fizetes becslese soran. Ebben a modellben azt is vedd szamitasba,
# hogy az adatok 10 kulonbozo egyetemrol (institution) szarmaznak. Amikor ezt a modellt epited, fontos
# figyelembe venni hogy az egyetemunkre nagyon sok mas egyetemrol is erkeznek jelentkezok,
# ezert az institution valtozot celszeru random hataskent figyelembe venni. 
# Nincs okunk feltetelezni hogy az intezmenynek hatasa lenne a fix hatasu prediktorokra,
# ezert epits egy random intercept modellt (ne hasznalj random slope-ot).
# Mekkora a megmagyarazott varianciaarany az elozo feladatban epitett egyszerubb modellben, 
# es mekkora ebben a bonyolultabb modellben? - 5/5 p

# 8. Toltsd fel a teljesen megoldott ZH kodjat a hazi feladatokhoz 
# is hasznalt sajat google drive folderedbe. A file neve legyen 
# zh_2_[neved].R (pl. zh_2_kekecszoltan.R)




