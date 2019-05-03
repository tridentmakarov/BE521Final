function [output] = Step4Interpolation(dg_train, Y_in, Y_compare, train_binary, test_binary, ecog_test, fingerFeats, show_plots, post_process, set)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Run through each finger
	disp('Interpolating the finger positions')
	
	for i = 1:5
		y = Y_in(:, i); % Get y value of finger
		y_c = Y_compare(:, i); % Get y value of finger
		x = 1:length(y); % Get x values of finger
		x_c = 1:length(y_c); % Get x values of finger
		xq = (1:(0.050*1000*(length(y)+3)))/(0.05*1000);
		xq_c = (1:(0.050*1000*(length(y_c)+3)))/(0.05*1000);
		sp(i, :) = spline(x,y,xq); % Spline
		sp_c(i, :) = spline(x_c,y_c,xq_c); % Spline
		sp_store = sp(i, :);

		%% Post-process
		if post_process == true
			sp(i, :) = Step4Postprocess(0,sp(i, :),	fingerFeats, i, test_binary{i}, set);
			sp_c(i, :) = Step4Postprocess(dg_train(:, i), sp_c(i, :), fingerFeats, i, train_binary{i}, set);
% 			sp(i, :) = Step4PostprocessSVD(0, sp(i, :), fingerFeats, i, test_binary{i});
% 			sp_c(i, :) = Step4PostprocessSVD(dg_train(:, i), sp_c(i, :), fingerFeats, i, train_binary(:, i));
		end
		
		train_corr(i) = corr(sp_c(i, 1:size(dg_train, 1))', dg_train(:, i));
		fprintf('Correlation for finger %d: %.2f\n', i, train_corr(i))
		
		%% Plot
		if show_plots == true % Run if testing
			figure()
			hold on
% 			plot(sp_c_store)
% 			subplot(1, 5, i)
			plot(sp_store)
			plot(sp(i, :), '--');
% 			legend('before PP', 'calculated', 'actual')
			legend('before', 'after')
			hold off
			pause(0.1)
		end
	end
	
	%% Outputs
	predicted_dg = sp(:, 1:size(ecog_test, 1))';
	output = predicted_dg;
	fprintf('Average correlation for all fingers: %.2f\n', mean(train_corr))
end

