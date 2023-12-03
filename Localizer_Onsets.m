%% This code extracts the onsets for each of the 3 experimental conditions 
% of the localizer run

% condition1: left stimulation
% condition2: rigth stimulation
% condition3: baseline or no stimulation
% fixed duration of 8 seconds for all conditions

load('log_sub-009 localizer_localizer_time-17-14.mat')

index_left = find(log.conditions == 1);
index_right = find(log.conditions == 2);
index_baseline = find(log.conditions == 3);

% onset indices for each condition
idx_onsets_left = 2 * index_left - 1;
idx_onsets_right = 2 * index_right - 1;
idx_onsets_baseline = 2 * index_baseline - 1;

% onset times
onsets_left = log.onset(idx_onsets_left);
onsets_right = log.onset(idx_onsets_right);
onsets_baseline= log.onset(idx_onsets_baseline);

% save the onsets into one single structure
ons_loc.left = onsets_left;
ons_loc.right = onsets_right;
ons_loc.baseline = onsets_baseline;

% save the onsets in one file
filename = 'your directory';
save(filename, 'ons_loc');

