function output = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, testing)
%% Step 1: Get features

filename_train = sprintf('features_train_%d.mat', set);
filename_test = sprintf('features_test_%d.mat', set);


if ~isfile(filename_train) || ~isfile(filename_test) || testing == true
    features_train = getFeatures(ecog_train);
    features_test = getFeatures(ecog_test);
    
    if testing == false
        fprintf('Saving files: %s and %s\n', filename_train, filename_test);
        save(filename_train, 'features_train');
        save(filename_test, 'features_test');
    end
else
    load(filename_train);
    load(filename_test);
end

%% Step 2: Decimate
disp('Decimating')
for i = 1:5
    [move_times(i), finger_peaks(i) finger_offset(i), finger_variability(i)] = getFingerFeats(dg_train(:, i)); % Get times
    temp = decimate(dg_train(:, i), 50); % Decimate to get Y matrix
    Y(:, i) = temp(3:length(temp)-3); % Remove value
end

%% Step 3: Linear regression
disp('Performing regression')
datasets = {features_train, features_test};

for k = 1:2
    fprintf('Calculating X for set %d\n', k)
    dataset = datasets{k}; % Easier using cell array, get data

    M = size(dataset, 1); % Timepoints
    N = 5; % Time Bins
    v = size(dataset, 2); % Neurons

    rows = M; % Timepoints minus 2 extra time values
    cols = N * size(dataset, 2); % Neurons times features times 3 (for overlap)
    R = zeros(rows - 4, cols); % Create matrix
    one_col = ones(rows-4, 1); % Ones column
    % Run through each neuron (will be something like 62, 44, etc)
    for i = 1 : v
        % Run through each of the timepoints (will be something like 4999)
        for j = 3 : M - 2
            % Get the last three position values, for 150ms lag
            R(j-2, :) = [dataset(j-2, :),  dataset(j-1, :), dataset(j, :), dataset(j+1, :),  dataset(j+2, :)];
        end
    end
    % Add to cell array
    X{k} = [one_col, R];
end

% Create the B matrix
B = mldivide(X{1}' * X{1}, X{1}' * Y);

% Calculate the Y matrix, and pad
Y_out = X{2} * B;
Y_out = [zeros(1, 5); zeros(1, 5); Y_out; zeros(1, 5); zeros(1, 5) ];
% 	Y_testing = X * B;

% Test correlation
% 	correlation = corr(Y_testing(:, 1), Y_train(:, 1));
% 	fprintf('Finger 1 testing correlation of %.2f\n', correlation);


%% Step 4: Interpolation
% Run through each finger
disp('Interpolating the finger positions')
for i = 1:5
    y = Y_out(:, i); % Get y value of finger
    x = 1:length(y); % Get x values of finger
    xq = (1:(0.050*1000*(length(y)+3)))/(0.05*1000);
    sp(i, :) = spline(x,y,xq); % Spline

    %% Post-process
    if post_process == true
        sp(i, :) = calcMovement(sp(i, :), move_times(i), finger_peaks(i), finger_offset(i), finger_variability(i));
    end
    if testing == true
        c(i) = corr(sp(i, :)', dg_train(1:length(sp(i, :)), i));
    end 
    %% Plot
    if show_plots == true % Run if testing

        figure()
        hold on
        plot(sp(i, :))
        plot(dg_train(1:length(sp(i, :)), i), '--');
        legend('calculated', 'actual')
        hold off
    end
end
if testing == false
   predicted_dg = sp(:, 1:size(ecog_test, 1))';
   output = predicted_dg;
else
    output = c;
end
end


