function distance = compare_histograms(h1x, h1y, h2x, h2y)
%function that computes the distance between histogram h1 and histogram h2
% (h1 and h2 are arrays containing X row-vector (bins of the histogram) and Y 
% row-vector (values of the histogram)

[d1_intra, S1] = compute_adjacent_bars_height_distance(h1y);
[d2_intra, S2] = compute_adjacent_bars_height_distance(h2y);

if S1 ==0 && S2 ==0 
    distance = 0;
else    
    if S1 < S2
        ratio = S2/S1;
    else
        ratio = S1/S2;
    end
 
    if size(h1x, 2) < size(h2x, 2)
        [c, lag] = xcorr(h2y,h1y);
        nb_bins = size(h2x, 2);
    else
        [c, lag] = xcorr(h1y,h2y);
        nb_bins = size(h1x, 2);
    end

    [~, index] = max(c);
    deplacement = abs(lag(index));

    distance = ratio*(deplacement/nb_bins)*abs(d1_intra - d2_intra);
end


end

