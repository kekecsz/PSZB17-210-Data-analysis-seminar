# 1. toltsd be a ZH megoldasahoz hasznalt package-eket, ha szukseges, installald is a 
# package-eket betoltes elott (az alabbi feladatok a tidyverse es a psych packagekkel megoldhatoak) - 1 pont

# 2. toltsd be az adatot errol az URL-rol (ez egy .csv file). - 1 pont
#"https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar-exams/master/ZH-1/weight_loss_data_for_exam.csv"
#
# Olvasd el figyelmesen az adat leirasat, mert az adatok ismerete szukseges az alabbi feladatok megoldasahoz
#
# Az adatbazis egy olyan kutatas szimulalt adatait  tartalmazzam ahol kulonbozo kezelesek hatekonysagat 
# teszteltek a sulyvesztesre tulsolyos szemelyeknel. 	
# Valtozok:	
# - ID - vizsgalati szemlely azonositojele	
# - Gender - nem, egy faktor valtozo aminek ket szintje van: "female" = no, "male" = ferfi
# - Age - eletkor, numerikus folytonos valtozo, ami azt mutatja hany eves a vizsgalati szemely. 
# Csak pozitiv egesz szam erteket vehet fel, es csak 18 even feluliek vehettek reszt a kutatasban.
# - BMI_baseline - Body mass index (BMI) a kezeles elott. Numerikus folytonos valtozo, ami csak pozitiv 
# egesz szamot vehet fel. A kutatasban csak tulsulyos (BMI > 25) szemelyek vehettek reszt.
# - BMI_post_treatment - Body mass index (BMI) a kezeles utan	
# - treatment_type - A kezeles amit a vizsgalati szemely kapott, egy faktor valtozo aminek 
# negy szintje van: "no_treatment" - nem kapott kezelest; "pill" - etvagycsokkento gyogyszer; 
# "psychotherapy" - kognitiv behavior terapia (CBT); "pill_and_psychotherapy" - mind gyogyszeres, 
# mind CBT kezelesben reszesult)	
# - motivation - onbevallasos motivacioszint a fogyasra (0-10-es skalan, ahol a 0 extremen 
# alacsony motivacio a fogyasra, a 10 pedig extremen magas motivacio a fogyasra). Csak pozotiv egesz 
# szam erteket vehet fel 0 es 10 kozott.
# - body_acceptance - a szemely mennyire erzi elegedettnek magat jelenleg testevel (-7 - +7, ahol 
# a - 7 nagyon elegedetlen, a +7 nagyon elegedett). Csak egesz szam erteket vehet fel -7 es 7 kozott.

# 3. Jelold faktorkent a faktor valtozokat (a fenti leiras alapjan) - 1 pont

# 4. Keszits egy uj valtozot az adattablaban. Az egyik valtozonak legyen a neve "pill" es mindenki aki
# kapott gyogyszeres kezelest (a treatment_type valtozo szerint "pill" vagy "pill_and_psychotherapy" 
# csoportba tartozik) ezen a valtozon vegyen fel "pill" erteket, mindenki mas pedig "no_pill" erteket. '
# - 1 pont

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
# Hipotezis 1. Van kulonbseg a kezelesi csoportok (treatment_type) kozott a kezeles elotti BMI 
# ertekben - 4 pont
#
# Hipotezis 2. Azoknak a szemelyek, akik kaptak gyogyszeres kezelest ("pill", "pill_and_psychotherapy")
# atlagosan alacsonyabb volt a kezeles utani BMI-je mint azoknak, akik nem kaptak 
# gyogyszeres kezelest. - 5 p
#
# Hipotezis 3. Van egyuttjaras az eletkor es a kezeles elotti BMI kozott, meghozza 
# azok akik idosebbek magasabb a BMI-juk a kezeles elott. - 4 pont
#
# Hipotezis 4. A kezeles utan az "elhizott" kategoriaba esok aranya (azok, akiknek a BMI-je
# legalabb 30 vagy magasabb) kulonbozik azoknal akik nem kaptak semmijen kezelest ("no_treatment") 
# azokhoz kepest akik kaptak valamilyen fajta kezelest ("pill", "psychotherapy", "pill_and_psychotherapy").
# Lehet hogy ennek a hipotezisnek a tesztelesehez uj valtozo(ka)t kell csinalnod. - 6 p

