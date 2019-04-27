function [features_train,features_test] = Step1GetFeatures(filename_train, filename_test, ecog_train, ecog_test)

	%% Feature file names

	%% Load features
	if ~isfile(filename_train) || ~isfile(filename_test)
		features_train = getFeatures(ecog_train);
		features_test = getFeatures(ecog_test);

		fprintf('Saving files: %s and %s\n', filename_train, filename_test);
		save(filename_train, 'features_train');
		save(filename_test, 'features_test');
	else
		load(filename_train);
		load(filename_test);
	end
end

