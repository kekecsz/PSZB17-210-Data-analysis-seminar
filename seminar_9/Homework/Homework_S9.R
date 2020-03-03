
# 1. Toltsd be a package-eket

# 2. Olvasd be az adatokat (.csv fajl) errol a linkrol: "https://tinyurl.com/data-pain1"
# Ez az adattabla a mutet utani fajdalomrol tartalmaz adatokat, es olyan valtozokrol, amik
# kapcsolatban lehetnek a mutet utani (posztoperativ) fajdalomszinttel.
# Valtozok:
# - ID: a vizsgalati szemely azonositoja
# - pain1, pain2, pain3, pain4: Ebben a kutatasban a mutet napjan (pain1), es az azt koveto 
#   harom napban (pain2, pain3, pain4) megkertek a vizsgalati szemelyeket hogy ertekelje az
#   altala erzett fajdalom szintjet egy 0-10 vizualis analog skalan (minel magasabb, annal
#   nagyobb a fajdalom)
# - sex: nem
# - STAI_trait: A State Trait Anxiety Inventroy - t teszten elert pontertek, ami a vonasszorongas szintjet mutatja
# - pain_cat: Fajdalom-katasztrofizalas kerdoiven elert pontszam. Minel nagobb az erteke, a szemely
#   annal hajlamosabb arra hogy nagy jelentoseget es kovetkezmenyt tulajdonitson a fajdalomnak
# - cortisol_serum; cortisol_saliva: a cortisol egy stresszhormon. Ennek a szintjet mertek
#   a vizsgalati szemelyeknel a mutet utan azt kovetoen hogy megkerdeztek a fajdalomszintjukrol.
#   ezt a valtozot mind a verbol (serum), mind a nyalbol (saliva) mertek.
# - mindfulness: A mindfulness kerdoiven elert ertek, minel magasabb az erteke, a szemely annal
#   inkabb hajlamos az esemenyeket itelkezes nelkuli elfogadassal szemlelni es kezelni.
# - weight: testsuly kilogrammban
# - IQ: A szemely erteke egy intelligenciteszten a mutet elott egy hettel
# - household_income: a viszgalati szemely haztartasanak osszesitett bevetele UA dollarban

# 3. Alakitsd at az adatokat szeles formatumbol (wide format) hosszu formatumba (long format).
# Vagyis a fajdalomszint minden megfigyelese legyen kulon sorban. Ehhez hasznalhatod a gather()
# vagy a melt() funkciot

# 4. Epits egy kevert regresszios modellt amiben a fajdalom szintje a bejosolt valtozo.
# A modellben szerepeljen az ido (a muteti nap) mint fix hatasu prediktor. Szinten szerepeljen
# a modellben a vizsgalati szemelyt random hataske random intercept-kent 
# (de ne legyen megengedve a random slope).

# 5. A modell fix hatasu prediktora a fajdalom varianciajanak hany szazalekat tudja megmagyarazni? 
# Szignifikansan jobb bejosloja a fajdalomnak ez a modell mint a null modell?

# 6. Milyen az ido hatasa a fajdalomra? Ird le a legfontosabb adatokat a fajdalom regresszios egyutthatojarul:
# (regresszios egyutthato, 95%-os konfidencia intervallum, standardizalt beta)

# 7. Epits egy random slope modellt is a fentiekhez hasonloan: Itt mar legyen megengedett,
# hogy az ido hatasa kulonbozzon egyenenkent a fajdalomra.

# 8. Hasonlitsd ossze a random slope es random intercept modellek illeszkedeset a cAIC segitsegevel. Melyik modell
# illeszkedik jobban?


