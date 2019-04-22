function [times] = averageMovementTime(vals)

winLen = 2; %s
winDisp = 1; %s
LLFn = @(x) sum(abs(diff(x)));
% LLFn = @(x) mean(x);
sampleRate = 1000; %samples/s
ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

[LL, freq_mag, A, E, ZX, t_int] = MovingWinFeats(vals, sampleRate, winLen, winDisp, LLFn, ranges);

[pks,locs,w,p] = findpeaks(LL, 2, 'MinPeakProminence', max(LL)/2);

times = mean(w) * winLen * sampleRate;

end

