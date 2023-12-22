for i = 1:size(EEG.event,2)
    idx = EEG.event(1,i).type;
    switch idx
        case 111
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'LOW_ncf_launch';
                end
                EEG.event(1,i).type = 'low_NCF_launch';
                EEG.event(1,i+1).type = 'low_ncf_launch_onset';
                EEG.event(1,i+2).type = 'low_ncf_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'LOW_ncf_cancel';
                end
                EEG.event(1,i).type = 'low_NCF_cancel';
                EEG.event(1,i+1).type = 'low_ncf_cancel_onset';
                EEG.event(1,i+2).type = 'low_ncf_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'LOW_ncf_non';
                end
                EEG.event(1,i).type = 'low_NCF_non';
                EEG.event(1,i+1).type = 'low_ncf_non_onset';
            end
        case 112
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'LOW_ncm_launch';
                end
                EEG.event(1,i).type = 'low_NCM_launch';
                EEG.event(1,i+1).type = 'low_ncm_launch_onset';
                EEG.event(1,i+2).type = 'low_ncm_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'LOW_ncm_cancel';
                end
                EEG.event(1,i).type = 'low_NCM_cancel';
                EEG.event(1,i+1).type = 'low_ncm_cancel_onset';
                EEG.event(1,i+2).type = 'low_ncm_CANCEL';
            else
                EEG.event(1,i-1).type = 'LOW_ncm_non';
                EEG.event(1,i).type = 'low_NCM_non';
                EEG.event(1,i+1).type = 'low_ncm_non_onset';
            end
        case 121
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcf_launch';
                end
                EEG.event(1,i).type = 'low_PCF_launch';
                EEG.event(1,i+1).type = 'low_pcf_launch_onset';
                EEG.event(1,i+2).type = 'low_pcf_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcf_cancel';
                end
                EEG.event(1,i).type = 'low_PCF_cancel';
                EEG.event(1,i+1).type = 'low_pcf_cancel_onset';
                EEG.event(1,i+2).type = 'low_pcf_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcf_non';
                end
                EEG.event(1,i).type = 'low_PCF_non';
                EEG.event(1,i+1).type = 'low_pcf_non_onset';
            end
        case 122
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcm_launch';
                end
                EEG.event(1,i).type = 'low_PCM_launch';
                EEG.event(1,i+1).type = 'low_pcm_launch_onset';
                EEG.event(1,i+2).type = 'low_pcm_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcm_cancel';
                end
                EEG.event(1,i).type = 'low_PCM_cancel';
                EEG.event(1,i+1).type = 'low_pcm_cancel_onset';
                EEG.event(1,i+2).type = 'low_pcm_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'LOW_pcm_non';
                end
                EEG.event(1,i).type = 'low_PCM_non';
                EEG.event(1,i+1).type = 'low_pcm_non_onset';
            end
        case 211
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncf_launch';
                end
                EEG.event(1,i).type = 'high_NCF_launch';
                EEG.event(1,i+1).type = 'high_ncf_launch_onset';
                EEG.event(1,i+2).type = 'high_ncf_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncf_cancel';
                end
                EEG.event(1,i).type = 'high_NCF_cancel';
                EEG.event(1,i+1).type = 'high_ncf_cancel_onset';
                EEG.event(1,i+2).type = 'high_ncf_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncf_non';
                end
                EEG.event(1,i).type = 'high_NCF_non';
                EEG.event(1,i+1).type = 'high_ncf_non_onset';
            end
        case 212
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncm_launch';
                end
                EEG.event(1,i).type = 'high_NCM_launch';
                EEG.event(1,i+1).type = 'high_ncm_launch_onset';
                EEG.event(1,i+2).type = 'high_ncm_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncm_cancel';
                end
                EEG.event(1,i).type = 'high_NCM_cancel';
                EEG.event(1,i+1).type = 'high_ncm_cancel_onset';
                EEG.event(1,i+2).type = 'high_ncm_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_ncm_non';
                end
                EEG.event(1,i).type = 'high_NCM_non';
                EEG.event(1,i+1).type = 'high_ncm_non_onset';
            end
        case 221
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcf_launch';
                end
                EEG.event(1,i).type = 'high_PCF_launch';
                EEG.event(1,i+1).type = 'high_pcf_launch_onset';
                EEG.event(1,i+2).type = 'high_pcf_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcf_cancel';
                end
                EEG.event(1,i).type = 'high_PCF_cancel';
                EEG.event(1,i+1).type = 'high_pcf_cancel_onset';
                EEG.event(1,i+2).type = 'high_pcf_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcf_non';
                end
                EEG.event(1,i).type = 'high_PCF_non';
                EEG.event(1,i+1).type = 'high_pcf_non_onset';
            end
        case 222
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcm_launch';
                end
                EEG.event(1,i).type = 'high_PCM_launch';
                EEG.event(1,i+1).type = 'high_pcm_launch_onset';
                EEG.event(1,i+2).type = 'high_pcm_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcm_cancel';
                end
                EEG.event(1,i).type = 'high_PCM_cancel';
                EEG.event(1,i+1).type = 'high_pcm_cancel_onset';
                EEG.event(1,i+2).type = 'high_pcm_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_pcm_non';
                end
                EEG.event(1,i).type = 'high_PCM_non';
                EEG.event(1,i+1).type = 'high_pcm_non_onset';
            end
        case 113
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'LOW_tree_launch';
                end
                EEG.event(1,i).type = 'low_TREE_launch';
                EEG.event(1,i+1).type = 'low_tree_launch_onset';
                EEG.event(1,i+2).type = 'low_tree_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'LOW_tree_cancel';
                end
                EEG.event(1,i).type = 'low_TREE_cancel';
                EEG.event(1,i+1).type = 'low_tree_cancel_onset';
                EEG.event(1,i+2).type = 'low_tree_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'LOW_tree_non';
                end
                EEG.event(1,i).type = 'low_TREE_non';
                EEG.event(1,i+1).type = 'low_tree_non_onset';
            end
        case 213
            if EEG.event(1,i+2).type == 100
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_tree_launch';
                end
                EEG.event(1,i).type = 'high_TREE_launch';
                EEG.event(1,i+1).type = 'high_tree_launch_onset';
                EEG.event(1,i+2).type = 'high_tree_LAUNCH';
            elseif EEG.event(1,i+2).type == 200
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_tree_cancel';
                end
                EEG.event(1,i).type = 'high_TREE_cancel';
                EEG.event(1,i+1).type = 'high_tree_cancel_onset';
                EEG.event(1,i+2).type = 'high_tree_CANCEL';
            else
                if i>1
                    EEG.event(1,i-1).type = 'HIGH_tree_non';
                end
                EEG.event(1,i).type = 'high_TREE_non';
                EEG.event(1,i+1).type = 'high_tree_non_onset';
            end
        case 88
            EEG.event(1,i).type = 'start';
        case 66
            EEG.event(1,i).type = 'break';
    end
end

% delete non-relevant number
for i = 1:size(EEG.event,2)
    idx = EEG.event(i).type;
    if class(idx)=="double"
        EEG.event(i).type = 'other';
    end
end

% Relevant_Markers = {'LOW_ncf_launch' 'low_NCF_launch' 'low_ncf_LAUNCH' 'LOW_ncf_cancel' 'low_NCF_cancel' 'low_ncf_CANCEL' 'LOW_ncm_launch' 'low_NCM_launch' 'low_ncm_LAUNCH' 'LOW_ncm_cancel' 'low_NCM_cancel' 'low_ncm_CANCEL' 'LOW_pcf_launch' 'low_PCF_launch' 'low_pcf_LAUNCH' 'LOW_pcf_cancel' 'low_PCF_cancel' 'low_pcf_CANCEL' 'LOW_pcm_launch' 'low_PCM_launch' 'low_pcm_LAUNCH' 'LOW_pcm_cancel' 'low_PCM_cancel' 'low_pcm_CANCEL' 'HIGH_ncf_launch' 'high_NCF_launch' 'high_ncf_LAUNCH' 'HIGH_ncf_cancel' 'high_NCF_cancel' 'high_ncf_CANCEL' 'HIGH_ncm_launch' 'high_NCM_launch' 'high_ncm_LAUNCH' 'HIGH_ncm_cancel' 'high_NCM_cancel' 'high_ncm_CANCEL' 'HIGH_pcf_launch' 'high_PCF_launch' 'high_pcf_LAUNCH' 'HIGH_pcf_cancel' 'high_PCF_cancel' 'high_pcf_CANCEL' 'HIGH_pcm_launch' 'high_PCM_launch' 'high_pcm_LAUNCH' 'HIGH_pcm_cancel' 'high_PCM_cancel' 'high_pcm_CANCEL' 'LOW_tree_launch' 'low_TREE_launch' 'low_tree_LAUNCH' 'LOW_tree_cancel' 'low_TREE_cancel' 'low_tree_CANCEL' 'HIGH_tree_launch' 'high_TREE_launch' 'high_tree_LAUNCH' 'HIGH_tree_cancel' 'high_TREE_cancel' 'high_tree_CANCEL' 'low_ncf_launch_onset' 'low_ncf_cancel_onset' 'low_ncm_launch_onset' 'low_ncm_cancel_onset' 'low_pcf_launch_onset' 'low_pcf_cancel_onset' 'low_pcm_launch_onset' 'low_pcm_cancel_onset' 'high_ncf_launch_onset' 'high_ncf_cancel_onset' 'high_ncm_launch_onset' 'high_ncm_cancel_onset' 'high_pcf_launch_onset' 'high_pcf_cancel_onset' 'high_pcm_launch_onset' 'high_pcm_cancel_onset' 'low_tree_launch_onset' 'low_tree_cancel_onset' 'high_tree_launch_onset' 'high_tree_cancel_onset'};
Relevant_Markers = {'LOW_ncf_launch' 'LOW_ncf_cancel' 'LOW_ncm_launch' 'LOW_ncm_cancel' 'LOW_pcf_launch' 'LOW_pcf_cancel' 'LOW_pcm_launch' 'LOW_pcm_cancel' 'HIGH_ncf_launch' 'HIGH_ncf_cancel' 'HIGH_ncm_launch' 'HIGH_ncm_cancel' 'HIGH_pcf_launch' 'HIGH_pcf_cancel' 'HIGH_pcm_launch' 'HIGH_pcm_cancel' 'LOW_tree_launch' 'LOW_tree_cancel' 'HIGH_tree_launch' 'HIGH_tree_cancel'};
EEG = pop_epoch( EEG, Relevant_Markers , [-1.4 12], 'newname', strcat(filenames{VP},'_intchan_avg_filt epochs'), 'epochinfo', 'yes'); % Time window must be adjusted by RT

