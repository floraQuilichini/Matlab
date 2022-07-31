function [dists, inds, repeated_list_extremities] = compute_distance_from_other_lists(list_extremities, endings, im_bw)

other_endings =  endings;
sz = [size(im_bw, 1), size(im_bw, 2)];
px_extremities = zeros(length(list_extremities), 2);
for i=1:length(list_extremities)
    list_ending = list_extremities(i);
    %other_endings(other_endings == list_ending) =[];
    [row, col] = ind2sub(sz,list_ending);
    px_extremities(i, :) = [row, col];
end

other_px = zeros(length(other_endings), 2);
for i=1:length(other_endings)
    [row, col] = ind2sub(sz, other_endings(i));
    other_px(i, :) = [row, col];
end

repeated_other_px  = repmat(other_px,[length(list_extremities) 1]);
repeated_px_extremities = repelem(px_extremities,length(other_endings),1);
repeated_list_extremities = repelem(list_extremities,length(other_endings),1);

dists = sqrt(sum((repeated_other_px - repeated_px_extremities).^2, 2));

inds = [];
for i=1:length(repeated_other_px)
    inds(i) = sub2ind(sz, repeated_other_px(i, 1), repeated_other_px(i, 2));
end

end

