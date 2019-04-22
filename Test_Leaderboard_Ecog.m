%% Executing Code on Leaderboard Ecog
clc
clear all
close all
load('test_ecog_1.mat')
load('test_ecog_2.mat')
load('test_ecog_3.mat')
load('train_dg_1.mat')
load('train_dg_2.mat')
load('train_dg_3.mat')
load('train_ecog_1.mat')
load('train_ecog_2.mat')
load('train_ecog_3.mat')

Sub1_session = IEEGSession('I521_Sub1_Leaderboard_ecog', 'belindan', 'bel_ieeglogin.bin');
Sub2_session = IEEGSession('I521_Sub2_Leaderboard_ecog', 'belindan', 'bel_ieeglogin.bin');
Sub3_session = IEEGSession('I521_Sub3_Leaderboard_ecog', 'belindan', 'bel_ieeglogin.bin');

num_samples = 147500;

test_ecog{1} = test_ecog_1;
test_ecog{2} = test_ecog_2;
test_ecog{3} = test_ecog_3;

Sub1_lead_feat = getFeatures(test_ecog{1});
Sub2_lead_feat = getFeatures(test_ecog{2});
Sub3_lead_feat = getFeatures(test_ecog{3});

N = 3; %num of time bins used before
win_s = .050; %length of window in ms
SampleRate = (Sub1_session.data.sampleRate);
duration = (num_samples/SampleRate); %seconds
M = duration/win_s; %num of time bins
num_feat = 6;
p = 1:N; %setting new starting indices
q = M-2*N:M-N; %setting new ending indices. the -2 and -3 is to account for fact that the features only have 2948 time bins instead of 6000
%% Sub1 Feats Calculation
Sub1_num_chan = size(test_ecog_1,2);
v = Sub1_num_chan;
total_bins = v*N;
columns = total_bins + 1; %to account for intercept term
next_start = 1:N:columns-1; 

for feat = 1:6
    for c = v:-1:1 %to cycle through all of the channels backwards
        for k = 1:N %number of bin
            start = next_start(c);
            new_start = start+k;
            X1(:,new_start, feat) = Sub1_lead_feat(c,p(k):q(k),feat);
        end
    end
    X1(:, 1, feat) = 1;
end

% for i = 1:5
%     downsampled_Sub1_dg_data = decimate(Sub1_dg_data{i},50);
%     adjusted_downsample = downsampled_Sub1_dg_data(1:5994); %to clip off the last 6 data points since downsampled dg data had 6000
% 
%     for j = 1:6
%         X_j = X(:, :, j);
%         feat_i = mldivide(X_j'*X_j,X_j'*adjusted_downsample);
%         feat_u = X_j*feat_i;
% 
%         figure;
%         plot(feat_u)
%         hold on
%         plot(adjusted_downsample)
%         hold off
%         title('Predicted vs Actual')
%         legend('Predicted', 'Actual')
%         accuracy(i, j) = corr(feat_u, adjusted_downsample);
%     end
% end

new_X1 = reshape(X1, size(X1, 1), []);

for i = 1:5
    f = floor((length(train_dg_1(:,i))/length(new_X1)));
    downsampled_Sub1_dg_data = decimate(train_dg_1(:,i),f);
    adjusted_downsample1 = downsampled_Sub1_dg_data(1:length(new_X1));

    feat_i1 = mldivide(new_X1'*new_X1,new_X1'*adjusted_downsample1);
    feat_u1 = new_X1*feat_i1;

    figure;
    plot(feat_u1)
    hold on
    plot(adjusted_downsample1)
    hold off
    title('Predicted vs Actual')
    legend('Predicted', 'Actual')
    accuracy(i) = corr(feat_u1, adjusted_downsample1);
end
%% Sub2 Feats Calculation
Sub2_num_chan = size(test_ecog_2,2);
v2 = Sub2_num_chan;
total_bins2 = v2*N;
columns2 = total_bins2 + 1; %to account for intercept term
next_start2 = 1:N:columns2-1; 

for feat = 1:6
    for c = v2:-1:1 %to cycle through all of the channels backwards
        for k = 1:N %number of bin
            start2 = next_start2(c);
            new_start2 = start2+k;
            X2(:,new_start2, feat) = Sub2_lead_feat(c,p(k):q(k),feat);
        end
    end
    X2(:, 1, feat) = 1;
end

% for i = 1:5
%     downsampled_Sub1_dg_data = decimate(Sub1_dg_data{i},50);
%     adjusted_downsample = downsampled_Sub1_dg_data(1:5994); %to clip off the last 6 data points since downsampled dg data had 6000
% 
%     for j = 1:6
%         X_j = X(:, :, j);
%         feat_i = mldivide(X_j'*X_j,X_j'*adjusted_downsample);
%         feat_u = X_j*feat_i;
% 
%         figure;
%         plot(feat_u)
%         hold on
%         plot(adjusted_downsample)
%         hold off
%         title('Predicted vs Actual')
%         legend('Predicted', 'Actual')
%         accuracy(i, j) = corr(feat_u, adjusted_downsample);
%     end
% end

new_X2 = reshape(X2, size(X2, 1), []);

for i = 1:5
    f2 = floor((length(train_dg_2(:,i))/length(new_X2)));
    downsampled_Sub2_dg_data = decimate(train_dg_2(:,i),2);
    adjusted_downsample2 = downsampled_Sub2_dg_data(1:length(new_X2));

    feat_i2 = mldivide(new_X2'*new_X2,new_X2'*adjusted_downsample2);
    feat_u2 = new_X2*feat_i2;

    figure;
    plot(feat_u2)
    hold on
    plot(adjusted_downsample2)
    hold off
    title('Predicted vs Actual')
    legend('Predicted', 'Actual')
    accuracy2(i) = corr(feat_u2, adjusted_downsample2);
end
%% Sub3 Feats Calculation
Sub3_num_chan = size(test_ecog_3,2);
v3 = Sub3_num_chan;
total_bins3 = v3*N;
columns3 = total_bins3 + 1; %to account for intercept term
next_start3 = 1:N:columns3-1; 

for feat = 1:6
    for c = v3:-1:1 %to cycle through all of the channels backwards
        for k = 1:N %number of bin
            start3 = next_start3(c);
            new_start3 = start3+k;
            X3(:,new_start3, feat) = Sub3_lead_feat(c,p(k):q(k),feat);
        end
    end
    X3(:, 1, feat) = 1;
end

% for i = 1:5
%     downsampled_Sub1_dg_data = decimate(Sub1_dg_data{i},50);
%     adjusted_downsample = downsampled_Sub1_dg_data(1:5994); %to clip off the last 6 data points since downsampled dg data had 6000
% 
%     for j = 1:6
%         X_j = X(:, :, j);
%         feat_i = mldivide(X_j'*X_j,X_j'*adjusted_downsample);
%         feat_u = X_j*feat_i;
% 
%         figure;
%         plot(feat_u)
%         hold on
%         plot(adjusted_downsample)
%         hold off
%         title('Predicted vs Actual')
%         legend('Predicted', 'Actual')
%         accuracy(i, j) = corr(feat_u, adjusted_downsample);
%     end
% end

new_X3 = reshape(X3, size(X3, 1), []);

for i = 1:5
    f3 = floor((length(train_dg_3(:,i))/length(new_X3)));
    downsampled_Sub3_dg_data = decimate(train_dg_3(:,i),2);
    adjusted_downsample3 = downsampled_Sub3_dg_data(1:length(new_X3));

    feat_i3{i} = mldivide(new_X3'*new_X3,new_X3'*adjusted_downsample3);
    feat_u3{i} = new_X3*feat_i3;

    figure;
    plot(feat_u3)
    hold on
    plot(adjusted_downsample3)
    hold off
    title('Predicted vs Actual')
    legend('Predicted', 'Actual')
    accuracy3(i) = corr(feat_u3{i}, adjusted_downsample3{i});
    feat_pred3(i,:) = feat_u3{i};
end
%% Step 4 of Simple Method

% Sub 1
for i = 1:5
    y1 = feat_u1(i);
    x1 = 1:length(feat_u1{i});
    xq1 = 1:1/50:length(feat_u1{i})+7; % +7 is to scale it up closer to the 147500

interp_pred1(i,:) = spline(feat_pred3(i,:), y1, xq1);
new_interp_pred1(i,:) = interp_pred1(1:end-1);
end

% Sub 2
y2 = feat_u2;
x2 = 1:length(feat_u2);
xq2 = 1:1/50:length(feat_u2)+7; % +7 is to scale it up closer to the 147500

interp_pred2 = spline(x2, y2, xq2);
new_interp_pred2 = interp_pred2(1:end-1);

% Sub 3
for i = 1:5
    y3 = feat_u3(i,:);
    x3 = 1:length(feat_u3);
    xq3 = 1:1/50:length(feat_u3)+7; % +7 is to scale it up closer to the 147500

    interp_pred3 = spline(x3, y3, xq3);
    new_interp_pred3 = interp_pred3(1:end-1);
end
%% Storing all outputs
predicted_dg{1} = new_interp_pred1;
predicted_dg{2} = new_interp_pred2;
predicted_dg{3} = new_interp_pred3;