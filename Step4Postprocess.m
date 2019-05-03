function [output] = Step4Postprocess(dg_train, sp, fingerFeats, f_i, binary, set)

% scales = [2.0, 1.8, 1.8, 1.9, 2.2];% <--- HIGHER NUMBER = FEWER PEAKS
% scale = scales(f_i);
peak_scales = [1.0, 1.0, 1.0, 1.1, 1.1];
peak_scale = peak_scales(f_i); %		<--- CHANGE FOR SCALING OF PEAK HEIGHTS
% windowSizes = [1400, 1100, 1100, 1100, 1100];
% windowSize = windowSizes(f_i); %		<--- WINDOW SIZE FOR NON-PEAKS
% roll_size = 5000;%		<--- ROLLING WINDOW SIZE

scale = 1.8;
a = 1.05;
% peak_scale = 1.2;
windowSize = 400;	
roll_size = 1400;

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
[~, ~, M2] = MovingWinFeats(sp, 800, winLen, winDisp, ranges);
[~,locations] = findpeaks(M, 1, 'MinPeakProminence', std(M) * scale);
[~,locations2] = findpeaks(M2, 2, 'MinPeakProminence', std(M2) * scale);
% findpeaks(LL, 1, 'MinPeakProminence', std(LL)*2);
locations = locations * sampleRate;
locations2 = locations2 * 800 * 2;
locations(locations < 1) = 1;
locations2(locations2 < 1) = 1;

if set == 5
	figure()
	findpeaks(M, 1, 'MinPeakProminence', std(M) * scale);
	figure()
	findpeaks(M2, 2, 'MinPeakProminence', std(M2) * scale);
end

%% Remove any insane outliers
sp(sp > mean(sp) + 4 * std(sp)) = mean(sp);
sp(sp < mean(sp) - 4 * std(sp)) = mean(sp);

sp_store = sp;


%% Find peaks and non-peaks, to filter and also visualize 
plot_locs = [];
peaks_max = [];
count = 0;
for i = 1:length(locations)
	% For some reason, the positions arent perfect and have to be moved left
	left_pos = round(locations(i));
	right_pos = round(locations(i) + 2 * times);
	loc = locations(i);
	if any(abs(locations(i) - locations2) < times)
		count = count + 1;
		% Create a matrix of all of the locations
		plot_locs(:, count) = left_pos : right_pos;

		% Remove values below 1 and above the range
		plot_locs(plot_locs(:, count) < 1, count) = 1;
		plot_locs(plot_locs(:, count) > length(sp), count) = length(sp);
		
		if loc + avg_time * 2 > length(sp)
			peaks_max(count) = max(sp(loc:length(sp)));
		else
			peaks_max(count) = max(sp(loc:loc + avg_time * 2));
		end
	end
end

%% Define the ranges for easier peak scaling
low_pos = 1:length(sp);
if ~isempty(peaks_max) % Checks to make sure peaks exist
	peak_ratio = peak / mean(peaks_max) * peak_scale; % Scales peaks 
	
	[r, c] = size(plot_locs); % For reshape
	high_pos = reshape(plot_locs, [], r*c); % Reshape to vector of peaks
	high_pos(sp(high_pos) < 0) = [];
	low_pos(high_pos) = [];	% Make vector of the non-peak positions
	sp(high_pos) = sp(high_pos) * peak_ratio; % Resize peaks
end
%% Rolling Filter
% figure()
% plot(sp)
for i = 1:roll_size:length(low_pos)
	pos_r = i : i + roll_size - 1;
	pos_r(pos_r > length(low_pos)) = [];
	new_vari = std(sp(low_pos(pos_r)));
	if log(new_vari) < -3 || new_vari > 3
		new_vari = 1;
	end
	offset = mean(sp(low_pos(pos_r)));
	vari_ratio = mean([1, vari / new_vari]);
	
	sp(low_pos(pos_r)) = (sp(low_pos(pos_r)))*vari_ratio;
% 	if length(pos_r) > 1400
% 		sp(low_pos(pos_r)) = filtfilt(b1,a,sp(low_pos(pos_r))); % Filter non-peaks
% 	end
% 	plot(sp)
end
% hold on
% plot(sp_store)
% plot(sp)
% plot(dg_train)
% hold off

sp(sp < mean(sp) - 3 * std(sp)) = mean(sp);

%% Create vals for filter
b1 = (1/windowSize)*ones(1,windowSize);
sp(low_pos) = filtfilt(b1,a,sp(low_pos));

% Plots if using the training data
if length(dg_train) > 1
	figure()
	plot(dg_train)
	hold on
	plot(sp_store)
	plot(sp)
% 	plot(plot_locs, sp(plot_locs), '*r')
	legend('true', 'original', 'calculated')
% 	legend('calculated', 'og shit')
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

%% Output the result
output = sp;

end

