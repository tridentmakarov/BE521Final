function output = CrossSteps(ecog_train, dg_train, show_plots, post_process, set, nc)
	%% Step 1: Get features
	
	
	vals = 0:size(ecog_train, 1)/nc:size(ecog_train, 1);
	vals2 = vals(2:length(vals));
	vals = vals(1:length(vals)-1) + 1;
	
	for i = 1:nc
		
		fprintf('Cross validation %d\n', i)
		trainset = 1:size(ecog_train, 1);
		testset = vals(i):vals2(i);
		trainset(testset) = [];
		ecog_train_vals = ecog_train(trainset, :);
		ecog_test_vals = ecog_train(testset, :);
		dg_train_vals = dg_train(trainset, :);
		dg_test_vals = dg_train(testset, :);

		f_train = sprintf('MatFiles/features_train_%d_%d.mat', set, i);
		f_test = sprintf('MatFiles/features_test_%d_%d.mat', set, i);
		[features_train,features_test] = Step1GetFeatures(f_train, f_test, ecog_train_vals, ecog_test_vals);

		%% Step 2: Decimate

		[Y, fingerFeats] = Step2Decimation(dg_train_vals);

		%% Step 3: Linear regression

		datasets = {features_train, features_test};
		[Y_out] = Step3LinearRegression(Y, datasets);

		%% Step 4: Interpolation
		output{i} = Step4Interpolation(dg_test_vals, Y_out, ecog_test_vals, fingerFeats, show_plots, post_process);
		dg_test = dg_train((i-1)*length(output{i})+1 : i*length(output{i}), :);
		for j = 1:5
			figure()
			plot(output{i}(:, j))
			hold on;
			plot(dg_test_vals(:, j))
			hold off;
			pause(0.2)
			correlation(i, j) = corr(output{i}(:, j), dg_test_vals(:, j));
		end
		output{i} = [zeros(37, 5); output(38:size(output, 1), :)];
	end
end


