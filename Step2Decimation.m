function [Y, fingerFeats] = Step2Decimation(dg_train)
	%% Decimate to ensure the Y matrix is the proper size
	disp('Decimating')
	for i = 1:5
		[move_times(i), finger_peaks(i) finger_offset(i), finger_variability(i), n_peaks(i)] = getFingerFeats(dg_train(:, i)); % Get times
		temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
		Y(:, i) = temp(3:length(temp)-3); % Remove value
	end
	
	%% Create the object fingerFeats (this shortens things)
	fingerFeats.move_times = move_times; 
	fingerFeats.finger_peaks = finger_peaks;
	fingerFeats.finger_offset = finger_offset;
	fingerFeats.finger_variability = finger_variability;
	fingerFeats.n_peaks = n_peaks;
end

