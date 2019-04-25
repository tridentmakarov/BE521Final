function [LL, freq_mag, M] = MovingWinFeats(x, fs, winLen, winDisp, ranges)
	% Inputs:
		% x: signal
		% fs: signal frequency (Hz)
		% winLen: length of window (s)
		% winDisp: displacement of window (s)
	% featFn: feature function
	
	
	LLFn = @(x) sum(abs(diff(x)));
	MeanFn = @(x) mean(x);
	
	winOffset = winDisp * fs;
	w = winLen * fs;
	
	x_0 = 1;
	
	NumWins = ((length(x)/fs)/winDisp)-1;
	s_ranges = [];
	for i = 1:size(ranges)
		s_ranges = [s_ranges, ranges(i, 1): ranges(i, 2)];
	end
% 	ni = rem((length(x)/fs - winLen), winDisp);
	
	%Three extra features
% 	area = @(x) sum(abs(x)); %Area
% 	energy = @(x) sum(x.^2); %Energy
% 	zx = @(x) sum(and(x(2:length(x)) - mean(x) > 0,...
% 		x(1:length(x)-1) - mean(x) < 0)); %Crossings
	
	
	for i = 1:NumWins
		
		time(i) = (x_0-1) / fs + winLen;
		
		x_i = x(x_0 : x_0 + w - 1);
		LL(i) = LLFn(x_i);
		M(i) = MeanFn(x_i);
		
		[s1, f1, ~] = spectrogram(x_i,100,50,s_ranges,1000);
		for j = 1:5
			freq_mag(i, j) = abs(mean(s1(f1 >= ranges(j,1) & f1 <= ranges(j, 2))));
		end
		
		%Extra features calculations
% 		A(i) = area(x_i);
% 		E(i) = energy(x_i);
% 		ZX(i) = zx(x_i);
		
		x_0 = x_0 + winOffset;
	end
end

