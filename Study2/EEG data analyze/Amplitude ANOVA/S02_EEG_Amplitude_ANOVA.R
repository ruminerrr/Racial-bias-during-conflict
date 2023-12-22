rm(list=ls())
library(tidyr)
library(bruceR)
setwd('/Users/junchenglu/Documents/R/ORB/EEG/')

raw_data = import('eeg_ddm_StimAllElec_new.csv')
data = pivot_wider(
  data = raw_data,
  id_cols = c('subj_idx','race','gender'),
  id_expand = FALSE,
  names_from = 'type',
  values_from = c(
    'response',
    'rt',
    'frontal_N1',
    'frontal_P2',
    'frontal_N2',
    'central_N1',
    'central_P2',
    'central_N2',
    'P7P8_P1',
    'P7P8_N170',
    'F3_N1',
    'F1_N1',
    'Fz_N1',
    'F2_N1',
    'F4_N1',
    'FC3_N1',
    'FC1_N1',
    'FCz_N1',
    'FC2_N1',
    'FC4_N1',
    'C3_N1',
    'C1_N1',
    'Cz_N1',
    'C2_N1',
    'C4_N1',
    'F3_P2',
    'F1_P2',
    'Fz_P2',
    'F2_P2',
    'F4_P2',
    'FC3_P2',
    'FC1_P2',
    'FCz_P2',
    'FC2_P2',
    'FC4_P2',
    'C3_P2',
    'C1_P2',
    'Cz_P2',
    'C2_P2',
    'C4_P2',
    'F3_N2',
    'F1_N2',
    'Fz_N2',
    'F2_N2',
    'F4_N2',
    'FC3_N2',
    'FC1_N2',
    'FCz_N2',
    'FC2_N2',
    'FC4_N2',
    'C3_N2',
    'C1_N2',
    'Cz_N2',
    'C2_N2',
    'C4_N2',
    'P7_P1',
    'P8_P1',
    'P7_N170',
    'P8_N170'
  ),
  values_fn = mean
)

###########ANOVA#############
m1 = MANOVA(data,dvs=c('frontal_N1_neutral','frontal_N1_pain'),dvs.pattern='frontal_N1_(.+)',within='expression',between='race')
m2 = MANOVA(data,dvs=c('frontal_P2_neutral','frontal_P2_pain'),dvs.pattern='frontal_P2_(.+)',within='expression',between='race')
m3 = MANOVA(data,dvs=c('frontal_N2_neutral','frontal_N2_pain'),dvs.pattern='frontal_N2_(.+)',within='expression',between='race')
d3 = emmip(m3,race~expression)
d3 = d3$data
data$frontal_P2_control = data$frontal_P2_pain - data$frontal_P2_neutral
t3 = TTEST(data,y='frontal_P2_control',x='race')

m4 = MANOVA(data,dvs=c('central_N1_neutral','central_N1_pain'),dvs.pattern='central_N1_(.+)',within='expression',between='race')
m5 = MANOVA(data,dvs=c('central_P2_neutral','central_P2_pain'),dvs.pattern='central_P2_(.+)',within='expression',between='race')
data$central_P2_control = data$central_P2_pain - data$central_P2_neutral
t5 = TTEST(data,y='central_P2_control',x='race')

m6 = MANOVA(data,dvs=c('central_N2_neutral','central_N2_pain'),dvs.pattern='central_N2_(.+)',within='expression',between='race')
m7 = MANOVA(data,dvs=c('P7P8_P1_neutral','P7P8_P1_pain'),dvs.pattern='P7P8_P1_(.+)',within='expression',between='race')
m8 = MANOVA(data,dvs=c('P7P8_N170_neutral','P7P8_N170_pain'),dvs.pattern='P7P8_N170_(.+)',within='expression',between='race')
d8 = emmip(m8,race~expression)
d8 = d8$data

############PLOT##############
ggplot(d, aes(x = interaction(expression, race), y = yvar, fill = interaction(race,expression))) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=yvar-SE, ymax=yvar), width=.5,
                position=position_dodge(.9)) +
  labs(x = "Face race", y = "Frontal region N2 amplitude", fill="Stimulus") +
  facet_wrap(~expression, scales = "free_x", ncol = 4) +
  scale_fill_manual(values=c('#9488CF','#78B087','#7797BF','#E7A876'),labels = c("Asian neutral","Caucasian neutral", "Asian pain","Caucasian pain")) +
  scale_x_discrete(labels = cc("Asian", "Caucasian", "Asian","Caucasian")) +
  theme(
    text = element_text(size = 10),    # Overall text size
    title = element_text(size = 10),   # Title font size
    axis.title = element_text(size = 10),  # Axis label font size
    axis.text = element_text(size = 7)    # Axis text font size
  )

#ggsave("FrontalN2.png", plot = last_plot(), device = "png", dpi = 300, width = 4, height = 4)

MANOVA(data,dvs=c('Cz_P2_neutral','Cz_P2_pain'),dvs.pattern='(.+)',within='expression',between='race')
data$Cz_P2_contral = data$Cz_P2_neutral- data$Cz_P2_pain
data$Cz_P2_control = data$Cz_P2_pain- data$Cz_P2_tree
TTEST(data,y=c('Cz_P2_neutral','Cz_P2_pain','Cz_P2_tree','Cz_P2_contral','Cz_P2_control'),x='race')
##
TTEST(data=filter(data,data$race=='Asian'),y=c('F3_N2_neutral','F3_N2_pain'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('F3_N2_neutral','F3_N2_pain'),paired = TRUE)

####pain vs. neutral ########
MANOVA(data,dvs=c('aF_pain','aF_neutral'),dvs.pattern='(.+)',within='expression',between='race')
data$aF_control = data$aF_pain- data$aF_neutral
TTEST(data,y=c('aF_pain','aF_neutral','aF_control'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('aF_pain','aF_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('aF_pain','aF_neutral'),paired = TRUE)

########## pain vs. tree ##########
MANOVA(data,dvs=c('C3_N2_pain','C3_N2_tree'),dvs.pattern='(.+)',within='stimulus',between='race')
data$P7_N170_TreeControl = data$P7_N170_pain - data$P7_N170_tree
TTEST(data,y=c('P7_N170_pain','P7_N170_tree','P7_N170_TreeControl'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('P7_P1_pain','P7_P1_tree'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('P7_P1_pain','P7_P1_tree'),paired = TRUE)

########### neutral vs. tree #############
MANOVA(data,dvs=c('C3_N2_neutral','C3_N2_tree'),dvs.pattern='(.+)',within='stimulus',between='race')
data$C3_N2_NTreeControl = data$C3_N2_neutral - data$C3_N2_tree
TTEST(data,y=c('C3_N2_neutral','C3_N2_tree','C3_N2_NTreeControl'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('C3_N2_neutral','C3_N2_tree'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('C3_N2_neutral','C3_N2_tree'),paired = TRUE)

#######average channel##########
## Frontal
data$aF_P2_pain = (data$F1_P2_pain + data$F2_P2_pain + data$F3_P2_pain + data$F4_P2_pain + data$Fz_P2_pain)/5
data$aF_P2_neutral = (data$F1_P2_neutral + data$F2_P2_neutral + data$F3_P2_neutral + data$F4_P2_neutral + data$Fz_P2_neutral)/5

MANOVA(data,dvs=c('aF_P2_pain','aF_P2_neutral'),dvs.pattern='(.+)',within='expression',between='race')
data$aF_P2_control = data$aF_P2_pain- data$aF_P2_neutral
TTEST(data,y=c('aF_P2_pain','aF_P2_neutral','aF_P2_control'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('aF_P2_pain','aF_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('aF_P2_pain','aF_P2_neutral'),paired = TRUE)

## Frontal-Central
data$aFC_N2_pain = (data$FC1_N2_pain + data$FC2_N2_pain + data$FC3_N2_pain + data$FC4_N2_pain + data$FCz_N2_pain)/5
data$aFC_N2_neutral = (data$FC1_N2_neutral + data$FC2_N2_neutral + data$FC3_N2_neutral + data$FC4_N2_neutral + data$FCz_N2_neutral)/5

MANOVA(data,dvs=c('aFC_N2_pain','aFC_N2_neutral'),dvs.pattern='(.+)',within='expression',between='race')
data$aFC_N2_control = data$aFC_N2_pain- data$aFC_N2_neutral
TTEST(data,y=c('aFC_N2_pain','aFC_N2_neutral','aFC_N2_control'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('aFC_N2_pain','aFC_N2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('aFC_N2_pain','aFC_N2_neutral'),paired = TRUE)

## Central
data$aC_P2_pain = (data$C1_P2_pain + data$C2_P2_pain + data$C3_P2_pain + data$C4_P2_pain + data$Cz_P2_pain)/5
data$aC_P2_neutral = (data$C1_P2_neutral + data$C2_P2_neutral + data$C3_P2_neutral + data$C4_P2_neutral + data$Cz_P2_neutral)/5

MANOVA(data,dvs=c('aC_P2_pain','aC_P2_neutral'),dvs.pattern='(.+)',within='expression',between='race')
data$aC_P2_control = data$aC_P2_pain- data$aC_P2_neutral
TTEST(data,y=c('aC_P2_pain','aC_P2_neutral','aC_P2_control'),x='race')
TTEST(data=filter(data,data$race=='Asian'),y=c('aC_P2_pain','aC_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Caucasian'),y=c('aC_P2_pain','aC_P2_neutral'),paired = TRUE)

TTEST(data=filter(data,data$race=='Asian'),y=c('aC_P2_pain','aC_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Asian'),y=c('C3_P2_pain','C3_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Asian'),y=c('C1_P2_pain','C1_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Asian'),y=c('Cz_P2_pain','Cz_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Asian'),y=c('C2_P2_pain','C2_P2_neutral'),paired = TRUE)
TTEST(data=filter(data,data$race=='Asian'),y=c('C4_P2_pain','C4_P2_neutral'),paired = TRUE)



