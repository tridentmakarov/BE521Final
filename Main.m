clc
clearvars -except train_mini_ecog train_mini_dg
close all

%% This will be the main code

load('train_mini_ecog.mat')
load('train_mini_dg.mat')

% remove_samples = 0.04 * 1000;
times = linspace(0, size(train_mini_dg, 1)*1000/1E6, size(train_mini_dg, 1))';

winLen = 0.1; %s
winDisp = 0.05; %s
% LLFn = @(x) sum(abs(diff(x)));
LLFn = @(x) mean(x);
sampleRate = 1000; %samples/s

for i = 1:size(train_mini_ecog, 2)
	
	set = train_mini_ecog(:, i);
	
	[LL_data, A, E, ZX, t_int] = MovingWinFeats(set, sampleRate, winLen, winDisp, LLFn);
% 	LL_data_int = zoInterp(LL_data, 3000);
% 	LL_data_norm(:, i) = (2 * LL_data_int / (max(LL_data_int) / max(set)))';
	
% 	times = linspace(0, length(LL_data_norm) * 1000/1E6, length(LL_data_norm))';
	
end

% for i = 1:5
% 	temp = decimate(train_mini_dg(:, i), 50);
% 	dg(:, i) = temp(4:length(temp));
% end
fs = 1000;
spectrogram(train_mini_ecog(:, 1),100,50,fs,'yaxis');
[s, f, t] = spectrogram(train_mini_ecog(:, 1),100,50,fs,'yaxis');
f = f/pi*180;
mean(s)