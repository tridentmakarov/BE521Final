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

	[Y, fingerFeats] = Step2Decimation(dg_train);

	%% Step 3: Linear regression

	datasets = {features_train, features_test};
	[Y_out, Y_compare] = Step3LinearRegression(Y, datasets);

	%% Step 4: Interpolation
	[output] = Step4Interpolation(dg_train, Y_out, Y_compare, ecog_test, fingerFeats, show_plots, post_process);
	
% 	output = [zeros(37, 5); output(38:size(output, 1), :)];
end






