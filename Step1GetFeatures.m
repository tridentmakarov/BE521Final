function [features_train,features_test] = Step1GetFeatures(ecog_train, ecog_test, set, pre_process)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	filename_train = sprintf('MatFiles/features_train_%d.mat', set);
	filename_test = sprintf('MatFiles/features_test_%d.mat', set);

	if ~isfile(filename_train) || ~isfile(filename_test)
		features_train = getFeatures(ecog_train, pre_process);
		features_test = getFeatures(ecog_test, pre_process);

		fprintf('Saving files: %s and %s\n', filename_train, filename_test);
		save(filename_train, 'features_train');
		save(filename_test, 'features_test');
	else
		load(filename_train);
		load(filename_test);
	end
end

function [output] = getFeatures(train_data, pre_process)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 	times = linspace(0, size(train_mini_dg, 1)*1000/1E6, size(train_mini_dg, 1))';

	if pre_process == true
		windowSize1 = 20; % TEST
		b1 = (1/windowSize1)*ones(1,windowSize1);
		a = 1;
		train_data = filtfilt(b1,a,train_data);
	end

	winLen = 0.1; %s
	winDisp = 0.05; %s
	% LLFn = @(x) sum(abs(diff(x)));
	LLFn = @(x) mean(x);
	sampleRate = 1000; %samples/s
	ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];
	output = [];
	for i = 1:size(train_data, 2)

		set = train_data(:, i);

		[LL, freq_mag, M, ZX] = MovingWinFeats(set, sampleRate, winLen, winDisp, ranges);

		output = [output, LL', M', freq_mag];
	end
end



