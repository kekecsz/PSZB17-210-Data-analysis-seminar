######################################
# Az 5. gyakorlat gyakorló script-je #
######################################


# 
# 1. Töltsd be a tidyverse csomagot!

# 2. Töltsd be az adatokat. Ezt a 
# https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_05/S05_orai_adat.csv

# url-ről tudod betölteni. Használd a betöltéshez a read.csv() vagy a read_csv() funkciókat.

# Az adatok egy (kepzeletbeli) randomizalt kontrollalt klinikai kutatas eredmenyeibol szarmaznak, ahol a **pszichoterapia hatekonysagat** teszteltek. Olyan szemelyeket vontak be a kutatasba, akik egy **hurrikan aldozatai** voltak, es **szorongassal** kuszkodtek. A szemelyeknel felmertek a reziliancia (psziches ellenallokepesseg) szintjet, majd veletlenszeruen osztottak a szemelyeket egy kezelesi vagy egy kontrol csoportba. Ezt kovetoen a kezelesi csoport **pszichoterapiat kapott 6 heten keresztul** heti egyszer, mig a kontrol csoport nem kapott kezelest. A vizsgalat vegen megmertek a szemelyek **szorongasszintjet**, es a klinikai kriteriumok alapjan meghataroztak, hogy a szemely **gyogyultnak, vagy szorongonak** szamit-e.	

# Lathatjuk, hogy 8 valtozo van az adattablaban. 	

# - participant_ID - reszvevo azonositoja	
# - gender - nem	
# - group - csoporttagsag, ez egy faktor valtozo aminek ket szintje van: "treatment" (kezelt csoport), es "control" (kontrol csoport). A "treatment" csoport kapott kezelest, mig a "control" csoport nem kapott kezelest.	
# - resilience - reziliancia: a nehezsegekkel valo megkuzdes kepessege, ez egy szemlyes kepesseg, olyasmi mint a szemelyisegvonasok	
# - anxiety - szorongas szint	
# - health_status - a klinikai kriteriumok alapjan szorongonak vagy gyogyultnak tekintheto a szemely 	
# - home_ownership - lakhatasi helyzet: harom szintje van az alapjan hogy a szemely hol lakik: "friend" - baratnal vagy csaladnal lakik, "own" - sajat tulajdonu lakasban lakik, "rent" - berelt lakasban lakik, 	
# - height - magassag	

# 3. Teszteld a hipotezist, hogy "Tobb a ferfi mint a no ebben a klinikai mintaban" (**gender** valtozo)	

# - Ezt ugyan ugy teheted meg, mint az orai peldaban, hiszen a null-hipotezis az, hogy a ferfiak ("male") elvart valoszinusege 50% vagy kevesebb (p = 0.5). Szoval a ferfiak ekvivalensek a "fejekkel" a penzfeldobasos peldaban.	
# - Meg kell hataroznod a ferfiak szamat a mintaban, es a teljes mintaelemszamot, hogy ki tudd tolteni a binom.test() fuggveny parametereit.	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


# 4. Teszteld a 2. hipotezist, hogy "A pszichoterapiat kapo csoportban a terapia utan kevesebb lesz a klinikai kriteriumok alapjan szorongonak szamito szemely" (**health_status** vs. **group**)	

# - Ezt ugyan ugy teheted meg, mint az orai peldaban, hiszen a null-hipotezis az, hogy nincs kulonbseg a csoporttagsag szerint (treatment vs. control) abban hogy milyen aranyban gyogyultak meg a kutatas vegere.	
# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a table() funkcioval es egy abraval (mondjuk geom_bar() hasznalataval) 	
# - A tablazatot mentsd el egy uj objektumba	
# - Ez utan vegezd el a tesztet, chisq.test()	
# - Es ird le a fentiek szerint az eredmenyeket.


# 5. Teszteld a 3. hipotezist, hogy "A terapias csoportban alacsonyabb lesz a szorongas atlaga a kutatas vegere mint a kontrol csoportban" (**anxiety** vs. **group**)	

# - Eloszor vegezzunk egy feltaro elemzest egy tablazattal a ket valtozo kapcsolatarol a summarize(mean(), sd()) funkciokkal, es keszitsunk abrat, mondjuk geom_boxplot() segitsegevel.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Melyik tesztet erdemes hasznalni, az egyvaltozos ANOVA-t, vagy a t-tesztet? (gondolj arra, hogy hany csoport (szint) van a kategorikus valtozon belul)	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


# 6. Teszteld a 4. hipotezist, hogy "A reziliancia es a kutatas vegen mert szorongasszint negativ osszefuggest fog mutatni (vagyis aki reziliensebb, annal alacsonyabb szorongasszintet fognak merni a kutatas vegen)" (**anxiety** vs. **resilience**)	

# - Eloszor vegezzunk egy feltaro elemzest a korrelacios egyutthato meghatarozasaval es egy pontdiagrammal a ket valtozo kapcsolatarol.	
# - egy- vagy ketoldalu tesztet kell alkalmaznunk? (gondolj arra, hogy a hipotezisunkben megjosoljuk-e a hatas vagy kulonbseg iranyat vagy sem)	
# - Mi a null-hipotezis ebben az esetben?	
# - Ez utan vegezd el a tesztet	
# - Es ird le a fentiek szerint az eredmenyeket.	


