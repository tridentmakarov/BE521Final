function output = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, pc, cross_validating)
	%% Step 1: Get features

	[features_train,features_test] = Step1GetFeatures(ecog_train, ecog_test, set, pc, cross_validating);

	%% Step 2: Decimate

	[Y, fingerFeats] = Step2Decimation(dg_train);

	%% Step 3: Linear regression

	datasets = {features_train, features_test};
	[Y_out] = Step3LinearRegression(Y, datasets);

	%% Step 4: Interpolation
	[output] = Step4Interpolation(dg_train, Y_out, ecog_test, fingerFeats, show_plots, post_process, cross_validating);
	
% 	output = [zeros(37, 5); output(38:size(output, 1), :)];
end


