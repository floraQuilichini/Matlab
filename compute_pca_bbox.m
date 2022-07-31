function [bbox_points, norm_diag, d] = compute_pca_bbox(pc, show_flag)

data = pc.Location;

% center data
mean_data = mean(data, 1);
data_centered = data - repmat(mean_data, pc.Count, 1);

% compute covariance
C = cov(data_centered);

% get eigen vectors and eigen values
[V, D] = eig(C);
[d,ind] = sort(diag(D)); % sort eigen values and eigen vectors
Ds = D(ind, ind);
Vs = V(:,ind);

% the vectors of Vs give us a new basis of R3
% now we compute the data coordinates in the new base 
newdata = Vs * data';
newdata = newdata';

% compute bounding box
[pmin_, pmax_] = computeBoundingBox(pointCloud(newdata));  % we get pmin and pmax in the new base

points = zeros(17, 3);
    % face 1
points(1, :) = pmin_;
points(2, :) = [pmax_(1), pmin_(2), pmin_(3)];
points(3, :) = [pmax_(1), pmax_(2), pmin_(3)];
points(4, :) = [pmin_(1), pmax_(2), pmin_(3)];
points(5, :) = pmin_;
    % face 2
points(6, :) = [pmin_(1), pmin_(2), pmax_(3)];
points(7, :) = [pmax_(1), pmin_(2), pmax_(3)];
points(8, :) = points(2, :);
    % face 3
points(9, :) = points(3, :);    
points(10, :) = pmax_;  
points(11, :) = points(7, :);
%     % face 4
points(12, :) = points(6, :);  
points(13, :) = [pmin_(1), pmax_(2), pmax_(3)]; 
points(14, :) = pmax_;
    % face 5
points(15, :) = points(3, :); 
points(16, :) = points(4, :); 
points(17, :) = points(13, :);

% % scale point cloud in unitary squared bounding box
% scale_vec = [norm(pmin_ - points(2, :)), norm(pmin_ - points(4, :)), norm(pmin_ - points(6, :))];
% norm_matrix = compute_scale_matrix(ones(1, 3)./scale_vec);
% norm_matrix = norm_matrix(1:3, 1:3);
% points = (norm_matrix*points')';

% scale point cloud according to the bounding box diagonal
norm_diag = norm(pmin_- pmax_);




if show_flag
    % plot pc
    figure; 
%     pcshow(pointCloud((norm_matrix*newdata')'));
    pcshow(pointCloud(newdata));

    % draw bbox
    hold on
    plot3(points(:, 1), points(:, 2), points(:, 3), '-*', 'Color', 'g','MarkerSize', 2);
end


% go back to the old base
points_t = (Vs\points')';
% data_scaled = (Vs\norm_matrix*newdata')';
data_scaled = (Vs\newdata')';
 

if show_flag
    % plot pc
    figure; 
    pcshow(pointCloud(data_scaled));

    % draw bbox
    hold on
    plot3(points_t(:, 1), points_t(:, 2), points_t(:, 3), '-*', 'Color', 'g','MarkerSize', 2);

end

bbox_points = unique(points_t, 'rows');
% norm_matrix = (data\data_scaled)';
%norm_matrix = inv((Vs'*norm_matrix)\Vs')';
%norm_matrix = Vs\norm_matrix;
%scale_vec = (Vs\scale_vec')';


end

