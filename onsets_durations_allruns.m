%% This code extracts the onsets and durations of each condition (alternating vs 
% simultaneous and switching) for all 6 functional runs and saves them in a corresponding file

num_runs = 6; %define number of runs (needed for forloop later)

% define a string variable with the path where all the logfiles are located
logs_dir = 'C:\Users\phili\OneDrive\Desktop\FUB\00_Master FUB\05 Quinto semestre\NM_Practical\sub_009_3D_Nifti\log_files\logs_original_sub-009\';

cd (logs_dir); % change directory to the directory where the logfiles are located

% the "alternating" condition has the label "1" in all the runs
% the "simultaneous" condition has the label "2" in all the runs
% all runs start with the alternating condition (1) and have 7 onsets (except run 6 which has 8 onsets)
% the "alternating" and the "simultaneous" conditions are presented alternatively in all runs, following the form: 1 2 1 2 1 2 1
% the onsets of the "switching" condition are extracted irrespective of the direction of change and duration = 0

% loop across runs to extract onsets and durations for both conditions:

for i = 1:num_runs
    logfile = strcat(logs_dir,'log_sub-009_run-0',num2str(i),'.mat'); %define the path to the logfile of a specific run
    load(logfile);  %load the logfile of a specific run
    cue_series = [log.cueseries];  %extract/create variable of the cues
    onset_general = [log.onsets];  %extract/create variable of all the onsets of both conditions (alt. and sim.)
    index_onset_alt = find(diff(cue_series) == -1)+1; % Finding indices where the value changes from 2 to 1 (these are the indices of the onsets of the Alternating condition)
    index_onset_sim = find(diff(cue_series) == 1)+1;  % Finding indices where the value changes from 1 to 2 (these are the indices of the onsets of the Simultaneous condition)
    if cue_series(1) == 1
        index_onset_alt = [1, index_onset_alt]; %including the first element of the whole cue series in the "index_onset_alt" variable because all runs start with the cue 1 (Alt)
    end
    onsets_ALT = onset_general(index_onset_alt)/1000; %extracting onset values for the "alternating condition" and converting to seconds
    onsets_SIM = onset_general(index_onset_sim)/1000; % same but for "simultaneous"
    
    last_index = 449; % this value has to be included in the next variable in order to calculate the durations
    all_indices_onsets = [sort([index_onset_alt, index_onset_sim]),last_index]; % putting all indices of the onsets (both conditions) in one variable in order to calculate durations next
    all_durations = diff(all_indices_onsets)*800/1000; 
    odd_indices = 1:2:length(all_durations); % the odd indices of "all durations" can be used later to create the variable that has the durations of the alternating condition
    even_indices = 2:2:length(all_durations); % even indices correspond to the simultaneous condition
    durations_ALT = all_durations(odd_indices);  % duration of Alternating condition
    durations_SIM = all_durations(even_indices);  % duration of Simultaneous condition

    onsets_Switch = [sort([onsets_ALT,onsets_SIM])]; % onsets of switches irrespective of direction of change

    % save the onsets and durations into one single structure
    ons_dur.onsets_ALT = onsets_ALT;
    ons_dur.durations_ALT = durations_ALT;
    ons_dur.onsets_SIM = onsets_SIM;
    ons_dur.durations_SIM = durations_SIM;
    ons_dur.onsets_switch = onsets_Switch;

    % save the onsets and durations of both conditions in one single file per run
    filename = strcat(logs_dir, 'run',num2str(i), '_ons_dur.mat');
    save(filename, 'ons_dur');

end

