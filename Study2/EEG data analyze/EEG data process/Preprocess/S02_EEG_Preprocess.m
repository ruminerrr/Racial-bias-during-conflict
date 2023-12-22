%% Initial
clear    					    %clear workspace matlab
clc								%clear command window matlab
addpath('C:\Users\xiaoc\Documents\MATLAB\add-on\eeglab2023.1');
eeglab							%start EEGlab
close all						

% Dictionary settings
read_dir = 'C:\Users\xiaoc\Documents\MATLAB\EEG_data\new\';   
write_dir = 'C:\Users\xiaoc\Documents\MATLAB\Result\';          
%mark important paths that are needed
check_dir = strcat(write_dir,'before_removal/'); 
load_dir = strcat(write_dir,'removed_automatically/');           
mkdir(write_dir);
mkdir(check_dir);
mkdir(load_dir);
mkdir(strcat(load_dir,'ICA/'));
mkdir(strcat(load_dir,'ICA/done_still_to_reject/'));
mkdir(strcat(load_dir,'ICA/automatically_rejected/'));
mkdir(strcat(load_dir,'ICA/automatically_rejected/Mastoid/'));
check_dir_mastoid = strcat(load_dir,'ICA/automatically_rejected/Mastoid/');

% EEG data file
files = dir([read_dir '*.cdt']); % This is the file format of brain vision (.vhdr [vmrk,eeg]), if you have another file format, insert the corresponding file type
filenames = {files.name}';

% detection criteria
Channelz_value_automatic_detection = 3.29; 

% Participants numbers
COUNTPARTICIPANT = size(filenames,1);

Number_of_EEG_electrodes_without_reference_and_ground = 64; % EEG channel number


for VP = 1:COUNTPARTICIPANT  %FOR EVERY FILE
	
    checkfiles = dir([check_dir_mastoid '*.set']); 	%look at all files in the check directory: the set format is the eeglab format
	checkfilenames = {checkfiles.name}';	%look at all file names there
	for checkfilesi = 1:size(checkfiles)	%for every file in there
        %"THE GREAT CHANGE" here you need to adjust the file format to the format of your recorded files (example is header file from brainvision)
		if strcmp(strrep(filenames{VP},'.cdt',''),strrep(checkfilenames{checkfilesi},'.set','')) == 1 	%check whether the present file is in there
			VP = VP +1;																					 %#ok<*FXSET> %if it is in there, then take the next file
		end
	end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	EEG = loadcurry(strcat(read_dir, filenames{VP}), 'KeepTriggerChannel', 'False', 'CurryLocations', 'True');	%LOAD THE DATA, all channels, all timepoints		
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',filenames{VP},'gui','off'); %#ok<*ASGLU> %in dataset 0 of EEGLab

    %Resample the data as 250Hz
    % EEG.data = detrend(EEG.data);
    EEG = pop_resample(EEG, 250);
    %remove sc Heart (if you don´t have any, comment it out or use it for eye, we don´t need that any more as we use ICA for blink and eyemovement detection
    %"THE GREAT CHANGE"
    EEG = pop_select( EEG,'nochannel',{'HEO' 'VEO'});   		%State the channels that you want to "ignore" insert your channel names
    EEG = eeg_checkset( EEG );
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );

 EEG = pop_reref( EEG, []); %,'refloc',struct('labels',{'Cz'},'type',{''},'theta',{0},'radius',{0},'X',{5.2047e-015},'Y',{0},'Z',{85},'sph_theta',{0},'sph_phi',{90},'sph_radius',{85},'urchan',{65},'ref',{''},'datachan',{0}));
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    EEG = eeg_checkset( EEG );
		
    % now we look for band channels
	
    [~, indelec1] = pop_rejchan(EEG, 'elec',1:Number_of_EEG_electrodes_without_reference_and_ground ,'threshold',Channelz_value_automatic_detection,'norm','on','measure','prob'); 		%we look for probability

	[~, indelec2] = pop_rejchan(EEG, 'elec',1:Number_of_EEG_electrodes_without_reference_and_ground ,'threshold',Channelz_value_automatic_detection,'norm','on','measure','kurt');	%we look for kurtosis 
	
    [~, indelec3] = pop_rejchan(EEG, 'elec',1:Number_of_EEG_electrodes_without_reference_and_ground ,'threshold',Channelz_value_automatic_detection,'norm','on','measure','spec','freqrange',[1 125] );	%we look for frequency spectra


    % now we look whether a channel is bad in multiple criteria
    index=sort(unique([indelec1,indelec2,indelec3])); %index is the bad channel array

    for i = 1:size(index,2)
        VP_indexarray(VP,i) = index(1,i); %#ok<*SAGROW>
    end
    savename = strcat(write_dir,'removed_channels_auto.mat');  %save the bad channel array for every participant in a matrix
    save(savename,'VP_indexarray', 'filenames');

    %Here we save the data before we remove the bad channels we have detected before
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', strcat(filenames{VP},'_to_ICA'),'filepath',strcat(write_dir,'before_removal/'));

    %remove channels because of index array
	%Interpolate Channels (Bad Channels)
    EEG = pop_interp(EEG, index, 'spherical');
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat(filenames{VP},'_start'),'gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', strcat(filenames{VP},'_to_ICA'),'filepath',strcat(write_dir,'removed_automatically/'));
    EEG = eeg_checkset( EEG );
	
    clear indelec1 indelec2 indelec3 i 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%å
	S02_EEG_Preprocess_First_Segment; % replace of former script

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Filter lowpass 1 Hz: because it gives a more stable ICA solution and works best with MARA
	% (Tools-> filter the data -> basic FIR filter (new, default) -> lower edge 1 
	%EEG = pop_eegfiltnew(EEG, [], 1, [], 1, [], 0); %%comment: These two filter displayed here are mathematically identical... notch vs. bandpass
    EEG = pop_eegfiltnew(EEG, 'locutoff',1); % 1Hz highpass
    % EEG = pop_eegfiltnew(EEG, 48, 52, [], 1, [], 0); % notch filter 50Hz
	
	[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
	EEG = eeg_checkset( EEG );
	
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%first ICA: compute the ICA, takes some time....
	% EEG = pop_runica(EEG, 'extended',1,'interupt','on');
	EEG = pop_runica(EEG, 'extended',1,'interupt','on', 'pca', Number_of_EEG_electrodes_without_reference_and_ground-size(index,2)); %this takes into account that we have extrapolated some channels and the rank of the matrix was reduced: Count original electrodes + reference - extrapolated channels
	
    
    EEG = pop_jointprob(EEG,0,1:Number_of_EEG_electrodes_without_reference_and_ground-size(index,2) ,20,Channelz_value_automatic_detection,0,0,0,[],0);
	EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
	%"THE GREAT CHANGåE" Change the number of channels to your ICA(here starting with 1:65, but the function should do it if you also added a reference channel); the z value 20 is chosen to not correct anything here on single component limitation, but only on all component limitations (global)
	EEG = pop_rejkurt(EEG,0,1:Number_of_EEG_electrodes_without_reference_and_ground-size(index,2) ,20,Channelz_value_automatic_detection,2,0,1,[],0);
	EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
    %reject the selected bad segments !
    reject1 = EEG.reject; %save this for later approaches, for instance if intersted in LPP or other stuff with freq < 1 Hz
	EEG = pop_rejepoch( EEG, EEG.reject.rejglobal ,0);
	EEG = eeg_checkset( EEG );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%second ICA: again, takes some time... if no segments were rejected, the ICA will be the same. This can be good if the data is rather well...
    % this step is only one if data is rejected in step 5
    if sum(reject1.rejglobal) > 0
        EEG = pop_runica(EEG, 'extended',1,'interupt','on', 'pca', Number_of_EEG_electrodes_without_reference_and_ground-size(index,2)); %this takes into account that we have extrapolated some channels and the rank of the matrix was reduced: Count original electrodes + reference - extrapolated channels
    end
	[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname',strcat(filenames{VP},'_all_arifact_filt1'),'overwrite','on','gui','off');
    EEG = eeg_checkset( EEG ); 
	EEG = pop_saveset( EEG, 'filename', strcat(filenames{VP},'_to_ICA'),'filepath',strcat(write_dir,'removed_automatically/ICA/done_still_to_reject/'));
	
    %automatically reject ICA: Using IClabels (to be used instead of MARA and ADJUST)
    % "THE GREAT CHANGE": Change what kind of selection criteria you want to apply for automatic selection. Note that the "other" classification is very prevalent when having more than 64 channels.
    % The default selection criteria here is considering the probability of the signal against the highest artifact probability (if signal probability is higher, use the IC). Note that the "other" classification is not seen as an artifact Pion-Tonachini, L., Kreutz-Delgado, K., & Makeig, S. (2019).
    % FOR UNEXPERIENCED USERS I RECOMMEND USING GUI FIRST AND READING Pion-Tonachini, L., Kreutz-Delgado, K., & Makeig, S. (2019). ICLabel: An automated electroencephalographic independent component classifier, dataset, and website. NeuroImage, 198, 181–197. https://doi.org/10.1016/j.neuroimage.2019.05.026
    EEG = pop_iclabel(EEG, 'default');
    %EEG = pop_icflag(EEG, [NaN NaN;0.5 1;0.5 1;0.5 1;0.5 1;0.5 1;0.5 1]); % THESE ARE EXAMPLE THRESHOLDS ! VALIDATE ON YOUR DATA !
    for i = 1:size(EEG.etc.ic_classification.ICLabel.classifications,1)
        if EEG.etc.ic_classification.ICLabel.classifications(i,1)>max(EEG.etc.ic_classification.ICLabel.classifications(i,2:6))% if signal probability is higher than "pure" artifact
            classifyICs(i)=0;
        else
            classifyICs(i)=1;
        end
    end
    EEG.reject.gcompreject=classifyICs; %
    EEG = eeg_checkset( EEG );

    %"THE GREAT CHANGE": if you want to choose other criteria, specify them here.    This code is adapted from HAPPE  (Gabard-Durnam et al., 2018)
    %"THE GREAT CHANGE": if an error comes at compvar, check whether ICA_act is empty. if it is, run this code manually and start again from "ICs_to_keep" below: EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
    %%% prepare evaluation of the performance
    %store IC variables and calculate variance of data that will be kept after IC rejection: This code is adapted from HAPPE  (Gabard-Durnam et al., 2018)
    ICs_to_keep =find(EEG.reject.gcompreject == 0);
    if size(EEG.icaact) == [0,0]
        EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
    end
    ICA_act = EEG.icaact;
    ICA_winv =EEG.icawinv;   
    %variance of wavelet-cleaned data to be kept = varianceWav: : This code is adapted from HAPPE  (Gabard-Durnam et al., 2018)
    [proj, variancekeep] =compvar(EEG.data, ICA_act, ICA_winv, ICs_to_keep);

    % 1)	Channels that are not rejected (contributing “good” channels): see VP_indexarray
    Percentage_channels_kept(VP,1) = (1-(size(index,2)/Number_of_EEG_electrodes_without_reference_and_ground))*100;
    % 2)	Rejected ICs after second ICA
    Percentage_rejected_ICs(VP,1) = 1-(size(ICs_to_keep,2)/size(classifyICs,2));
    %3)	Variance kept after the rejection of the ICs
    Percentage_variance_kept(VP,1) = variancekeep;
    %4)	Number of rejected segment: not yet possible: later in processing with Step 5 revisited but remember taking reject1
    Reject1_VP(VP,1)=sum(reject1.rejglobal);
    %5)	Artifact probability of retained components, from ICLabel  
    median_artif_prob_good_ICs(VP,1) = median(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:6),1,[]));
    mean_artif_prob_good_ICs(VP,1) = mean(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:6),1,[]));
    range_artif_prob_good_ICs(VP,1) = range(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:6),1,[]));
    min_artif_prob_good_ICs(VP,1) = min(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:6),1,[]));
    max_artif_prob_good_ICs(VP,1) = max(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:6),1,[]));
    %including category "other"
    median_artif_prob_good_ICs(VP,2) = median(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:7),1,[]));
    mean_artif_prob_good_ICs(VP,2) = mean(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:7),1,[]));
    range_artif_prob_good_ICs(VP,2) = range(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:7),1,[]));
    min_artif_prob_good_ICs(VP,2) = min(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:7),1,[]));
    max_artif_prob_good_ICs(VP,2) = max(reshape(EEG.etc.ic_classification.ICLabel.classifications(ICs_to_keep,2:7),1,[]));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END OF STEP 7a
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STEP 7b
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %now take the original data in order to loose the 1 Hz filter:
    %first save necessary ICA components
    reject2 = EEG.reject.gcompreject;
    ICA_stuff1 = EEG.icawinv;
    ICA_stuff2 = EEG.icasphere;
    ICA_stuff3 = EEG.icaweights;
    ICA_stuff4 = EEG.icachansind;
    %now reload the data
    %"THE GREAT CHANGE" Change the file extension from vhdr (brain-vision header file) to your original file type
    EEG = pop_loadset('filename',strrep(filenames{VP},'cdt','set'),'filepath',load_dir);
    EEG = eeg_checkset( EEG );
    %segment the data once again as before
    FirstSegmentation;
    %reject the bad segemtns once more
    EEG.reject = reject1; %apply the bad segments
    EEG = pop_rejepoch( EEG, EEG.reject.rejglobal ,0); %reject the bad segments
    EEG = eeg_checkset( EEG );
    %now apply the ICA solution to the unfiltered EEG data
    EEG.icawinv = ICA_stuff1;
    EEG.icasphere = ICA_stuff2;
    EEG.icaweights = ICA_stuff3;
    EEG.icachansind = ICA_stuff4;
    %recompute EEG.icaact:
    EEG = eeg_checkset( EEG );
    %set the components to reject
    EEG.reject.gcompreject = reject2;
	%Automatically reject all marked components
	EEG = pop_subcomp(EEG,[],0);
    %recompute EEG.icaact:
    EEG = eeg_checkset( EEG );
	%save it
	EEG = pop_saveset( EEG, 'filename', strcat(filenames{VP},'_to_ICA'),'filepath',strcat(write_dir,'removed_automatically/ICA/automatically_rejected/'));
	[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

	
	EEG = pop_reref( EEG, [33 43] );
    
	EEG = pop_saveset( EEG, 'filename',filenames{VP},'filepath',strcat(write_dir,'removed_automatically/ICA/automatically_rejected/Mastoid/'));
	
    
    %clear all stuff that is not needed for next person
	STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    clear ICA_stuff1 ICA_stuff2 ICA_stuff3 ICA_stuff4 reject1 reject2 data backupEEGdata backupEEGICA proj variancekeep index ICA_act ICA_winv ICs_to_keep reject1 classifyICs
	close all
end

Bad_channel_array = VP_indexarray ;
Number_Great_epochs_rejected = Reject1_VP;
save('Evaluation.mat','max_artif_prob_good_ICs','mean_artif_prob_good_ICs','median_artif_prob_good_ICs','min_artif_prob_good_ICs','Percentage_channels_kept','Percentage_rejected_ICs','Percentage_variance_kept','range_artif_prob_good_ICs','filenames','Bad_channel_array','Number_Great_epochs_rejected','Number_of_EEG_electrodes_without_reference_and_ground','Channelz_value_automatic_detection')
