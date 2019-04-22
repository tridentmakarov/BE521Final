%% Attempting Step 3 in Paper - WORKING X MATRIX FOR 1ST FEAT FOR SUB 1
clc
clear all
close all

for set = 1:3
	
	filename_train = sprintf('features_train_%d.mat', set);
	filename_test = sprintf('features_test_%d.mat', set);
	
	load(filename_train);
	load(filename_test);

	% Each window is 50 ms long (length of time bin)
	% Instead of Neurons, it's channels and instead of firings it's features
	v = size(features_train, 3);
	N = 3; %num of time bins used before
	win_s = 50/1e3; %length of window in seconds
	duration = 300; %seconds
	M = duration/win_s; %num of time bins                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ins where position is captured
	total_bins = v*N;
	columns = total_bins + 1; %to account for intercept term
	num_feat = 6;
	p = 1:N; %setting new starting indices
	q = M-2*N:M-3; %setting new ending indices. the -2 and -3 is to account for fact that the features only have 5997 time bins instead of 6000
	next_start = 1:N:columns-1; 


	for j = 1:num_feat
		features{j} = features_train(:,:,j);
	end

	for feat = 1:6
		for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
			for k = 1:N %number of bin
				start = next_start(c);
				new_start = start+k;
				X(:,new_start, feat) = features{feat}(c,p(k):q(k));
			end
		end
		X(:, 1, feat) = 1;
	end

	%% Steps 2 and 3: 

	X = reshape(X, size(X, 1), []); %Resize to the new matrix

	for i = 1:5
		downsampled_Sub1_dg_data = decimate(Sub1_dg_data{i},50); % Decimate
		adjusted_downsample = downsampled_Sub1_dg_data(1:5994); %to clip off the last 6 data points since downsampled dg data had 6000

		feat_i = mldivide(X'*X,X'*adjusted_downsample);
		feat_u = X*feat_i;
	end
end