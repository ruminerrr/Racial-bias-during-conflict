rm(list=ls())
library(bruceR)
setwd('~/Documents/R/ORB/US/study')

## load US data
us_exp1_asian = import('S01_US_OtherNeutral.csv')
us_exp1_caucasian = import('S01_US_SameNeutral.csv')
us_exp2_asian = import('S01_US_OtherPainful.csv')
us_exp2_caucasian = import('S01_US_SamePainful.csv')

us_exp1_asian = filter(us_exp1_asian, us_exp1_asian$AttenCheck != 0, us_exp1_asian$Age <= 30, us_exp1_asian$Race == "White", us_exp1_asian$selection==0)
us_exp1_caucasian = filter(us_exp1_caucasian, us_exp1_caucasian$AttenCheck != 0, us_exp1_caucasian$Age <= 30, us_exp1_caucasian$Race == "White", us_exp1_caucasian$selection==0)
us_exp2_asian = filter(us_exp2_asian, us_exp2_asian$AttenCheck != 0, us_exp2_asian$Age <= 30, us_exp2_asian$Race == "White", us_exp2_asian$selection==0)
us_exp2_caucasian = filter(us_exp2_caucasian, us_exp2_caucasian$AttenCheck != 0, us_exp2_caucasian$Age <= 30, us_exp2_caucasian$Race == "White", us_exp2_caucasian$selection==0)
# exp1 data combine
race = factor(c(us_exp1_asian$`Face race`,us_exp1_caucasian$`Face race`), levels = 1:2, labels = c("Asian","Caucasian"))
gender = factor(c(us_exp1_asian$Gender,us_exp1_caucasian$Gender), levels = 1:2, labels = c("sub_male","sub_female"))
male = c(asin(sqrt(us_exp1_asian$NCM)), asin(sqrt(us_exp1_caucasian$NFM)))
female = c(asin(sqrt(us_exp1_asian$NCF)), asin(sqrt(us_exp1_caucasian$NFF)))
tree = c(asin(sqrt(us_exp1_asian$tree)), asin(sqrt(us_exp1_caucasian$tree)))
us_exp1 = data.frame(race, male, female, tree, gender)
us_exp1$face = (us_exp1$male+us_exp1$female)/2
us_exp1$type = 'Neutral'
rm(male,female,tree,race,gender)
# exp2 data combine
race = factor(c(us_exp2_asian$`Face race`,us_exp2_caucasian$`Face race`), levels = 1:2, labels = c("Asian","Caucasian"))
gender = factor(c(us_exp2_asian$Gender,us_exp2_caucasian$Gender), levels = 1:2, labels = c("sub_male","sub_female"))
male = c(asin(sqrt(us_exp2_asian$PCM)), asin(sqrt(us_exp2_caucasian$PFM)))
female = c(asin(sqrt(us_exp2_asian$PCF)), asin(sqrt(us_exp2_caucasian$PFF)))
tree = c(asin(sqrt(us_exp2_asian$tree)), asin(sqrt(us_exp2_caucasian$tree)))
us_exp2 = data.frame(race, male, female, tree, gender)
us_exp2$face = (us_exp2$male+us_exp2$female)/2
us_exp2$type = 'Pain'
rm(male,female,tree,race,gender)
# conmbine all data
us_pain = rbind(us_exp1, us_exp2)

## load CN data
data_exp1_asian = import('S01_CN_SameNeutral.csv')
data_exp1_caucasian = import('S01_CN_OtherNeutral.csv')
data_exp2_asian = import('S01_CN_SamePainful.csv')
data_exp2_caucasian = import('S01_CN_OtherPainful.csv')

data_exp1_asian = filter(data_exp1_asian, data_exp1_asian$AttenCheck != 0, data_exp1_asian$Age <= 30, data_exp1_asian$Nation != 0, data_exp1_asian$Race != 0, data_exp1_asian$selection==0)
data_exp1_caucasian = filter(data_exp1_caucasian, data_exp1_caucasian$AttenCheck != 0, data_exp1_caucasian$Age <= 30, data_exp1_caucasian$Nation != 0, data_exp1_caucasian$Race != 0, data_exp1_caucasian$selection==0)
data_exp2_asian = filter(data_exp2_asian, data_exp2_asian$AttenCheck != 0, data_exp2_asian$Age <= 30, data_exp2_asian$Nation != 0, data_exp2_asian$Race != 0, data_exp2_asian$selection==0)
data_exp2_caucasian = filter(data_exp2_caucasian, data_exp2_caucasian$AttenCheck != 0, data_exp2_caucasian$Age <= 30, data_exp2_caucasian$Nation != 0, data_exp2_caucasian$Race != 0, data_exp2_caucasian$selection==0)
# exp1 data combine
race = factor(c(data_exp1_asian$`Face race`,data_exp1_caucasian$`Face race`), levels = 1:2, labels = c("Asian","Caucasian"))
gender = factor(c(data_exp1_asian$Gender,data_exp1_caucasian$Gender), levels = 0:1, labels = c("sub_female","sub_male"))
male = c(asin(sqrt(data_exp1_asian$NCM)), asin(sqrt(data_exp1_caucasian$NFM)))
female = c(asin(sqrt(data_exp1_asian$NCF)), asin(sqrt(data_exp1_caucasian$NFF)))
tree = c(asin(sqrt(data_exp1_asian$tree)), asin(sqrt(data_exp1_caucasian$tree)))
data_exp1 = data.frame(race, male, female, tree, gender)
data_exp1$face = (data_exp1$male+data_exp1$female)/2
data_exp1$type = 'Neutral'
rm(male,female,tree,race,gender)
# exp2 data combine
race = factor(c(data_exp2_asian$`Face race`,data_exp2_caucasian$`Face race`), levels = 1:2, labels = c("Asian","Caucasian"))
gender = factor(c(data_exp2_asian$Gender,data_exp2_caucasian$Gender), levels = 0:1, labels = c("sub_female","sub_male"))
male = c(asin(sqrt(data_exp2_asian$PCM)), asin(sqrt(data_exp2_caucasian$PFM)))
female = c(asin(sqrt(data_exp2_asian$PCF)), asin(sqrt(data_exp2_caucasian$PFF)))
tree = c(asin(sqrt(data_exp2_asian$tree)), asin(sqrt(data_exp2_caucasian$tree)))
data_exp2 = data.frame(race, male, female, tree, gender)
data_exp2$face = (data_exp2$male+data_exp2$female)/2
data_exp2$type = 'Pain'
rm(male,female,tree,race,gender)

## CN vs. US
data_exp1$SubRace="Asian"
data_exp2$SubRace="Asian"
us_exp1$SubRace="Caucasian"
us_exp2$SubRace="Caucasian"
data_all = rbind(data_exp1,data_exp2,us_exp1,us_exp2)

m_subrace_neutral=MANOVA(data=filter(data_all,data_all$type=="Neutral"),dvs=c("male","female","tree"),dvs.pattern = "(.+)",between = c("race","SubRace"),within = ("stimulus"),sph.correction="GG")
emmip(m_subrace_neutral,race ~ SubRace|stimulus,CIs=TRUE)
EMMEANS(m_subrace_neutral, "SubRace",by=c("stimulus","race"))
m_subrace_pain=MANOVA(data=filter(data_all,data_all$type=="Pain"),dvs=c("male","female","tree"),dvs.pattern = "(.+)",between = c("race","SubRace"),within = ("stimulus"),sph.correction="GG")
emmip(m_subrace_pain,race ~ SubRace|stimulus,CIs=TRUE)
EMMEANS(m_subrace_pain, "SubRace",by=c("stimulus","race"))

## T-test
# Exp1
t1 = TTEST(us_exp1, y = c('male','female','tree','face'), x = 'race')
t2 = TTEST(us_exp1_asian, y = c('NCM','NCF'), paired = TRUE)
t3 = TTEST(us_exp1_caucasian, y = c('NFM','NFF'), paired = TRUE)
TTEST(data = filter(us_exp1,us_exp1$race=='Asian'), y = c('male','female','tree'), x = 'gender')
TTEST(data = filter(us_exp1,us_exp1$race=='Caucasian'), y = c('male','female','tree'), x = 'gender')
TTEST(data = filter(us_exp1,us_exp1$gender=='sub_male'), y = c('male','female','tree'), x = 'race')
TTEST(data = filter(us_exp1,us_exp1$gender=='sub_female'), y = c('male','female','tree'), x = 'race')

TTEST(data = filter(us_exp1,us_exp1$race=='Asian'), y = c('male','female','tree'), x = 'gender', var.equal=FALSE)
m_exp1_asian_sub = MANOVA(data=filter(us_exp1,us_exp1$race=='Asian'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', between = 'gender', within = 'stimuli', sph.correction="GG")
emmip(m_exp1_asian_sub, stimuli~gender, CIs = TRUE)
ggsave("exp1_asian_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)
TTEST(data = filter(us_exp1,us_exp1$race=='Caucasian'), y = c('male','female','tree'), x = 'gender')
m_exp1_caucasian_sub = MANOVA(data=filter(us_exp1,us_exp1$race=='Caucasian'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', between = 'gender', within = 'stimuli', sph.correction="GG")
emmip(m_exp1_caucasian_sub, stimuli~gender, CIs = TRUE)
ggsave("exp1_caucasian_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)

m_exp1_race_sub = MANOVA(us_exp1,dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'stimuli', between = c('race','gender'),sph.correction="GG")
EMMEANS(m_exp1_race_sub, 'gender',by=c('race','stimuli'))
EMMEANS(m_exp1_race_sub, 'gender',by='stimuli')
EMMEANS(m_exp1_race_sub, 'race',by=c('gender','stimuli'))
emmip(m_exp1_race_sub, stimuli~race|gender, CIs=TRUE)
ggsave("exp1_race_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

m9 = MANOVA(us_exp1, dvs = c('male','female'),dvs.pattern = '(.*)', within = 'Gender',  between = 'race')
emmip(m9,  Gender ~ race, CIs=TRUE)
ggsave("exp1_gender_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 6, height = 8)
mm = MANOVA(us_exp1, dvs = c('male','female','tree'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(mm, 'stimulus', by='race')
EMMEANS(mm, 'race', by='stimulus')
emmip(mm,  stimulus ~ race, CIs=TRUE)
ggsave("exp1_stim_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

m_gender = MANOVA(us_exp1,dvs = c('male','female'), dvs.pattern = '(.*)', within = 'Gender', between = 'race')

# Exp2
t4 = TTEST(us_exp2, y = c('male','female','tree','face'), x = 'race')
t5 = TTEST(data=filter(us_exp2,us_exp2$race=='Asian'), y = c('male','female'), paired = TRUE)
t6 = TTEST(data=filter(us_exp2,us_exp2$race=='Caucasian'), y = c('male','female'), paired = TRUE)

TTEST(data = filter(us_exp2,us_exp2$race=='Asian'), y = c('male','female','tree'), x = 'gender')
m_exp2_asian_sub = MANOVA(data=filter(us_exp2,us_exp2$race=='Asian'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', between = 'gender', within = 'stimuli', sph.correction="GG")
emmip(m_exp2_asian_sub, stimuli~gender, CIs = TRUE)
ggsave("exp2_asian_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)
TTEST(data = filter(us_exp2,us_exp2$race=='Caucasian'), y = c('male','female','tree'), x = 'gender')
m_exp2_caucasian_sub = MANOVA(data=filter(us_exp2,us_exp2$race=='Caucasian'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', between = 'gender', within = 'stimuli', sph.correction="GG")
emmip(m_exp2_caucasian_sub, stimuli~gender, CIs = TRUE)
ggsave("exp2_caucasian_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

TTEST(data = filter(us_exp2,us_exp2$gender=='sub_male'), y = c('male','female','tree'), x = 'race', var.equal=FALSE)
TTEST(data = filter(us_exp2,us_exp2$gender=='sub_female'), y = c('male','female','tree'), x = 'race')
m_exp2_race_sub = MANOVA(us_exp2,dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'stimuli', between = c('race','gender'),sph.correction="GG")
EMMEANS(m_exp2_race_sub, 'gender',by='stimuli')
emmip(m_exp2_race_sub, stimuli~race|gender, CIs=TRUE)
ggsave("exp2_race_subj.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

m10 = MANOVA(us_exp2, dvs = c('male','female'),dvs.pattern = '(.*)', within = 'Gender',  between = 'race')
emmip(m10,  Gender ~ race, CIs=TRUE)
ggsave("exp2_gender_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)
mm2 = MANOVA(us_exp2, dvs = c('male','female','tree'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(mm2, 'stimulus',by='race')
emmip(mm2,  stimulus ~ race, CIs=TRUE)
ggsave("exp2_stim_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

## MANOVA
# pain
TTEST(data=filter(us_pain,us_pain$race=='Asian'), y=c('male','female','tree','face'), x = 'type')
TTEST(data=filter(us_pain,us_pain$race=='Caucasian'), y=c('male','female','tree','face'), x = 'type')

TTEST(data=filter(us_pain,us_pain$race=='Asian',us_pain$gender=='sub_male'), y=c('male','female','tree','face'), x = 'type')
TTEST(data=filter(us_pain,us_pain$race=='Asian',us_pain$gender=='sub_female'), y=c('male','female','tree','face'), x = 'type')

TTEST(data=filter(us_pain,us_pain$race=='Caucasian',us_pain$gender=='sub_male'), y=c('male','female','tree','face'), x = 'type')
TTEST(data=filter(us_pain,us_pain$race=='Caucasian',us_pain$gender=='sub_female'), y=c('male','female','tree','face'), x = 'type')

m_pain_subgender = MANOVA(us_pain,dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'stimuli',between=c('type','gender','race'), sph.correction="GG")
emmip(m_pain_subgender, stimuli~type|race|gender, CIs = TRUE)
ggsave("pain_subgender.png", plot = last_plot(), device = "png", dpi = 300, width = 12, height = 10)

m1 = MANOVA(us_pain, dv = 'face', between = c('race','type'))
emmip(m1,  race ~ type, CIs=TRUE)
emmip(m1,  type ~ race, CIs=TRUE)

m2 = MANOVA(us_pain, dv = 'male', between = c('race','type'))
emmip(m2,  race ~ type, CIs=TRUE)
ggsave("pain_male_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)

m3 = MANOVA(us_pain, dv = 'female', between = c('race','type'))
emmip(m3,  race ~ type, CIs=TRUE)
ggsave("pain_female_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)
TTEST(data=filter(us_pain,us_pain$race == 'Asian'), y = 'female', x = 'type')
TTEST(data=filter(us_pain,us_pain$race == 'Caucasian'), y = 'female', x = 'type')

m4 = MANOVA(us_pain, dv = 'tree', between = c('race','type'))
emmip(m4,  race ~ type, CIs=TRUE)
ggsave("pain_tree_interact.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 6)

mm1 = MANOVA(us_pain,dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between = c('race','type'),sph.correction="GG")
#emmip(mm1,Stimulus~type|race,CIs=TRUE)
emmip(mm1,race~type|Stimulus,CIs=TRUE)
EMMEANS(mm1,"Stimulus",by=c("race"))
ggsave("pain_modulation.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)

mmm1 = MANOVA(us_pain,dvs = c('face','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between = c('race','type'),sph.correction="GG")
emmip(mmm1,Stimulus~type|race,CIs=TRUE)
emmip(mmm1,type~race,CIs=TRUE)
emmip(mmm1,Stimulus~type~race,CIs=TRUE)
EMMEANS(mmm1, "race", by=c("Stimulus","type"))
EMMEANS(mmm1, "Stimulus", by=c("race","type"))
EMMEANS(mmm1, "type", by=c("Stimulus","type"))

ggsave("us_pain_modulation_modified.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)


## RT
rt_exp1_asian = us_exp1_asian[,83:146]
rt_exp1_caucasian = us_exp1_caucasian[,83:146]
rt_exp2_asian = us_exp2_asian[,83:146]
rt_exp2_caucasian = us_exp2_caucasian[,83:146]
rt_exp1_asian$type = "Neutral"
rt_exp1_caucasian$type = "Neutral"
rt_exp2_asian$type = "Pain"
rt_exp2_caucasian$type = "Pain"
rt_exp1_asian$race = "Asian"
rt_exp1_caucasian$race = "Caucasian"
rt_exp2_asian$race = "Asian"
rt_exp2_caucasian$race = "Caucasian"
rt_all = rbind(rt_exp1_asian,rt_exp1_caucasian,rt_exp2_asian,rt_exp2_caucasian)
race = rt_all$race
type = rt_all$type

rt = unlist(rt_all[,1:64])
data_rt = data.frame(rt)
rt_mean = mean(rt)
rt_sd = sd(rt)
threshold = c(100, rt_mean+3*rt_sd)
data_rt$rt[ data_rt$rt<threshold[1] | data_rt$rt>threshold[2]] = NA
data_cleaned = data.frame(matrix(data_rt$rt, nrow = 328, ncol = 64))
data_cleaned = data_cleaned/1000
data_cleaned = log(data_cleaned)

data_cleaned$female = rowMeans(data_cleaned[,1:16],na.rm = TRUE)
data_cleaned$male = rowMeans(data_cleaned[,17:32],na.rm = TRUE)
data_cleaned$tree = rowMeans(data_cleaned[,33:64],na.rm = TRUE)
data_cleaned$face = (data_cleaned$male+data_cleaned$female)/2
data_cleaned = data.frame(data_cleaned, rt_all[,65:66])
m_1 = MANOVA(data=filter(data_cleaned,data_cleaned$type=='Neutral'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between  = 'race', sph.correction="GG")
emmip(m_1, Stimulus~race, CIs = TRUE)
m_2 = MANOVA(data=filter(data_cleaned,data_cleaned$type=='Pain'), dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between  = 'race', sph.correction="GG")
emmip(m_2, Stimulus~race, CIs = TRUE)

## Pain modulate
# Asian
TTEST(data=filter(data_cleaned,data_cleaned$race=='Asian'), y = c('male','female','tree'), x = 'type')
# Caucasian
TTEST(data=filter(data_cleaned,data_cleaned$race=='Caucasian'), y = c('male','female','tree'), x = 'type', var.equal = FALSE)
m_p = MANOVA(data=filter(data_cleaned), dvs = c('male','female','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between  = c('race','type'), sph.correction="GG")
emmip(m_p, race~type|Stimulus,CIs=TRUE)

mmm2 = MANOVA(data_cleaned,dvs = c('face','tree'), dvs.pattern = '(.*)', within = 'Stimulus', between = c('race','type'),sph.correction="GG")
emmip(mmm2,Stimulus~type|race,CIs=TRUE)
emmip(mmm2,type~race,CIs=TRUE)
emmip(mmm2,Stimulus~type~race,CIs=TRUE)
EMMEANS(mmm2, "race", by=c("Stimulus","type"))
EMMEANS(mmm2, "Stimulus", by=c("race","type"))
ggsave("us_pain_modulation_modified_RT.png", plot = last_plot(), device = "png", dpi = 300, width = 8, height = 8)


## Face - Tree
data_all$MaleCtrl = data_all$male-data_all$tree
data_all$FemaleCtrl = data_all$female-data_all$tree
mmm = MANOVA(data=filter(data_all,data_all$type=="Neutral",data_all$SubRace=="Caucasian"), dvs = c('MaleCtrl','FemaleCtrl'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(mmm, 'stimulus', by='race')
EMMEANS(mmm, 'race', by='stimulus')
emmip(mmm,  stimulus ~ race, CIs=TRUE)

mmm1 = MANOVA(data=filter(data_all,data_all$type=="Pain",data_all$SubRace=="Caucasian"), dvs = c('MaleCtrl','FemaleCtrl'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(mmm1, 'stimulus', by='race')
EMMEANS(mmm1, 'race', by='stimulus')
emmip(mmm1,  stimulus ~ race, CIs=TRUE)

m_subrace_neutral1=MANOVA(data=filter(data_all,data_all$type=="Neutral"),dvs=c("MaleCtrl","FemaleCtrl"),dvs.pattern = "(.+)",between = c("race","SubRace"),within = ("stimulus"),sph.correction="GG")
emmip(m_subrace_neutral1,race ~ SubRace|stimulus,CIs=TRUE)
EMMEANS(m_subrace_neutral1, "SubRace",by=c("stimulus","race"))
m_subrace_pain1=MANOVA(data=filter(data_all,data_all$type=="Pain"),dvs=c("MaleCtrl","FemaleCtrl"),dvs.pattern = "(.+)",between = c("race","SubRace"),within = ("stimulus"),sph.correction="GG")
emmip(m_subrace_pain1,race ~ SubRace|stimulus,CIs=TRUE)
EMMEANS(m_subrace_pain1, "SubRace",by=c("stimulus","race"))

m_male = MANOVA(data=filter(us_exp1,us_exp1$gender=='sub_male'), dvs = c('male','female','tree'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(m_male, 'stimulus', by='race')
EMMEANS(m_male, 'race', by='stimulus')
emmip(m_male,  stimulus ~ race, CIs=TRUE)

m2_male = MANOVA(data=filter(us_exp2,us_exp2$gender=='sub_male'), dvs = c('male','female','tree'),dvs.pattern = '(.*)', within = 'stimulus',  between = 'race',sph.correction="GG")
EMMEANS(m2_male, 'stimulus', by='race')
EMMEANS(m2_male, 'race', by='stimulus')
emmip(m2_male,  stimulus ~ race, CIs=TRUE)

m_male_pain = MANOVA(data=filter(data_all,data_all$gender=='sub_male',data_all$SubRace=='Caucasian'),dvs = c('male','female','tree'),dvs.pattern = '(.*)', within = 'stimulus',  between = c('race','type'),sph.correction="GG")
emmip(m_male_pain, race~type|stimulus,CIs=TRUE)

