function [Y_out, Y_compare] = Step3LinearRegression(Y_in, datasets)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
	disp('Performing regression')

	X = cell(1, 2);
	for k = 1:2
		fprintf('Calculating X for set %d\n', k)
		dataset = datasets{k}; % Easier using cell array, get data

		M = size(dataset, 1); % Timepoints
		N = 5; % Time Bins
		v = size(dataset, 2); % Neurons

		rows = M; % Timepoints minus 2 extra time values
		cols = N * size(dataset, 2); % Neurons times features times 3 (for overlap)
		R = zeros(rows - 4, cols); % Create matrix
		one_col = ones(rows-4, 1); % Ones column
		% Run through each neuron (will be something like 62, 44, etc)
		for i = 1 : v
			% Run through each of the timepoints (will be something like 4999)
			for j = 3 : M - 2
				% Get the last three position values, for 150ms lag
				R(j-2, :) = [dataset(j-2, :),  dataset(j-1, :), dataset(j, :), dataset(j+1, :),  dataset(j+2, :)];
			end
		end
		% Add to cell array
		X{k} = [one_col, R];
	end

	% Create the B matrix
	B = mldivide(X{1}' * X{1}, X{1}' * Y_in);

	% Calculate the Y matrix, and pad
	Y_out = X{2} * B;
	Y_compare = X{1} * B;
	Y_out = [zeros(1, 5); zeros(1, 5); Y_out; zeros(1, 5); zeros(1, 5) ];
	Y_compare = [zeros(1, 5); zeros(1, 5); Y_compare; zeros(1, 5); zeros(1, 5) ];
	% 	Y_testing = X * B;

	% Test correlation
	% 	correlation = corr(Y_testing(:, 1), Y_train(:, 1));
	% 	fprintf('Finger 1 testing correlation of %.2f\n', correlation);
end

