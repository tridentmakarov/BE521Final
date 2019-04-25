function [output] = Step4Interpolation(true_Y, Y_in, ecog_test, fingerFeats, show_plots, post_process, cross_validating)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Run through each finger
	disp('Interpolating the finger positions')
	for i = 1:5
		y = Y_in(:, i); % Get y value of finger
		x = 1:length(y); % Get x values of finger
		xq = (1:(0.050*1000*(length(y)+3)))/(0.05*1000);
		sp(i, :) = spline(x,y,xq); % Spline
		store_sp = sp(i, :);
		figure()
		plot(store_sp)
		hold on

		%% Post-process
		if post_process == true
			sp(i, :) = calcMovement(sp(i, :), fingerFeats, i);
		end
		if cross_validating == true
			c(i) = corr(sp(i, :)', true_Y(1:length(sp(i, :)), i));
		end 
		%% Plot
		if show_plots == true % Run if testing

			plot(sp(i, :))
			plot(true_Y(1:length(sp(i, :)), i), '--');
			legend('original', 'calculated', 'actual')
			hold off
		end
	end
	if cross_validating == false
		predicted_dg = sp(:, 1:size(ecog_test, 1))';
		output = predicted_dg;
	else
		output = mean(c);
	end
end

