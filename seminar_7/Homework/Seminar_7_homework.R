### Hazi feladat

# 1. toltsd be a lakasarak adatbazist (az oran hasznalt valtozatat itt talalod: https://bit.ly/2DpwKOr)
# 2. Alakitsd at az adatokat ugy hogy dollar helyett forintban legyen a price valtozo (1 USD nagyjabol 294 HUF), 
# es negyzetlab helyett negyzetmeterben szerepljenek az adatok (ez a kovetkezo valtozokat erinti: 
# sqft_living, sqft_lot, sqft_above, sqft_basement, sqft_living15, sqft_lot15) (1 negyzetlab = 0.09 m^2)
# 3. futtass le egy korrelacios tesztet hogy meghatarozd, van-e egyuttjaras a lakas ara es a lakas allapota (condition) kozott (cor.test())
# 4. Illessz egy egyszeru regresszios modellt amelyben a lakas arat (price) josolod be a lakas allapotaval (condition)
# 5. Hasonlitsd ossze a teljes model F-teszt p-erteket, a condition regresszios egyutthatojahoz tartozo p-erteket, es a korrelacios teszt p-erteket. Mit veszel eszre?
# 6. Hasonlitsd ossze az R^2 mutatot es a korrelacios egyutthato negyzetet. Mit veszel eszre?
# 7. Most javitsd ezt a modelt ujabb prediktorok hozzaadasaval (hasznalj legalabb 3 prediktort a modellben).
# 8. Mekkora a modell altal megmagyarazott varianciaarany?
# 9. Hasonlitsd ossze az egyszeru regresszios modell bejoslo erejet a tobbszoros regresszios modell bejoslo erejevel. (Hasznald az anova()) funkciot, igy: anova(model1, model2)) Szignifikansan jobb a bejoslo ereje a tobbszoros regresszios modellnek?
# 10. Ird le a tobbszoros regresszios modell eredmenyet a gyakorlati jegyzet alapjan. Szerepeljen benne mindaz az informacio a teljes modellrol es a prediktorokrol amit a gyakorlati jegyzet javasol.
