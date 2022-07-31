function [distance, S] = compute_adjacent_bars_height_distance(hy)


S = sum(hy);
if S ~= 0
    distance = (hy(1:end-1) - hy(2:end))*transpose(hy(1:end-1) - hy(2:end));
else
    distance = 0;
end

end

