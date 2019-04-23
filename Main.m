clc
clearvars -except
close all

%% Step 0: Load in data

% session = IEEGSession('I521_Sub3_Leaderboard_ecog','Luke Jungmann','Luk_ieeglogin.bin');
% nr = ceil((session.data.rawChannels(1).get_tsdetails.getEndTime)/1e6*session.data.sampleRate);
% test_ecog_3 = session.data.getvalues(1:320000, 1:length(session.data.rawChannels));
% remove_pos = find(isnan(test_ecog_3(:, 1)), 1, 'first');
% test_ecog_3 = test_ecog_3(1:remove_pos-1, :);
% save('data/test_ecog_3.mat', 'test_ecog_3')

testing = false;
show_plots = false;
post_process = true;

load('data/train_ecog_1.mat')
load('data/train_dg_1.mat')
load('data/test_ecog_1.mat')

load('data/train_ecog_2.mat')
load('data/train_dg_2.mat')
load('data/test_ecog_2.mat')

load('data/train_ecog_3.mat')
load('data/train_dg_3.mat')
load('data/test_ecog_3.mat')


% ecog_sets = {train_ecog_1, train_ecog_2, train_ecog_3};
dg_sets = {train_dg_1, train_dg_2, train_dg_3};
% test_sets = {test_ecog_1, test_ecog_2, test_ecog_3};


load('updated_features.mat')

Sub1_lead_feat = permute(Sub1_lead_feat,[2 3 1]);
Sub2_lead_feat = permute(Sub2_lead_feat,[2 3 1]);
Sub3_lead_feat = permute(Sub3_lead_feat,[2 3 1]);

ecog_sets = {Sub1_lead_feat, Sub2_lead_feat, Sub3_lead_feat};

for set = 1:3
	%% Step 1: Get features
	fprintf('Getting features for person %d\n', set)
	ecog_train = ecog_sets{set};
	if testing == true
		ecog_test = test_sets{set};
		dg_test = dg_test_sets{set};
	end

	dg_train = dg_sets{set};


	filename_train = sprintf('features_train_%d.mat', set);
	filename_test = sprintf('features_test_%d.mat', set);
	
	
	if ~isfile(filename_train)
		features_train = getFeatures(ecog_train);
		fprintf('Saving file: %s\n', filename_train);
		save(filename_train, 'features_train');
	else
		load(filename_train);
	end
	
	if ~isfile(filename_test)
		features_test = getFeatures(ecog_test);
		fprintf('Saving file: %s\n', filename_test);
		save(filename_test, 'features_test');
	else
		load(filename_test);
	end

% 	features_train = ecog_sets{set};

	%% Step 2: Decimate
	disp('Decimating')
	for i = 1:5
		[move_times(i), finger_peaks(i) finger_offset(i), finger_variability(i)] = getFingerFeats(dg_train(:, i)); % Get times
		temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
		Y(:, i) = temp(2:length(temp)); % Remove value
		
		if testing == true
			temp2 = decimate(dg_test(:, i), 50); 
			Y_test(:, i) = temp2(2:length(temp2)); % Test set
		end
	end

	%% Step 3: Linear regression
	disp('Performing regression')
	dataset = features_train; % Easier using cell array, get data

	M = size(dataset, 1); % Timepoints
	N = size(dataset, 2); % Time Bins
	v = size(dataset, 3); % Neurons

	rows = M-2; % Timepoints minus 2 extra time values
	cols = N * v * 3; % Neurons times features times 3 (for overlap)
	R = ones(rows, cols); % Create matrix
	one_col = ones(rows, 1); % Ones column

	% Run through each neuron (will be something like 62, 44, etc)
	for i = 1 : v
		data = squeeze(dataset(:, :, i)); % Remove extra dimension

		% Run through each of the timepoints (will be something like 4999)
		for j = 3 : M
			% Get the last three position values, for 150ms lag
			R(j-2, (i-1)*N*3+1 : i*N*3) = [data(j-2, :),  data(j-1, :), data(j, :)];
		end
	end

	% Add to cell array
	X = [one_col, R];


	% Ensure the Y matrices are the right sizes for calculation
	Y_train = Y(1:size(X, 1), :);
	if testing == true
		Y_test = Y_test(1:size(X{2}, 1), :);
	end

	% Create the B matrix
	B = inv(X' * X) * X' * Y_train;
	
	% Calculate the Y matrix, and pad
	Y_B = X * B;
	Y_B = [Y_B(1, :); Y_B(1, :); Y_B; Y_B(size(Y_B, 1),:)];
	Y_testing = X * B;

	% Test correlation
	correlation = corr(Y_testing(:, 1), Y_train(:, 1));
	fprintf('Finger 1 testing correlation of %.2f\n', correlation);


	%% Step 4: Interpolation
	% Run through each finger
	disp('Interpolating the finger positions')
	for i = 1:5
		y = Y_B(:, i); % Get y value of finger
		x = 1:length(y); % Get x values of finger
		xq1 = 1:1/50:length(y)+2; % Interpolate positions
		xq1 = xq1(1:size(test_ecog_1, 1));
		sp(i, :) = spline(x,y,xq1); % Spline

		%% Post-process
		if post_process == true
			sp(i, :) = calcMovement(sp(i, :), move_times(i), finger_peaks(i), finger_offset(i), finger_variability(i));
		end
		
		if show_plots == true % Run if testing
			c(i) = corr(sp(i, :)', dg_train(1:length(sp(i, :)), i));

			figure()
			hold on
			plot(sp(i, :))
			plot(dg_train(1:length(sp(i, :)), i), '--');
			legend('calculated', 'actual')
			hold off
		end
	end
	if testing == false
		predicted_dg{set} = sp(:, 1:size(test_ecog_1, 1))';
	end
end
if testing == false
	save('predicted_dg.mat', 'predicted_dg');
end


