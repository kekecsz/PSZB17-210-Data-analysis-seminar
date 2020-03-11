
library(tidyverse)




alternative = "greater"
observed_sample = c(96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99)
observation_mean = mean(observed_sample)
observation_mean

IQ_generalpop_mean = 100
IQ_generalpop_sd = 15
n = length(observed_sample)

iter = 10
null_norm = replicate(iter, mean(rnorm(mean = IQ_generalpop_mean, sd = IQ_generalpop_sd, n = n)))


abs_difference_from_pop_mean = abs(IQ_generalpop_mean - observation_mean)

thresholds = if(alternative == "greater"){
  IQ_generalpop_mean + abs_difference_from_pop_mean
} else if(alternative == "less"){
  IQ_generalpop_mean - abs_difference_from_pop_mean
} else if(alternative == "two.sided"){
  c(IQ_generalpop_mean - abs_difference_from_pop_mean, IQ_generalpop_mean + abs_difference_from_pop_mean)
}


null_norm_df = data.frame(null_norm)

which_more_extreme = 
  if(alternative == "greater"){
    null_norm >= thresholds
  } else if(alternative == "less"){
    null_norm <= thresholds
  } else if(alternative == "two.sided"){
    (null_norm <= thresholds[1] | null_norm >= thresholds[2])
  }



null_norm_df = cbind(null_norm_df, which_more_extreme)
percent_greater = round(sum(which_more_extreme)/length(which_more_extreme)*100, 2)

null_norm_df %>% 
  ggplot() +
  aes(x = null_norm, col = which_more_extreme, fill = which_more_extreme) +
  geom_dotplot(binwidth = 1.5/log(iter)) +
  xlim(c(80,120)) +
  geom_vline(xintercept = thresholds, size = 2, linetype = "dashed", col = "red") +
  annotate("text", x = 115, y = 0, label = paste0(percent_greater, "%")) +
  theme_bw() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 

t.test(mu = 100, x = observed_sample, alternative = alternative)








alternative = "greater"
observed_sample = c(96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99)
observation_mean = mean(observed_sample)
observation_mean

IQ_generalpop_mean = 100
IQ_generalpop_sd = 15
n = length(observed_sample)

iter = 10000
null_norm = replicate(iter, mean(rnorm(mean = IQ_generalpop_mean, sd = IQ_generalpop_sd, n = n)))


abs_difference_from_pop_mean = abs(IQ_generalpop_mean - observation_mean)

thresholds = if(alternative == "greater"){
  IQ_generalpop_mean + abs_difference_from_pop_mean
} else if(alternative == "less"){
  IQ_generalpop_mean - abs_difference_from_pop_mean
} else if(alternative == "two.sided"){
  c(IQ_generalpop_mean - abs_difference_from_pop_mean, IQ_generalpop_mean + abs_difference_from_pop_mean)
}


null_norm_df = data.frame(null_norm)

which_more_extreme = 
  if(alternative == "greater"){
    null_norm >= thresholds
  } else if(alternative == "less"){
    null_norm <= thresholds
  } else if(alternative == "two.sided"){
    (null_norm <= thresholds[1] | null_norm >= thresholds[2])
  }



null_norm_df = cbind(null_norm_df, which_more_extreme)
percent_greater = round(sum(which_more_extreme)/length(which_more_extreme)*100, 2)

null_norm_df %>% 
  ggplot() +
  aes(x = null_norm, col = which_more_extreme, fill = which_more_extreme) +
  geom_dotplot(binwidth = 1.5/log(iter)) +
  xlim(c(80,120)) +
  geom_vline(xintercept = thresholds, size = 2, linetype = "dashed", col = "red") +
  annotate("text", x = 115, y = 0, label = paste0(percent_greater, "%")) +
  theme_bw() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 

t.test(mu = 100, x = observed_sample, alternative = alternative)



alternative = "greater"
observed_sample = c(96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99) + 4
observation_mean = mean(observed_sample)
observation_mean

IQ_generalpop_mean = 100
IQ_generalpop_sd = 15
n = length(observed_sample)

iter = 10000
null_norm = replicate(iter, mean(rnorm(mean = IQ_generalpop_mean, sd = IQ_generalpop_sd, n = n)))


abs_difference_from_pop_mean = abs(IQ_generalpop_mean - observation_mean)

thresholds = if(alternative == "greater"){
  IQ_generalpop_mean + abs_difference_from_pop_mean
} else if(alternative == "less"){
  IQ_generalpop_mean - abs_difference_from_pop_mean
} else if(alternative == "two.sided"){
  c(IQ_generalpop_mean - abs_difference_from_pop_mean, IQ_generalpop_mean + abs_difference_from_pop_mean)
}


null_norm_df = data.frame(null_norm)

which_more_extreme = 
  if(alternative == "greater"){
    null_norm >= thresholds
  } else if(alternative == "less"){
    null_norm <= thresholds
  } else if(alternative == "two.sided"){
    (null_norm <= thresholds[1] | null_norm >= thresholds[2])
  }



null_norm_df = cbind(null_norm_df, which_more_extreme)
percent_greater = round(sum(which_more_extreme)/length(which_more_extreme)*100, 2)

null_norm_df %>% 
  ggplot() +
  aes(x = null_norm, col = which_more_extreme, fill = which_more_extreme) +
  geom_dotplot(binwidth = 1.5/log(iter)) +
  xlim(c(80,120)) +
  geom_vline(xintercept = thresholds, size = 2, linetype = "dashed", col = "red") +
  annotate("text", x = 115, y = 0, label = paste0(percent_greater, "%")) +
  theme_bw() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 

t.test(mu = 100, x = observed_sample, alternative = alternative)






alternative = "two.sided"
observed_sample = c(96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99) +4
observation_mean = mean(observed_sample)
observation_mean

IQ_generalpop_mean = 100
IQ_generalpop_sd = 15
n = length(observed_sample)

iter = 10000
null_norm = replicate(iter, mean(rnorm(mean = IQ_generalpop_mean, sd = IQ_generalpop_sd, n = n)))


abs_difference_from_pop_mean = abs(IQ_generalpop_mean - observation_mean)

thresholds = if(alternative == "greater"){
  IQ_generalpop_mean + abs_difference_from_pop_mean
} else if(alternative == "less"){
  IQ_generalpop_mean - abs_difference_from_pop_mean
} else if(alternative == "two.sided"){
  c(IQ_generalpop_mean - abs_difference_from_pop_mean, IQ_generalpop_mean + abs_difference_from_pop_mean)
}


null_norm_df = data.frame(null_norm)

which_more_extreme = 
  if(alternative == "greater"){
    null_norm >= thresholds
  } else if(alternative == "less"){
    null_norm <= thresholds
  } else if(alternative == "two.sided"){
    (null_norm <= thresholds[1] | null_norm >= thresholds[2])
  }



null_norm_df = cbind(null_norm_df, which_more_extreme)
percent_greater = round(sum(which_more_extreme)/length(which_more_extreme)*100, 2)

null_norm_df %>% 
  ggplot() +
  aes(x = null_norm, col = which_more_extreme, fill = which_more_extreme) +
  geom_dotplot(binwidth = 1.5/log(iter)) +
  xlim(c(80,120)) +
  geom_vline(xintercept = thresholds, size = 2, linetype = "dashed", col = "red") +
  annotate("text", x = 115, y = 0, label = paste0(percent_greater, "%")) +
  theme_bw() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 

t.test(mu = 100, x = observed_sample, alternative = alternative)




alternative = "two.sided"
observed_sample = c(96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99, 96, 128,  94, 108, 121,  89,  85,  84, 123,  97, 123, 101, 120, 111,  86,  93, 103,  79, 100,  99)
observation_mean = mean(observed_sample)
observation_mean

IQ_generalpop_mean = 100
IQ_generalpop_sd = 15
n = length(observed_sample)

iter = 10000
null_norm = replicate(iter, mean(rnorm(mean = IQ_generalpop_mean, sd = IQ_generalpop_sd, n = n)))


abs_difference_from_pop_mean = abs(IQ_generalpop_mean - observation_mean)

thresholds = if(alternative == "greater"){
  IQ_generalpop_mean + abs_difference_from_pop_mean
} else if(alternative == "less"){
  IQ_generalpop_mean - abs_difference_from_pop_mean
} else if(alternative == "two.sided"){
  c(IQ_generalpop_mean - abs_difference_from_pop_mean, IQ_generalpop_mean + abs_difference_from_pop_mean)
}


null_norm_df = data.frame(null_norm)

which_more_extreme = 
  if(alternative == "greater"){
    null_norm >= thresholds
  } else if(alternative == "less"){
    null_norm <= thresholds
  } else if(alternative == "two.sided"){
    (null_norm <= thresholds[1] | null_norm >= thresholds[2])
  }



null_norm_df = cbind(null_norm_df, which_more_extreme)
percent_greater = round(sum(which_more_extreme)/length(which_more_extreme)*100, 2)

null_norm_df %>% 
  ggplot() +
  aes(x = null_norm, col = which_more_extreme, fill = which_more_extreme) +
  geom_dotplot(binwidth = 1.5/log(iter)) +
  xlim(c(80,120)) +
  geom_vline(xintercept = thresholds, size = 2, linetype = "dashed", col = "red") +
  annotate("text", x = 115, y = 0, label = paste0(percent_greater, "%")) +
  theme_bw() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 

t.test(mu = 100, x = observed_sample, alternative = alternative)


summary = data %>% 
  group_by(group) %>% 
  summarize(mean = mean(anxiety), sd = sd(anxiety))
summary

data %>% 
  ggplot() +
  aes(x = group, y = anxiety) +
  geom_boxplot()

t_test_results_one_sided = t.test(anxiety ~ group, data = data, alternative = "less")
t_test_results_one_sided

