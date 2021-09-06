####################################
#          Hazi feladat            #
####################################

# 1. toltsd be a hazi feladat megoldasahoz hasznalt package-eket 
# (az alabbi feladatok a tidyverse es a psych packagekkel megoldhatoak)

# 2. toltsd be az adatot errol az URL-rol (ez egy .csv file) a mar korabban megismert adatbeolvaso funkcioval:
#"https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_5/Homework/homework_data.csv"
#
# Az adatok szimulalt adatok, de kepzeljuk el hogy egy randomizalt 
# kontrollalt klinikai kutatas eredmenyeibol szarmaznak, ahol a 
# pszichoterapia hatekonysagat teszteltek. Olyan szemelyeket vontak 
# be a kutatasba, akik egy hurrikan aldozatai voltak, es szorongassal 
# kuszkodtek. A szemelyeknel felmertek a reziliancia szintjet, majd 
# veletlenszeruen osztottak a szemelyeket egy kezelesi vagy egy 
# kontrol csoportba. Ezt kovetoen a kezelesi csoport pszichoterapiat 
# kapott 6 heten keresztul heti egyszer, mig a kontrol csoport nem 
# kapott kezelest. A vizsgalat vegen megmertek a szemelyek 
# szorongasszintjet, es a klinikai kriteriumok alapjan meghataroztak,
# hogy a szemely gyogyulnak, vagy szorongonak szamit-e.	
#
# Lathatjuk, hogy 10 valtozo van az adattablaban. 	
#
# - participant_ID - reszvevo azonositoja	
# - gender - nem
# - group - csoporttagsag, ez egy faktor valtozo aminek ket szintje van: "treatment" (kezelt csoport), es "control" (kontrol csoport). A "treatment" csoport kapott kezelest, mig a "control" csoport nem kapott kezelest.	
# - resilience - reziliancia: a nehezsegekkel valo megkuzdes kepessege, ez egy szemlyes kepesseg, olyasmi mint a szemelyisegvonasok	
# - anxiety - szorongas szint	
# - health_status - a klinikai kriteriumok alapjan szorongonak vagy gyogyultnak tekintheto a szemely 	
# - home_ownership - lakhatasi helyzet: harom szintje van az alapjan hogy a szemely hol lakik: "friend" - baratnal vagy csaladnal lakik, "own" - sajat tulajdonu lakasban lakik, "rent" - berelt lakasban lakik, 
# - height - magassag
# - has_children - egy kategorikus valtozo ami arrol informal minket hogy a szemelynek-e gyermekei (has_children) vagy nincsenek (no_children) 
# - left_before_hurricane - egy numerikus valtozo ami azt mutatja meg, hany nappal a hurrikan elott hagyta el az otthonat a szemely (0, 1, 2, vagy 3)

# 3. Jelold faktorkent azokat a valtozokat, amiket faktor valtozonak itelsz

# 4. Vegezz az adatokon alapveto adatellenorzo muveleteket (mondjuk a summary, es describe fuggvenyekkel, es abrakkal, ha szukseges)
# Ellenorizd hogy vannak-e furcsa vagy hibas adatok, es ha vannak ilyenek, javitsd ki oket. (Egyes adatpontok atjavitasara peldat a negyedik orai script-ben es hazi feladatban talalsz)
# Van olyan, hogy egy numerikus valtozot karaktervektorkent eszlel az R, ha van benne akar egy szoveges ertek is. Ilyenkor a szoveges ertek szamra vagy NA-ra cserelese utan is karaktervektor marad a valtozo. Ebben az esetben a hiba javitasa utan erdemes az adott valtozot az as.numeric() fugvennyel numerikus valtozokent megjelolni.
# Erdemes ellenorizni, hogy sikerult-e minden adatot helyesen javitani azzal, hogy ujra lefuttatjuk az adatellenorzo muveleteket.

# 5. Teszteld a kovetkezo hipoteziseket: 
# Minden egyes hipotezis eseten eloszor vegezz leiro (exploratoros) elemzest a megfelfelo tablazatokkal es abrakkal.
# Az elemzes elvegzese utan roviden ird le hogy hogyan ertelmezhetjuk az eredmenyeket.
# Az egyes statisztikai tesztek eredmenyenek leirasahoz hasznald az irai jegyzet pdf. valtozatat:
# https://osf.io/4tvd2/
#
# Hipotezis 1. Azok, akiknek van gyermeke (**has_children**), atlagosan magasabb szorongassal
#jellemezhetoek, mint azok akiknek nincs gyermeke
#
# Hipotezis 2. A vizsgalati szemelyek tobb mint 50%-a gyogyultnak mondhato a kutatasvegere (**health_status**)
#
# Hipotezis 3. Van kapcsolat a lakhatasi helyzet (**home_ownership**) es a kozott 
# hogy a szemelynek van-e gyermeke (**has_children**)
#
# Hipotezis 4. Azok, akiknek a hurrikan napjan hagytak el az otthonukat 
# (vagyis akiknel a **left_before_hurricane** erteke 0), atlagosan 
# szorongobbak a kutatas vegen, mint akik hamarabb hagytak el az 
# otthonukat (vagyis akiknel a **left_before_hurricane** erteke 1, 2, vagy 3) 
# (Ennek a hipotezisnek a helyes tesztelesehez elkepzelheto hogy csinalnod kell 
# egy uj valtozot a left_before_hurricane valtozobol)






