clc
clearvars -except test
close all

%% This will be the main code

winLen = 0.1; %s
winDisp = 0.05; %s
[LL_data, A, E, ZX, t_int] = MovingWinFeats(s_plot, sampleRate, winLen, winDisp, LLFn);
LL_data_int = zoInterp(LL_data,sampleRate);
space = length(s_plot) - length(LL_data_int);
time = ((0:length(LL_data_int)-1) + space)/sampleRate;
s_time = (0:length(s_plot)-1)/sampleRate;

LL_data_norm = 2 * LL_data_int / (max(LL_data_int) / max(s_plot));
