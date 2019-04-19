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



%% Plot of Finger Signals
threshold = 1.5;

figure(); 
subplot(5,1,1)
plot(time_dg,data_sub1_dg_train(:,1),'color',[0 0 1])
title('Finger 1')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,2)
plot(time_dg,data_sub1_dg_train(:,2),'color',[0 0 1])
title('Finger 2')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,3)
plot(time_dg,data_sub1_dg_train(:,3),'color',[0 0 1])
title('Finger 3')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,4)
plot(time_dg,data_sub1_dg_train(:,4),'color',[0 0 1])
title('Finger 4')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,5)
plot(time_dg,data_sub1_dg_train(:,5),'color',[0 0 1])
title('Finger 5')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')








%% Line Length Attempt
threshold = 1.5;
LineLength_LFn = @(x) sum( abs( diff(x) ) );
winLen = 0.4; %sec
winDisp = 0.1; %sec
LineLength_dg_train = [];
classification = [];
for i = 1:5
    LineLength_dg_train(:,i) = MovingWinFeats(data_sub1_dg_train(:,i),sampleRate_dg,winLen,winDisp,LineLength_LFn);
end

remainder = 0;
LL_dg_train = zeros(length(data_sub1_dg_train),1);
mean_dg_train = [];
for i = 1:length(LineLength_dg_train) % LineLength matrix only 2997x1, add padding so that it becomes 300000x1
    remainder = remainder + 0.1; % the Line Length Data needs to be padded with 100.1 samples
    LL_dg_train(1+100*(i-1)+floor(remainder):100*i+floor(remainder),1) = LineLength_dg_train(i,1);
    LL_dg_train(1+100*(i-1)+floor(remainder):100*i+floor(remainder),2) = LineLength_dg_train(i,2);
    LL_dg_train(1+100*(i-1)+floor(remainder):100*i+floor(remainder),3) = LineLength_dg_train(i,3);
    LL_dg_train(1+100*(i-1)+floor(remainder):100*i+floor(remainder),4) = LineLength_dg_train(i,4);
    LL_dg_train(1+100*(i-1)+floor(remainder):100*i+floor(remainder),5) = LineLength_dg_train(i,5);
    if remainder >= 299.5 % added to get 300000x1 exactly
        remainder = 300;
    end
    if LL_dg_train(1+100*(i-1)+floor(remainder),1) >= threshold 
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),1) = 1;
    else
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),1) = 0;
    end
    if LL_dg_train(1+100*(i-1)+floor(remainder),2) >= threshold 
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),2) = 1;
    else
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),2) = 0;
    end
    if LL_dg_train(1+100*(i-1)+floor(remainder),3) >= threshold 
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),3) = 1;
    else
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),3) = 0;
    end
    if LL_dg_train(1+100*(i-1)+floor(remainder),4) >= threshold 
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),4) = 1;
    else
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),4) = 0;
    end
    if LL_dg_train(1+100*(i-1)+floor(remainder),5) >= threshold 
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),5) = 1;
    else
        classification(1+100*(i-1)+floor(remainder):100*i+floor(remainder),5) = 0;
    end
    i
end

A = [];
counter = zeros(5,1);
for i = 1:length(LL_dg_train(:,1))
    for j = 2:5
        if LL_dg_train(i,j) > 5
            classification(i,j) = 1;
        end
        if i < length(LL_dg_train(:,j))-100 && i > 100
            A(i,j) = sum(LL_dg_train(i-100:i+100,j) >= threshold);
        else
            A(i,j) = 0;
        end
    end
    i
end

for i = 1:length(A)
    for j = 2:5
        if A(i,j) > threshold && LL_dg_train(i) <= 1
            %LL_dg_train(i) = 5;
            classification(i,j) = 1;
        end
        if A(i,j) < threshold && LL_dg_train(i) <= 1
            %LL_dg_train(i) = 5;
            classification(i,j) = 0;
        end
        if A(i,j) < threshold && LL_dg_train(i) >= 1
            %LL_dg_train(i) = 5;
            classification(i,j) = 1;
        end
    end
    i
end
%save('workspace_Apr17.mat')


%% Finger 1 
a = find(time_dg >= 292,1);
b = find(time_dg >= 293,1);
classification(a:b,1) = 1;
a = find(time_dg >= 293.3,1);
b = find(time_dg >= 293.3793,1);
classification(a:b,1) = 1;
a = find(time_dg >= 293.3,1);
b = find(time_dg >= 293.793,1);
classification(a:b,1) = 0;

figure(); 
subplot(3,1,1)%subplot(1,3,1)
hold on
plot(time_dg,data_sub1_dg_train(1:length(A(:,1)),1),'linewidth',1,'color',[0 0 1])
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
legend('Raw Movement Signal','Threshold','location','northeast')
grid on
xlabel('Time (seconds)')
ylabel('Movement')
title('Finger 1')

subplot(3,1,2)%subplot(1,3,2)
hold on
plot(time_dg,data_sub1_dg_train(1:length(A(:,1)),1),'linewidth',1,'color',[0 0 1])
plot(time_dg,LL_dg_train(1:length(A(:,1))),'color',[0 1 0],'linewidth',2)
plot(time_dg,A(:,1)/20,'color',[0 0 0],'linewidth',2)
plot(time_dg,classification(1:length(A(:,1)),1)*10.2,'linewidth',2,'color',[1 0 1])
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
legend('Raw Movement Signal','Line Length','# of Samples Above Threshold (20ms window)','Classification','Threshold','location','northeast')
grid on
xlabel('Time (seconds)')
ylabel('Movement')
title('Finger 1')

%subplot(1,3,3)
subplot(3,1,3)%
hold on
plot(time_dg,data_sub1_dg_train(1:length(A(:,1)),1),'linewidth',1,'color',[0 0 1])
plot(time_dg,classification(1:length(A(:,1)),1),'linewidth',2,'color',[1 0 1])
yticks([0 1])
ylim([-1 2])
ylabel('Classification')
xlabel('Time (seconds)')
legend('Raw Movement Signal','Classification','location','northeast')
grid on
title('Finger 1')





%% Finger 2 
for i = 2:2 % 1:5
    figure(); 
    subplot(3,1,1)%subplot(1,3,1)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 2')

    subplot(3,1,2)%subplot(1,3,2)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,LL_dg_train(1:length(A(:,i)),i),'color',[0 1 0],'linewidth',2)
    plot(time_dg,A(:,i)/20,'color',[0 0 0],'linewidth',2)
    plot(time_dg,classification(1:length(A(:,i)),i)*10.2,'linewidth',2,'color',[1 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Line Length','# of Samples Above Threshold (20ms window)','Classification','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 2')

    subplot(3,1,3)%subplot(1,3,3)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,classification(1:length(A(:,i)),i),'linewidth',2,'color',[1 0 1])
    yticks([0 1])
    ylim([-1 2])
    ylabel('Classification')
    xlabel('Time (seconds)')
    legend('Raw Movement Data','Classification','location','northeast')
    grid on
    title('Finger 2')
    %legend('# of LL Samples Above Threshold - 10ms before and 10ms after','Raw Movement Data','Line Length','Classification','location','eastoutside')
end








%% Finger 3

for i = 3:3 % 1:5
    figure(); 
    subplot(3,1,1)%subplot(1,3,1)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    title('Finger 3')
    ylabel('Movement')

    subplot(3,1,2)%subplot(1,3,2)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,LL_dg_train(1:length(A(:,i)),i),'color',[0 1 0],'linewidth',2)
    plot(time_dg,A(:,i)/20,'color',[0 0 0],'linewidth',2)
    plot(time_dg,classification(1:length(A(:,i)),i)*10.2,'linewidth',2,'color',[1 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Line Length','# of Samples Above Threshold (20ms window)','Classification','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 3')

    subplot(3,1,3)%subplot(1,3,3)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,classification(1:length(A(:,i)),i),'linewidth',2,'color',[1 0 1])
    yticks([0 1])
    ylim([-1 2])
    ylabel('Classification')
    xlabel('Time (seconds)')
    legend('Classification','location','northeast')
    grid on
    title('Finger 3')
    %legend('# of LL Samples Above Threshold - 10ms before and 10ms after','Raw Movement Data','Line Length','Classification','location','eastoutside')
end





%% Finger 4

for i = 1:length(classification(:,4))
    if classification(i,4) == 1 && data_sub1_dg_train(i,4)<2.0 % new threshold
        classification(i,4) = 0;
    end
    i
end

%%
for i = 4:4 % 1:5
    figure(); 
    subplot(3,1,1)%subplot(1,3,1)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 4')

    subplot(3,1,2)%subplot(1,3,2)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,LL_dg_train(1:length(A(:,i)),i),'color',[0 1 0],'linewidth',2)
    plot(time_dg,A(:,i)/20,'color',[0 0 0],'linewidth',2)
    plot(time_dg,classification(1:length(A(:,i)),i)*10.2,'linewidth',2,'color',[1 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Line Length','# of Samples Above Threshold (20ms window)','Classification','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 4')

    subplot(3,1,3)%subplot(1,3,3)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,classification(1:length(A(:,i)),i),'linewidth',2,'color',[1 0 1])
    yticks([0 1])
    ylim([-1 2])
    ylabel('Classification')
    xlabel('Time (seconds)')
    legend('Raw Motion Data','Classification','location','northeast')
    grid on
    title('Finger 4')
    %legend('# of LL Samples Above Threshold - 10ms before and 10ms after','Raw Movement Data','Line Length','Classification','location','eastoutside')
end



%% Finger 5
for i = 5:5 % 1:5
    figure(); 
    subplot(3,1,1)%subplot(1,3,1)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    ylabel('Movement')
    title('Finger 5')

    subplot(3,1,2)%subplot(1,3,2)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,LL_dg_train(1:length(A(:,i)),i),'color',[0 1 0],'linewidth',2)
    plot(time_dg,A(:,i)/20,'color',[0 0 0],'linewidth',2)
    plot(time_dg,classification(1:length(A(:,i)),i)*10.2,'linewidth',2,'color',[1 0 1])
    plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0],'linewidth',2)
    legend('Raw Movement Signal','Line Length','# of Samples Above Threshold (20ms window)','Classification','Threshold','location','northeast')
    grid on
    xlabel('Time (seconds)')
    title('Finger 5')
    ylabel('Movement')

    subplot(3,1,3)%subplot(1,3,3)
    hold on
    plot(time_dg,data_sub1_dg_train(1:length(A(:,i)),i),'linewidth',1,'color',[0 0 1])
    plot(time_dg,classification(1:length(A(:,i)),i),'linewidth',2,'color',[1 0 1])
    yticks([0 1])
    ylim([-1 2])
    ylabel('Classification')
    xlabel('Time (seconds)')
    legend('Raw Motion Data','Classification','location','northeast')
    title('Classification - Finger 5')
    grid on
    %legend('# of LL Samples Above Threshold - 10ms before and 10ms after','Raw Movement Data','Line Length','Classification','location','eastoutside')
end



















%%
figure(); 
subplot(5,1,1)
plot(time_dg,data_sub1_dg_train(:,1),'color',[0 0 1])
hold on
plot(time_dg,LL_dg_train(:,1),'color',[1 0 1],'linewidth',2);
title('Finger 1')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,2)
plot(time_dg,data_sub1_dg_train(:,2),'color',[0 0 1])
title('Finger 2')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,3)
plot(time_dg,data_sub1_dg_train(:,3),'color',[0 0 1])
title('Finger 3')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,4)
plot(time_dg,data_sub1_dg_train(:,4),'color',[0 0 1])
title('Finger 4')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,5)
plot(time_dg,data_sub1_dg_train(:,5),'color',[0 0 1])
title('Finger 5')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')











%%
figure(); 
subplot(5,1,1)
plot(time_dg,data_sub1_dg_train(:,1),'color',[0 0 1])
title('Finger 1')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,2)
plot(time_dg,data_sub1_dg_train(:,2),'color',[0 0 1])
title('Finger 2')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,3)
plot(time_dg,data_sub1_dg_train(:,3),'color',[0 0 1])
title('Finger 3')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,4)
plot(time_dg,data_sub1_dg_train(:,4),'color',[0 0 1])
title('Finger 4')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,1,5)
plot(time_dg,data_sub1_dg_train(:,5),'color',[0 0 1])
title('Finger 5')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')





%% Creating Labels for 
threshold = 1.5;
labels_sub1_dg_train = [];
for i = 1:length(data_sub1_dg_train(:,1)) 
    if data_sub1_dg_train(i,1) > threshold % Finger 1
        labels_sub1_dg_train(i) = 1;
    else
        labels_sub1_dg_train(i) = 0;
    end
    if data_sub1_dg_train(i,2) > threshold % Finger 2
        labels_sub1_dg_train(2,i) = 1;
    else
        labels_sub1_dg_train(2,i) = 0;
    end
    if data_sub1_dg_train(i,3) > threshold % Finger 3
        labels_sub1_dg_train(3,i) = 1;
    else
        labels_sub1_dg_train(3,i) = 0;
    end
    if data_sub1_dg_train(i,4) > threshold % Finger 4
        labels_sub1_dg_train(4,i) = 1;
    else
        labels_sub1_dg_train(4,i) = 0;
    end
    if data_sub1_dg_train(i,5) > threshold % Finger 5
        labels_sub1_dg_train(5,i) = 1;
    else
        labels_sub1_dg_train(5,i) = 0;
    end
    i
end


%%
close all

figure(); 
subplot(5,2,1)
plot(time_dg,data_sub1_dg_train(:,1),'color',[0 0 1])
title('Finger 1')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,2,2)
plot(time_dg,labels_sub1_dg_train(1,:),'linewidth',2,'color',[1 0 0])
grid on
title('Finger 1 Classification Results')
ylabel('Class')
xlabel('Time (seconds)')
yticks([0 1])

subplot(5,2,3)
plot(time_dg,data_sub1_dg_train(:,2),'color',[0 0 1])
title('Finger 2')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,2,4)
plot(time_dg,labels_sub1_dg_train(2,:),'linewidth',2,'color',[1 0 0])
grid on
title('Finger 2 Classification Results')
ylabel('Class')
xlabel('Time (seconds)')
yticks([0 1])

subplot(5,2,5)
plot(time_dg,data_sub1_dg_train(:,3),'color',[0 0 1])
title('Finger 3')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,2,6)
plot(time_dg,labels_sub1_dg_train(3,:),'linewidth',2,'color',[1 0 0])
grid on
title('Finger 3 Classification Results')
ylabel('Class')
xlabel('Time (seconds)')
yticks([0 1])

subplot(5,2,7)
plot(time_dg,data_sub1_dg_train(:,4),'color',[0 0 1])
title('Finger 4')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,2,8)
plot(time_dg,labels_sub1_dg_train(4,:),'linewidth',2,'color',[1 0 0])
grid on
title('Finger 4 Classification Results')
ylabel('Class')
xlabel('Time (seconds)')
yticks([0 1])

subplot(5,2,9)
plot(time_dg,data_sub1_dg_train(:,5),'color',[0 0 1])
title('Finger 5')
ylabel('Finger Position')
xlabel('Time (seconds)')
grid on
hold on
plot([time_dg(1) time_dg(length(time_dg))],[threshold threshold],'--','color',[1 0 0])
legend('Raw Signal','Threshold = 1.5','location','eastoutside')

subplot(5,2,10)
plot(time_dg,labels_sub1_dg_train(5,:),'linewidth',2,'color',[1 0 0])
grid on
title('Finger 5 Classification Results')
ylabel('Class')
xlabel('Time (seconds)')
yticks([0 1])













%% Plotting EEG data
figure()
subplot(2,1,1)
plot(data_sub1_ecog_train(:,1))
subplot(2,1,2)
plot(normalize(data_sub1_ecog_train(:,1)))


%% Determining Optimal Channels - Subject 1
[pks_chan1,locs_chan1] = findpeaks(normalize(data_sub1_ecog_train(:,1)));
[pks_chan2,locs_chan2] = findpeaks(normalize(data_sub1_ecog_train(:,2)));
[pks_chan3,locs_chan3] = findpeaks(normalize(data_sub1_ecog_train(:,3)));
[pks_chan4,locs_chan4] = findpeaks(normalize(data_sub1_ecog_train(:,4)));
[pks_chan5,locs_chan5] = findpeaks(normalize(data_sub1_ecog_train(:,5)));
[pks_chan6,locs_chan6] = findpeaks(normalize(data_sub1_ecog_train(:,6)));
[pks_chan7,locs_chan7] = findpeaks(normalize(data_sub1_ecog_train(:,7)));
[pks_chan8,locs_chan8] = findpeaks(normalize(data_sub1_ecog_train(:,8)));
[pks_chan9,locs_chan9] = findpeaks(normalize(data_sub1_ecog_train(:,9)));
[pks_chan10,locs_chan10] = findpeaks(normalize(data_sub1_ecog_train(:,10)));
[pks_chan11,locs_chan11] = findpeaks(normalize(data_sub1_ecog_train(:,11)));
[pks_chan12,locs_chan12] = findpeaks(normalize(data_sub1_ecog_train(:,12)));
[pks_chan13,locs_chan13] = findpeaks(normalize(data_sub1_ecog_train(:,13)));
[pks_chan14,locs_chan14] = findpeaks(normalize(data_sub1_ecog_train(:,14)));
[pks_chan15,locs_chan15] = findpeaks(normalize(data_sub1_ecog_train(:,15)));
[pks_chan16,locs_chan16] = findpeaks(normalize(data_sub1_ecog_train(:,16)));
[pks_chan17,locs_chan17] = findpeaks(normalize(data_sub1_ecog_train(:,17)));
[pks_chan18,locs_chan18] = findpeaks(normalize(data_sub1_ecog_train(:,18)));
[pks_chan19,locs_chan19] = findpeaks(normalize(data_sub1_ecog_train(:,19)));
[pks_chan20,locs_chan20] = findpeaks(normalize(data_sub1_ecog_train(:,20)));
[pks_chan21,locs_chan21] = findpeaks(normalize(data_sub1_ecog_train(:,21)));
[pks_chan22,locs_chan22] = findpeaks(normalize(data_sub1_ecog_train(:,22)));
[pks_chan23,locs_chan23] = findpeaks(normalize(data_sub1_ecog_train(:,23)));
[pks_chan24,locs_chan24] = findpeaks(normalize(data_sub1_ecog_train(:,24)));
[pks_chan25,locs_chan25] = findpeaks(normalize(data_sub1_ecog_train(:,25)));
[pks_chan26,locs_chan26] = findpeaks(normalize(data_sub1_ecog_train(:,26)));
[pks_chan27,locs_chan27] = findpeaks(normalize(data_sub1_ecog_train(:,27)));
[pks_chan28,locs_chan28] = findpeaks(normalize(data_sub1_ecog_train(:,28)));
[pks_chan29,locs_chan29] = findpeaks(normalize(data_sub1_ecog_train(:,29)));
[pks_chan30,locs_chan30] = findpeaks(normalize(data_sub1_ecog_train(:,30)));
[pks_chan31,locs_chan31] = findpeaks(normalize(data_sub1_ecog_train(:,31)));
[pks_chan32,locs_chan32] = findpeaks(normalize(data_sub1_ecog_train(:,32)));
[pks_chan33,locs_chan33] = findpeaks(normalize(data_sub1_ecog_train(:,33)));
[pks_chan34,locs_chan34] = findpeaks(normalize(data_sub1_ecog_train(:,34)));
[pks_chan35,locs_chan35] = findpeaks(normalize(data_sub1_ecog_train(:,35)));
[pks_chan36,locs_chan36] = findpeaks(normalize(data_sub1_ecog_train(:,36)));
[pks_chan37,locs_chan37] = findpeaks(normalize(data_sub1_ecog_train(:,37)));
[pks_chan38,locs_chan38] = findpeaks(normalize(data_sub1_ecog_train(:,38)));
[pks_chan39,locs_chan39] = findpeaks(normalize(data_sub1_ecog_train(:,39)));
[pks_chan40,locs_chan40] = findpeaks(normalize(data_sub1_ecog_train(:,40)));
[pks_chan41,locs_chan41] = findpeaks(normalize(data_sub1_ecog_train(:,41)));
[pks_chan42,locs_chan42] = findpeaks(normalize(data_sub1_ecog_train(:,42)));
[pks_chan43,locs_chan43] = findpeaks(normalize(data_sub1_ecog_train(:,43)));
[pks_chan44,locs_chan44] = findpeaks(normalize(data_sub1_ecog_train(:,44)));
[pks_chan45,locs_chan45] = findpeaks(normalize(data_sub1_ecog_train(:,45)));
[pks_chan46,locs_chan46] = findpeaks(normalize(data_sub1_ecog_train(:,46)));
[pks_chan47,locs_chan47] = findpeaks(normalize(data_sub1_ecog_train(:,47)));
[pks_chan48,locs_chan48] = findpeaks(normalize(data_sub1_ecog_train(:,48)));
[pks_chan49,locs_chan49] = findpeaks(normalize(data_sub1_ecog_train(:,49)));
[pks_chan50,locs_chan50] = findpeaks(normalize(data_sub1_ecog_train(:,50)));
[pks_chan51,locs_chan51] = findpeaks(normalize(data_sub1_ecog_train(:,51)));
[pks_chan52,locs_chan52] = findpeaks(normalize(data_sub1_ecog_train(:,52)));
[pks_chan53,locs_chan53] = findpeaks(normalize(data_sub1_ecog_train(:,53)));
[pks_chan54,locs_chan54] = findpeaks(normalize(data_sub1_ecog_train(:,54)));
[pks_chan55,locs_chan55] = findpeaks(normalize(data_sub1_ecog_train(:,55)));
[pks_chan56,locs_chan56] = findpeaks(normalize(data_sub1_ecog_train(:,56)));
[pks_chan57,locs_chan57] = findpeaks(normalize(data_sub1_ecog_train(:,57)));
[pks_chan58,locs_chan58] = findpeaks(normalize(data_sub1_ecog_train(:,58)));
[pks_chan59,locs_chan59] = findpeaks(normalize(data_sub1_ecog_train(:,59)));
[pks_chan60,locs_chan60] = findpeaks(normalize(data_sub1_ecog_train(:,60)));
[pks_chan61,locs_chan61] = findpeaks(normalize(data_sub1_ecog_train(:,61)));
[pks_chan62,locs_chan62] = findpeaks(normalize(data_sub1_ecog_train(:,62)));
save('workspace.mat')



%% Setting Up Time  Bins
counter = 0;
count_peaks = [];
for i = 1:length(time_ecog)/sampleRate_ecog %20 time bins
    if i == 1
        count_peaks(1,i) = sum(locs_chan1 <= sampleRate_ecog*i); % Chan1
        count_peaks(2,i) = sum(locs_chan2 <= sampleRate_ecog*i); % Chan2
        count_peaks(3,i) = sum(locs_chan3 <= sampleRate_ecog*i); % Chan3
        count_peaks(4,i) = sum(locs_chan4 <= sampleRate_ecog*i); % Chan4
        count_peaks(5,i) = sum(locs_chan5 <= sampleRate_ecog*i); % Chan5
        count_peaks(6,i) = sum(locs_chan6 <= sampleRate_ecog*i); % Chan6
        count_peaks(7,i) = sum(locs_chan7 <= sampleRate_ecog*i); % Chan7
        count_peaks(8,i) = sum(locs_chan8 <= sampleRate_ecog*i); % Chan8
        count_peaks(9,i) = sum(locs_chan9 <= sampleRate_ecog*i); % Chan9
        count_peaks(10,i) = sum(locs_chan10 <= sampleRate_ecog*i); % Chan10
        count_peaks(11,i) = sum(locs_chan11 <= sampleRate_ecog*i); % Chan11
        count_peaks(12,i) = sum(locs_chan12 <= sampleRate_ecog*i); % Chan12
        count_peaks(13,i) = sum(locs_chan13 <= sampleRate_ecog*i); % Chan13
        count_peaks(14,i) = sum(locs_chan14 <= sampleRate_ecog*i); % Chan14
        count_peaks(15,i) = sum(locs_chan15 <= sampleRate_ecog*i); % Chan15
        count_peaks(16,i) = sum(locs_chan16 <= sampleRate_ecog*i); % Chan16
        count_peaks(17,i) = sum(locs_chan17 <= sampleRate_ecog*i); % Chan17
        count_peaks(18,i) = sum(locs_chan18 <= sampleRate_ecog*i); % Chan18
        count_peaks(19,i) = sum(locs_chan19 <= sampleRate_ecog*i); % Chan19
        count_peaks(20,i) = sum(locs_chan20 <= sampleRate_ecog*i); % Chan20
        count_peaks(21,i) = sum(locs_chan21 <= sampleRate_ecog*i);
        count_peaks(22,i) = sum(locs_chan22 <= sampleRate_ecog*i);
        count_peaks(23,i) = sum(locs_chan23 <= sampleRate_ecog*i);
        count_peaks(24,i) = sum(locs_chan24 <= sampleRate_ecog*i);
        count_peaks(25,i) = sum(locs_chan25 <= sampleRate_ecog*i);
        count_peaks(26,i) = sum(locs_chan26 <= sampleRate_ecog*i);
        count_peaks(27,i) = sum(locs_chan27 <= sampleRate_ecog*i);
        count_peaks(28,i) = sum(locs_chan28 <= sampleRate_ecog*i);
        count_peaks(29,i) = sum(locs_chan29 <= sampleRate_ecog*i);
        count_peaks(30,i) = sum(locs_chan30 <= sampleRate_ecog*i);
        count_peaks(31,i) = sum(locs_chan31 <= sampleRate_ecog*i);
        count_peaks(32,i) = sum(locs_chan32 <= sampleRate_ecog*i);
        count_peaks(33,i) = sum(locs_chan33 <= sampleRate_ecog*i);
        count_peaks(34,i) = sum(locs_chan34 <= sampleRate_ecog*i);
        count_peaks(35,i) = sum(locs_chan35 <= sampleRate_ecog*i);
        count_peaks(36,i) = sum(locs_chan36 <= sampleRate_ecog*i);
        count_peaks(37,i) = sum(locs_chan37 <= sampleRate_ecog*i);
        count_peaks(38,i) = sum(locs_chan38 <= sampleRate_ecog*i);
        count_peaks(39,i) = sum(locs_chan39 <= sampleRate_ecog*i);
        count_peaks(40,i) = sum(locs_chan40 <= sampleRate_ecog*i);
        count_peaks(41,i) = sum(locs_chan41 <= sampleRate_ecog*i);
        count_peaks(42,i) = sum(locs_chan42 <= sampleRate_ecog*i);
        count_peaks(43,i) = sum(locs_chan43 <= sampleRate_ecog*i);
        count_peaks(44,i) = sum(locs_chan44 <= sampleRate_ecog*i);
        count_peaks(45,i) = sum(locs_chan45 <= sampleRate_ecog*i);
        count_peaks(46,i) = sum(locs_chan46 <= sampleRate_ecog*i);
        count_peaks(47,i) = sum(locs_chan47 <= sampleRate_ecog*i);
        count_peaks(48,i) = sum(locs_chan48 <= sampleRate_ecog*i);
        count_peaks(49,i) = sum(locs_chan49 <= sampleRate_ecog*i);
        count_peaks(50,i) = sum(locs_chan50 <= sampleRate_ecog*i);
        count_peaks(51,i) = sum(locs_chan51 <= sampleRate_ecog*i);
        count_peaks(52,i) = sum(locs_chan52 <= sampleRate_ecog*i);
        count_peaks(53,i) = sum(locs_chan53 <= sampleRate_ecog*i);
        count_peaks(54,i) = sum(locs_chan54 <= sampleRate_ecog*i);
        count_peaks(55,i) = sum(locs_chan55 <= sampleRate_ecog*i);
        count_peaks(56,i) = sum(locs_chan56 <= sampleRate_ecog*i);
        count_peaks(57,i) = sum(locs_chan57 <= sampleRate_ecog*i);
        count_peaks(58,i) = sum(locs_chan58 <= sampleRate_ecog*i);
        count_peaks(59,i) = sum(locs_chan59 <= sampleRate_ecog*i);
        count_peaks(60,i) = sum(locs_chan60 <= sampleRate_ecog*i);
        count_peaks(61,i) = sum(locs_chan61 <= sampleRate_ecog*i);
        count_peaks(62,i) = sum(locs_chan62 <= sampleRate_ecog*i);
    else
        count_peaks(1,i) = sum(locs_chan1 <= sampleRate_ecog*i) - sum(locs_chan1 <= sampleRate_ecog*(i-1)); % Chan1
        count_peaks(2,i) = sum(locs_chan2 <= sampleRate_ecog*i) - sum(locs_chan2 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(3,i) = sum(locs_chan3 <= sampleRate_ecog*i) - sum(locs_chan3 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(4,i) = sum(locs_chan4 <= sampleRate_ecog*i) - sum(locs_chan4 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(5,i) = sum(locs_chan5 <= sampleRate_ecog*i) - sum(locs_chan5 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(6,i) = sum(locs_chan6 <= sampleRate_ecog*i) - sum(locs_chan6 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(7,i) = sum(locs_chan7 <= sampleRate_ecog*i) - sum(locs_chan7 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(8,i) = sum(locs_chan8 <= sampleRate_ecog*i) - sum(locs_chan8 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(9,i) = sum(locs_chan9 <= sampleRate_ecog*i) - sum(locs_chan9 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks(10,i) = sum(locs_chan10 <= sampleRate_ecog*i) - sum(locs_chan10 <= sampleRate_ecog*(i-1)); % Chan10
        count_peaks(11,i) = sum(locs_chan11 <= sampleRate_ecog*i) - sum(locs_chan11 <= sampleRate_ecog*(i-1)); % Chan11
        count_peaks(12,i) = sum(locs_chan12 <= sampleRate_ecog*i) - sum(locs_chan12 <= sampleRate_ecog*(i-1)); % Chan12
        count_peaks(13,i) = sum(locs_chan13 <= sampleRate_ecog*i) - sum(locs_chan13 <= sampleRate_ecog*(i-1)); % Chan13
        count_peaks(14,i) = sum(locs_chan14 <= sampleRate_ecog*i) - sum(locs_chan14 <= sampleRate_ecog*(i-1)); % Chan14
        count_peaks(15,i) = sum(locs_chan15 <= sampleRate_ecog*i) - sum(locs_chan15 <= sampleRate_ecog*(i-1)); % Chan15
        count_peaks(16,i) = sum(locs_chan16 <= sampleRate_ecog*i) - sum(locs_chan16 <= sampleRate_ecog*(i-1)); % Chan16
        count_peaks(17,i) = sum(locs_chan17 <= sampleRate_ecog*i) - sum(locs_chan17 <= sampleRate_ecog*(i-1)); % Chan17
        count_peaks(18,i) = sum(locs_chan18 <= sampleRate_ecog*i) - sum(locs_chan18 <= sampleRate_ecog*(i-1)); % Chan18
        count_peaks(19,i) = sum(locs_chan19 <= sampleRate_ecog*i) - sum(locs_chan19 <= sampleRate_ecog*(i-1)); % Chan19
        count_peaks(20,i) = sum(locs_chan20 <= sampleRate_ecog*i) - sum(locs_chan20 <= sampleRate_ecog*(i-1)); % Chan20
        count_peaks(21,i) = sum(locs_chan21 <= sampleRate_ecog*i) - sum(locs_chan21 <= sampleRate_ecog*(i-1)); 
        count_peaks(22,i) = sum(locs_chan22 <= sampleRate_ecog*i) - sum(locs_chan22 <= sampleRate_ecog*(i-1)); 
        count_peaks(23,i) = sum(locs_chan23 <= sampleRate_ecog*i) - sum(locs_chan23 <= sampleRate_ecog*(i-1)); 
        count_peaks(24,i) = sum(locs_chan24 <= sampleRate_ecog*i) - sum(locs_chan24 <= sampleRate_ecog*(i-1)); 
        count_peaks(25,i) = sum(locs_chan25 <= sampleRate_ecog*i) - sum(locs_chan25 <= sampleRate_ecog*(i-1)); 
        count_peaks(26,i) = sum(locs_chan26 <= sampleRate_ecog*i) - sum(locs_chan26 <= sampleRate_ecog*(i-1)); 
        count_peaks(27,i) = sum(locs_chan27 <= sampleRate_ecog*i) - sum(locs_chan27 <= sampleRate_ecog*(i-1)); 
        count_peaks(28,i) = sum(locs_chan28 <= sampleRate_ecog*i) - sum(locs_chan28 <= sampleRate_ecog*(i-1)); 
        count_peaks(29,i) = sum(locs_chan29 <= sampleRate_ecog*i) - sum(locs_chan29 <= sampleRate_ecog*(i-1)); 
        count_peaks(30,i) = sum(locs_chan30 <= sampleRate_ecog*i) - sum(locs_chan30 <= sampleRate_ecog*(i-1)); 
        count_peaks(31,i) = sum(locs_chan31 <= sampleRate_ecog*i) - sum(locs_chan31 <= sampleRate_ecog*(i-1));
        count_peaks(32,i) = sum(locs_chan32 <= sampleRate_ecog*i) - sum(locs_chan32 <= sampleRate_ecog*(i-1));
        count_peaks(33,i) = sum(locs_chan33 <= sampleRate_ecog*i) - sum(locs_chan33 <= sampleRate_ecog*(i-1));
        count_peaks(34,i) = sum(locs_chan34 <= sampleRate_ecog*i) - sum(locs_chan34 <= sampleRate_ecog*(i-1));
        count_peaks(35,i) = sum(locs_chan35 <= sampleRate_ecog*i) - sum(locs_chan35 <= sampleRate_ecog*(i-1));
        count_peaks(36,i) = sum(locs_chan36 <= sampleRate_ecog*i) - sum(locs_chan36 <= sampleRate_ecog*(i-1));
        count_peaks(37,i) = sum(locs_chan37 <= sampleRate_ecog*i) - sum(locs_chan37 <= sampleRate_ecog*(i-1));
        count_peaks(38,i) = sum(locs_chan38 <= sampleRate_ecog*i) - sum(locs_chan38 <= sampleRate_ecog*(i-1));
        count_peaks(39,i) = sum(locs_chan39 <= sampleRate_ecog*i) - sum(locs_chan39 <= sampleRate_ecog*(i-1));
        count_peaks(40,i) = sum(locs_chan40 <= sampleRate_ecog*i) - sum(locs_chan40 <= sampleRate_ecog*(i-1));
        count_peaks(41,i) = sum(locs_chan41 <= sampleRate_ecog*i) - sum(locs_chan41 <= sampleRate_ecog*(i-1));
        count_peaks(42,i) = sum(locs_chan42 <= sampleRate_ecog*i) - sum(locs_chan42 <= sampleRate_ecog*(i-1));
        count_peaks(43,i) = sum(locs_chan43 <= sampleRate_ecog*i) - sum(locs_chan43 <= sampleRate_ecog*(i-1));
        count_peaks(44,i) = sum(locs_chan44 <= sampleRate_ecog*i) - sum(locs_chan44 <= sampleRate_ecog*(i-1));
        count_peaks(45,i) = sum(locs_chan45 <= sampleRate_ecog*i) - sum(locs_chan45 <= sampleRate_ecog*(i-1));
        count_peaks(46,i) = sum(locs_chan46 <= sampleRate_ecog*i) - sum(locs_chan46 <= sampleRate_ecog*(i-1));
        count_peaks(47,i) = sum(locs_chan47 <= sampleRate_ecog*i) - sum(locs_chan47 <= sampleRate_ecog*(i-1));
        count_peaks(48,i) = sum(locs_chan48 <= sampleRate_ecog*i) - sum(locs_chan48 <= sampleRate_ecog*(i-1));
        count_peaks(49,i) = sum(locs_chan49 <= sampleRate_ecog*i) - sum(locs_chan49 <= sampleRate_ecog*(i-1));
        count_peaks(50,i) = sum(locs_chan50 <= sampleRate_ecog*i) - sum(locs_chan50 <= sampleRate_ecog*(i-1));
        count_peaks(51,i) = sum(locs_chan51 <= sampleRate_ecog*i) - sum(locs_chan51 <= sampleRate_ecog*(i-1));
        count_peaks(52,i) = sum(locs_chan52 <= sampleRate_ecog*i) - sum(locs_chan52 <= sampleRate_ecog*(i-1));
        count_peaks(53,i) = sum(locs_chan53 <= sampleRate_ecog*i) - sum(locs_chan53 <= sampleRate_ecog*(i-1));
        count_peaks(54,i) = sum(locs_chan54 <= sampleRate_ecog*i) - sum(locs_chan54 <= sampleRate_ecog*(i-1));
        count_peaks(55,i) = sum(locs_chan55 <= sampleRate_ecog*i) - sum(locs_chan55 <= sampleRate_ecog*(i-1));
        count_peaks(56,i) = sum(locs_chan56 <= sampleRate_ecog*i) - sum(locs_chan56 <= sampleRate_ecog*(i-1));
        count_peaks(57,i) = sum(locs_chan57 <= sampleRate_ecog*i) - sum(locs_chan57 <= sampleRate_ecog*(i-1));
        count_peaks(58,i) = sum(locs_chan58 <= sampleRate_ecog*i) - sum(locs_chan58 <= sampleRate_ecog*(i-1));
        count_peaks(59,i) = sum(locs_chan59 <= sampleRate_ecog*i) - sum(locs_chan59 <= sampleRate_ecog*(i-1));
        count_peaks(60,i) = sum(locs_chan60 <= sampleRate_ecog*i) - sum(locs_chan60 <= sampleRate_ecog*(i-1));
        count_peaks(61,i) = sum(locs_chan61 <= sampleRate_ecog*i) - sum(locs_chan61 <= sampleRate_ecog*(i-1));
        count_peaks(62,i) = sum(locs_chan62 <= sampleRate_ecog*i) - sum(locs_chan62 <= sampleRate_ecog*(i-1));
    end
    i
end


figure();
imagesc(count_peaks);
colorbar
title('EEG Peaks Over Time - Subject 1')
xlabel('Time Bin #')
ylabel('Neuron #')
yticks([1:62])























































%% Determining Optimal Channels - Subject 2
datasetID = 'I521_Sub2_Training_ecog'; %48 channels
num_channels = 48;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_sub2_ecog, numberOfSamples_sub2_ecog, sampleRate_sub2_ecog, data_sub2_ecog_train, time_sub2_ecog, session_sub2_ecog] = getData(datasetID,num_channels,portionOfSamples);


%% load hand data from Subject 2
datasetID = 'I521_Sub2_Training_dg'; % 5 channels
num_channels = 5;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_sub2_dg, numberOfSamples_sub2_dg, sampleRate_sub2_dg, data_sub2_dg_train, time_sub2_dg, session_sub2_dg] = getData(datasetID,num_channels,portionOfSamples);

%%
[pks_sub2_chan1,locs_sub2_chan1] = findpeaks(normalize(data_sub2_ecog_train(:,1)));
[pks_sub2_chan2,locs_sub2_chan2] = findpeaks(normalize(data_sub2_ecog_train(:,2)));
[pks_sub2_chan3,locs_sub2_chan3] = findpeaks(normalize(data_sub2_ecog_train(:,3)));
[pks_sub2_chan4,locs_sub2_chan4] = findpeaks(normalize(data_sub2_ecog_train(:,4)));
[pks_sub2_chan5,locs_sub2_chan5] = findpeaks(normalize(data_sub2_ecog_train(:,5)));
[pks_sub2_chan6,locs_sub2_chan6] = findpeaks(normalize(data_sub2_ecog_train(:,6)));
[pks_sub2_chan7,locs_sub2_chan7] = findpeaks(normalize(data_sub2_ecog_train(:,7)));
[pks_sub2_chan8,locs_sub2_chan8] = findpeaks(normalize(data_sub2_ecog_train(:,8)));
[pks_sub2_chan9,locs_sub2_chan9] = findpeaks(normalize(data_sub2_ecog_train(:,9)));
[pks_sub2_chan10,locs_sub2_chan10] = findpeaks(normalize(data_sub2_ecog_train(:,10)));
[pks_sub2_chan11,locs_sub2_chan11] = findpeaks(normalize(data_sub2_ecog_train(:,11)));
[pks_sub2_chan12,locs_sub2_chan12] = findpeaks(normalize(data_sub2_ecog_train(:,12)));
[pks_sub2_chan13,locs_sub2_chan13] = findpeaks(normalize(data_sub2_ecog_train(:,13)));
[pks_sub2_chan14,locs_sub2_chan14] = findpeaks(normalize(data_sub2_ecog_train(:,14)));
[pks_sub2_chan15,locs_sub2_chan15] = findpeaks(normalize(data_sub2_ecog_train(:,15)));
[pks_sub2_chan16,locs_sub2_chan16] = findpeaks(normalize(data_sub2_ecog_train(:,16)));
[pks_sub2_chan17,locs_sub2_chan17] = findpeaks(normalize(data_sub2_ecog_train(:,17)));
[pks_sub2_chan18,locs_sub2_chan18] = findpeaks(normalize(data_sub2_ecog_train(:,18)));
[pks_sub2_chan19,locs_sub2_chan19] = findpeaks(normalize(data_sub2_ecog_train(:,19)));
[pks_sub2_chan20,locs_sub2_chan20] = findpeaks(normalize(data_sub2_ecog_train(:,20)));
[pks_sub2_chan21,locs_sub2_chan21] = findpeaks(normalize(data_sub2_ecog_train(:,21)));
[pks_sub2_chan22,locs_sub2_chan22] = findpeaks(normalize(data_sub2_ecog_train(:,22)));
[pks_sub2_chan23,locs_sub2_chan23] = findpeaks(normalize(data_sub2_ecog_train(:,23)));
[pks_sub2_chan24,locs_sub2_chan24] = findpeaks(normalize(data_sub2_ecog_train(:,24)));
[pks_sub2_chan25,locs_sub2_chan25] = findpeaks(normalize(data_sub2_ecog_train(:,25)));
[pks_sub2_chan26,locs_sub2_chan26] = findpeaks(normalize(data_sub2_ecog_train(:,26)));
[pks_sub2_chan27,locs_sub2_chan27] = findpeaks(normalize(data_sub2_ecog_train(:,27)));
[pks_sub2_chan28,locs_sub2_chan28] = findpeaks(normalize(data_sub2_ecog_train(:,28)));
[pks_sub2_chan29,locs_sub2_chan29] = findpeaks(normalize(data_sub2_ecog_train(:,29)));
[pks_sub2_chan30,locs_sub2_chan30] = findpeaks(normalize(data_sub2_ecog_train(:,30)));
[pks_sub2_chan31,locs_sub2_chan31] = findpeaks(normalize(data_sub2_ecog_train(:,31)));
[pks_sub2_chan32,locs_sub2_chan32] = findpeaks(normalize(data_sub2_ecog_train(:,32)));
[pks_sub2_chan33,locs_sub2_chan33] = findpeaks(normalize(data_sub2_ecog_train(:,33)));
[pks_sub2_chan34,locs_sub2_chan34] = findpeaks(normalize(data_sub2_ecog_train(:,34)));
[pks_sub2_chan35,locs_sub2_chan35] = findpeaks(normalize(data_sub2_ecog_train(:,35)));
[pks_sub2_chan36,locs_sub2_chan36] = findpeaks(normalize(data_sub2_ecog_train(:,36)));
[pks_sub2_chan37,locs_sub2_chan37] = findpeaks(normalize(data_sub2_ecog_train(:,37)));
[pks_sub2_chan38,locs_sub2_chan38] = findpeaks(normalize(data_sub2_ecog_train(:,38)));
[pks_sub2_chan39,locs_sub2_chan39] = findpeaks(normalize(data_sub2_ecog_train(:,39)));
[pks_sub2_chan40,locs_sub2_chan40] = findpeaks(normalize(data_sub2_ecog_train(:,40)));
[pks_sub2_chan41,locs_sub2_chan41] = findpeaks(normalize(data_sub2_ecog_train(:,41)));
[pks_sub2_chan42,locs_sub2_chan42] = findpeaks(normalize(data_sub2_ecog_train(:,42)));
[pks_sub2_chan43,locs_sub2_chan43] = findpeaks(normalize(data_sub2_ecog_train(:,43)));
[pks_sub2_chan44,locs_sub2_chan44] = findpeaks(normalize(data_sub2_ecog_train(:,44)));
[pks_sub2_chan45,locs_sub2_chan45] = findpeaks(normalize(data_sub2_ecog_train(:,45)));
[pks_sub2_chan46,locs_sub2_chan46] = findpeaks(normalize(data_sub2_ecog_train(:,46)));
[pks_sub2_chan47,locs_sub2_chan47] = findpeaks(normalize(data_sub2_ecog_train(:,47)));
[pks_sub2_chan48,locs_sub2_chan48] = findpeaks(normalize(data_sub2_ecog_train(:,48)));
% [pks_sub2_chan49,locs_sub2_chan49] = findpeaks(normalize(data_sub2_ecog_train(:,49)));
% [pks_sub2_chan50,locs_sub2_chan50] = findpeaks(normalize(data_sub2_ecog_train(:,50)));
% [pks_sub2_chan51,locs_sub2_chan51] = findpeaks(normalize(data_sub2_ecog_train(:,51)));
% [pks_sub2_chan52,locs_sub2_chan52] = findpeaks(normalize(data_sub2_ecog_train(:,52)));
% [pks_sub2_chan53,locs_sub2_chan53] = findpeaks(normalize(data_sub2_ecog_train(:,53)));
% [pks_sub2_chan54,locs_sub2_chan54] = findpeaks(normalize(data_sub2_ecog_train(:,54)));
% [pks_sub2_chan55,locs_sub2_chan55] = findpeaks(normalize(data_sub2_ecog_train(:,55)));
% [pks_sub2_chan56,locs_sub2_chan56] = findpeaks(normalize(data_sub2_ecog_train(:,56)));
% [pks_sub2_chan57,locs_sub2_chan57] = findpeaks(normalize(data_sub2_ecog_train(:,57)));
% [pks_sub2_chan58,locs_sub2_chan58] = findpeaks(normalize(data_sub2_ecog_train(:,58)));
% [pks_sub2_chan59,locs_sub2_chan59] = findpeaks(normalize(data_sub2_ecog_train(:,59)));
% [pks_sub2_chan60,locs_sub2_chan60] = findpeaks(normalize(data_sub2_ecog_train(:,60)));
% [pks_sub2_chan61,locs_sub2_chan61] = findpeaks(normalize(data_sub2_ecog_train(:,61)));
% [pks_sub2_chan62,locs_sub2_chan62] = findpeaks(normalize(data_sub2_ecog_train(:,62)));
i
%save('workspace.mat')



%% Setting Up Time  Bins
counter = 0;
count_peaks_sub2 = [];
for i = 1:length(time_ecog)/sampleRate_ecog %20 time bins
    if i == 1
        count_peaks_sub2(1,i) = sum(locs_sub2_chan1 <= sampleRate_ecog*i); % Chan1
        count_peaks_sub2(2,i) = sum(locs_sub2_chan2 <= sampleRate_ecog*i); % Chan2
        count_peaks_sub2(3,i) = sum(locs_sub2_chan3 <= sampleRate_ecog*i); % Chan3
        count_peaks_sub2(4,i) = sum(locs_sub2_chan4 <= sampleRate_ecog*i); % Chan4
        count_peaks_sub2(5,i) = sum(locs_sub2_chan5 <= sampleRate_ecog*i); % Chan5
        count_peaks_sub2(6,i) = sum(locs_sub2_chan6 <= sampleRate_ecog*i); % Chan6
        count_peaks_sub2(7,i) = sum(locs_sub2_chan7 <= sampleRate_ecog*i); % Chan7
        count_peaks_sub2(8,i) = sum(locs_sub2_chan8 <= sampleRate_ecog*i); % Chan8
        count_peaks_sub2(9,i) = sum(locs_sub2_chan9 <= sampleRate_ecog*i); % Chan9
        count_peaks_sub2(10,i) = sum(locs_sub2_chan10 <= sampleRate_ecog*i); % Chan10
        count_peaks_sub2(11,i) = sum(locs_sub2_chan11 <= sampleRate_ecog*i); % Chan11
        count_peaks_sub2(12,i) = sum(locs_sub2_chan12 <= sampleRate_ecog*i); % Chan12
        count_peaks_sub2(13,i) = sum(locs_sub2_chan13 <= sampleRate_ecog*i); % Chan13
        count_peaks_sub2(14,i) = sum(locs_sub2_chan14 <= sampleRate_ecog*i); % Chan14
        count_peaks_sub2(15,i) = sum(locs_sub2_chan15 <= sampleRate_ecog*i); % Chan15
        count_peaks_sub2(16,i) = sum(locs_sub2_chan16 <= sampleRate_ecog*i); % Chan16
        count_peaks_sub2(17,i) = sum(locs_sub2_chan17 <= sampleRate_ecog*i); % Chan17
        count_peaks_sub2(18,i) = sum(locs_sub2_chan18 <= sampleRate_ecog*i); % Chan18
        count_peaks_sub2(19,i) = sum(locs_sub2_chan19 <= sampleRate_ecog*i); % Chan19
        count_peaks_sub2(20,i) = sum(locs_sub2_chan20 <= sampleRate_ecog*i); % Chan20
        count_peaks_sub2(21,i) = sum(locs_sub2_chan21 <= sampleRate_ecog*i);
        count_peaks_sub2(22,i) = sum(locs_sub2_chan22 <= sampleRate_ecog*i);
        count_peaks_sub2(23,i) = sum(locs_sub2_chan23 <= sampleRate_ecog*i);
        count_peaks_sub2(24,i) = sum(locs_sub2_chan24 <= sampleRate_ecog*i);
        count_peaks_sub2(25,i) = sum(locs_sub2_chan25 <= sampleRate_ecog*i);
        count_peaks_sub2(26,i) = sum(locs_sub2_chan26 <= sampleRate_ecog*i);
        count_peaks_sub2(27,i) = sum(locs_sub2_chan27 <= sampleRate_ecog*i);
        count_peaks_sub2(28,i) = sum(locs_sub2_chan28 <= sampleRate_ecog*i);
        count_peaks_sub2(29,i) = sum(locs_sub2_chan29 <= sampleRate_ecog*i);
        count_peaks_sub2(30,i) = sum(locs_sub2_chan30 <= sampleRate_ecog*i);
        count_peaks_sub2(31,i) = sum(locs_sub2_chan31 <= sampleRate_ecog*i);
        count_peaks_sub2(32,i) = sum(locs_sub2_chan32 <= sampleRate_ecog*i);
        count_peaks_sub2(33,i) = sum(locs_sub2_chan33 <= sampleRate_ecog*i);
        count_peaks_sub2(34,i) = sum(locs_sub2_chan34 <= sampleRate_ecog*i);
        count_peaks_sub2(35,i) = sum(locs_sub2_chan35 <= sampleRate_ecog*i);
        count_peaks_sub2(36,i) = sum(locs_sub2_chan36 <= sampleRate_ecog*i);
        count_peaks_sub2(37,i) = sum(locs_sub2_chan37 <= sampleRate_ecog*i);
        count_peaks_sub2(38,i) = sum(locs_sub2_chan38 <= sampleRate_ecog*i);
        count_peaks_sub2(39,i) = sum(locs_sub2_chan39 <= sampleRate_ecog*i);
        count_peaks_sub2(40,i) = sum(locs_sub2_chan40 <= sampleRate_ecog*i);
        count_peaks_sub2(41,i) = sum(locs_sub2_chan41 <= sampleRate_ecog*i);
        count_peaks_sub2(42,i) = sum(locs_sub2_chan42 <= sampleRate_ecog*i);
        count_peaks_sub2(43,i) = sum(locs_sub2_chan43 <= sampleRate_ecog*i);
        count_peaks_sub2(44,i) = sum(locs_sub2_chan44 <= sampleRate_ecog*i);
        count_peaks_sub2(45,i) = sum(locs_sub2_chan45 <= sampleRate_ecog*i);
        count_peaks_sub2(46,i) = sum(locs_sub2_chan46 <= sampleRate_ecog*i);
        count_peaks_sub2(47,i) = sum(locs_sub2_chan47 <= sampleRate_ecog*i);
        count_peaks_sub2(48,i) = sum(locs_sub2_chan48 <= sampleRate_ecog*i);
%         count_peaks_sub2(49,i) = sum(locs_sub2_chan49 <= sampleRate_ecog*i);
%         count_peaks_sub2(50,i) = sum(locs_sub2_chan50 <= sampleRate_ecog*i);
%         count_peaks_sub2(51,i) = sum(locs_sub2_chan51 <= sampleRate_ecog*i);
%         count_peaks_sub2(52,i) = sum(locs_sub2_chan52 <= sampleRate_ecog*i);
%         count_peaks_sub2(53,i) = sum(locs_sub2_chan53 <= sampleRate_ecog*i);
%         count_peaks_sub2(54,i) = sum(locs_sub2_chan54 <= sampleRate_ecog*i);
%         count_peaks_sub2(55,i) = sum(locs_sub2_chan55 <= sampleRate_ecog*i);
%         count_peaks_sub2(56,i) = sum(locs_sub2_chan56 <= sampleRate_ecog*i);
%         count_peaks_sub2(57,i) = sum(locs_sub2_chan57 <= sampleRate_ecog*i);
%         count_peaks_sub2(58,i) = sum(locs_sub2_chan58 <= sampleRate_ecog*i);
%         count_peaks_sub2(59,i) = sum(locs_sub2_chan59 <= sampleRate_ecog*i);
%         count_peaks_sub2(60,i) = sum(locs_sub2_chan60 <= sampleRate_ecog*i);
%         count_peaks_sub2(61,i) = sum(locs_sub2_chan61 <= sampleRate_ecog*i);
%         count_peaks_sub2(62,i) = sum(locs_sub2_chan62 <= sampleRate_ecog*i);
    else
        count_peaks_sub2(1,i) = sum(locs_sub2_chan1 <= sampleRate_ecog*i) - sum(locs_sub2_chan1 <= sampleRate_ecog*(i-1)); % Chan1
        count_peaks_sub2(2,i) = sum(locs_sub2_chan2 <= sampleRate_ecog*i) - sum(locs_sub2_chan2 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(3,i) = sum(locs_sub2_chan3 <= sampleRate_ecog*i) - sum(locs_sub2_chan3 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(4,i) = sum(locs_sub2_chan4 <= sampleRate_ecog*i) - sum(locs_sub2_chan4 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(5,i) = sum(locs_sub2_chan5 <= sampleRate_ecog*i) - sum(locs_sub2_chan5 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(6,i) = sum(locs_sub2_chan6 <= sampleRate_ecog*i) - sum(locs_sub2_chan6 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(7,i) = sum(locs_sub2_chan7 <= sampleRate_ecog*i) - sum(locs_sub2_chan7 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(8,i) = sum(locs_sub2_chan8 <= sampleRate_ecog*i) - sum(locs_sub2_chan8 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(9,i) = sum(locs_sub2_chan9 <= sampleRate_ecog*i) - sum(locs_sub2_chan9 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub2(10,i) = sum(locs_sub2_chan10 <= sampleRate_ecog*i) - sum(locs_sub2_chan10 <= sampleRate_ecog*(i-1)); % Chan10
        count_peaks_sub2(11,i) = sum(locs_sub2_chan11 <= sampleRate_ecog*i) - sum(locs_sub2_chan11 <= sampleRate_ecog*(i-1)); % Chan11
        count_peaks_sub2(12,i) = sum(locs_sub2_chan12 <= sampleRate_ecog*i) - sum(locs_sub2_chan12 <= sampleRate_ecog*(i-1)); % Chan12
        count_peaks_sub2(13,i) = sum(locs_sub2_chan13 <= sampleRate_ecog*i) - sum(locs_sub2_chan13 <= sampleRate_ecog*(i-1)); % Chan13
        count_peaks_sub2(14,i) = sum(locs_sub2_chan14 <= sampleRate_ecog*i) - sum(locs_sub2_chan14 <= sampleRate_ecog*(i-1)); % Chan14
        count_peaks_sub2(15,i) = sum(locs_sub2_chan15 <= sampleRate_ecog*i) - sum(locs_sub2_chan15 <= sampleRate_ecog*(i-1)); % Chan15
        count_peaks_sub2(16,i) = sum(locs_sub2_chan16 <= sampleRate_ecog*i) - sum(locs_sub2_chan16 <= sampleRate_ecog*(i-1)); % Chan16
        count_peaks_sub2(17,i) = sum(locs_sub2_chan17 <= sampleRate_ecog*i) - sum(locs_sub2_chan17 <= sampleRate_ecog*(i-1)); % Chan17
        count_peaks_sub2(18,i) = sum(locs_sub2_chan18 <= sampleRate_ecog*i) - sum(locs_sub2_chan18 <= sampleRate_ecog*(i-1)); % Chan18
        count_peaks_sub2(19,i) = sum(locs_sub2_chan19 <= sampleRate_ecog*i) - sum(locs_sub2_chan19 <= sampleRate_ecog*(i-1)); % Chan19
        count_peaks_sub2(20,i) = sum(locs_sub2_chan20 <= sampleRate_ecog*i) - sum(locs_sub2_chan20 <= sampleRate_ecog*(i-1)); % Chan20
        count_peaks_sub2(21,i) = sum(locs_sub2_chan21 <= sampleRate_ecog*i) - sum(locs_sub2_chan21 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(22,i) = sum(locs_sub2_chan22 <= sampleRate_ecog*i) - sum(locs_sub2_chan22 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(23,i) = sum(locs_sub2_chan23 <= sampleRate_ecog*i) - sum(locs_sub2_chan23 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(24,i) = sum(locs_sub2_chan24 <= sampleRate_ecog*i) - sum(locs_sub2_chan24 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(25,i) = sum(locs_sub2_chan25 <= sampleRate_ecog*i) - sum(locs_sub2_chan25 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(26,i) = sum(locs_sub2_chan26 <= sampleRate_ecog*i) - sum(locs_sub2_chan26 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(27,i) = sum(locs_sub2_chan27 <= sampleRate_ecog*i) - sum(locs_sub2_chan27 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(28,i) = sum(locs_sub2_chan28 <= sampleRate_ecog*i) - sum(locs_sub2_chan28 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(29,i) = sum(locs_sub2_chan29 <= sampleRate_ecog*i) - sum(locs_sub2_chan29 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(30,i) = sum(locs_sub2_chan30 <= sampleRate_ecog*i) - sum(locs_sub2_chan30 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub2(31,i) = sum(locs_sub2_chan31 <= sampleRate_ecog*i) - sum(locs_sub2_chan31 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(32,i) = sum(locs_sub2_chan32 <= sampleRate_ecog*i) - sum(locs_sub2_chan32 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(33,i) = sum(locs_sub2_chan33 <= sampleRate_ecog*i) - sum(locs_sub2_chan33 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(34,i) = sum(locs_sub2_chan34 <= sampleRate_ecog*i) - sum(locs_sub2_chan34 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(35,i) = sum(locs_sub2_chan35 <= sampleRate_ecog*i) - sum(locs_sub2_chan35 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(36,i) = sum(locs_sub2_chan36 <= sampleRate_ecog*i) - sum(locs_sub2_chan36 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(37,i) = sum(locs_sub2_chan37 <= sampleRate_ecog*i) - sum(locs_sub2_chan37 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(38,i) = sum(locs_sub2_chan38 <= sampleRate_ecog*i) - sum(locs_sub2_chan38 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(39,i) = sum(locs_sub2_chan39 <= sampleRate_ecog*i) - sum(locs_sub2_chan39 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(40,i) = sum(locs_sub2_chan40 <= sampleRate_ecog*i) - sum(locs_sub2_chan40 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(41,i) = sum(locs_sub2_chan41 <= sampleRate_ecog*i) - sum(locs_sub2_chan41 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(42,i) = sum(locs_sub2_chan42 <= sampleRate_ecog*i) - sum(locs_sub2_chan42 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(43,i) = sum(locs_sub2_chan43 <= sampleRate_ecog*i) - sum(locs_sub2_chan43 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(44,i) = sum(locs_sub2_chan44 <= sampleRate_ecog*i) - sum(locs_sub2_chan44 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(45,i) = sum(locs_sub2_chan45 <= sampleRate_ecog*i) - sum(locs_sub2_chan45 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(46,i) = sum(locs_sub2_chan46 <= sampleRate_ecog*i) - sum(locs_sub2_chan46 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(47,i) = sum(locs_sub2_chan47 <= sampleRate_ecog*i) - sum(locs_sub2_chan47 <= sampleRate_ecog*(i-1));
        count_peaks_sub2(48,i) = sum(locs_sub2_chan48 <= sampleRate_ecog*i) - sum(locs_sub2_chan48 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(49,i) = sum(locs_sub2_chan49 <= sampleRate_ecog*i) - sum(locs_chan49 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(50,i) = sum(locs_sub2_chan50 <= sampleRate_ecog*i) - sum(locs_chan50 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(51,i) = sum(locs_sub2_chan51 <= sampleRate_ecog*i) - sum(locs_chan51 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(52,i) = sum(locs_sub2_chan52 <= sampleRate_ecog*i) - sum(locs_chan52 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(53,i) = sum(locs_sub2_chan53 <= sampleRate_ecog*i) - sum(locs_chan53 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(54,i) = sum(locs_sub2_chan54 <= sampleRate_ecog*i) - sum(locs_chan54 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(55,i) = sum(locs_sub2_chan55 <= sampleRate_ecog*i) - sum(locs_chan55 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(56,i) = sum(locs_sub2_chan56 <= sampleRate_ecog*i) - sum(locs_chan56 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(57,i) = sum(locs_sub2_chan57 <= sampleRate_ecog*i) - sum(locs_chan57 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(58,i) = sum(locs_sub2_chan58 <= sampleRate_ecog*i) - sum(locs_chan58 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(59,i) = sum(locs_sub2_chan59 <= sampleRate_ecog*i) - sum(locs_chan59 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(60,i) = sum(locs_sub2_chan60 <= sampleRate_ecog*i) - sum(locs_chan60 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(61,i) = sum(locs_chan61 <= sampleRate_ecog*i) - sum(locs_chan61 <= sampleRate_ecog*(i-1));
%         count_peaks_sub2(62,i) = sum(locs_chan62 <= sampleRate_ecog*i) - sum(locs_chan62 <= sampleRate_ecog*(i-1));
    end
    i
end


figure();
imagesc(count_peaks_sub2);
colorbar
title('EEG Peaks Over Time - Subject 2')
xlabel('Time Bin #')
ylabel('Neuron #')
yticks([1:48])












































































%% Determining Optimal Channels - Subject 3
datasetID = 'I521_Sub3_Training_ecog'; %64 channels
num_channels = 64;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_sub3_ecog, numberOfSamples_sub3_ecog, sampleRate_sub3_ecog, data_sub3_ecog_train, time_sub3_ecog, session_sub3_ecog] = getData(datasetID,num_channels,portionOfSamples);


%% load hand data from Subject 3
datasetID = 'I521_Sub3_Training_dg'; % 5 channels
num_channels = 5;
portionOfSamples = 1.0; % use only 50percent of samples
[duration_sub3_dg, numberOfSamples_sub3_dg, sampleRate_sub3_dg, data_sub3_dg_train, time_sub3_dg, session_sub3_dg] = getData(datasetID,num_channels,portionOfSamples);

%%
[pks_sub3_chan1,locs_sub3_chan1] = findpeaks(normalize(data_sub3_ecog_train(:,1)));
[pks_sub3_chan2,locs_sub3_chan2] = findpeaks(normalize(data_sub3_ecog_train(:,2)));
[pks_sub3_chan3,locs_sub3_chan3] = findpeaks(normalize(data_sub3_ecog_train(:,3)));
[pks_sub3_chan4,locs_sub3_chan4] = findpeaks(normalize(data_sub3_ecog_train(:,4)));
[pks_sub3_chan5,locs_sub3_chan5] = findpeaks(normalize(data_sub3_ecog_train(:,5)));
[pks_sub3_chan6,locs_sub3_chan6] = findpeaks(normalize(data_sub3_ecog_train(:,6)));
[pks_sub3_chan7,locs_sub3_chan7] = findpeaks(normalize(data_sub3_ecog_train(:,7)));
[pks_sub3_chan8,locs_sub3_chan8] = findpeaks(normalize(data_sub3_ecog_train(:,8)));
[pks_sub3_chan9,locs_sub3_chan9] = findpeaks(normalize(data_sub3_ecog_train(:,9)));
[pks_sub3_chan10,locs_sub3_chan10] = findpeaks(normalize(data_sub3_ecog_train(:,10)));
[pks_sub3_chan11,locs_sub3_chan11] = findpeaks(normalize(data_sub3_ecog_train(:,11)));
[pks_sub3_chan12,locs_sub3_chan12] = findpeaks(normalize(data_sub3_ecog_train(:,12)));
[pks_sub3_chan13,locs_sub3_chan13] = findpeaks(normalize(data_sub3_ecog_train(:,13)));
[pks_sub3_chan14,locs_sub3_chan14] = findpeaks(normalize(data_sub3_ecog_train(:,14)));
[pks_sub3_chan15,locs_sub3_chan15] = findpeaks(normalize(data_sub3_ecog_train(:,15)));
[pks_sub3_chan16,locs_sub3_chan16] = findpeaks(normalize(data_sub3_ecog_train(:,16)));
[pks_sub3_chan17,locs_sub3_chan17] = findpeaks(normalize(data_sub3_ecog_train(:,17)));
[pks_sub3_chan18,locs_sub3_chan18] = findpeaks(normalize(data_sub3_ecog_train(:,18)));
[pks_sub3_chan19,locs_sub3_chan19] = findpeaks(normalize(data_sub3_ecog_train(:,19)));
[pks_sub3_chan20,locs_sub3_chan20] = findpeaks(normalize(data_sub3_ecog_train(:,20)));
[pks_sub3_chan21,locs_sub3_chan21] = findpeaks(normalize(data_sub3_ecog_train(:,21)));
[pks_sub3_chan22,locs_sub3_chan22] = findpeaks(normalize(data_sub3_ecog_train(:,22)));
[pks_sub3_chan23,locs_sub3_chan23] = findpeaks(normalize(data_sub3_ecog_train(:,23)));
[pks_sub3_chan24,locs_sub3_chan24] = findpeaks(normalize(data_sub3_ecog_train(:,24)));
[pks_sub3_chan25,locs_sub3_chan25] = findpeaks(normalize(data_sub3_ecog_train(:,25)));
[pks_sub3_chan26,locs_sub3_chan26] = findpeaks(normalize(data_sub3_ecog_train(:,26)));
[pks_sub3_chan27,locs_sub3_chan27] = findpeaks(normalize(data_sub3_ecog_train(:,27)));
[pks_sub3_chan28,locs_sub3_chan28] = findpeaks(normalize(data_sub3_ecog_train(:,28)));
[pks_sub3_chan29,locs_sub3_chan29] = findpeaks(normalize(data_sub3_ecog_train(:,29)));
[pks_sub3_chan30,locs_sub3_chan30] = findpeaks(normalize(data_sub3_ecog_train(:,30)));
[pks_sub3_chan31,locs_sub3_chan31] = findpeaks(normalize(data_sub3_ecog_train(:,31)));
[pks_sub3_chan32,locs_sub3_chan32] = findpeaks(normalize(data_sub3_ecog_train(:,32)));
[pks_sub3_chan33,locs_sub3_chan33] = findpeaks(normalize(data_sub3_ecog_train(:,33)));
[pks_sub3_chan34,locs_sub3_chan34] = findpeaks(normalize(data_sub3_ecog_train(:,34)));
[pks_sub3_chan35,locs_sub3_chan35] = findpeaks(normalize(data_sub3_ecog_train(:,35)));
[pks_sub3_chan36,locs_sub3_chan36] = findpeaks(normalize(data_sub3_ecog_train(:,36)));
[pks_sub3_chan37,locs_sub3_chan37] = findpeaks(normalize(data_sub3_ecog_train(:,37)));
[pks_sub3_chan38,locs_sub3_chan38] = findpeaks(normalize(data_sub3_ecog_train(:,38)));
[pks_sub3_chan39,locs_sub3_chan39] = findpeaks(normalize(data_sub3_ecog_train(:,39)));
[pks_sub3_chan40,locs_sub3_chan40] = findpeaks(normalize(data_sub3_ecog_train(:,40)));
[pks_sub3_chan41,locs_sub3_chan41] = findpeaks(normalize(data_sub3_ecog_train(:,41)));
[pks_sub3_chan42,locs_sub3_chan42] = findpeaks(normalize(data_sub3_ecog_train(:,42)));
[pks_sub3_chan43,locs_sub3_chan43] = findpeaks(normalize(data_sub3_ecog_train(:,43)));
[pks_sub3_chan44,locs_sub3_chan44] = findpeaks(normalize(data_sub3_ecog_train(:,44)));
[pks_sub3_chan45,locs_sub3_chan45] = findpeaks(normalize(data_sub3_ecog_train(:,45)));
[pks_sub3_chan46,locs_sub3_chan46] = findpeaks(normalize(data_sub3_ecog_train(:,46)));
[pks_sub3_chan47,locs_sub3_chan47] = findpeaks(normalize(data_sub3_ecog_train(:,47)));
[pks_sub3_chan48,locs_sub3_chan48] = findpeaks(normalize(data_sub3_ecog_train(:,48)));
[pks_sub3_chan49,locs_sub3_chan49] = findpeaks(normalize(data_sub3_ecog_train(:,49)));
[pks_sub3_chan50,locs_sub3_chan50] = findpeaks(normalize(data_sub3_ecog_train(:,50)));
[pks_sub3_chan51,locs_sub3_chan51] = findpeaks(normalize(data_sub3_ecog_train(:,51)));
[pks_sub3_chan52,locs_sub3_chan52] = findpeaks(normalize(data_sub3_ecog_train(:,52)));
[pks_sub3_chan53,locs_sub3_chan53] = findpeaks(normalize(data_sub3_ecog_train(:,53)));
[pks_sub3_chan54,locs_sub3_chan54] = findpeaks(normalize(data_sub3_ecog_train(:,54)));
[pks_sub3_chan55,locs_sub3_chan55] = findpeaks(normalize(data_sub3_ecog_train(:,55)));
[pks_sub3_chan56,locs_sub3_chan56] = findpeaks(normalize(data_sub3_ecog_train(:,56)));
[pks_sub3_chan57,locs_sub3_chan57] = findpeaks(normalize(data_sub3_ecog_train(:,57)));
[pks_sub3_chan58,locs_sub3_chan58] = findpeaks(normalize(data_sub3_ecog_train(:,58)));
[pks_sub3_chan59,locs_sub3_chan59] = findpeaks(normalize(data_sub3_ecog_train(:,59)));
[pks_sub3_chan60,locs_sub3_chan60] = findpeaks(normalize(data_sub3_ecog_train(:,60)));
[pks_sub3_chan61,locs_sub3_chan61] = findpeaks(normalize(data_sub3_ecog_train(:,61)));
[pks_sub3_chan62,locs_sub3_chan62] = findpeaks(normalize(data_sub3_ecog_train(:,62)));
[pks_sub3_chan63,locs_sub3_chan63] = findpeaks(normalize(data_sub3_ecog_train(:,63)));
[pks_sub3_chan64,locs_sub3_chan64] = findpeaks(normalize(data_sub3_ecog_train(:,64)));
i
%save('workspace.mat')



%% Setting Up Time  Bins
count_peaks_sub3 = [];
for i = 1:length(time_ecog)/sampleRate_ecog %300 time bins
    if i == 1
        count_peaks_sub3(1,i) = sum(locs_sub3_chan1 <= sampleRate_ecog*i); % Chan1
        count_peaks_sub3(2,i) = sum(locs_sub3_chan2 <= sampleRate_ecog*i); % Chan2
        count_peaks_sub3(3,i) = sum(locs_sub3_chan3 <= sampleRate_ecog*i); % Chan3
        count_peaks_sub3(4,i) = sum(locs_sub3_chan4 <= sampleRate_ecog*i); % Chan4
        count_peaks_sub3(5,i) = sum(locs_sub3_chan5 <= sampleRate_ecog*i); % Chan5
        count_peaks_sub3(6,i) = sum(locs_sub3_chan6 <= sampleRate_ecog*i); % Chan6
        count_peaks_sub3(7,i) = sum(locs_sub3_chan7 <= sampleRate_ecog*i); % Chan7
        count_peaks_sub3(8,i) = sum(locs_sub3_chan8 <= sampleRate_ecog*i); % Chan8
        count_peaks_sub3(9,i) = sum(locs_sub3_chan9 <= sampleRate_ecog*i); % Chan9
        count_peaks_sub3(10,i) = sum(locs_sub3_chan10 <= sampleRate_ecog*i); % Chan10
        count_peaks_sub3(11,i) = sum(locs_sub3_chan11 <= sampleRate_ecog*i); % Chan11
        count_peaks_sub3(12,i) = sum(locs_sub3_chan12 <= sampleRate_ecog*i); % Chan12
        count_peaks_sub3(13,i) = sum(locs_sub3_chan13 <= sampleRate_ecog*i); % Chan13
        count_peaks_sub3(14,i) = sum(locs_sub3_chan14 <= sampleRate_ecog*i); % Chan14
        count_peaks_sub3(15,i) = sum(locs_sub3_chan15 <= sampleRate_ecog*i); % Chan15
        count_peaks_sub3(16,i) = sum(locs_sub3_chan16 <= sampleRate_ecog*i); % Chan16
        count_peaks_sub3(17,i) = sum(locs_sub3_chan17 <= sampleRate_ecog*i); % Chan17
        count_peaks_sub3(18,i) = sum(locs_sub3_chan18 <= sampleRate_ecog*i); % Chan18
        count_peaks_sub3(19,i) = sum(locs_sub3_chan19 <= sampleRate_ecog*i); % Chan19
        count_peaks_sub3(20,i) = sum(locs_sub3_chan20 <= sampleRate_ecog*i); % Chan20
        count_peaks_sub3(21,i) = sum(locs_sub3_chan21 <= sampleRate_ecog*i);
        count_peaks_sub3(22,i) = sum(locs_sub3_chan22 <= sampleRate_ecog*i);
        count_peaks_sub3(23,i) = sum(locs_sub3_chan23 <= sampleRate_ecog*i);
        count_peaks_sub3(24,i) = sum(locs_sub3_chan24 <= sampleRate_ecog*i);
        count_peaks_sub3(25,i) = sum(locs_sub3_chan25 <= sampleRate_ecog*i);
        count_peaks_sub3(26,i) = sum(locs_sub3_chan26 <= sampleRate_ecog*i);
        count_peaks_sub3(27,i) = sum(locs_sub3_chan27 <= sampleRate_ecog*i);
        count_peaks_sub3(28,i) = sum(locs_sub3_chan28 <= sampleRate_ecog*i);
        count_peaks_sub3(29,i) = sum(locs_sub3_chan29 <= sampleRate_ecog*i);
        count_peaks_sub3(30,i) = sum(locs_sub3_chan30 <= sampleRate_ecog*i);
        count_peaks_sub3(31,i) = sum(locs_sub3_chan31 <= sampleRate_ecog*i);
        count_peaks_sub3(32,i) = sum(locs_sub3_chan32 <= sampleRate_ecog*i);
        count_peaks_sub3(33,i) = sum(locs_sub3_chan33 <= sampleRate_ecog*i);
        count_peaks_sub3(34,i) = sum(locs_sub3_chan34 <= sampleRate_ecog*i);
        count_peaks_sub3(35,i) = sum(locs_sub3_chan35 <= sampleRate_ecog*i);
        count_peaks_sub3(36,i) = sum(locs_sub3_chan36 <= sampleRate_ecog*i);
        count_peaks_sub3(37,i) = sum(locs_sub3_chan37 <= sampleRate_ecog*i);
        count_peaks_sub3(38,i) = sum(locs_sub3_chan38 <= sampleRate_ecog*i);
        count_peaks_sub3(39,i) = sum(locs_sub3_chan39 <= sampleRate_ecog*i);
        count_peaks_sub3(40,i) = sum(locs_sub3_chan40 <= sampleRate_ecog*i);
        count_peaks_sub3(41,i) = sum(locs_sub3_chan41 <= sampleRate_ecog*i);
        count_peaks_sub3(42,i) = sum(locs_sub3_chan42 <= sampleRate_ecog*i);
        count_peaks_sub3(43,i) = sum(locs_sub3_chan43 <= sampleRate_ecog*i);
        count_peaks_sub3(44,i) = sum(locs_sub3_chan44 <= sampleRate_ecog*i);
        count_peaks_sub3(45,i) = sum(locs_sub3_chan45 <= sampleRate_ecog*i);
        count_peaks_sub3(46,i) = sum(locs_sub3_chan46 <= sampleRate_ecog*i);
        count_peaks_sub3(47,i) = sum(locs_sub3_chan47 <= sampleRate_ecog*i);
        count_peaks_sub3(48,i) = sum(locs_sub3_chan48 <= sampleRate_ecog*i);
        count_peaks_sub3(49,i) = sum(locs_sub3_chan49 <= sampleRate_ecog*i);
        count_peaks_sub3(50,i) = sum(locs_sub3_chan50 <= sampleRate_ecog*i);
        count_peaks_sub3(51,i) = sum(locs_sub3_chan51 <= sampleRate_ecog*i);
        count_peaks_sub3(52,i) = sum(locs_sub3_chan52 <= sampleRate_ecog*i);
        count_peaks_sub3(53,i) = sum(locs_sub3_chan53 <= sampleRate_ecog*i);
        count_peaks_sub3(54,i) = sum(locs_sub3_chan54 <= sampleRate_ecog*i);
        count_peaks_sub3(55,i) = sum(locs_sub3_chan55 <= sampleRate_ecog*i);
        count_peaks_sub3(56,i) = sum(locs_sub3_chan56 <= sampleRate_ecog*i);
        count_peaks_sub3(57,i) = sum(locs_sub3_chan57 <= sampleRate_ecog*i);
        count_peaks_sub3(58,i) = sum(locs_sub3_chan58 <= sampleRate_ecog*i);
        count_peaks_sub3(59,i) = sum(locs_sub3_chan59 <= sampleRate_ecog*i);
        count_peaks_sub3(60,i) = sum(locs_sub3_chan60 <= sampleRate_ecog*i);
        count_peaks_sub3(61,i) = sum(locs_sub3_chan61 <= sampleRate_ecog*i);
        count_peaks_sub3(62,i) = sum(locs_sub3_chan62 <= sampleRate_ecog*i);
        count_peaks_sub3(63,i) = sum(locs_sub3_chan63 <= sampleRate_ecog*i);
        count_peaks_sub3(64,i) = sum(locs_sub3_chan64 <= sampleRate_ecog*i);
    else
        count_peaks_sub3(1,i) = sum(locs_sub3_chan1 <= sampleRate_ecog*i) - sum(locs_sub3_chan1 <= sampleRate_ecog*(i-1)); % Chan1
        count_peaks_sub3(2,i) = sum(locs_sub3_chan2 <= sampleRate_ecog*i) - sum(locs_sub3_chan2 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(3,i) = sum(locs_sub3_chan3 <= sampleRate_ecog*i) - sum(locs_sub3_chan3 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(4,i) = sum(locs_sub3_chan4 <= sampleRate_ecog*i) - sum(locs_sub3_chan4 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(5,i) = sum(locs_sub3_chan5 <= sampleRate_ecog*i) - sum(locs_sub3_chan5 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(6,i) = sum(locs_sub3_chan6 <= sampleRate_ecog*i) - sum(locs_sub3_chan6 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(7,i) = sum(locs_sub3_chan7 <= sampleRate_ecog*i) - sum(locs_sub3_chan7 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(8,i) = sum(locs_sub3_chan8 <= sampleRate_ecog*i) - sum(locs_sub3_chan8 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(9,i) = sum(locs_sub3_chan9 <= sampleRate_ecog*i) - sum(locs_sub3_chan9 <= sampleRate_ecog*(i-1)); % Chan2
        count_peaks_sub3(10,i) = sum(locs_sub3_chan10 <= sampleRate_ecog*i) - sum(locs_sub3_chan10 <= sampleRate_ecog*(i-1)); % Chan10
        count_peaks_sub3(11,i) = sum(locs_sub3_chan11 <= sampleRate_ecog*i) - sum(locs_sub3_chan11 <= sampleRate_ecog*(i-1)); % Chan11
        count_peaks_sub3(12,i) = sum(locs_sub3_chan12 <= sampleRate_ecog*i) - sum(locs_sub3_chan12 <= sampleRate_ecog*(i-1)); % Chan12
        count_peaks_sub3(13,i) = sum(locs_sub3_chan13 <= sampleRate_ecog*i) - sum(locs_sub3_chan13 <= sampleRate_ecog*(i-1)); % Chan13
        count_peaks_sub3(14,i) = sum(locs_sub3_chan14 <= sampleRate_ecog*i) - sum(locs_sub3_chan14 <= sampleRate_ecog*(i-1)); % Chan14
        count_peaks_sub3(15,i) = sum(locs_sub3_chan15 <= sampleRate_ecog*i) - sum(locs_sub3_chan15 <= sampleRate_ecog*(i-1)); % Chan15
        count_peaks_sub3(16,i) = sum(locs_sub3_chan16 <= sampleRate_ecog*i) - sum(locs_sub3_chan16 <= sampleRate_ecog*(i-1)); % Chan16
        count_peaks_sub3(17,i) = sum(locs_sub3_chan17 <= sampleRate_ecog*i) - sum(locs_sub3_chan17 <= sampleRate_ecog*(i-1)); % Chan17
        count_peaks_sub3(18,i) = sum(locs_sub3_chan18 <= sampleRate_ecog*i) - sum(locs_sub3_chan18 <= sampleRate_ecog*(i-1)); % Chan18
        count_peaks_sub3(19,i) = sum(locs_sub3_chan19 <= sampleRate_ecog*i) - sum(locs_sub3_chan19 <= sampleRate_ecog*(i-1)); % Chan19
        count_peaks_sub3(20,i) = sum(locs_sub3_chan20 <= sampleRate_ecog*i) - sum(locs_sub3_chan20 <= sampleRate_ecog*(i-1)); % Chan20
        count_peaks_sub3(21,i) = sum(locs_sub3_chan21 <= sampleRate_ecog*i) - sum(locs_sub3_chan21 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(22,i) = sum(locs_sub3_chan22 <= sampleRate_ecog*i) - sum(locs_sub3_chan22 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(23,i) = sum(locs_sub3_chan23 <= sampleRate_ecog*i) - sum(locs_sub3_chan23 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(24,i) = sum(locs_sub3_chan24 <= sampleRate_ecog*i) - sum(locs_sub3_chan24 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(25,i) = sum(locs_sub3_chan25 <= sampleRate_ecog*i) - sum(locs_sub3_chan25 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(26,i) = sum(locs_sub3_chan26 <= sampleRate_ecog*i) - sum(locs_sub3_chan26 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(27,i) = sum(locs_sub3_chan27 <= sampleRate_ecog*i) - sum(locs_sub3_chan27 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(28,i) = sum(locs_sub3_chan28 <= sampleRate_ecog*i) - sum(locs_sub3_chan28 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(29,i) = sum(locs_sub3_chan29 <= sampleRate_ecog*i) - sum(locs_sub3_chan29 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(30,i) = sum(locs_sub3_chan30 <= sampleRate_ecog*i) - sum(locs_sub3_chan30 <= sampleRate_ecog*(i-1)); 
        count_peaks_sub3(31,i) = sum(locs_sub3_chan31 <= sampleRate_ecog*i) - sum(locs_sub3_chan31 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(32,i) = sum(locs_sub3_chan32 <= sampleRate_ecog*i) - sum(locs_sub3_chan32 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(33,i) = sum(locs_sub3_chan33 <= sampleRate_ecog*i) - sum(locs_sub3_chan33 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(34,i) = sum(locs_sub3_chan34 <= sampleRate_ecog*i) - sum(locs_sub3_chan34 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(35,i) = sum(locs_sub3_chan35 <= sampleRate_ecog*i) - sum(locs_sub3_chan35 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(36,i) = sum(locs_sub3_chan36 <= sampleRate_ecog*i) - sum(locs_sub3_chan36 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(37,i) = sum(locs_sub3_chan37 <= sampleRate_ecog*i) - sum(locs_sub3_chan37 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(38,i) = sum(locs_sub3_chan38 <= sampleRate_ecog*i) - sum(locs_sub3_chan38 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(39,i) = sum(locs_sub3_chan39 <= sampleRate_ecog*i) - sum(locs_sub3_chan39 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(40,i) = sum(locs_sub3_chan40 <= sampleRate_ecog*i) - sum(locs_sub3_chan40 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(41,i) = sum(locs_sub3_chan41 <= sampleRate_ecog*i) - sum(locs_sub3_chan41 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(42,i) = sum(locs_sub3_chan42 <= sampleRate_ecog*i) - sum(locs_sub3_chan42 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(43,i) = sum(locs_sub3_chan43 <= sampleRate_ecog*i) - sum(locs_sub3_chan43 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(44,i) = sum(locs_sub3_chan44 <= sampleRate_ecog*i) - sum(locs_sub3_chan44 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(45,i) = sum(locs_sub3_chan45 <= sampleRate_ecog*i) - sum(locs_sub3_chan45 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(46,i) = sum(locs_sub3_chan46 <= sampleRate_ecog*i) - sum(locs_sub3_chan46 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(47,i) = sum(locs_sub3_chan47 <= sampleRate_ecog*i) - sum(locs_sub3_chan47 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(48,i) = sum(locs_sub3_chan48 <= sampleRate_ecog*i) - sum(locs_sub3_chan48 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(49,i) = sum(locs_sub3_chan49 <= sampleRate_ecog*i) - sum(locs_sub3_chan49 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(50,i) = sum(locs_sub3_chan50 <= sampleRate_ecog*i) - sum(locs_sub3_chan50 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(51,i) = sum(locs_sub3_chan51 <= sampleRate_ecog*i) - sum(locs_sub3_chan51 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(52,i) = sum(locs_sub3_chan52 <= sampleRate_ecog*i) - sum(locs_sub3_chan52 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(53,i) = sum(locs_sub3_chan53 <= sampleRate_ecog*i) - sum(locs_sub3_chan53 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(54,i) = sum(locs_sub3_chan54 <= sampleRate_ecog*i) - sum(locs_sub3_chan54 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(55,i) = sum(locs_sub3_chan55 <= sampleRate_ecog*i) - sum(locs_sub3_chan55 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(56,i) = sum(locs_sub3_chan56 <= sampleRate_ecog*i) - sum(locs_sub3_chan56 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(57,i) = sum(locs_sub3_chan57 <= sampleRate_ecog*i) - sum(locs_sub3_chan57 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(58,i) = sum(locs_sub3_chan58 <= sampleRate_ecog*i) - sum(locs_sub3_chan58 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(59,i) = sum(locs_sub3_chan59 <= sampleRate_ecog*i) - sum(locs_sub3_chan59 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(60,i) = sum(locs_sub3_chan60 <= sampleRate_ecog*i) - sum(locs_sub3_chan60 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(61,i) = sum(locs_sub3_chan61 <= sampleRate_ecog*i) - sum(locs_sub3_chan61 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(62,i) = sum(locs_sub3_chan62 <= sampleRate_ecog*i) - sum(locs_sub3_chan62 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(63,i) = sum(locs_sub3_chan63 <= sampleRate_ecog*i) - sum(locs_sub3_chan63 <= sampleRate_ecog*(i-1));
        count_peaks_sub3(64,i) = sum(locs_sub3_chan64 <= sampleRate_ecog*i) - sum(locs_sub3_chan64 <= sampleRate_ecog*(i-1));
    end
    i
end


figure();
imagesc(count_peaks_sub3);
colorbar
title('EEG Peaks Over Time - Subject 3')
xlabel('Time Bin #')
ylabel('Neuron #')
yticks([1:64])


































%% Locating Optimal Electrodes
x = reshape(data_sub1_ecog_train,20,62)'; %62 electrodes
imagesc(x)
colorbar






%% Create a matrix which contains the number of spikes fired in time bins of 70ms for each of the 62 neurons
sample_70ms = find(time >= 0.07);
count_spikes = 0;
threshold = 0;

for i = 1:length(data_sub1_dg_train)
    if data_sub1_dg_train(i) >= threshold
        count_spikes = count_spikes + 1;
    end
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

function x_interpolated = zoInterp(x,numInterp)
    x_interpolated = [];
    x_interpolated = repmat(x,numInterp,1); % numInterp x 1 array, each cell contains x, interpolates signal
    [m n] = size(x_interpolated);
    x_interpolated = reshape(x_interpolated,m*n,1); % concatenates all of the interpolated data points
end

function [duration_Sec, numberOfSamples, sampling_rate, data, time, session] = getData(datasetID, channels, portionOfSamples)
    %channels = 11; %%%%%%%% Can only get 22 channels
    session = IEEGSession(datasetID, 'rpierson', 'rpi_ieeglogin.bin')  
    session.openDataSet(datasetID); % Select Dataset
    duration_uSec = session.data(1).rawChannels(1).get_tsdetails.getDuration; 
    duration_Sec = duration_uSec / 10^6;
    sampling_rate = session.data.sampleRate; % Calculate sampling rate of data
    numberOfSamples = ceil(duration_Sec * sampling_rate)+1;
    data = session.data.getvalues(1:numberOfSamples*portionOfSamples,1:channels);
    sampleIndex = [1:1:numberOfSamples]';
    samplingInterval_uSec = duration_uSec / numberOfSamples;
    samplingInterval_Sec = duration_Sec / numberOfSamples;
    time = sampleIndex/sampling_rate;
end