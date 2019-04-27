function [output] = Step4Interpolation(dg_test_vals, Y_in, ecog_test, fingerFeats, show_plots, post_process)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Run through each finger
	disp('Interpolating the finger positions')
	for i = 1:5
		y = Y_in(:, i); % Get y value of finger
		x = 1:length(y); % Get x values of finger
		xq = (1:(0.050*1000*(length(y)+3)))/(0.05*1000); % Interp vals
		sp(i, :) = spline(x,y,xq); % Generate Spline
		
		if show_plots == true
			store_sp = sp(i, :); 
			figure()
			plot(store_sp)
			hold on
		end

		%% Post-process
		if post_process == true
			sp(i, :) = Step4Postprocess(sp(i, :), fingerFeats, i);
		end
	end
	output = sp(:, 1:size(ecog_test, 1))';
end

