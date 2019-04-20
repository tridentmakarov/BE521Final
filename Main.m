clc
clearvars -except
close all

%% This will be the main code

load('data/train_ecog_1.mat')
load('data/train_dg_1.mat')
load('data/test_ecog_1.mat')

ecog_train = train_ecog_1(1:250000, :);
ecog_test = train_ecog_1(250001:300000, :);

dg_train = train_dg_1(1:250000, :);
dg_test = train_dg_1(250001:300000, :);

% remove_samples = 0.04 * 1000;

if ~isfile('features_train.mat') && ~isfile('features_test.mat')
	features_train = getFeatures(ecog_train);
	save('features_train.mat', 'features_train');
	features_test = getFeatures(ecog_test);
	save('features_test.mat', 'features_test');
else
	load('features_train.mat');
	load('features_test.mat');
end

for i = 1:5
	temp = decimate(dg_train(:, i), 50);
	Y(:, i) = temp(3:length(temp));
	temp2 = decimate(dg_test(:, i), 50);
	Y_test(:, i) = temp2(3:length(temp2));
end

datasets = {features_train, features_test};

for k = 1:2
	dataset = datasets{k};

	M = size(dataset, 2);
	N = size(dataset, 3); % Time Bins
	v = size(dataset, 1);

	rows = M;
	cols = N * v;
	R = ones(rows, cols);
	one_col = ones(rows, 1);

	for i = 1:v
		d = dataset(i, :, :);
		for j = 1:M
			R(j, (i-1)*N+1:i*N) = d(j:j+N-1);
		end
	end
	
	X{k} = [one_col, R];
	
end
B = inv(X{1}' * X{1}) * X{1}' * Y;
Y_p = X{2} * B;
correlation = corr(Y_p(:, 1), Y_test(1:997, 1));

for i = 1:5
	y = Y_p(:, i);
	x = 1:length(y); 
	xq1 = 1:1/50:length(y);
	sp(i, :) = spline(x,y,xq1);
	c(i) = corr(sp(i, :)', dg_test(1:length(sp(i, :)), i));

	figure()
	plot(sp(i, :))
	hold on
	plot(dg_test(1:length(sp(i, :)), i));
	legend('calculated', 'actual')
	hold off
end

% end