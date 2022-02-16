#####################################
# A 10. gyakorlat gyakorlo script-je #
#####################################


# Töltsd be a szükséged package-eket. 

library(tidyverse) # for dplyr and ggplot2
library(pscl) # for pR2
library(lmtest) # for lrtest

# A Heart Disease adatbázist fogjuk használni, amely egy jól ismert adatbázis, 
# amelyet kategorizációs problémák bemutatására használnak. 
# Az adatkészlet különböző adatokat tartalmaz olyan betegekről, 
# akiket szívbetegség gyanujával vizsgáltak.

# Az alábbi kódban a "dec = "," " azt jelzi, hogy a tizedesjel ebben az 
# online adatkészletben "," (az R-ben alapértelmezett "." helyett).

heart_data = read.csv("https://raw.githubusercontent.com/kekecsz/PSZB17-210-Data-analysis-seminar/master/seminar_10/Heart_disease.csv", dec = ",")

# Az adatkészlet a következő változókat tartalmazza:
  
# - age - életkor években kifejezve
# - sex - (1 = férfi; 0 = nő)
# - cp - mellkasi fájdalom típusa (0 = tünetmentes, 1 = tipikus angina, 2 = atipikus angina, 3 = nem anginás fájdalom)
# - trestbps - nyugalmi szisztolés vérnyomás (mm Hg-ban a kórházba való felvételkor)
# - chol - szérumkoleszterin mg/dl-ben
# - fbs - (éhgyomri vércukor > 120 mg/dl) (1 = igaz; 0 = hamis)
# - restecg - nyugalmi elektrokardiográfiás eredmények: (0 = normális; 1 = ST-T-hullám eltérés; 2 = valószínű vagy biztos bal kamrai hipertrófia)
# - thalach - a terheléses vizsgálat során elért maximális pulzusszám.
# - exang - terhelés okozta angina pectoris (1 = igen; 0 = nem)
# - oldpeak - a terhelés által kiváltott ST-depresszió a nyugalomhoz képest
# - meredekség - a terhelés ST-csúcsának meredeksége
# - ca - a flouroszópiával színezett fő erek száma (0-3)
# - thal - 3 = normális; 6 = rögzített defektus; 7 = visszafordítható defektus
# - disease_status - van-e szívbetegség vagy nincs (heart_disease vs. no_heart_disease)

# Az adatkészletről további információkat itt találhatsz:
  
# Translated with www.DeepL.com/Translator (free version)

# https://www.kaggle.com/ronitf/heart-disease-uci; https://archive.ics.uci.edu/ml/datasets/Heart+Disease

### Adatmenedzsment

# Azzal kezdjük, hogy rendbe tesszük az adatállományunkat, a kategorikus 
# változókat faktorokként definiáljuk, a faktorszinteket átkódoljuk, hogy 
# informatívabbak legyenek, és olyan új változóneveket adunk, amelyek informatívabbak.

heart_data = heart_data %>% 
  mutate(sex = factor(recode(sex,
                             "1" = "male",
                             "0" = "female")),
         cp = factor(recode(cp,
                            "0" = "asymptomatic",
                            "1" = "typical_angina",
                            "2" = "atypical angina",
                            "3" = "non_anginal_pain")),
         fbs = factor(recode(fbs,
                             "1" = "true",
                             "0" = "false")),
         disease_status = factor(disease_status)
  ) %>% 
  rename(chest_pain = cp,
         sys_bloodpressure = trestbps,
         blood_sugar_over120 = fbs,
         max_HR = thalach,
         cholesterol = chol)

names(heart_data)[1] = "age"

heart_data = heart_data %>% 
  mutate(has_chest_pain = factor(recode(chest_pain,
                                        "asymptomatic" = "no_chest_pain",
                                        "typical_angina" = "has_chest_pain",
                                        "atypical angina" = "has_chest_pain",
                                        "non_anginal_pain" = "has_chest_pain"), levels = c("no_chest_pain", "has_chest_pain")),
         disease_status = factor(disease_status, levels = c("no_heart_disease", "heart_disease"))
  )

# Jó okunk van feltételezni, hogy a terheléses vizsgálat során 
# elért maximális pulzusszám (max_HR), a nyugalmi szisztolés 
# vérnyomás (sys_bloodpressure) és a mellkasi fájdalom (has_chest_pain) 
# segíthet a szívbetegség (disease_status) előrejelzésében.

# 1. Készíts logisztikus regressziós modellt, amelyben a bejósolt váltózó 
# a szívbetegség jelenléte (disease_status), a prediktorok pedig a 
# terheléses vizsgálat során elért maximális pulzusszám (max_HR), 
# a nyugalmi szisztolés vérnyomás (sys_bloodpressure) és a mellkasi 
# fájdalom jelenléte (has_chest_pain).

# 2. Mekkora ennek a modellnek az előrejelzési pontossága? Határozd meg, 
# hogy összességében mennyire pontosak az előrejelzések. 

# 3. Határozd meg a modell illeszkedését az AIC és a -2LL segítségével, 
# valamint a modell pszeudo R^2 értékét.
