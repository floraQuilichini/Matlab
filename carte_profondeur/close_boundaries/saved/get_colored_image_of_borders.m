function im_bounds_bw = get_colored_image_of_borders(im_bw, stacked_boundaries)


colors = (1:1:length(stacked_boundaries));
im_bounds = zeros(size(im_bw));
im_bounds_bw = zeros(size(im_bw));
for i=1:length(stacked_boundaries)
    l = stacked_boundaries{1, i}.list;
    for k = 1:length(l)
        im_bounds(l(k))= colors(i);
        im_bounds_bw(l(k)) = 1;
    end
%     figure;
%     imagesc(im_bounds)
end
figure; imagesc(im_bounds);

% im_bounds_r = zeros(size(im_bw));
% im_bounds_g = zeros(size(im_bw));
% im_bounds_b = zeros(size(im_bw));
% nscales = round(length(stacked_boundaries).^(1/3));
% step = fix(255/nscales);
% color_val = (step:step:nscales*step);
% colors = [];
% for r=1:nscales
%     for g=1:nscales
%         for b=1:nscales
%             colors(:, end+1) = [color_val(r); color_val(g); color_val(b)];
%         end
%     end
% end
% 
% for i=1:length(stacked_boundaries)
%     l = stacked_boundaries{1, i}.list;
%     for k = 1:length(l)
%         im_bounds_r(l(k))= colors(1, i);
%         im_bounds_g(l(k))= colors(2, i);
%         im_bounds_b(l(k))= colors(3, i);
%         im_bounds(:, :, 1) = im_bounds_r;
%         im_bounds(:, :, 2) = im_bounds_g;
%         im_bounds(:, :, 3) = im_bounds_b;
%     end
%     figure;
%     imagesc(im_bounds)
% end
end

