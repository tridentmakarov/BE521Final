function [output] = getFeatures(train_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 	times = linspace(0, size(train_mini_dg, 1)*1000/1E6, size(train_mini_dg, 1))';

	winLen = 0.1; %s
	winDisp = 0.05; %s
	% LLFn = @(x) sum(abs(diff(x)));
	LLFn = @(x) mean(x);
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];
	output = [];
	for i = 1:size(train_data, 2)

		set = train_data(:, i);

		[LL, freq_mag, A, E, ZX, t_int] = MovingWinFeats(set, sampleRate, winLen, winDisp, LLFn, ranges);

		output = [output, LL', freq_mag];
	end
end

