function [features_train,features_test] = Step1GetFeatures(ecog_train, ecog_test, set, pc, testing)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	if testing == false
		filename_train = sprintf('MatFiles/features_train_%d.mat', set);
		filename_test = sprintf('MatFiles/features_test_%d.mat', set);
	else
		filename_train = sprintf('MatFiles/features_train_%d_epoch_%d.mat', set, pc);
		filename_test = sprintf('MatFiles/features_test_%d_epoch_%d.mat', set, pc);
	end


	if ~isfile(filename_train) || ~isfile(filename_test) || testing == true
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

