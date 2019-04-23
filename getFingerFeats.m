function [times, peaks, finger_offset, finger_variability] = getFingerFeats(fingerVals)

	winLen = 2; %s
	winDisp = 1; %s
	LLFn = @(x) sum(abs(diff(x)));
	% LLFn = @(x) mean(x);
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

	[LL, ~, ~, ~, ~, ~] = MovingWinFeats(fingerVals, sampleRate, winLen, winDisp, LLFn, ranges);

	[~,~,w,~] = findpeaks(LL, 2, 'MinPeakProminence', max(LL)/2);

	times = mean(w) * winLen * sampleRate;
	filter = 0.1 * max(fingerVals);

	peaks = mean(fingerVals(fingerVals>filter));
	finger_offset = mean(fingerVals(fingerVals<filter));
	finger_variability = std(fingerVals(fingerVals<filter));
end
