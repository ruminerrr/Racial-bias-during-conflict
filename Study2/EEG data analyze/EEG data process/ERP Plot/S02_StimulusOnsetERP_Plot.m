%% Load ERP Matrix
close all;clear;clc;
load('/Users/junchenglu/Research/ORB/EEG/scripts/StimERP.mat');
load('montage_for_topoplot.mat');
FronElec = [8:12 17:21]; %frontal regions: F3,F1,Fz,F2,F4,FC3,FC1,FCz,FC2,FC4
CentElec = 26:30; %central regions: C3,C1,Cz,C2,C4
OctrElec = [42 50]; %occipito-trmporal regions:P7,P8
FronElec_text = ["F3","F1","Fz","F2","F4","FC3","FC1","FCz","FC2","FC4"];
CentElec_text = ["C3","C1","Cz","C2","C4"];
OctrElec_text = ["P7","P8"];
frontal = 8:12;
fron_cent = 17:21;
central = 26:30;
%% Plot parameter
display_time_start_from_zero_in_ms = -200; %Note that one can also go into - : this means it is left from 0, being a display of the baseline. Note also that you cannot display data that is not in your segmentation.
display_time_end_from_zero_in_ms = 800; %Note also that you cannot display data that is not in your segmentation.
%display parameter for ERP:
display_time_start = display_time_start_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate
display_time_end = display_time_end_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate
%% set conditions
% trial condition
PainCond = [5:8 13:16];
NeutCond = [1:4 9:12];
NoTreeCond = 1:16;
TreeCond = 17:20;
LaunchCond = 1:2:19;
CancelCond = 2:2:20;
PainLaunchCond = intersect(PainCond,LaunchCond);
PainCancelCond = intersect(PainCond,CancelCond);
NeutLaunchCond = intersect(NeutCond,LaunchCond);
NeutCancelCond = intersect(NeutCond,CancelCond);
TreeLaunchCond = intersect(TreeCond,LaunchCond);
TreeCancelCond = intersect(TreeCond,CancelCond);
% group condition
SubCond = readtable('eeg_exp_condition.xlsx');
AsianCond = SubCond(string(SubCond.Condition)=="Asian",:);
AsianCond = AsianCond.ID;
CaucaCond = SubCond(string(SubCond.Condition)=="Caucasian",:);
CaucaCond = CaucaCond.ID;
MaleCond = SubCond(string(SubCond.Gender)=="male",:);
MaleCond = MaleCond.ID;
FemaleCond = SubCond(string(SubCond.Gender)=="female",:);
FemaleCond = FemaleCond.ID;
AsianMaleCond = intersect(AsianCond,MaleCond);
CaucaMaleCond = intersect(CaucaCond,MaleCond);
AsianFemaleCond = intersect(AsianCond,FemaleCond);
CaucaFemaleCond = intersect(CaucaCond,FemaleCond);
% extend subject condition matrix (each subject has 4 blocks)
for i=1:size(AsianCond,1)
    AsianCondEx((i-1)*4+1:i*4) = (AsianCond(i)*4-3: AsianCond(i)*4);
end
for i=1:size(CaucaCond,1)
    CaucaCondEx((i-1)*4+1:i*4) = (CaucaCond(i)*4-3: CaucaCond(i)*4);
end

%% Frontal

Front_N1 = [115 165];
Front_P2 = [175 225];
Front_N2 = [242 322];
for i = 1:size(FronElec,2)

    %%% Asian face
    erp_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,FronElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_asian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,FronElec(i),:),1),2),3));
    erp_asian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,TreeCond,FronElec(i),:),1),2),3));

    figure1 = ERP_P(erp_asian_pain,erp_asian_neut,Front_N1,Front_P2,Front_N2);
    legend('Asian Painful Face','Asian Neutral Face','','','')
    title_asian = strcat("Asian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_asian_PvN.jpg'),'Resolution',300)
    hold off

    figure2 = ERP_P(erp_asian_pain,erp_asian_tree,Front_N1,Front_P2,Front_N2);
    legend('Asian Painful Face','Tree','','','')
    title_asian = strcat("Asian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_asian_PvT.jpg'),'Resolution',300)
    hold off

    figure3 = ERP_P(erp_asian_neut,erp_asian_tree,Front_N1,Front_P2,Front_N2);
    legend('Asian Neutral Face','Tree','','','')
    title_asian = strcat("Asian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_asian_NvT.jpg'),'Resolution',300)
    hold off

    %%% Caucasian face
    erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,FronElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,FronElec(i),:),1),2),3));
    erp_caucasian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,TreeCond,FronElec(i),:),1),2),3));

    figure4 = ERP_P(erp_caucasian_pain,erp_caucasian_neut,Front_N1,Front_P2,Front_N2);
    legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
    title_asian = strcat("Caucasian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_caucasian_PvN.jpg'),'Resolution',300)
    hold off

    figure5 = ERP_P(erp_caucasian_pain,erp_caucasian_tree,Front_N1,Front_P2,Front_N2);
    legend('Caucasian Painful Face','Tree','','','')
    title_asian = strcat("Caucasian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_caucasian_PvT.jpg'),'Resolution',300)
    hold off

    figure6 = ERP_P(erp_caucasian_neut,erp_caucasian_tree,Front_N1,Front_P2,Front_N2);
    legend('Caucasian Neutral Face','Tree','','','')
    title_asian = strcat("Caucasian ",FronElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_caucasian_NvT.jpg'),'Resolution',300)
    hold off
end

%% Central

Cent_N1 = [111 161];
Cent_P2 = [171 221];
Cent_N2 = [238 318];

for i = 1:size(CentElec,2)

    %%% Asian face
    erp_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,CentElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_asian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,CentElec(i),:),1),2),3));
    erp_asian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,TreeCond,CentElec(i),:),1),2),3));

    figure1 = ERP_P(erp_asian_pain,erp_asian_neut,Cent_N1,Cent_P2,Cent_N2);
    legend('Asian Painful Face','Asian Neutral Face','','','')
    title_asian = strcat("Asian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_asian_PvN.jpg'),'Resolution',300)
    hold off

    figure2 = ERP_P(erp_asian_pain,erp_asian_tree,Cent_N1,Cent_P2,Cent_N2);
    legend('Asian Painful Face','Tree','','','')
    title_asian = strcat("Asian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_asian_PvT.jpg'),'Resolution',300)
    hold off

    figure3 = ERP_P(erp_asian_neut,erp_asian_tree,Cent_N1,Cent_P2,Cent_N2);
    legend('Asian Neutral Face','Tree','','','')
    title_asian = strcat("Asian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_asian_NvT.jpg'),'Resolution',300)
    hold off

    %%% Caucasian face
    erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,CentElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,CentElec(i),:),1),2),3));
    erp_caucasian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,TreeCond,CentElec(i),:),1),2),3));

    figure4 = ERP_P(erp_caucasian_pain,erp_caucasian_neut,Cent_N1,Cent_P2,Cent_N2);
    legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
    title_asian = strcat("Caucasian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_caucasian_PvN.jpg'),'Resolution',300)
    hold off

    figure5 = ERP_P(erp_caucasian_pain,erp_caucasian_tree,Cent_N1,Cent_P2,Cent_N2);
    legend('Caucasian Painful Face','Tree','','','')
    title_asian = strcat("Caucasian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_caucasian_PvT.jpg'),'Resolution',300)
    hold off

    figure6 = ERP_P(erp_caucasian_neut,erp_caucasian_tree,Cent_N1,Cent_P2,Cent_N2);
    legend('Caucasian Neutral Face','Tree','','','')
    title_asian = strcat("Caucasian ",CentElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_caucasian_NvT.jpg'),'Resolution',300)
    hold off
end

%% P7P8

P7P8_P1 = [140 180];
P7P8_N170 = [188 228];

for i = 1:size(OctrElec,2)

    %%% Asian face
    erp_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,OctrElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_asian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,OctrElec(i),:),1),2),3));
    erp_asian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,TreeCond,OctrElec(i),:),1),2),3));

    figure1 = ERP_N(erp_asian_pain,erp_asian_neut,P7P8_P1,P7P8_N170);
    legend('Asian Painful Face','Asian Neutral Face','','','')
    title_asian = strcat("Asian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_asian_PvN.jpg'),'Resolution',300)
    hold off

    figure2 = ERP_N(erp_asian_pain,erp_asian_tree,P7P8_P1,P7P8_N170);
    legend('Asian Painful Face','Tree','','','')
    title_asian = strcat("Asian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_asian_PvT.jpg'),'Resolution',300)
    hold off

    figure3 = ERP_N(erp_asian_neut,erp_asian_tree,P7P8_P1,P7P8_N170);
    legend('Asian Neutral Face','Tree','','','')
    title_asian = strcat("Asian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_asian_NvT.jpg'),'Resolution',300)
    hold off

    %%% Caucasian face
    erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,OctrElec(i),:),1),2),3)); %#ok<*NANMEAN>
    erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,OctrElec(i),:),1),2),3));
    erp_caucasian_tree = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,TreeCond,OctrElec(i),:),1),2),3));

    figure4 = ERP_N(erp_caucasian_pain,erp_caucasian_neut,P7P8_P1,P7P8_N170);
    legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
    title_asian = strcat("Caucasian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_caucasian_PvN.jpg'),'Resolution',300)
    hold off

    figure5 = ERP_N(erp_caucasian_pain,erp_caucasian_tree,P7P8_P1,P7P8_N170);
    legend('Caucasian Painful Face','Tree','','','')
    title_asian = strcat("Caucasian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_caucasian_PvT.jpg'),'Resolution',300)
    hold off

    figure6 = ERP_N(erp_caucasian_neut,erp_caucasian_tree,P7P8_P1,P7P8_N170);
    legend('Caucasian Neutral Face','Tree','','','')
    title_asian = strcat("Caucasian ",OctrElec_text(i));
    title(title_asian)
    exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_caucasian_NvT.jpg'),'Resolution',300)
    hold off
end

%% Average channel

%% Frontal
frontal_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,frontal,:),1),2),3));
frontal_asian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,frontal,:),1),2),3));
frontal_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,frontal,:),1),2),3));
frontal_caucasian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,frontal,:),1),2),3));
Front_N1 = [115 165];
Front_P2 = [175 225];
Front_N2 = [242 322];
% Asian 
figure
plot(frontal_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(frontal_asian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Front_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Front_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Front_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Front_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Front_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Front_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Asian Painful Face','Asian Neutral Face','','','')
title("Asian average frontal channel")
exportgraphics(gca,strcat('erp_figures/','averageF','_asian_PvN.jpg'),'Resolution',300)
hold off
% Caucasian 
figure
plot(frontal_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(frontal_caucasian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Front_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Front_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Front_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Front_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Front_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Front_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
title("Caucasian average frontal channel")
exportgraphics(gca,strcat('erp_figures/','averageF','_caucasian_PvN.jpg'),'Resolution',300)
hold off

%% Frontal-Central
froncent_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,fron_cent,:),1),2),3));
froncent_asian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,fron_cent,:),1),2),3));
froncent_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,fron_cent,:),1),2),3));
froncent_caucasian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,fron_cent,:),1),2),3));
Front_N1 = [115 165];
Front_P2 = [175 225];
Front_N2 = [242 322];
% Asian 
figure
plot(froncent_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(froncent_asian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Front_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Front_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Front_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Front_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Front_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Front_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Asian Painful Face','Asian Neutral Face','','','')
title("Asian average frontal-central channel")
exportgraphics(gca,strcat('erp_figures/','averageFC','_asian_PvN.jpg'),'Resolution',300)
hold off
% Caucasian 
figure
plot(froncent_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(froncent_caucasian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Front_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Front_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Front_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Front_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Front_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Front_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
title("Caucasian average frontal-central channel")
exportgraphics(gca,strcat('erp_figures/','averageFC','_caucasian_PvN.jpg'),'Resolution',300)
hold off

%% Central
central_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,central,:),1),2),3));
central_asian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,central,:),1),2),3));
central_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,central,:),1),2),3));
central_caucasian_neutral = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,central,:),1),2),3));
Cent_N1 = [111 161];
Cent_P2 = [171 221];
Cent_N2 = [238 318];
% Asian 
figure
plot(central_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(central_asian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Cent_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Cent_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Cent_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Cent_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Cent_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Cent_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Asian Painful Face','Asian Neutral Face','','','')
title("Asian average central channel")
exportgraphics(gca,strcat('erp_figures/','averageC','_asian_PvN.jpg'),'Resolution',300)
hold off

% Caucasian 
figure
plot(central_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(central_caucasian_neutral(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');
% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+Cent_N1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+Cent_N1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+Cent_P2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+Cent_P2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+Cent_N2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+Cent_N2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% label&save
legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
title("Caucasian average central channel")
exportgraphics(gca,strcat('erp_figures/','averageC','_caucasian_PvN.jpg'),'Resolution',300)
hold off

%     %%%% Pain vs. Neutral
%     figure
%     plot(erp_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_asian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % N1
%     n1_start_time = (-display_time_start_from_zero_in_ms+115)/(1000/EEG.srate);
%     n1_end_time = (-display_time_start_from_zero_in_ms+165)/(1000/EEG.srate);
%     n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
%     n1y = [yl(1), yl(1), 0, 0];
%     patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % P2
%     p2_start_time = (-display_time_start_from_zero_in_ms+175)/(1000/EEG.srate);
%     p2_end_time = (-display_time_start_from_zero_in_ms+225)/(1000/EEG.srate);
%     p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
%     p2y = [0, 0, yl(2), yl(2)];
%     patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N2
%     n2_start_time = (-display_time_start_from_zero_in_ms+242)/(1000/EEG.srate);
%     n2_end_time = (-display_time_start_from_zero_in_ms+322)/(1000/EEG.srate);
%     n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
%     n2y = [yl(1), yl(1), 0, 0];
%     patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Asian Painful Face','Asian Neutral Face','','','')
%     title_asian = strcat("Asian ",FronElec_text(i));
%     title(title_asian)
%     exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_asian_PvN.jpg'),'Resolution',300)
%     hold off
% 
%     %%%% Pain vs. Tree
%     figure
%     plot(erp_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_asian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % N1
%     n1_start_time = (-display_time_start_from_zero_in_ms+115)/(1000/EEG.srate);
%     n1_end_time = (-display_time_start_from_zero_in_ms+165)/(1000/EEG.srate);
%     n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
%     n1y = [yl(1), yl(1), 0, 0];
%     patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % P2
%     p2_start_time = (-display_time_start_from_zero_in_ms+175)/(1000/EEG.srate);
%     p2_end_time = (-display_time_start_from_zero_in_ms+225)/(1000/EEG.srate);
%     p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
%     p2y = [0, 0, yl(2), yl(2)];
%     patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N2
%     n2_start_time = (-display_time_start_from_zero_in_ms+242)/(1000/EEG.srate);
%     n2_end_time = (-display_time_start_from_zero_in_ms+322)/(1000/EEG.srate);
%     n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
%     n2y = [yl(1), yl(1), 0, 0];
%     patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Asian Painful Face','Asian Neutral Face','','','')
%     title_asian = strcat("Asian ",FronElec_text(i));
%     title(title_asian)
%     exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_asian_PvT.jpg'),'Resolution',300)
%     hold off
% 
%     %%% Caucasian face
%     erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,FronElec(i),:),1),2),3)); %#ok<*NANMEAN>
%     erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,FronElec(i),:),1),2),3));
%     figure
%     plot(erp_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_caucasian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % N1
%     n1_start_time = (-display_time_start_from_zero_in_ms+115)/(1000/EEG.srate);
%     n1_end_time = (-display_time_start_from_zero_in_ms+165)/(1000/EEG.srate);
%     n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
%     n1y = [yl(1), yl(1), 0, 0];
%     patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % P2
%     p2_start_time = (-display_time_start_from_zero_in_ms+175)/(1000/EEG.srate);
%     p2_end_time = (-display_time_start_from_zero_in_ms+225)/(1000/EEG.srate);
%     p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
%     p2y = [0, 0, yl(2), yl(2)];
%     patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N2
%     n2_start_time = (-display_time_start_from_zero_in_ms+242)/(1000/EEG.srate);
%     n2_end_time = (-display_time_start_from_zero_in_ms+322)/(1000/EEG.srate);
%     n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
%     n2y = [yl(1), yl(1), 0, 0];
%     patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
%     title_caucasian = strcat("Caucasian ",FronElec_text(i));
%     title(title_caucasian)
%     exportgraphics(gca,strcat('erp_figures/',FronElec_text(i),'_caucasian.jpg'),'Resolution',300)
%     hold off
% 
% end
% 
% %% central
% for i = 1:size(CentElec,2)
% 
%     %%% Asian face
%     erp_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,CentElec(i),:),1),2),3)); %#ok<*NANMEAN>
%     erp_asian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,CentElec(i),:),1),2),3));
%     figure
%     plot(erp_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_asian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % N1
%     n1_start_time = (-display_time_start_from_zero_in_ms+111)/(1000/EEG.srate);
%     n1_end_time = (-display_time_start_from_zero_in_ms+161)/(1000/EEG.srate);
%     n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
%     n1y = [yl(1), yl(1), 0, 0];
%     patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % P2
%     p2_start_time = (-display_time_start_from_zero_in_ms+171)/(1000/EEG.srate);
%     p2_end_time = (-display_time_start_from_zero_in_ms+221)/(1000/EEG.srate);
%     p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
%     p2y = [0, 0, yl(2), yl(2)];
%     patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N2
%     n2_start_time = (-display_time_start_from_zero_in_ms+238)/(1000/EEG.srate);
%     n2_end_time = (-display_time_start_from_zero_in_ms+318)/(1000/EEG.srate);
%     n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
%     n2y = [yl(1), yl(1), 0, 0];
%     patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Asian Painful Face','Asian Neutral Face','','','')
%     title_asian = strcat("Asian ",CentElec_text(i));
%     title(title_asian)
%     exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_asian.jpg'),'Resolution',300)
%     hold off
% 
%     %%% Caucasian face
%     erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,CentElec(i),:),1),2),3)); %#ok<*NANMEAN>
%     erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,CentElec(i),:),1),2),3));
%     figure
%     plot(erp_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_caucasian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % N1
%     n1_start_time = (-display_time_start_from_zero_in_ms+111)/(1000/EEG.srate);
%     n1_end_time = (-display_time_start_from_zero_in_ms+161)/(1000/EEG.srate);
%     n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
%     n1y = [yl(1), yl(1), 0, 0];
%     patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % P2
%     p2_start_time = (-display_time_start_from_zero_in_ms+171)/(1000/EEG.srate);
%     p2_end_time = (-display_time_start_from_zero_in_ms+221)/(1000/EEG.srate);
%     p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
%     p2y = [0, 0, yl(2), yl(2)];
%     patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N2
%     n2_start_time = (-display_time_start_from_zero_in_ms+238)/(1000/EEG.srate);
%     n2_end_time = (-display_time_start_from_zero_in_ms+318)/(1000/EEG.srate);
%     n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
%     n2y = [yl(1), yl(1), 0, 0];
%     patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
%     title_caucasian = strcat("Caucasian ",CentElec_text(i));
%     title(title_caucasian)
%     exportgraphics(gca,strcat('erp_figures/',CentElec_text(i),'_caucasian.jpg'),'Resolution',300)
%     hold off
% 
% end
% 
% %% P7P8
% for i = 1:size(OctrElec,2)
% 
%     %%% Asian face
%     erp_asian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,PainCond,OctrElec(i),:),1),2),3)); %#ok<*NANMEAN>
%     erp_asian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(AsianCondEx,NeutCond,OctrElec(i),:),1),2),3));
%     figure
%     plot(erp_asian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_asian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % P1
%     p1_start_time = (-display_time_start_from_zero_in_ms+140)/(1000/EEG.srate);
%     p1_end_time = (-display_time_start_from_zero_in_ms+180)/(1000/EEG.srate);
%     p1x = [p1_start_time, p1_end_time, p1_end_time, p1_start_time];
%     p1y = [0, 0, yl(2), yl(2)];
%     patch(p1x, p1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N170
%     n170_start_time = (-display_time_start_from_zero_in_ms+188)/(1000/EEG.srate);
%     n170_end_time = (-display_time_start_from_zero_in_ms+228)/(1000/EEG.srate);
%     n170x = [n170_start_time, n170_end_time, n170_end_time, n170_start_time];
%     n170y = [yl(1), yl(1), 0, 0];
%     patch(n170x, n170y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Asian Painful Face','Asian Neutral Face','','','')
%     title_asian = strcat("Asian ",OctrElec_text(i));
%     title(title_asian)
%     exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_asian.jpg'),'Resolution',300)
%     hold off
% 
%     %%% Caucasian face
%     erp_caucasian_pain = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,PainCond,OctrElec(i),:),1),2),3)); %#ok<*NANMEAN>
%     erp_caucasian_neut = squeeze(nanmean(nanmean(nanmean(StimERP(CaucaCondEx,NeutCond,OctrElec(i),:),1),2),3));
%     figure
%     plot(erp_caucasian_pain(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
%     hold on
%     set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
%     set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
%     plot(erp_caucasian_neut(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
%     xlim([0 display_time_end-display_time_start])
%     yl = ylim;
%     y=yl(1,1):0.2:yl(1,2);
%     plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
%     axis ij
%     set(gca, 'YAxisLocation', 'origin');
%     set(gca, 'XAxisLocation', 'origin');
% 
%     % amplitude time-windows
%     % P1
%     p1_start_time = (-display_time_start_from_zero_in_ms+140)/(1000/EEG.srate);
%     p1_end_time = (-display_time_start_from_zero_in_ms+180)/(1000/EEG.srate);
%     p1x = [p1_start_time, p1_end_time, p1_end_time, p1_start_time];
%     p1y = [0, 0, yl(2), yl(2)];
%     patch(p1x, p1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     % N170
%     n170_start_time = (-display_time_start_from_zero_in_ms+188)/(1000/EEG.srate);
%     n170_end_time = (-display_time_start_from_zero_in_ms+228)/(1000/EEG.srate);
%     n170x = [n170_start_time, n170_end_time, n170_end_time, n170_start_time];
%     n170y = [yl(1), yl(1), 0, 0];
%     patch(n170x, n170y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% 
%     legend('Caucasian Painful Face','Caucasian Neutral Face','','','')
%     title_caucasian = strcat("Caucasian ",OctrElec_text(i));
%     title(title_caucasian)
%     exportgraphics(gca,strcat('erp_figures/',OctrElec_text(i),'_caucasian.jpg'),'Resolution',300)
%     hold off

%% Functions
function erpfigure = ERP_P(erp1,erp2,n1,p2,n2)
EEG.srate=250;
Segementation_time_start = -1;
Segementation_time_end = 2;
display_time_start_from_zero_in_ms = -200; %Note that one can also go into - : this means it is left from 0, being a display of the baseline. Note also that you cannot display data that is not in your segmentation.
display_time_end_from_zero_in_ms = 800; %Note also that you cannot display data that is not in your segmentation.
%display parameter for ERP:
display_time_start = display_time_start_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate
display_time_end = display_time_end_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate

figure
plot(erp1(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(erp2(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');

% amplitude time-windows
% N1
n1_start_time = (-display_time_start_from_zero_in_ms+n1(1))/(1000/EEG.srate);
n1_end_time = (-display_time_start_from_zero_in_ms+n1(2))/(1000/EEG.srate);
n1x = [n1_start_time, n1_end_time, n1_end_time, n1_start_time];
n1y = [yl(1), yl(1), 0, 0];
patch(n1x, n1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% P2
p2_start_time = (-display_time_start_from_zero_in_ms+p2(1))/(1000/EEG.srate);
p2_end_time = (-display_time_start_from_zero_in_ms+p2(2))/(1000/EEG.srate);
p2x = [p2_start_time, p2_end_time, p2_end_time, p2_start_time];
p2y = [0, 0, yl(2), yl(2)];
patch(p2x, p2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n2_start_time = (-display_time_start_from_zero_in_ms+n2(1))/(1000/EEG.srate);
n2_end_time = (-display_time_start_from_zero_in_ms+n2(2))/(1000/EEG.srate);
n2x = [n2_start_time, n2_end_time, n2_end_time, n2_start_time];
n2y = [yl(1), yl(1), 0, 0];
patch(n2x, n2y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
erpfigure = gca;
end

function erpfigure = ERP_N(erp1,erp2,p1,n170)
EEG.srate=250;
Segementation_time_start = -1;
display_time_start_from_zero_in_ms = -200; %Note that one can also go into - : this means it is left from 0, being a display of the baseline. Note also that you cannot display data that is not in your segmentation.
display_time_end_from_zero_in_ms = 800; %Note also that you cannot display data that is not in your segmentation.
%display parameter for ERP:
display_time_start = display_time_start_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate
display_time_end = display_time_end_from_zero_in_ms/(1000/EEG.srate)-(Segementation_time_start*EEG.srate); % dependent on the starting point of segement and sampling rate

figure
plot(erp1(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#CE2E20')
hold on
set(gca,'XTick',[0 (display_time_end-display_time_start)/5 (display_time_end-display_time_start)*2/5 (display_time_end-display_time_start)*3/5 (display_time_end-display_time_start)*4/5 display_time_end-display_time_start] );
set(gca,'XTickLabel',[display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*2/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*3/5)+display_time_start_from_zero_in_ms ((display_time_end_from_zero_in_ms-display_time_start_from_zero_in_ms)*4/5)+display_time_start_from_zero_in_ms display_time_end_from_zero_in_ms] );
plot(erp2(display_time_start:display_time_end),'LineWidth',1.5, 'Color','#45486E')
xlim([0 display_time_end-display_time_start])
yl = ylim;
y=yl(1,1):0.2:yl(1,2);
plot((-display_time_start_from_zero_in_ms/(1000/EEG.srate))*ones(size(y)), y, 'LineWidth',1,'Color',[1 1 1],'LineStyle','--') %plot a line on 0
axis ij
set(gca, 'YAxisLocation', 'origin');
set(gca, 'XAxisLocation', 'origin');

% amplitude time-windows
% P1
p1_start_time = (-display_time_start_from_zero_in_ms+p1(1))/(1000/EEG.srate);
p1_end_time = (-display_time_start_from_zero_in_ms+p1(2))/(1000/EEG.srate);
p1x = [p1_start_time, p1_end_time, p1_end_time, p1_start_time];
p1y = [0, 0, yl(2), yl(2)];
patch(p1x, p1y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% N2
n170_start_time = (-display_time_start_from_zero_in_ms+n170(1))/(1000/EEG.srate);
n170_end_time = (-display_time_start_from_zero_in_ms+n170(2))/(1000/EEG.srate);
n170x = [n170_start_time, n170_end_time, n170_end_time, n170_start_time];
n170y = [yl(1), yl(1), 0, 0];
patch(n170x, n170y, [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
erpfigure = gca;
end