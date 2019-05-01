function [output] = Step4Postprocess(dg_train, sp, fingerFeats, f_i, binary)

scale = 1.0;
peak_scale = 1.25; %		<--- CHANGE FOR SCALING OF PEAK HEIGHTS
windowSize = 500; %		<--- WINDOW SIZE FOR NON-PEAKS
roll_size = 5000;%		<--- ROLLING WINDOW SIZE

%% Get finger feature values
times = fingerFeats.move_times(f_i); % Times spent moving
peak = fingerFeats.finger_peaks(f_i); % Average max peak heights
% offset = fingerFeats.finger_offset(f_i); % Not used
vari = fingerFeats.finger_variability(f_i); % Variability of the lower data
n_peaks = fingerFeats.n_peaks(f_i); % Number of peaks, not used?
min_val = fingerFeats.min_val(f_i); % Lowest value, for filtering

%% Initialization
avg_time = round(mean(times));
dev = std(sp);
winLen = 2; %s
winDisp = 1; %s
sampleRate = 1000; %samples/s
ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

%% Find peaks, this works very well
[~, ~, M] = MovingWinFeats(sp, sampleRate, winLen, winDisp, ranges);
[~,locations] = findpeaks(M, 1, 'MinPeakProminence', std(M) * scale);
% findpeaks(LL, 1, 'MinPeakProminence', std(LL)*2);
locations = locations * sampleRate;
locations(locations < 1) = 1;

%% Remove any insane outliers
sp(sp > mean(sp) + 4 * std(sp)) = mean(sp);
sp(sp < mean(sp) - 4 * std(sp)) = mean(sp);

sp_store = sp;


%% Find peaks and non-peaks, to filter and also visualize 
plot_locs = [];
for i = 1:length(locations)
	% For some reason, the positions arent perfect and have to be moved left
	left_pos = round(locations(i));
	right_pos = round(locations(i) + 2 * times);
	
	% Create a matrix of all of the locations
	plot_locs(:, i) = left_pos : right_pos;
	
	% Remove values below 1 and above the range
	plot_locs(plot_locs(:, i) < 1, i) = 1;
	plot_locs(plot_locs(:, i) > length(sp), i) = length(sp);
end

%% Find the highest peak values
peaks_max = [];
for i = 1:length(locations)
	loc = locations(i);
	if loc + avg_time * 2 > length(sp)
		peaks_max(i) = max(sp(loc:length(sp)));
	else
		peaks_max(i) = max(sp(loc:loc + avg_time * 2));
	end
end

%% Define the ranges for easier peak scaling
low_pos = 1:length(sp);
if ~isempty(peaks_max) % Checks to make sure peaks exist
	peak_ratio = peak / max(peaks_max) * peak_scale; % Scales peaks 
	
	[r, c] = size(plot_locs); % For reshape
	high_pos = reshape(plot_locs, [], r*c); % Reshape to vector of peaks
	high_pos(sp(high_pos) < 0) = [];
	low_pos(high_pos) = [];	% Make vector of the non-peak positions
	sp(high_pos) = sp(high_pos) * peak_ratio; % Resize peaks
end

%% Create vals for filter
b1 = (1/windowSize)*ones(1,windowSize);
a = 1;
sp(low_pos) = filtfilt(b1,a,sp(low_pos));
%% Rolling Filter
% figure()
% plot(sp)
% for i = 1:roll_size:length(low_pos)
% 	pos_r = i : i + roll_size - 1;
% 	pos_r(pos_r > length(low_pos)) = [];
% 	new_vari = std(sp(low_pos(pos_r)));
% 	offset = mean(sp(low_pos(pos_r)));
% 	vari_ratio = vari / new_vari;
% 	sp(low_pos(pos_r)) = (sp(low_pos(pos_r)))*vari_ratio;
% 	if length(pos_r) > 1400
% 		sp(low_pos(pos_r)) = filtfilt(b1,a,sp(low_pos(pos_r))); % Filter non-peaks
% 	end
% % 	plot(sp)
% % 	pause(0.2)
% end

% Plots if using the training data
% if length(dg_train) > 1
% 	figure()
% 	plot(sp)
% 	hold on
% % 	plot(sp_store)
% 	plot(dg_train)
% % 	plot(plot_locs, sp(plot_locs), '*r')
% % 	legend('true', 'original', 'calculated')
% 	legend('calculated', 'og shit')
% 	hold off
% end

% Plots if using the testing data
% if length(dg_train) == 1
% 	figure()
% 	hold on
% 	plot(sp)
% 	plot(plot_locs, sp(plot_locs), 'or')
% 	legend('plot', 'peaks')
% 	hold off
% end

%% Output the result
output = sp;

end

