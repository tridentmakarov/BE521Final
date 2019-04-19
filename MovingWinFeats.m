function [LL, A, E, ZX, time] = MovingWinFeats(x, fs, winLen, winDisp, featFn)
	% Inputs:
		% x: signal
		% fs: signal frequency (Hz)
		% winLen: length of window (s)
		% winDisp: displacement of window (s)
	% featFn: feature function
	
	winOffset = winDisp * fs;
	w = winLen * fs;
	
	x_0 = 1;
	
	NumWins = ((length(x)/fs - winLen)/winDisp);
	ni = rem((length(x)/fs - winLen), winDisp);
	
	%Three extra features
	area = @(x) sum(abs(x)); %Area
	energy = @(x) sum(x.^2); %Energy
	zx = @(x) sum(and(x(2:length(x)) - mean(x) > 0,...
		x(1:length(x)-1) - mean(x) < 0)); %Crossings
	
	
	for i = 1:NumWins
		time(i) = (x_0-1) / fs + winLen;
		
		x_i = x(x_0 : x_0 + w - 1);
		LL(i) = featFn(x_i);
		
		%Extra features calculations
		A(i) = area(x_i);
		E(i) = energy(x_i);
		ZX(i) = zx(x_i);
		
		x_0 = x_0 + winOffset;
	end
end

