predictions_filtfilt = filter_predictions(predicted_dg);

figure()
hold on
plot(predicted_dg{1,1}(:,1),'linewidth',2)
plot(predictions_filtfilt{1,1}(:,1),'linewidth',3)
legend('Predictions','Filtered Predictions')


%%
function [predictions_filtfilt] = filter_predictions(predicted_dg)
    clear predictions_filtfilt
    predictions_filtfilt = [];
    for i = 1:3
        for j = 1:5
            windowSize = 1000;
            b = (1/windowSize)*ones(1,windowSize);
            a = 1;
            predictions_filtfilt{1,i}(:,j) = filtfilt(b,a,predicted_dg{1,i}(:,j));
        end
    end
end

predicted_dg = predictions_filtfilt;
save('filtered_predictions_Apr23.mat','predicted_dg')


