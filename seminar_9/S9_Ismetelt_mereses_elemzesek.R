# ---	
# title: "Kevert modellek - Ismetelt mereses elemzesek"	
# author: "Zoltan Kekecs"	
# date: "19 november 2019"	
# 
# # Absztrakt	

# Ez a gyakorlat az ismetelt mereses elemzessekkel foglalkozik. Amikor az elemzesunkben ugyan attol a vizsgalati szemelytol tobb adat is szerepel ugyan abbol a valtozobol, ismetelt mereses elemzest vegzunk (pl. a szemely kezeles elotti es utani depresszio szintje).	

# # Adatmenedzsment es leiro statisztikak	

# ## Package-ek betoltese	

# A kovetkezo package-ekre lesz szukseg a gyakorlathoz:	


library(psych) # for describe	
library(tidyverse) # for tidy code and ggplot	
library(cAIC4) # for cAIC	
library(r2glmm) # for r2beta	



# ## Sajat funkcio	

# Ezzel a funkcioval kinyerhetjuk a standardizalt Beta egyutthatot a kevert modellekbol.	
# Ez a funkcio innen lett atemelve: 	
# https://stackoverflow.com/questions/25142901/standardized-coefficients-for-lmer-model	


stdCoef.merMod <- function(object) {	
  sdy <- sd(getME(object,"y"))	
  sdx <- apply(getME(object,"X"), 2, sd)	
  sc <- fixef(object)*sdx/sdy	
  se.fixef <- coef(summary(object))[,"Std. Error"]	
  se <- se.fixef*sdx/sdy	
  return(data.frame(stdcoef=sc, stdse=se))	
}	



# ## Sebgyogyulas adat betoltese	

# A gyakorlat soran a sebgyogyulas adatbazissal fogunk dolgozni. Ez egy szimulat adatbazis, ami a mutet soran ejtett bemetszesek gyogyulasat vizsgaljuk annak fuggvenyeben hogy a paciensek agya milyen kozel van az ablakhoz, es hogy mennyi napfeny eri oket a felepules idoszak alatt. Mondjuk hogy az az elmeletunk hogy a korhazi betegeknek szukseguk van a kulvilaggal valo kapcsolatra ahhoz hogy gyorsan felepuljenek. Egy ablak ami a szabadba nyilik megteremtheti ezt a kapcsolatot a kulvilaggal, ezert a kutatasunk azt vizsgalja, hogy befolyasolja-e a sebgyogyulas merteket az, hogy a szemelynek milyen kozel van az agya a legkozelebbi ablakhoz. Az elmelet egy valtozata azt allitja, hogy az ablak nem csak a kulvilaggal valo szorosabb kapcsolat megteremtesen keresztul vezet gyorsabb gyogyulashoz, hanem azon keresztul is hogy tobb napfenyt enged a szobaba, es az elmelet szerint a napfeny is jotekony hatassal van a gyogyulasra. 	

# Valtozok az adatbazisban:	

# - ID: azonosito kod	
# - day_1, day_2, ..., day_7: A mutet utani 1-7. napon egy orvos megvizsgalta a pedeg bemetszesi sebeit, es ertekelte azokat egy standardizalt seb-allapot ertekkel. Minel nagyobb ez az ertek, annal nagyobb vagy rosszabb allapotu a seb (pl. gyulladt). Minden szemelynek mind a 7 naphoz kulon seb-allapot ertek tartozik.	
# - distance_window: A szemely agyahoz legkozelebbi ablak tavolsaga az agytol meterben.	
# - location: A korhazi szarny, ahol a paciens agya van. Ket allasu faktor valtozo: szintjei "north wing" es "south wing" (a "south wing"-ben tobb napfeny eri a pacienseket, ez a valtozo azert fontos). 	



data_wound = read_csv("https://raw.githubusercontent.com/kekecsz/PSYP13_Data_analysis_class-2018/master/data_woundhealing_repeated.csv")	
	
# asign ID and location as factors	
data_wound = data_wound %>% 	
  mutate(ID = factor(ID),	
         location = factor(location))	
	


# ## Adatellenorzes	

# Vizsgaljuk meg az adattablat a View(), describe(), es table() fukciok segitsegevel. Fontos, hogy az adattablaban jelenleg minden adata mit egy adott szemelytol gyujtottek egy sorban talalhato. Vizualizalhatjuk is az adatokat. 	



View(data_wound)	
	
# descriptives	
describe(data_wound)	
table(data_wound$location)	
	


# Az alabbi abra elkeszitesehez eloszor a day1-day7 valtozokban kulon-kulon kiszamoljuk az atlagokat es a standard hibat, majd a standard hibat megszorozva 1.96-al megkapjuk a konfidencia intervallumot. Vegul mindezt egy uj adat objektumba tesszuk, es a geom_errorbar, geom_point, es geom_line segitsegevel viualizaljuk. Lathato hogy a seb allapot ertek egyre csokken ahogy telnek a napok.	



# designate which are the repeated varibales	
repeated_variables = c("day_1", "day_2", "day_3",	"day_4", "day_5",	"day_6",	"day_7")	
	
# explore change over time	
wound_ratings = describe(data_wound[,repeated_variables])$mean	
repeated_CIs = describe(data_wound[,repeated_variables])$se*1.96	
days = as.numeric(as.factor(repeated_variables))	
days = as.data.frame(days)	
data_for_plot = cbind(days, wound_ratings, repeated_CIs)	
	
data_for_plot %>% 	
  ggplot() +	
  aes(x = days, y = wound_ratings) +	
  geom_errorbar(aes(ymin=wound_ratings-repeated_CIs, ymax=wound_ratings+repeated_CIs), width=.1) +	
  geom_point() +	
  geom_line()	
	


# # Repeated measures analysis using linear mixed models	

# ## Exploring clustering in the data	

# Now lets look at the relatiohsip of the repeated measures of wound healing. (First, we save the variable names of the repeated measures into an object called repeated_variables so that we can easily refer to these variable names later in our functions.) We can explore the correlation between the variables with the cor() function. Notice that the repeated measures data points are highly correlated. This shows that the different observations of wound rating are not independent from each other. This is normal, since the wound rating and the initial size of the incision and the wound healing rate depends on the patient. So this is clustered data. Just like the data in the previous exercise was clustered in classes, here, the data is clustered within participants. 	


	
# correlation of repeated variables	
	
cor(data_wound[,repeated_variables])	


# ## Reshape dataframe	

# Because of this clustering, we can basically treat this data similarly to the bullying dataset. However, first we need to re-structure the dataset to a format that will be interpretable to the linear mixed effect regression (lmer()) function.	

# At this point, the dataframe contains 7 observations of wound rating from the same participant in one row (one for each day of the week while data was collected). This format is called the **wide format**. 	

# For lmer() to be able to interpret the data correctly, we will have to restructure the dataframe so that each row contains a single observation. This would mean that each participant would have 7 rows instead of 1. Data in the variables ID, distance_window, and location would be duplicated in each of the rows of the same participant, and there would be only a single column for wound rating in this new dataframe. This format of the data is usually referred to as the **long format**.	

# We can do this using the gather() function from the tidyr package. In this function we specify the variable name in which will index the repeated obervations (in our case we will call this "days"), and the variable name in which we want to gather all the observations made on the same variable (in our case we will call this "wound rating"). Finally, we will have to specify the variable names in which the data is currently located in the wide format. (By saying: day_1:day_7 we say that the variables are the column names between the day_1 and day_7 columns). Using the arrange() function we sort the data table based on the column "ID". This is not important, but it is easier to see the logic behind a long format file if we look at this sorted dataset.	

# (As always, we create a new object where we will store the data with the new shape, and leave the raw data unchanged. The new object is called data_wound_long.)	


	
data_wound_long = data_wound %>% 	
  gather(key = days, value = wound_rating,  day_1:day_7) %>% 	
  arrange(ID) 	
	
data_wound_long	


# We can also clarify the new dataframe a little bit by ordering the rows so that each observation from the same participant follow each other.	

# Also, notice that our 'days' variable now contains the names of the repeated measures variables from the wide format ('day_1', 'day_2' etc.). We will simplify this by simply using numbers 1-7 here to make them a numerical variable which is easier to deal with statistically. The easiest to do this is by using the mutate() and recode() functions.	


	
# change the days variable to a numerical vector	
data_wound_long = data_wound_long %>% 	
  mutate(days = recode(days,	
                       "day_1" = 1,	
                       "day_2" = 2,	
                       "day_3" = 3,	
                       "day_4" = 4,	
                       "day_5" = 5,	
                       "day_6" = 6,	
                       "day_7" = 7	
                       ))	


# Let's explore how this new datafrmae looks like.	


View(data_wound_long)	


# ## Building the linear mixed model	

# Now that we have our dataframe in an approriate formate, we can build our prediction model. The outcome will be wound rating, and the fixed effect predictors will be day after surgery, distance of the bed from the window, and south or north location (these information are stored in the variables days, distance_window, and location).	

# Since our outcome is clustered within participants, the random effect predictor will be participant ID. As in the previous exercise, we will fit two models, one will be a random intercept model, the other a random slope model.	

# Note that the **random intercept model** means that we suspect that the each participant is different in their overall wound rating (or baseline wound rating), but that the effect of the fixed effect predictors (days, distance from window, and location) is the same for each participant. On the other hand, the **random slope model** not only baseline wound rating will be different across participants, but also that the fixed effects will be different from participant to participant as well.	

# Note that here we have 3 different fixed effect predictors, so we can specify in the random slope model, which of these predictors we suspect that will be influenced by the random effect (participant). By specifying the random effect term as + (days|ID) we allow for the effect of days to be different across participants (basically saying that the rate of wound healing can be different from person to person), but restrict the model to predict the same effect for the other two fixed predictors: distance_window and location.	

# (We could allow for the random slope of distance_window and location as well by adding + (days|ID) + (distance_window|ID) + (location|ID) if you want the random effects to be uncorrelated, or + (days + distance_window + location|ID) if you want all random effects to be correlated). Now let's stick to a simpler model where we only allow for the random slope of days.	



mod_rep_int = lmer(wound_rating ~ days + distance_window + location + (1|ID), data = data_wound_long)	
mod_rep_slope = lmer(wound_rating ~ days + distance_window + location + (days|ID), data = data_wound_long)	


# ## Comparing models	

# Now let's compare the model predictions of the different random effect models to see which one fits the data better.	

# First, let's visualize the predictions. For this we will have to save the predicted values into new variables, then, we can visualize the predicted values and the actual observations for each participant separately for both the random intercept and the random slope model.	

# (We create a new copy of the data object so that our long format data can remain unharmed.)	



data_wound_long_withpreds = data_wound_long	
data_wound_long_withpreds$pred_int = predict(mod_rep_int)	
data_wound_long_withpreds$pred_slope = predict(mod_rep_slope)	
	
# random intercept model	
ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_int, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	
	
# random slope and intercept model	
ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_slope, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	
	


# The difference between the predictions of the two models is unremarkable.	

# Furthermore, we can compare the cAIC of the two models and use the likelihood ratio test with the anova() function to get further information about the model fit of the two models in comparison to wach other.	


cAIC(mod_rep_int)$caic	
cAIC(mod_rep_slope)$caic	
	
anova(mod_rep_int, mod_rep_slope)	


# None of these methods indicate a significant difference between the prediction efficiency of the models. So in this particular sample thre is not too much benefit for assuming a different slope of days for each participant. But this does not necesseraly mean that there is no point of using it in another sample. Previous studies and theory needs to be evaluated as well.	

# For now, without any prior knowledge from the literature, we can continue using the random intercept model.	

# ## Adding the quadratic term of days to the model	

# While exploring the plots we might notice that there is a non-linear relationship between days and wound rating. It seems that wounds improve fast in the first few days, and the healing is slower in the days after that.	

# Let's add the quadratic term of days to the model random intercept model tp account for this non-linear relationship.	


mod_rep_int_quad = lmer(wound_rating ~ days + I(days^2) + distance_window + location + (1|ID), data = data_wound_long)	


# And add the predictions to the new dataframe containing the other predicted values as well.	


data_wound_long_withpreds$pred_int_quad = predict(mod_rep_int_quad)	


# Now we can compare the model fit of the random intercept model containing the quadratic effect of days with the random intercept model without it. As usual, we use visualization, cAIC and the likelihood ratio test.	


data_wound_long_withpreds$pred_int_quad = predict(mod_rep_int_quad)	
	
plot_quad = ggplot(data_wound_long_withpreds, aes(y = wound_rating, x = days, group = ID))+	
  geom_point(size = 3)+	
  geom_line(color='red', aes(y=pred_int_quad, x=days))+	
  facet_wrap( ~ ID, ncol = 5)	



plot_quad	
	
cAIC(mod_rep_int)$caic	
cAIC(mod_rep_int_quad)$caic	
	
anova(mod_rep_int, mod_rep_int_quad)	


# The results indicate that a model taking into account the nonlinear relationship of days and wound rating produces a significantly better fit to the observed data than a model only allowing for a linear trend of days and wound healing.	

# The fit seems reasonable, so we stop here and decide that this will be our final model.	

# Since we entered days's quadratic term into the model, we can expect problems with multicollinearity. As seen in the exercise on model diagnostics, we can avoid this problem by centering the variable days, this way removing the correlation of days and days^2.	

# Let's do this now and refit our model with the centered days and its quadratic term as predictors.	


data_wound_long_centered_days = data_wound_long	
data_wound_long_centered_days$days_centered = data_wound_long_centered_days$days - mean(data_wound_long_centered_days$days)	
	
	
mod_rep_int_quad = lmer(wound_rating ~ days_centered + I(days_centered^2) + distance_window + location + (1|ID), data = data_wound_long_centered_days)	


# Now we can request the reportable results the same way we did in the previous exercise. 	


# Marginal R squared	
r2beta(mod_rep_int_quad, method = "nsj", data = data_wound_long_centered_days)	
	
# Conditional AIC	
cAIC(mod_rep_int_quad)$caic	
	
# Model coefficients	
summary(mod_rep_int_quad)	
	
# Confidence intervals for the coefficients	
confint(mod_rep_int_quad)	
	
# standardized Betas	
stdCoef.merMod(mod_rep_int_quad)	


# As always, you will need to run model diagnostics before reporting your final results. The next exercis will conver this topic.	
