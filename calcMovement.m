function [output] = calcMovement(sp, times, peak, offset, vari)


output = sp;
barrier = 0;
avg_time = round(mean(times));


[vals,locs] = findpeaks(sp, 1, 'MinPeakProminence', std(sp)*3);
count = 0;
dev = std(sp);

count = inf;
prev_loc = -inf;

sp(find(sp > mean(sp) + 6 * std(sp))) = mean(sp);

while count > 20
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
				peaks_max(count) = max(sp(loc:length(sp)));
			end
		else
			if mean(sp(loc:loc + avg_time)) > mean(sp) + barrier * dev...
					&& loc - prev_loc  > avg_time
				count = count + 1;
				locations(count) = loc;
				values(count) = vals(i);
				prev_loc = loc;
				peaks_max(count) = max(sp(loc:loc + avg_time));
			end
		end
	end
	barrier = barrier + 0.01;
end

total_avg = mean(peaks_max);
for i = 1:length(locations)
	locate = locations(i);
end

peak_ratio = peak / mean(peaks_max);
m_val = vari/std(sp);

pl = 0;
while pl < length(sp)
	pl = pl + 1;
	if any(pl == locations)
		if pl + avg_time > length(sp)
			output(pl : length(sp)) = sp(pl : length(sp)) * peak_ratio;
		else
			output(pl : pl + avg_time) = sp(pl : pl + avg_time) * peak_ratio;
			pl = pl + avg_time;
		end
	else
		output(pl) = sp(pl)*m_val + offset;
	end
end

% output(output < -dev) = -dev;

% figure()
% plot(sp)
% findpeaks(sp, 1, 'MinPeakProminence', std(sp)*3);
% hold on; plot(locations, values, 'o')
% hold off;
% figure()
% hold on; plot(locations, values, 'o')

end

