library(lme4)




adat = read.csv("https://raw.githubusercontent.com/kyragiran/databases/master/univeristy_salary")


adat = adat %>% 
  mutate (rank = factor(rank),
          sex = factor(sex),
          discipline = factor(discipline))


adat$institution = rep(c("Princeton",
                      "Harvard",
                      "Columbia",
                      "MIT",
                      "UCLA",
                      "University of California Davis",
                      "Yale",
                      "Stanford",
                      "Penn State",
                      "Northwestern"), each = 40)[1:nrow(adat)]


adat$salary = adat$salary + round(rep(rnorm(n = 10, mean = 0, sd = mean(adat$salary)/20), each = 40)[1:nrow(adat)], 0)

### Need to insert errors manually!!!



mod_2 = lmer(salary ~ yrs.since.phd + yrs.service + rank + discipline + (1|institution), data = adat)
summary(mod_2)

write.csv(adat, "C:\\Users\\User\\Dropbox\\ELTE\\Teaching\\Statisztika Gyakorlat - BA\\_ZH_library\\ZH2\\ZH_2_C_dataset.csv", row.names = F)
