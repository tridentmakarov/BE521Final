function output = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set)
	%% Step 1: Get features

	f_train = sprintf('MatFiles/features_train_%d.mat', set);
	f_test = sprintf('MatFiles/features_test_%d.mat', set);
	[features_train,features_test] = Step1GetFeatures(f_train, f_test, ecog_train, ecog_test);

	%% Step 2: Decimate

	[Y, fingerFeats] = Step2Decimation(dg_train);

	%% Step 3: Linear regression
	

	datasets = {features_train, features_test};
	[Y_out] = Step3LinearRegression(Y, datasets);

	%% Step 4: Interpolation
	output = Step4Interpolation(Y_out, ecog_test, fingerFeats, show_plots, post_process);

% 	output = [zeros(37, 5); output(38:size(output, 1), :)];
end


