function [Y, fingerFeats] = Step2Decimation(dg_train)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
	disp('Decimating')
	for i = 1:5
		[move_times(i), finger_peaks(i), finger_offset(i), finger_variability(i), n_peaks(i), min_val(i)] = getFingerFeats(dg_train(:, i)); % Get times
		temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
		Y(:, i) = temp(3:length(temp)-3); % Remove value
	end
	fingerFeats.move_times = move_times;
	fingerFeats.finger_peaks = finger_peaks;
	fingerFeats.finger_offset = finger_offset;
	fingerFeats.finger_variability = finger_variability;
	fingerFeats.n_peaks = n_peaks;
	fingerFeats.min_val = min_val;
end


function [times, peaks, finger_offset, finger_variability, n_peaks, min_val] = getFingerFeats(vals)

	winLen = 2; %s
	winDisp = 1; %s
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

	[LL, ~, ~] = MovingWinFeats(vals, sampleRate, winLen, winDisp, ranges);

	[~,~,w,~] = findpeaks(LL, 2, 'MinPeakProminence', max(LL)/2);

	times = mean(w) * winLen * sampleRate;
	filter = 0.1 * max(vals);
	n_peaks = length(w);

	peaks = mean([mean(vals(vals>filter)), max(vals(vals>filter))]);
	finger_offset = mean(vals(vals<filter));
	finger_variability = std(vals(vals<filter));
	min_val = min(vals);
end

