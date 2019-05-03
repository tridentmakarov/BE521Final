clc
clearvars -except
close all

%% Step 0: Load in data

show_plots = false; % Shows the post-process comparison
post_process = true; % Use post-processing. Very important!
pre_process = true; % Use pre-processing 

load('data/train_ecog_1.mat')
load('data/train_dg_1.mat')
load('data/test_ecog_1.mat')

load('data/train_ecog_2.mat')
load('data/train_dg_2.mat')
load('data/test_ecog_2.mat')

load('data/train_ecog_3.mat')
load('data/train_dg_3.mat')
load('data/test_ecog_3.mat')

%% Run through each person
ecog_sets = {train_ecog_1, train_ecog_2, train_ecog_3};
dg_sets = {train_dg_1, train_dg_2, train_dg_3};
test_sets = {test_ecog_1, test_ecog_2, test_ecog_3};

for set = 1:3
    fprintf('Getting features for person %d\n', set)
	ecog_train = ecog_sets{set};
	dg_train = dg_sets{set};
	ecog_test = test_sets{set};

	predicted_dg{set} = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, pre_process);
end

%% Output plots, for visual
for i = 1:length(predicted_dg)
	for j = 1:5
		figure()
		plot(predicted_dg{i}(:, j))
	end
end
%% Save predicted_dg.mat
disp('Finished! Outputting predicted_dg');
save('predicted_dg.mat', 'predicted_dg'); 


%% Function! Placed here for compactness
function output = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, preprocess)
	%% Step 1: Get features

	[features_train,features_test] = Step1GetFeatures(ecog_train, ecog_test, set, preprocess);

	%% Step 2: Decimate

	[Y, fingerFeats, train_binary] = Step2Decimation(dg_train);

	%% Step 3: Linear regression
% 	output = 1;

	filename_train = sprintf('MatFiles/Y_out_%d.mat', set);
	filename_test = sprintf('MatFiles/Y_compare_%d.mat', set);
	filename_binary = sprintf('MatFiles/test_binary_%d.mat', set);
	
	if ~isfile(filename_train) || ~isfile(filename_test) || ~isfile(filename_test)
		
		fprintf('Saving files: %s, %s, and %s\n', filename_train, filename_test, filename_binary);
		datasets = {features_train, features_test};
		[Y_out, Y_compare, test_binary] = Step3LinearRegression(Y, datasets, train_binary, set);

		save(filename_train, 'Y_out');
		save(filename_test, 'Y_compare');
		save(filename_binary, 'test_binary');
	else
		fprintf('Loading files: %s, %s, and %s\n', filename_train, filename_test, filename_binary);
		load(filename_train);
		load(filename_test);
		load(filename_binary);
	end
	

	%% Step 4: Interpolation
	
	load('new_mdl_train_label_predictions.mat')
	load('new_mdl_test_label_predictions.mat')
	train_binary = new_predicted_labels{set};
	test_binary = predicted_labels_test{set};
	
	[output] = Step4Interpolation(dg_train, Y_out, Y_compare, train_binary, test_binary, ecog_test, fingerFeats, show_plots, post_process, set);
	
	output = [zeros(37, 5); output(38:size(output, 1), :)];
end






