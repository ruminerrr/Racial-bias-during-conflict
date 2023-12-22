rm(list=ls())
library(bruceR)
setwd('/Users/junchenglu/Documents/R/ORB/EEG/')

beh_data = import('S02_Behavior_data.csv')
## response
beh_data$neutral_female = (asin(sqrt(beh_data$low_neutral_female))+asin(sqrt(beh_data$high_neutral_female)))/2
beh_data$pain_female = (asin(sqrt(beh_data$low_pain_female))+asin(sqrt(beh_data$high_pain_female)))/2
beh_data$neutral_male = (asin(sqrt(beh_data$low_neutral_male))+asin(sqrt(beh_data$high_neutral_male)))/2
beh_data$pain_male = (asin(sqrt(beh_data$low_pain_male))+asin(sqrt(beh_data$high_pain_male)))/2
beh_data$tree = (asin(sqrt(beh_data$low_tree))+asin(sqrt(beh_data$high_tree)))/2
beh_data$neutral = (beh_data$neutral_female+beh_data$neutral_male)/2
beh_data$pain = (beh_data$pain_female+beh_data$pain_male)/2
## RT
beh_data$neutral_female_rt = (log(beh_data$low_neutral_female_RT)+log(beh_data$high_neutral_female_RT))/2
beh_data$pain_female_rt = (log(beh_data$low_pain_female_RT)+log(beh_data$high_pain_female_RT))/2
beh_data$neutral_male_rt = (log(beh_data$low_neutral_male_RT)+log(beh_data$high_neutral_male_RT))/2
beh_data$pain_male_rt = (log(beh_data$low_pain_male_RT)+log(beh_data$high_pain_male_RT))/2
beh_data$tree_rt = (log(beh_data$low_tree_RT)+log(beh_data$high_tree_RT))/2
beh_data$neutral_rt = (beh_data$neutral_female_rt+beh_data$neutral_male_rt)/2
beh_data$pain_rt = (beh_data$pain_female_rt+beh_data$pain_male_rt)/2

m1 = MANOVA(data = beh_data, dvs = c("neutral","pain","tree"), dvs.pattern = "(.+)", between="race", within="stimulus", sph.correction="GG") 
emmip(m1, stimulus ~ race,CIs=TRUE)
ggsave("choice.png", plot = last_plot(), device = "png", dpi = 300, width = 6, height = 8)
EMMEANS(m1, "race", by = "stimulus")
EMMEANS(m1, "stimulus", by = "race")

beh_data$neutral_ctrl = beh_data$neutral - beh_data$tree
beh_data$pain_ctrl = beh_data$pain - beh_data$tree
mm1 = MANOVA(data = beh_data, dvs = c("neutral_ctrl","pain_ctrl"), dvs.pattern = "(.+)", between="race", within="stimulus_control", sph.correction="GG") 
emmip(mm1, stimulus_control ~ race,CIs=TRUE)
EMMEANS(mm1, "stimulus_control", by = "race")
EMMEANS(mm1, "race", by = "stimulus_control")


m2 = MANOVA(data = beh_data, dvs = c("neutral_rt","pain_rt","tree_rt"), dvs.pattern = "(.+)", between="race", within="stimulus", sph.correction="GG") 
emmip(m2, stimulus ~ race,CIs=TRUE)
ggsave("rt.png", plot = last_plot(), device = "png", dpi = 300, width = 6, height = 8)
EMMEANS(m2, "race", by = "stimulus")
EMMEANS(m2, "stimulus", by = "race")
