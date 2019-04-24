clc
clearvars -except
close all

%% Step 0: Load in data

% session = IEEGSession('I521_Sub3_Leaderboard_ecog','Luke Jungmann','Luk_ieeglogin.bin');
% nr = ceil((session.data.rawChannels(1).get_tsdetails.getEndTime)/1e6*session.data.sampleRate);
% test_ecog_3 = session.data.getvalues(1:320000, 1:length(session.data.rawChannels));
% remove_pos = find(isnan(test_ecog_3(:, 1)), 1, 'first');
% test_ecog_3 = test_ecog_3(1:remove_pos-1, :);
% save('data/test_ecog_3.mat', 'test_ecog_3')

testing = false;
show_plots = false;
post_process = true;

load('data/train_ecog_1.mat')
load('data/train_dg_1.mat')
load('data/test_ecog_1.mat')

load('data/train_ecog_2.mat')
load('data/train_dg_2.mat')
load('data/test_ecog_2.mat')

load('data/train_ecog_3.mat')
load('data/train_dg_3.mat')
load('data/test_ecog_3.mat')


ecog_sets = {train_ecog_1, train_ecog_2, train_ecog_3};
dg_sets = {train_dg_1, train_dg_2, train_dg_3};
test_sets = {test_ecog_1, test_ecog_2, test_ecog_3};

for set = 1:3
    fprintf('Getting features for person %d\n', set)
    if testing == false            
        ecog_train = ecog_sets{set};
        dg_train = dg_sets{set};
        ecog_test = test_sets{set};
        predicted_dg{set} = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, testing);

    else
        ecog_full = ecog_sets{set};
        
        n_cross = 10;
        percent_data = 0.1;
        all_pos = linspace(0, size(ecog_full, 1)*percent_data, n_cross + 1);
        shift = [all_pos(length(all_pos)), all_pos(1: length(all_pos) - 1)];
        stack = [shift; all_pos];
        stack = stack(:, 2 : n_cross + 1);
        fullset = 1:size(ecog_full, 1)*percent_data;
        
        for pc = 1:n_cross
            fprintf('Getting accuracy for cross-validation %d\n', pc)
            p1 = stack(1, pc)+1;
            p2 = stack(2, pc);
            train_pos = fullset(~ismember(fullset, p1:p2));
            test_pos = p1:p2;
            
            ecog_train = ecog_sets{set}(train_pos, :);
            dg_train = dg_sets{set}(train_pos, :);
            ecog_test = ecog_sets{set}(test_pos, :);
            accuracy = AllSteps(ecog_train, dg_train, ecog_test, show_plots, post_process, set, testing);
            fprintf('Accuracy: %.3d\n', accuracy)
        end
    end
end

if testing == false
    disp('Finished! Outputting predicted_dg');
    save('predicted_dg.mat', 'predicted_dg'); 
end



