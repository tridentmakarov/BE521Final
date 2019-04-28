function [output] = Step4Postprocess(dg_train, sp, fingerFeats, f_i)

%% Get finger feature values
times = fingerFeats.move_times(f_i); % Times spent moving
peak = fingerFeats.finger_peaks(f_i); % Average max peak heights
offset = fingerFeats.finger_offset(f_i); % Not used
vari = fingerFeats.finger_variability(f_i); % Variability of the lower data
n_peaks = fingerFeats.n_peaks(f_i); % Number of peaks, not used?
min_val = fingerFeats.min_val(f_i); % Lowest value, for filtering

%% Initialization
avg_time = round(mean(times));
dev = std(sp);
winLen = 2; %s
winDisp = 1; %s
sampleRate = 400; %samples/s
ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

%% Find peaks, this works very well
[~, ~, M] = MovingWinFeats(sp, sampleRate, winLen, winDisp, ranges);
[~,locations] = findpeaks(M, 1, 'MinPeakProminence', std(M)*1.3);
% findpeaks(LL, 1, 'MinPeakProminence', std(LL)*2);
locations = locations * sampleRate;
locations(locations < 1) = 1;

%% Remove any insane outliers
sp(sp > mean(sp) + 4 * std(sp)) = mean(sp);
sp(sp < mean(sp) - 4 * std(sp)) = mean(sp);


%% Find peaks and non-peaks, to filter and also visualize 
plot_locs = [];
for i = 1:length(locations)
	% For some reason, the positions arent perfect and have to be moved left
	left_pos = round(locations(i) - 0.02 * times);
	far_left = round(left_pos - times);
	left_pos_2 = round(locations(i) - 0.1 * times);
	right_pos = round(locations(i) + 0.98 * times);
	far_right = round(right_pos + times);
	right_pos_2 = round(locations(i) + 1.1 * times);
	
	% Create a matrix of all of the locations
	plot_locs(:, i) = left_pos : right_pos;
	left_side = far_left : left_pos;
	bigger_locs(:, i) = left_pos_2 : right_pos_2;
	right_side = right_pos : far_right;
	
	% Remove values below 1 and above the range
	if ~isempty(plot_locs(plot_locs(:, i) < 1, i))
		plot_locs(plot_locs(:, i) < 1, i) = [];
	elseif ~isempty(plot_locs(plot_locs(:, i) > length(sp), i))
		plot_locs(plot_locs(:, i) > length(sp), i) = [];
	end
	% Remove values below 1 and above the range
	if ~isempty(bigger_locs(bigger_locs(:, i) < 1, i))
		bigger_locs(bigger_locs(:, i) < 1, i) = 1;
	elseif ~isempty(bigger_locs(bigger_locs(:, i) > length(sp), i))
		bigger_locs(bigger_locs(:, i) > length(sp), i) = length(sp);
	end
	% Remove values below 1 and above the range
	if ~isempty(left_side(left_side(:, i) < 1, i))
		left_side(left_side(:, i) < 1, i) = 1;
	elseif ~isempty(left_side(left_side(:, i) > length(sp), i))
		left_side(left_side(:, i) > length(sp), i) = length(sp);
	end
	% Remove values below 1 and above the range
	left_side(left_side < 1) = [];
	% Remove values below 1 and above the range
	right_side(right_side > length(sp)) = [];
	
	% Use the values surrounding each peak to filter the minimums
	left_min = mean(sp(left_side)) - std(sp(left_side)) * 2;
	right_min = mean(sp(right_side)) - std(sp(right_side)) * 2;
	avg_min(i) = mean([left_min, right_min]);
end

% Plots if using the training data
if length(dg_train) > 1
	figure()
	hold on
	plot(sp)
	plot(dg_train)
	plot(plot_locs, sp(plot_locs), 'or')
	legend('original', 'calculated')
	hold off
end

% Plots if using the testing data
% if length(dg_train) == 1
% 	figure()
% 	hold on
% 	plot(sp)
% 	plot(plot_locs, sp(plot_locs), 'or')
% 	legend('plot', 'peaks')
% 	hold off
% end

%% Find the highest peak values
peaks_max = [];
for i = 1:length(locations)
	loc = locations(i);
	if loc + avg_time > length(sp)
		peaks_max(i) = max(sp(loc:length(sp)));
	else
		peaks_max(i) = max(sp(loc:loc + avg_time));
	end
end

%% Define the ranges for easier peak scaling
low_pos = 1:length(sp);
if ~isempty(peaks_max) % Checks to make sure peaks exist
% 	peak_ratio = peak / mean(peaks_max); % Scales peaks 
	peak_ratio = peak / max(peaks_max); % Scales peaks 
	
	[r, c] = size(plot_locs); % For reshape
	high_pos = reshape(plot_locs, [], r*c); % Reshape to vector of peaks
	low_pos(high_pos) = [];	% Make vector of the non-peak positions
	sp(high_pos) = sp(high_pos) * peak_ratio; % Resize peaks
end

%% Create vals for filter
windowSize1 = 1000; % Larger window for the non-peaks
windowSize2 = 10; % Smaller window for the peaks. 
b1 = (1/windowSize1)*ones(1,windowSize1);
% b2 = (1/windowSize2)*ones(1,windowSize2);
a = 1;

%% Filter
sp(low_pos) = filtfilt(b1,a,sp(low_pos)); % Filter non-peaks
% for i = 1:length(locations)
% 	locs = find(sp(bigger_locs(:, i)) < avg_min(i));
% 	sp(bigger_locs(locs, i)) = avg_min(i); % Remove lower values
% end
% sp(high_pos) = filtfilt(b2,a,sp(high_pos)); % Filter peaks <-- MAKES IT
% WORSE???

%% Output the result
output = sp;

end

