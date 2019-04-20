%% Attempting Step 3 in Paper - WORKING X MATRIX FOR 1ST FEAT FOR SUB1

% Each window is 50 ms long (length of time bin)
% Instead of Neurons, it's channels and instead of firings it's features

v = Sub1_num_chan;
N = 3; %num of time bins used before
win_s = 50/1e3; %length of window in seconds
duration = 300; %seconds
M = duration/win_s; %num of time bins                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ins where position is captured
total_bins = v*N;
columns = total_bins + 1; %to account for intercept term
num_feat = 6;
X1 = [];
p = 1:N; %setting new starting indices
q = M-2*N:M-3; %setting new ending indices. the -2 and -3 is to account for fact that the features only have 5997 time bins instead of 6000
next_start = 1:N:columns-1; 

for j = 1:num_feat
new_Sub1_feat{j} = Sub1_features(:,:,j);
end

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X1(:,new_start) = new_Sub1_feat{1}(c,p(k):q(k));
        end
    end
end
X1(:,1) = 1;

%% Calculating coefficients

downsampled_Sub1_dg_data3 = decimate(Sub1_dg_data{1},50);
adjusted_downsample = downsampled_Sub1_dg_data3(1:5994) %to clip off the last 6 data points since downsampled dg data had 6000
f = mldivide(X1'*X1,X1'*adjusted_downsample);

%% Predicted Positions

u = X1*f;

figure;
plot(u)
hold on
plot(adjusted_downsample)
title('Predicted vs Actual')

%Plotted it looks absolutely horrible 

%% Calculated Positions

% But calculated accuracy isn't too shabby

accuracy = corr(u,adjusted_downsample);