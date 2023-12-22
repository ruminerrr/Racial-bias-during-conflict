clear
clc
addpath('C:\Users\xiaoc\Documents\MATLAB\add-on\eeglab2023.1');
eeglab
close all

%read in Data (still to modify)
%"THE GREAT CHANGE"
read_dir = 'C:\Users\xiaoc\Documents\MATLAB\Result\removed_automatically\ICA\automatically_rejected\Mastoid\';
%"THE GREAT CHANGE":Please load one eegfile or specify the sampling rate.
load('montage_for_topoplot.mat') % montage file that should be safed during STEP 8 in preprocessing to ica file

%"THE GREAT CHANGE":Please load the previous information from preprocessing
% load('D:\EEG data process\scripts\Evaluation.mat') % evaluation file that should be safed at the End of preprocessing file

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

%Creating all needed arrays: Here only mean_signal array and mean_theta array, but other arrays are possible (e.g. signle trial array shown for signal here)
erp_mean_SoldierNumber(:,:,:,:) = nan(SubjectNum,size(TrialCases,2), EEG.nbchan, (Segementation_time_end-Segementation_time_start)*EEG.srate, 'single');		    %4D array: VP,CASES,ELECTRODES,TIMES

%Create an array only to visually quickly check whether a case / condition is given in a participant and if so how many times.
Casecheck (:,:) = zeros(SubjectNum,size(TrialCases,2), 'single');

for P = 1:SubjectNum
	EEG = pop_loadset('filename',filenames{P},'filepath',read_dir);									%load set (first time)	-> Reason for this here: in case of error, the file is not loaded every case but only if something is done correctly
	
	for CASES = 1:size(TrialCases,2) 
        
        try % see whether the relevant segements are there... else do the next iteration
            EEG = pop_epoch( EEG, TrialCases{CASES}, [-1.4 12], 'epochinfo', 'yes'); %select trials
            EEG = pop_select(EEG, 'time', [Segementation_time_start Segementation_time_end]);
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); %#ok<*ASGLU>
            EEG = eeg_checkset( EEG );

            % baseline correction
            for i = 1:size(EEG.data,1)
                for j = 1:size(EEG.data,3)
                        EEG.data (i,:,j) = EEG.data (i,:,j) - nanmean(EEG.data(i,baselinestart:baselinestop,j),2);
                end
            end

            %%%"THE GREAT CHANGE": Choose your desired mean signals and frequencies
            erp_mean_SoldierNumber(P,CASES,1:size(EEG.data,1),1:size(EEG.data,2))  = single(nanmean(EEG.data,3));	            %4D array: VP,CASES,ELECTRODES,TIMES
       

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

            STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];	    %#ok<*NASGU> %clear the EEG sets
            EEG = pop_loadset('filename',filenames{P},'filepath',read_dir);       %reload data here if something was cut from it
		end %try end: If this condition can not be found, then simply start from here -> next condition
	end
	STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];		    %clear the EEG sets
end

size(erp_mean_SoldierNumber)
SoldNumERP = erp_mean_SoldierNumber(:,:,:,1:750);
size(SoldNumERP)
save('SoldNumERP', '-v7.3')
