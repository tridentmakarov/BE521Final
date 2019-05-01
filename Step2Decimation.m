function [Y, fingerFeats, out_binary] = Step2Decimation(dg_train)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
	disp('Decimating')
	for i = 1:5
		[move_times(i), finger_peaks(i), finger_offset(i), finger_variability(i), n_peaks(i), min_val(i), out_binary(:, i)] = getFingerFeats(dg_train(:, i)); % Get times
		avg_time = round(move_times(i)/50);
		temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
		Y(:, i) = temp(3:length(temp)-3); % Remove value
% 		figure()
% 		plot(out_binary(:, i), '*r')
% 		hold on
% 		plot(Y(:, i))
% 		hold off
	end
	fprintf('User variability: %.3f\n', mean(finger_variability));
	fingerFeats.move_times = move_times;
	fingerFeats.finger_peaks = finger_peaks;
	fingerFeats.finger_offset = finger_offset;
	fingerFeats.finger_variability = finger_variability;
	fingerFeats.n_peaks = n_peaks;
	fingerFeats.min_val = min_val;
end


function [avg_times, peaks, finger_offset, finger_variability, n_peaks, min_val, out_binary] = getFingerFeats(vals)

	thresh = 8;
	winLen = 2; %s
	winDisp = 1; %s
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

	[LL, ~, ~] = MovingWinFeats(vals, sampleRate, winLen, winDisp, ranges);
	[LL2, ~, ~] = MovingWinFeats(vals, 500, 1, 0.5, ranges);

	[~,~, w,~] = findpeaks(LL, winLen, 'MinPeakProminence', max(LL)/4);
	
	out_data = zeros(1, length(LL2)+1);
	out_data(LL2 > 1/thresh * max(LL2)) = 1;
	out_binary = zoInterp(out_data, 5);
	
	avg_times = mean(w) * (winLen-winDisp) * sampleRate;
	filter = 0.1 * max(vals);
	n_peaks = length(w);

	peaks = mean([mean(vals(vals>filter)), max(vals(vals>filter))]);
	finger_offset = mean(vals(vals<filter));
	finger_variability = std(vals(vals<filter));
	min_val = min(vals);
end

