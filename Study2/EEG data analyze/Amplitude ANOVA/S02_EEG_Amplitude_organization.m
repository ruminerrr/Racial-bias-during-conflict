clear
clc
addpath('/Applications/eeglab2023.1');
eeglab
close all

%read in Data (still to modify)
%"THE GREAT CHANGE"
read_dir = '/Users/junchenglu/Research/ORB/EEG/mastiod/';
condition = readtable("eeg_behvaior_condition.xlsx");
%load('peaks.mat')
load('montage_for_topoplot.mat')
%"THE GREAT CHANGE":Please load the previous information from preprocessing
% load('D:\EEG data process\scripts\Evaluation.mat') % evaluation file that should be safed at the End of preprocessing file

% amplitude time window setting
frontal_N1_start = floor((115+1000)/(1000/EEG.srate));
frontal_N1_end = floor((165+1000)/(1000/EEG.srate));
frontal_P2_start = floor((175+1000)/(1000/EEG.srate));
frontal_P2_end = floor((225+1000)/(1000/EEG.srate));
frontal_N2_start = floor((242+1000)/(1000/EEG.srate));
frontal_N2_end = floor((322+1000)/(1000/EEG.srate));
central_N1_start = floor((111+1000)/(1000/EEG.srate));
central_N1_end = floor((161+1000)/(1000/EEG.srate));
central_P2_start = floor((171+1000)/(1000/EEG.srate));
central_P2_end = floor((221+1000)/(1000/EEG.srate));
central_N2_start = floor((238+1000)/(1000/EEG.srate));
central_N2_end = floor((318+1000)/(1000/EEG.srate));
P7P8_P1_start = floor((140+1000)/(1000/EEG.srate));
P7P8_P1_end = floor((180+1000)/(1000/EEG.srate));
P7P8_N170_start = floor((188+1000)/(1000/EEG.srate));
P7P8_N170_end = floor((228+1000)/(1000/EEG.srate));
% electrodes setting
FronElec = [8:12 17:21];%frontal regions: F3,F1,Fz,F2,F4,FC3,FC1,FCz,FC2,FC4
CentElec = 26:30; %central regions: C3,C1,Cz,C2,C4
OctrElec = [42 50]; %occipito-trmporal regions:P7,P8

baselinestart = ((1000-200)/(1000/EEG.srate))+1; %from -200, as the segments start here from -1000, sampling rate set above
baselinestop =	((1000-0)/(1000/EEG.srate))+1; % to 0, as the segments start here from -1000, sampling rate set above
Segementation_time_start = -1;
Segementation_time_end = 2;

%select the files that are in the relevant directory:
files = dir([read_dir '*.set']);
filenames = {files.name}';
%How many participants / files are there ?
SubjectNum = size(filenames,1);

% choose epoches
ProcessEpoches;

%Create an array only to visually quickly check whether a case / condition is given in a participant and if so how many times.
Casecheck (:,:) = zeros(SubjectNum,size(TrialCases,2), 'single');
result = string([]);
result(1,1) = "subj_idx";
result(1,2) = "outSold";
result(1,3) = "stim";
result(1,4) = "stimulus";
result(1,5) = "type";
result(1,6) = "response";
result(1,7) = "rt";
result(1,8) = "gender";
result(1,9) = "race";
result(1,10) = "frontal_N1";
result(1,11) = "frontal_P2";
result(1,12) = "frontal_N2";
result(1,13) = "central_N1";
result(1,14) = "central_P2";
result(1,15) = "central_N2";
result(1,16) = "P7P8_P1";
result(1,17) = "P7P8_N170";
result(1,18) = "F3_N1";
result(1,19) = "F1_N1";
result(1,20) = "Fz_N1";
result(1,21) = "F2_N1";
result(1,22) = "F4_N1";
result(1,23) = "FC3_N1";
result(1,24) = "FC1_N1";
result(1,25) = "FCz_N1";
result(1,26) = "FC2_N1";
result(1,27) = "FC4_N1";
result(1,28) = "C3_N1";
result(1,29) = "C1_N1";
result(1,30) = "Cz_N1";
result(1,31) = "C2_N1";
result(1,32) = "C4_N1";
result(1,33) = "F3_P2";
result(1,34) = "F1_P2";
result(1,35) = "Fz_P2";
result(1,36) = "F2_P2";
result(1,37) = "F4_P2";
result(1,38) = "FC3_P2";
result(1,39) = "FC1_P2";
result(1,40) = "FCz_P2";
result(1,41) = "FC2_P2";
result(1,42) = "FC4_P2";
result(1,43) = "C3_P2";
result(1,44) = "C1_P2";
result(1,45) = "Cz_P2";
result(1,46) = "C2_P2";
result(1,47) = "C4_P2";
result(1,48) = "F3_N2";
result(1,49) = "F1_N2";
result(1,50) = "Fz_N2";
result(1,51) = "F2_N2";
result(1,52) = "F4_N2";
result(1,53) = "FC3_N2";
result(1,54) = "FC1_N2";
result(1,55) = "FCz_N2";
result(1,56) = "FC2_N2";
result(1,57) = "FC4_N2";
result(1,58) = "C3_N2";
result(1,59) = "C1_N2";
result(1,60) = "Cz_N2";
result(1,61) = "C2_N2";
result(1,62) = "C4_N2";
result(1,63) = "P7_P1";
result(1,64) = "P8_P1";
result(1,65) = "P7_N170";
result(1,66) = "P8_N170";

for P = 1:SubjectNum
    EEG = pop_loadset('filename',filenames{P},'filepath',read_dir);	
    subj_idx = regexp(filenames{P}, '(\d+)', 'match');
    subj_idx = str2double(subj_idx{1});
    gender = string(condition.gender{condition.ID==subj_idx});
    race = string(condition.race{condition.ID==subj_idx});

    for CASES = 1:size(TrialCases,2)
        ddm = string([]);
        [sold_num, stim, stimulus, type, response] = epoch_ddm(CASES, race);

        try % see whether the relevant segements are there... else do the next iteration
            EEG = pop_epoch( EEG, TrialCases{CASES}, [-1.4 12], 'epochinfo', 'yes'); %select trials
            EEG_stim = pop_select(EEG,'time',[-1.4 7]);
            EEG_stim = pop_epoch(EEG_stim, StimCases{CASES},[Segementation_time_start Segementation_time_end]);
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); %#ok<*ASGLU>
            EEG = eeg_checkset( EEG );
            % baseline correction
            for i = 1:size(EEG_stim.data,1)
                for j = 1:size(EEG_stim.data,3)
                    EEG_stim.data (i,:,j) = EEG_stim.data (i,:,j) - nanmean(EEG_stim.data(i,baselinestart:baselinestop,j),2); %#ok<*NANMEAN>
                end
            end

            try
                if size(EEG.data) == [EEG.nbchan,EEG.pnts]
                    for index = 1:size(EEG.event,2)
                        if strcmp(EEG.event(index).type, ChoiceCases{CASES})
                            break;
                        end
                    end
                    rt = (EEG.event(index).latency-EEG.event(index-1).latency)*(1000/EEG.srate);

                    frontal_N1 = mean(squeeze(EEG_stim.data(FronElec,frontal_N1_start:frontal_N1_end)),'all');
                    frontal_P2 = mean(squeeze(EEG_stim.data(FronElec,frontal_P2_start:frontal_P2_end)),'all');
                    frontal_N2 = mean(squeeze(EEG_stim.data(FronElec,frontal_N2_start:frontal_N2_end)),'all');
                    central_N1 = mean(squeeze(EEG_stim.data(CentElec,central_N1_start:central_N1_end)),'all');
                    central_P2 = mean(squeeze(EEG_stim.data(CentElec,central_P2_start:central_P2_end)),'all');
                    central_N2 = mean(squeeze(EEG_stim.data(CentElec,central_N2_start:central_N2_end)),'all');
                    P7P8_P1 = mean(squeeze(EEG_stim.data(OctrElec,P7P8_P1_start:P7P8_P1_end)),'all');
                    P7P8_N170 = mean(squeeze(EEG_stim.data(OctrElec,P7P8_N170_start:P7P8_N170_end)),'all');

                    ddm(1,1) = subj_idx;
                    ddm(1,2) = sold_num;
                    ddm(1,3) = stim;
                    ddm(1,4) = stimulus;
                    ddm(1,5) = type;
                    ddm(1,6) = response;
                    ddm(1,7) = rt;
                    ddm(1,8) = gender;
                    ddm(1,9) = race;
                    ddm(1,10) = frontal_N1;
                    ddm(1,11) = frontal_P2;
                    ddm(1,12) = frontal_N2;
                    ddm(1,13) = central_N1;
                    ddm(1,14) = central_P2;
                    ddm(1,15) = central_N2;
                    ddm(1,16) = P7P8_P1;
                    ddm(1,17) = P7P8_N170;
                    
                    for i = 1:size(FronElec,2)
                        frontal_N1_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_N1_start:frontal_N1_end)),'all');
                        ddm(1,i+17) = frontal_N1_elec;
                        frontal_P2_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_P2_start:frontal_P2_end)),'all');
                        ddm(1,i+32) = frontal_P2_elec;
                        frontal_N2_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_N2_start:frontal_N2_end)),'all');
                        ddm(1,i+47) = frontal_N2_elec;
                    end

                    for i = 1:size(CentElec,2)
                        central_N1_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_N1_start:central_N1_end)),'all');
                        ddm(1,i+27) = central_N1_elec;
                        central_P2_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_P2_start:central_P2_end)),'all');
                        ddm(1,i+42) = central_P2_elec;
                        central_N2_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_N2_start:central_N2_end)),'all');
                        ddm(1,i+57) = central_N2_elec;
                    end

                    for i = 1:size(OctrElec,2)
                        P7P8_P1_elec = mean(squeeze(EEG_stim.data(OctrElec(i),P7P8_P1_start:P7P8_P1_end)),'all');
                        ddm(1,i+62) = P7P8_P1_elec;
                        P7P8_N170_elec = mean(squeeze(EEG_stim.data(OctrElec(i),P7P8_N170_start:P7P8_N170_end)),'all');
                        ddm(1,i+64) = P7P8_N170_elec;
                    end

                end
            end

            try
                for j = 1:size(EEG.data,3)
                    index = find(cellfun(@(x) strcmp(x, ChoiceCases{CASES}), EEG.epoch(j).eventtype), 1);
                    TimeArray = cell2mat(EEG.epoch(j).eventlatency);
                    rt = TimeArray(index)-TimeArray(index-1);
                    frontal_N1 = mean(squeeze(EEG_stim.data(FronElec,frontal_N1_start:frontal_N1_end,j)),'all');
                    frontal_P2 = mean(squeeze(EEG_stim.data(FronElec,frontal_P2_start:frontal_P2_end,j)),'all');
                    frontal_N2 = mean(squeeze(EEG_stim.data(FronElec,frontal_N2_start:frontal_N2_end,j)),'all');
                    central_N1 = mean(squeeze(EEG_stim.data(CentElec,central_N1_start:central_N1_end,j)),'all');
                    central_P2 = mean(squeeze(EEG_stim.data(CentElec,central_P2_start:central_P2_end,j)),'all');
                    central_N2 = mean(squeeze(EEG_stim.data(CentElec,central_N2_start:central_N2_end,j)),'all');
                    P7P8_P1 = mean(squeeze(EEG_stim.data(OctrElec,P7P8_P1_start:P7P8_P1_end,j)),'all');
                    P7P8_N170 = mean(squeeze(EEG_stim.data(OctrElec,P7P8_N170_start:P7P8_N170_end,j)),'all');

                    ddm(j,1) = subj_idx;
                    ddm(j,2) = sold_num;
                    ddm(j,3) = stim;
                    ddm(j,4) = stimulus;
                    ddm(j,5) = type;
                    ddm(j,6) = response;
                    ddm(j,7) = rt;
                    ddm(j,8) = gender;
                    ddm(j,9) = race;
                    ddm(j,10) = frontal_N1;
                    ddm(j,11) = frontal_P2;
                    ddm(j,12) = frontal_N2;
                    ddm(j,13) = central_N1;
                    ddm(j,14) = central_P2;
                    ddm(j,15) = central_N2;
                    ddm(j,16) = P7P8_P1;
                    ddm(j,17) = P7P8_N170;

                    for i = 1:size(FronElec,2)
                        frontal_N1_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_N1_start:frontal_N1_end,j)),'all');
                        ddm(j,i+17) = frontal_N1_elec;
                        frontal_P2_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_P2_start:frontal_P2_end,j)),'all');
                        ddm(j,i+32) = frontal_P2_elec;
                        frontal_N2_elec = mean(squeeze(EEG_stim.data(FronElec(i),frontal_N2_start:frontal_N2_end,j)),'all');
                        ddm(j,i+47) = frontal_N2_elec;
                    end

                    for i = 1:size(CentElec,2)
                        central_N1_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_N1_start:central_N1_end,j)),'all');
                        ddm(j,i+27) = central_N1_elec;
                        central_P2_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_P2_start:central_P2_end,j)),'all');
                        ddm(j,i+42) = central_P2_elec;
                        central_N2_elec = mean(squeeze(EEG_stim.data(CentElec(i),central_N2_start:central_N2_end,j)),'all');
                        ddm(j,i+57) = central_N2_elec;
                    end

                    for i = 1:size(OctrElec,2)
                        P7P8_P1_elec = mean(squeeze(EEG_stim.data(OctrElec(i),P7P8_P1_start:P7P8_P1_end,j)),'all');
                        ddm(j,i+62) = P7P8_P1_elec;
                        P7P8_N170_elec = mean(squeeze(EEG_stim.data(OctrElec(i),P7P8_N170_start:P7P8_N170_end,j)),'all');
                        ddm(j,i+64) = P7P8_N170_elec;
                    end

                end
            end

            %Count the trials in the conditions and create a casecheck array
            try %#ok<*TRYNC>
                if size(EEG.data) == [EEG.nbchan,EEG.pnts] %#ok<*BDSCA>
                    Casecheck(P,CASES) =  single(1);                                  %2D array: VP,CASES
                end
            end
            try
                if size(EEG.data,3)>1
                    Casecheck(P,CASES) = single(size(EEG.data,3));                    %2D array: VP,CASES
                end
            end

            result = [result;ddm]; %#ok<*AGROW>
            STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];  %#ok<*NASGU> %clear the EEG sets
            EEG = pop_loadset('filename',filenames{P},'filepath',read_dir);       %reload data here if something was cut from it
        end %try end: If this condition can not be found, then simply start from here -> next condition
    end
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];		    %clear the EEG sets
end

writematrix(result,'eeg_ddm_StimAllElec_new.csv');

function[soldiler_number, stim, stimulus, type, response] = epoch_ddm(idx,race)
load('peaks.mat');
switch idx
    case 1
        soldiler_number = "low";
        stim = "female";
        stimulus = "face";
        type = "neutral";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 2
        soldiler_number = "low";
        stim = "female";
        stimulus = "face";
        type = "neutral";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 3
        soldiler_number = "low";
        stim = "male";
        stimulus = "face";
        type = "neutral";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 4
        soldiler_number = "low";
        stim = "male";
        stimulus = "face";
        type = "neutral";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 5
        soldiler_number = "low";
        stim = "female";
        stimulus = "face";
        type = "pain";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 6
        soldiler_number = "low";
        stim = "female";
        stimulus = "face";
        type = "pain";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 7
        soldiler_number = "low";
        stim = "male";
        stimulus = "face";
        type = "pain";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 8
        soldiler_number = "low";
        stim = "male";
        stimulus = "face";
        type = "pain";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 9
        soldiler_number = "high";
        stim = "female";
        stimulus = "face";
        type = "neutral";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 10
        soldiler_number = "high";
        stim = "female";
        stimulus = "face";
        type = "neutral";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 11
        soldiler_number = "high";
        stim = "male";
        stimulus = "face";
        type = "neutral";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 12
        soldiler_number = "high";
        stim = "male";
        stimulus = "face";
        type = "neutral";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimANF;
        else
            peak_time = peak_segmentation_start+c_StimCNF;
        end
    case 13
        soldiler_number = "high";
        stim = "female";
        stimulus = "face";
        type = "pain";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 14
        soldiler_number = "high";
        stim = "female";
        stimulus = "face";
        type = "pain";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 15
        soldiler_number = "high";
        stim = "male";
        stimulus = "face";
        type = "pain";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 16
        soldiler_number = "high";
        stim = "male";
        stimulus = "face";
        type = "pain";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimAPF;
        else
            peak_time = peak_segmentation_start+c_StimCPF;
        end
    case 17
        soldiler_number = "low";
        stim = "tree";
        stimulus = "tree";
        type = "tree";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimATF;
        else
            peak_time = peak_segmentation_start+c_StimCTF;
        end
    case 18
        soldiler_number = "low";
        stim = "tree";
        stimulus = "tree";
        type = "tree";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimATF;
        else
            peak_time = peak_segmentation_start+c_StimCTF;
        end
    case 19
        soldiler_number = "high";
        stim = "tree";
        stimulus = "tree";
        type = "tree";
        response = 1;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimATF;
        else
            peak_time = peak_segmentation_start+c_StimCTF;
        end
    case 20
        soldiler_number = "high";
        stim = "tree";
        stimulus = "tree";
        type = "tree";
        response = 0;
        if race=="Asian"
            peak_time = peak_segmentation_start+c_StimATF;
        else
            peak_time = peak_segmentation_start+c_StimCTF;
        end
end
end