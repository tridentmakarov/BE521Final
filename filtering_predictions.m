%% Simple Method Step 2 - decimate
clear accuracy_pred
clear accuracy_pred_filt
clear accuracy_pred_filt_norm

% Filtering Predictions - finding corr() when filtering windowSize is 1:30
for j = 1:30
    for i = 1:5
        f = floor((length(train_dg_1(:,i))/length(new_X1)));
        downsampled_Sub1_dg_data = decimate(train_dg_1(:,i),f);
        adjusted_downsample1 = downsampled_Sub1_dg_data(1:length(new_X1));

        feat_i1 = mldivide(new_X1'*new_X1,new_X1'*adjusted_downsample1); % coefficients via HW7 
        feat_u1 = new_X1*feat_i1; % dg predictions
        predictions = feat_u1;

        windowSize = j;
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        predictions_filtfilt = filtfilt(b,a,predictions);
        windowSize2 = 75;
        b2 = (1/windowSize2)*ones(1,windowSize2);
        a2 = 1;
        predictions_filtfilt2 = filtfilt(b2,a2,predictions);


        %figure;
        plot(feat_u1)
        hold on
        plot(adjusted_downsample1)
        hold off
        title('Predicted vs Actual')
        legend('Predicted', 'Actual')
        accuracy_pred(i,j) = corr(predictions, adjusted_downsample1);
        accuracy_pred_filt(i,j) = corr(predictions_filtfilt, adjusted_downsample1);
        accuracy_pred_filt_norm(i,j) = corr(predictions_filtfilt2, adjusted_downsample1);
        %i
    end
     accuracy_pred
     accuracy_pred_filt
%     accuracy_pred_filt_norm
    j
end
%% plot comparison
close all
figure();
clear pk
clear loc
%hold on
%plot(accuracy_pred
for i = 1:5
    subplot(5,1,i)
    hold on
    plot([0 30],[accuracy_pred(i,1) accuracy_pred(i,1)],'--','linewidth',2,'color',[1 0 0])
    plot(accuracy_pred_filt(i,:),'linewidth',2,'color',[0 0 1])
    pk = max(accuracy_pred_filt(i,:))
    loc = find(accuracy_pred_filt(i,:) >= pk)
    plot(loc,pk,'*','color',[0 0 0])
    plot([loc loc], [min(accuracy_pred_filt(i,:)) pk],'--','linewidth',2,'color',[0 0 0])
    title(strcat('Subject 1 - Finding Optimal Window Size for filtfilt() - Finger ',num2str(i)))
    %title(strcat('Maximum = ',num2str(accuracy_pred(i,1)))
    ylabel('Correlation')
    xlabel('Window Size of filtfilt()')
    grid on
    legend(strcat('Corr() of Predictions = ',num2str(accuracy_pred(i,1))),'Corr() of Filtered Predictions',strcat('Maximum = ',num2str(pk)), strcat('Window Size = ',num2str(loc)),'location','eastoutside')
    ylim([min(accuracy_pred_filt(i,:)) max(accuracy_pred_filt(i,:))])
end