function [Y, fingerFeats] = Step2Decimation(dg_train)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
	disp('Decimating')
	for i = 1:5
		[move_times(i), finger_peaks(i) finger_offset(i), finger_variability(i), n_peaks(i)] = getFingerFeats(dg_train(:, i)); % Get times
		temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
		Y(:, i) = temp(3:length(temp)-3); % Remove value
	end
	fingerFeats.move_times = move_times;
	fingerFeats.finger_peaks = finger_peaks;
	fingerFeats.finger_offset = finger_offset;
	fingerFeats.finger_variability = finger_variability;
	fingerFeats.n_peaks = n_peaks;
end

