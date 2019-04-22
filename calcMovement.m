function [output] = calcMovement(sp, times)


% winLen = 1; %s
% winDisp = 0.5; %s
% LLFn = @(x) sum(abs(diff(x)));
% % LLFn = @(x) mean(x);
% sampleRate = 1000; %samples/s
% ranges = [5, 15; 20, 25; 75, 115; 125, 160; 160, 175];
% 
% [LL, freq_mag, A, E, ZX, t_int] = MovingWinFeats(sp, sampleRate, winLen, winDisp, LLFn, ranges);
% plot(LL)

output = sp;
barrier = 0.1;
avg_time = round(mean(times));

% plot(sp)
findpeaks(sp, 1, 'MinPeakProminence', std(sp)*3);
[vals,locs] = findpeaks(sp, 1, 'MinPeakProminence', std(sp)*3);
count = 0;
dev = std(sp);
m_val = max(sp)*4;
offset = 0.4;

count = inf;
prev_loc = -inf;

while count > 30
	count = 0;
	for i = 1:length(locs)
		loc = locs(i);
		if loc + avg_time > length(sp)
			if mean(sp(loc:length(sp))) > mean(sp) + barrier * dev &&...
					loc - prev_loc  > avg_time
				count = count + 1;
				locations(count) = loc;
				values(count) = vals(i);
				prev_loc = loc;
			end
		else
			if mean(sp(loc:loc + avg_time)) > mean(sp) + barrier * dev...
					&& loc - prev_loc  > avg_time
				count = count + 1;
				locations(count) = loc;
				values(count) = vals(i);
				prev_loc = loc;
			end
		end
	end
	barrier = barrier + 0.4;
end
pl = 0;
% hold on; plot(locations, values, 'o')
% hold off;
% figure()
% hold on; plot(locations, values, 'o')
while pl < length(sp)
	pl = pl + 1;
	if any(pl == locations)
		if pl + avg_time > length(sp)
			output(pl : length(sp)) = sp(pl : length(sp)) * 2;
		else
			output(pl : pl + avg_time) = sp(pl : pl + avg_time) * 2;
			pl = pl + avg_time;
		end
	else
		output(pl) = sp(pl)/m_val - offset;
	end
end

output(output < -dev) = -dev;

end

