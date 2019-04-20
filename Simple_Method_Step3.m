%% Attempting Step 3 in Paper - WORKING X MATRIX FOR 1ST FEAT FOR SUB 1
load('full_data_features')
load('all_sub_dg_data')
% Each window is 50 ms long (length of time bin)
% Instead of Neurons, it's channels and instead of firings it's features
Sub1_num_chan = 62;
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
%% Sub1 Feat 1
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
%% Sub 1 Feat 2
X2 = [];

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X2(:,new_start) = new_Sub1_feat{2}(c,p(k):q(k));
        end
    end
end
X2(:,1) = 1;
%% Sub 1 Feat 3
X3 = [];

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X3(:,new_start) = new_Sub1_feat{3}(c,p(k):q(k));
        end
    end
end
X3(:,1) = 1;
%% Sub 1 Feat 4
X4 = [];

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X4(:,new_start) = new_Sub1_feat{4}(c,p(k):q(k));
        end
    end
end
X4(:,1) = 1;
%% Sub 1 Feat 5
X5 = [];

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X5(:,new_start) = new_Sub1_feat{5}(c,p(k):q(k));
        end
    end
end
X5(:,1) = 1;
%% Sub 1 Feat 6
X6 = [];

for c = Sub1_num_chan:-1:1 %to cycle through all of the channels backwards
    for b = c:c %num in sequence for next start
        for k = 1:N %number of bin
            start = next_start(b);
            new_start = start+k;
            X6(:,new_start) = new_Sub1_feat{6}(c,p(k):q(k));
        end
    end
end
X6(:,1) = 1;
%% Calculating coefficients for Feat 1
% 1-5 indicate which finger for downsample, f, u, and accuracy variables

downsampled_Sub1_dg_data1 = decimate(Sub1_dg_data{1},50);
downsampled_Sub1_dg_data2 = decimate(Sub1_dg_data{2},50);
downsampled_Sub1_dg_data3 = decimate(Sub1_dg_data{3},50);
downsampled_Sub1_dg_data4 = decimate(Sub1_dg_data{4},50);
downsampled_Sub1_dg_data5 = decimate(Sub1_dg_data{5},50);
adjusted_downsample1 = downsampled_Sub1_dg_data1(1:5994); %to clip off the last 6 data points since downsampled dg data had 6000
adjusted_downsample2 = downsampled_Sub1_dg_data2(1:5994); 
adjusted_downsample3 = downsampled_Sub1_dg_data3(1:5994); 
adjusted_downsample4 = downsampled_Sub1_dg_data4(1:5994); 
adjusted_downsample5 = downsampled_Sub1_dg_data5(1:5994);

feat1_f1 = mldivide(X1'*X1,X1'*adjusted_downsample1);
feat1_f2 = mldivide(X1'*X1,X1'*adjusted_downsample2);
feat1_f3 = mldivide(X1'*X1,X1'*adjusted_downsample3);
feat1_f4 = mldivide(X1'*X1,X1'*adjusted_downsample4);
feat1_f5 = mldivide(X1'*X1,X1'*adjusted_downsample5);
%% Calculating coefficients for Feat 2

feat2_f1 = mldivide(X2'*X2,X2'*adjusted_downsample1);
feat2_f2 = mldivide(X2'*X2,X2'*adjusted_downsample2);
feat2_f3 = mldivide(X2'*X2,X2'*adjusted_downsample3);
feat2_f4 = mldivide(X2'*X2,X2'*adjusted_downsample4);
feat2_f5 = mldivide(X2'*X2,X2'*adjusted_downsample5);
%% Calculating coefficients for Feat 3

feat3_f1 = mldivide(X3'*X3,X3'*adjusted_downsample1);
feat3_f2 = mldivide(X3'*X3,X3'*adjusted_downsample2);
feat3_f3 = mldivide(X3'*X3,X3'*adjusted_downsample3);
feat3_f4 = mldivide(X3'*X3,X3'*adjusted_downsample4);
feat3_f5 = mldivide(X3'*X3,X3'*adjusted_downsample5);
%% Calculating coefficients for Feat 4

feat4_f1 = mldivide(X4'*X4,X4'*adjusted_downsample1);
feat4_f2 = mldivide(X4'*X4,X4'*adjusted_downsample2);
feat4_f3 = mldivide(X4'*X4,X4'*adjusted_downsample3);
feat4_f4 = mldivide(X4'*X4,X4'*adjusted_downsample4);
feat4_f5 = mldivide(X4'*X4,X4'*adjusted_downsample5);
%% Calculating coefficients for Feat 5

feat5_f1 = mldivide(X5'*X5,X5'*adjusted_downsample1);
feat5_f2 = mldivide(X5'*X5,X5'*adjusted_downsample2);
feat5_f3 = mldivide(X5'*X5,X5'*adjusted_downsample3);
feat5_f4 = mldivide(X5'*X5,X5'*adjusted_downsample4);
feat5_f5 = mldivide(X5'*X5,X5'*adjusted_downsample5);
%% Calculating coefficients for Feat 6

feat6_f1 = mldivide(X6'*X6,X6'*adjusted_downsample1);
feat6_f2 = mldivide(X6'*X6,X6'*adjusted_downsample2);
feat6_f3 = mldivide(X6'*X6,X6'*adjusted_downsample3);
feat6_f4 = mldivide(X6'*X6,X6'*adjusted_downsample4);
feat6_f5 = mldivide(X6'*X6,X6'*adjusted_downsample5);
%% Predicted Positions by Feat 1

feat1_u1 = X1*feat1_f1;
feat1_u2 = X1*feat1_f2;
feat1_u3 = X1*feat1_f3;
feat1_u4 = X1*feat1_f4;
feat1_u5 = X1*feat1_f5;

figure;
plot(feat1_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat1_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat1_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat1_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat1_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')

%Plotted it looks absolutely horrible 
%% Predicted Positions by Feat 2

feat2_u1 = X2*feat2_f1;
feat2_u2 = X2*feat2_f2;
feat2_u3 = X2*feat2_f3;
feat2_u4 = X2*feat2_f4;
feat2_u5 = X2*feat2_f5;

figure;
plot(feat2_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat2_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat2_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat2_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat2_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')
%% Predicted Positions by Feat 3

feat3_u1 = X3*feat3_f1;
feat3_u2 = X3*feat3_f2;
feat3_u3 = X3*feat3_f3;
feat3_u4 = X3*feat3_f4;
feat3_u5 = X3*feat3_f5;

figure;
plot(feat3_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat3_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat3_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat3_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat3_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')
%% Predicted Positions by Feat 4

feat4_u1 = X4*feat4_f1;
feat4_u2 = X4*feat4_f2;
feat4_u3 = X4*feat4_f3;
feat4_u4 = X4*feat4_f4;
feat4_u5 = X4*feat4_f5;

figure;
plot(feat4_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat4_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat4_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat4_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat4_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')
%% Predicted Positions by Feat 5

feat5_u1 = X5*feat5_f1;
feat5_u2 = X5*feat5_f2;
feat5_u3 = X5*feat5_f3;
feat5_u4 = X5*feat5_f4;
feat5_u5 = X5*feat5_f5;

figure;
plot(feat5_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat5_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat5_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat5_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat5_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')
%% Predicted Positions by Feat 6

feat6_u1 = X6*feat6_f1;
feat6_u2 = X6*feat6_f2;
feat6_u3 = X6*feat6_f3;
feat6_u4 = X6*feat6_f4;
feat6_u5 = X6*feat6_f5;

figure;
plot(feat6_u1)
hold on
plot(adjusted_downsample1)
hold off
title('Predicted vs Actual')

figure;
plot(feat6_u2)
hold on
plot(adjusted_downsample2)
hold off
title('Predicted vs Actual')

figure;
plot(feat6_u3)
hold on
plot(adjusted_downsample3)
hold off
title('Predicted vs Actual')

figure;
plot(feat6_u4)
hold on
plot(adjusted_downsample4)
hold off
title('Predicted vs Actual')

figure;
plot(feat6_u5)
hold on
plot(adjusted_downsample5)
hold off
title('Predicted vs Actual')

%% Calculated Accuracy for Feat 1

feat1_accuracy1 = corr(feat1_u1,adjusted_downsample1);
feat1_accuracy2 = corr(feat1_u2,adjusted_downsample2);
feat1_accuracy3 = corr(feat1_u3,adjusted_downsample3);
feat1_accuracy4 = corr(feat1_u4,adjusted_downsample4);
feat1_accuracy5 = corr(feat1_u5,adjusted_downsample5);
%% Calculated Accuracy for Feat 2

feat2_accuracy1 = corr(feat2_u1,adjusted_downsample1);
feat2_accuracy2 = corr(feat2_u2,adjusted_downsample2);
feat2_accuracy3 = corr(feat2_u3,adjusted_downsample3);
feat2_accuracy4 = corr(feat2_u4,adjusted_downsample4);
feat2_accuracy5 = corr(feat2_u5,adjusted_downsample5);
%% Calculated Accuracy for Feat 3

feat3_accuracy1 = corr(feat3_u1,adjusted_downsample1);
feat3_accuracy2 = corr(feat3_u2,adjusted_downsample2);
feat3_accuracy3 = corr(feat3_u3,adjusted_downsample3);
feat3_accuracy4 = corr(feat3_u4,adjusted_downsample4);
feat3_accuracy5 = corr(feat3_u5,adjusted_downsample5);
%% Calculated Accuracy for Feat 4

feat4_accuracy1 = corr(feat4_u1,adjusted_downsample1);
feat4_accuracy2 = corr(feat4_u2,adjusted_downsample2);
feat4_accuracy3 = corr(feat4_u3,adjusted_downsample3);
feat4_accuracy4 = corr(feat4_u4,adjusted_downsample4);
feat4_accuracy5 = corr(feat4_u5,adjusted_downsample5);
%% Calculated Accuracy for Feat 

feat5_accuracy1 = corr(feat5_u1,adjusted_downsample1);
feat5_accuracy2 = corr(feat5_u2,adjusted_downsample2);
feat5_accuracy3 = corr(feat5_u3,adjusted_downsample3);
feat5_accuracy4 = corr(feat5_u4,adjusted_downsample4);
feat5_accuracy5 = corr(feat5_u5,adjusted_downsample5);
%% Calculated Accuracy for Feat 6

feat6_accuracy1 = corr(feat6_u1,adjusted_downsample1);
feat6_accuracy2 = corr(feat6_u2,adjusted_downsample2);
feat6_accuracy3 = corr(feat6_u3,adjusted_downsample3);
feat6_accuracy4 = corr(feat6_u4,adjusted_downsample4);
feat6_accuracy5 = corr(feat6_u5,adjusted_downsample5);