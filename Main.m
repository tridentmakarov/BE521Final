clc
clearvars -except features
close all

%% This will be the main code

load('train_mini_ecog.mat')
load('train_mini_dg.mat')

% remove_samples = 0.04 * 1000;

if ~isfile('mini_data.mat')
	features = getFeatures(train_mini_ecog);
	save('mini_data.mat', 'features');
else
	load('mini_data.mat');
end

for i = 1:5
	temp = decimate(train_mini_dg(:, i), 50);
	dg(:, i) = temp(3:length(temp));
end
