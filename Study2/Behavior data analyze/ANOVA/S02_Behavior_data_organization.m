clear;clc;
beh_dir = '/Users/junchenglu/Documents/MATLAB/ORB Study/EEG/result/';
all_files = dir(beh_dir);
beh_files = all_files([all_files.isdir]);
beh_files = beh_files(~ismember({beh_files.name}, {'.', '..'}));
beh_filenames = {beh_files.name}';
raw_result = [];
org_result = string([]);
org_result(1,1) = "ID";
org_result(1,4) = "low_neutral_female";
org_result(1,5) = "low_neutral_male";
org_result(1,6) = "low_pain_female";
org_result(1,7) = "low_pain_male";
org_result(1,8) = "low_tree";
org_result(1,9) = "high_neutral_female";
org_result(1,10) = "high_neutral_male";
org_result(1,11) = "high_pain_female";
org_result(1,12) = "high_pain_male";
org_result(1,13) = "high_tree";
org_result(1,14) = "low_neutral_female_RT";
org_result(1,15) = "low_neutral_male_RT";
org_result(1,16) = "low_pain_female_RT";
org_result(1,17) = "low_pain_male_RT";
org_result(1,18) = "low_tree_RT";
org_result(1,19) = "high_neutral_female_RT";
org_result(1,20) = "high_neutral_male_RT";
org_result(1,21) = "high_pain_female_RT";
org_result(1,22) = "high_pain_male_RT";
org_result(1,23) = "high_tree_RT";
for i = 1:size(beh_filenames)
    beh_data = readtable(strcat(beh_dir,beh_filenames{i},'/result.csv'));
    beh_data = sortrows(beh_data,"stimulus","ascend");
    % x=1;
    for j = 1:192
        k = j*2;
        beh_data_filter(j,1:3) = beh_data(k,:); %#ok<*SAGROW>
        beh_data_filter.Stim(j) = double(string(beh_data_filter.stimulus(j)));
        % if beh_data.response(j)==1||beh_data.response(j)==0
        %     beh_data_filter(x,1:3) = beh_data(j,:);
        %     beh_data_filter.Stim(x) = double(string(beh_data_filter.stimulus(x)));
        %     x=x+1;
        % end
    end
    beh_data_filter = sortrows(beh_data_filter,'Stim','ascend');
    beh_data_filter.response(beh_data_filter.response==99) = NaN;
    raw_result(i,1) = i;
    raw_result(i,2:193) = (beh_data_filter.response)';
    raw_result(i,194:385) = (beh_data_filter.rt)';
    % response
    org_result(i+1,1) = i;
    org_result(i+1,4) = nanmean(beh_data_filter.response(1:16)); %#ok<*NANMEAN>
    org_result(i+1,5) = nanmean(beh_data_filter.response(17:32));
    org_result(i+1,6) = nanmean(beh_data_filter.response(33:48));
    org_result(i+1,7) = nanmean(beh_data_filter.response(49:64));
    org_result(i+1,8) = nanmean(beh_data_filter.response(65:96));
    org_result(i+1,9) = nanmean(beh_data_filter.response(1+96:16+96));
    org_result(i+1,10) = nanmean(beh_data_filter.response(17+96:32+96));
    org_result(i+1,11) = nanmean(beh_data_filter.response(33+96:48+96));
    org_result(i+1,12) = nanmean(beh_data_filter.response(49+96:64+96));
    org_result(i+1,13) = nanmean(beh_data_filter.response(65+96:96+96));
    % rt
    org_result(i+1,14) = nanmean(beh_data_filter.rt(1:16));
    org_result(i+1,15) = nanmean(beh_data_filter.rt(17:32));
    org_result(i+1,16) = nanmean(beh_data_filter.rt(33:48));
    org_result(i+1,17) = nanmean(beh_data_filter.rt(49:64));
    org_result(i+1,18) = nanmean(beh_data_filter.rt(65:96));
    org_result(i+1,19) = nanmean(beh_data_filter.rt(1+96:16+96));
    org_result(i+1,20) = nanmean(beh_data_filter.rt(17+96:32+96));
    org_result(i+1,21) = nanmean(beh_data_filter.rt(33+96:48+96));
    org_result(i+1,22) = nanmean(beh_data_filter.rt(49+96:64+96));
    org_result(i+1,23) = nanmean(beh_data_filter.rt(65+96:96+96));
end

% condition = readtable('/Users/junchenglu/Documents/MATLAB/ORB Study/EEG/eeg_exp_condition.xlsx');
writematrix(org_result,'/Users/junchenglu/Documents/MATLAB/EEG data process/process script/org_result.csv');

%{
if index<=4
    stim_marker = 111;
    sold_marker = 1;
elseif index<=8&&index>4
    stim_marker = 112;
    sold_marker = 1;
elseif index<=12&&index>8
    stim_marker = 121;
    sold_marker = 1;
elseif index<=16&&index>12
    stim_marker = 122;
    sold_marker = 1;
elseif index<=24&&index>16
    stim_marker = 113;
    sold_marker = 1;
elseif index<=28&&index>24
    stim_marker = 211;
    sold_marker = 2;
elseif index<=32&&index>28
    stim_marker = 212;
    sold_marker = 2;
elseif index<=36&&index>32
    stim_marker = 221;
    sold_marker = 2;
elseif index<=40&&index>36
    stim_marker = 222;
    sold_marker = 2;
elseif index<=48&&index>40
    stim_marker = 213;
    sold_marker = 2;
end
%}


