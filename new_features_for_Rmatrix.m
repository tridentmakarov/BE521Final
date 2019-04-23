%% load EEG data for Subject 1
clear all
datasetID = 'I521_Sub1_Training_ecog'; %62 channels
num_channels = 62;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_ecog, numberOfSamples_ecog, sampleRate_ecog, data_sub1_ecog_train, time_ecog, session_ecog] = getData(datasetID,num_channels,portionOfSamples);


%% load hand data from Subject 1
datasetID = 'I521_Sub1_Training_dg'; % 5 channels
num_channels = 5;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_dg, numberOfSamples_dg, sampleRate_dg, data_sub1_dg_train, time_dg, session_dg] = getData(datasetID,num_channels,portionOfSamples);

%save('workspace.mat')
%%
threshold = 1.5;
LineLength_Fn = @(x) sum( abs( diff(x) ) );
Area_Fn = @(x) sum(abs(x));
Energy_Fn = @(x) sum(power(x,2));
winLen = 0.1; %sec
winDisp = 0.05; %sec
LineLength_dg_train = [];
classification = [];
for i = 1:5
    LineLength_dg_train(:,i) = MovingWinFeats(data_sub1_dg_train(:,i),sampleRate_dg,winLen,winDisp,LineLength_Fn);
    Area_dg_train(:,i) = MovingWinFeats(data_sub1_dg_train(:,i),sampleRate_dg,winLen,winDisp,Area_Fn);
    Energy_dg_train(:,i) = MovingWinFeats(data_sub1_dg_train(:,i),sampleRate_dg,winLen,winDisp,Energy_Fn);
    figure(i); 
    subplot(2,1,1)
    plot(data_sub1_dg_train(:,i))
    subplot(2,1,2)
    hold on
    plot(LineLength_dg_train(:,i))
    plot(Area_dg_train(:,i))
    plot(Energy_dg_train(:,i))
    legend('Line Length','Area','Energy')
end











%%
function FeatureFn_allWindows = MovingWinFeats(x,Fs,winLen,winDisp,FeatureFn)
    NumberOfWins_Fn = @(xLen,fs,winLen,winDisp) [(xLen/Fs)-winLen]/winDisp+1;
    NumWins = NumberOfWins_Fn(length(x),Fs,winLen,winDisp);
    sampLen = winLen*Fs;
    sampDisp = winDisp*Fs;
    FeatureFn_allWindows = [];
    for i = 0:NumWins-1
        window = x([sampDisp*i+1]:[sampDisp*i+1] + [sampLen] -1);
        FeatureFn_allWindows(i+1,:) = FeatureFn(window);
    end
end