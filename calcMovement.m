function [output] = calcMovement(sp, fingerFeats, f_i)

times = fingerFeats.move_times(f_i);
peak = fingerFeats.finger_peaks(f_i);
offset = fingerFeats.finger_offset(f_i);
vari = fingerFeats.finger_variability(f_i);
n_peaks = fingerFeats.n_peaks(f_i);


stored_plot = sp;
barrier = 2;
avg_time = round(mean(times));


% [vals,locs] = findpeaks(sp, 1, 'MinPeakProminence', std(sp)*2);
dev = std(sp);

winLen = 2; %s
winDisp = 1; %s
sampleRate = 1000; %samples/s
ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];

[~, ~, M] = MovingWinFeats(sp, sampleRate, winLen, winDisp, ranges);
[~,locations] = findpeaks(M, 1, 'MinPeakProminence', std(M)*2);
% findpeaks(LL, 1, 'MinPeakProminence', std(LL)*2);

locations = locations * 1000;
locations(locations < 1) = 1;

% plot_locs = [];
% for i = 1:length(locations)
% 	plot_locs = [plot_locs, locations(i):locations(i) + times];
% end
% 
% figure()
% plot(sp)
% hold on
% plot(plot_locs, sp(plot_locs), 'or')
% hold off

sp(sp > mean(sp) + 4 * std(sp)) = mean(sp);
sp(sp < mean(sp) - 4 * std(sp)) = mean(sp);

for i = 1:length(locations)
	loc = locations(i);
	if loc + avg_time > length(sp)
		peaks_max(i) = max(sp(loc:length(sp)));
	else
		peaks_max(i) = max(sp(loc:loc + avg_time));
	end
end

% plot(sp)
% hold on
% plot(locations, values, 'or')
% hold off

% total_avg = mean(peaks_max);
% for i = 1:length(locations)
% 	locate = locations(i);
% end

peak_ratio = peak / mean(peaks_max);
m_val = vari/dev/3;

low_pos = 1:length(sp);
for i = 1:length(locations)
	high_pos(i, :) = locations(i):locations(i) + avg_time;
end
[r, c] = size(high_pos);
high_pos = reshape(high_pos, [], r*c);
high_pos(high_pos > length(sp)) = [];
low_pos(high_pos) = [];

windowSize1 = 500; % TEST
% windowSize2 = 200; % TEST
b1 = (1/windowSize1)*ones(1,windowSize1);
% b2 = (1/windowSize2)*ones(1,windowSize2);
a = 1;

sp(low_pos) = sp(low_pos) * m_val + offset;
sp(low_pos) = filtfilt(b1,a,sp(low_pos));
sp(high_pos) = sp(high_pos) * peak_ratio;
% sp(high_pos) = filtfilt(b2,a,sp(high_pos));

plot(stored_plot)
hold on
plot(sp)
legend('unfiltered, filtered')
hold off

output = sp;

end

