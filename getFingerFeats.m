function [times, peaks, finger_offset, finger_variability, n_peaks] = getFingerFeats(vals)

	winLen = 2; %s
	winDisp = 1; %s
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

	[LL, ~, ~] = MovingWinFeats(vals, sampleRate, winLen, winDisp, ranges);

	[~,~,w,~] = findpeaks(LL, 2, 'MinPeakProminence', max(LL)/2);

	times = mean(w) * winLen * sampleRate;
	filter = 0.1 * max(vals);
	n_peaks = length(w);

	peaks = mean(vals(vals>filter));
	finger_offset = mean(vals(vals<filter));
	finger_variability = std(vals(vals<filter));
end
