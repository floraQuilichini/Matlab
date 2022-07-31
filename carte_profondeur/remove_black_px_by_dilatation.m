function [depthmap_with_reduced_black_px, mask] = remove_black_px_by_dilatation(depthmap, se)
% % se must be a rectangle element
% 
% mask = ~(depthmap ==0);
% se_height = size(se, 1);
% se_width = size(se, 2);
% [ii,jj]=find(~depthmap);
% row_ind =[ max(1, ii - fix(se_height/2)), min(size(depthmap, 1), ii + fix(se_height/2))];
% col_ind = [ max(1, jj - fix(se_width/2)), min(size(depthmap, 2), jj + fix(se_width/2))];
% depthmap_with_reduced_black_px = depthmap;
% for index=1:size(ii, 1)
%     depthmap_with_reduced_black_px(ii(index), jj(index)) = max(depthmap(row_ind(index, 1):row_ind(index, 2), col_ind(index, 1):col_ind(index, 2)),[],'all');
% 
% end
% 
% if any(~depthmap_with_reduced_black_px(:))
%     depthmap_with_reduced_black_px = remove_black_px_by_dilatation(depthmap_with_reduced_black_px, se);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se is a strel element
mask = ~(depthmap ==0);
depthmap_with_reduced_black_px = depthmap;
while any(depthmap_with_reduced_black_px == 0, 'all')
    dilated_depthmap = imdilate(depthmap_with_reduced_black_px, se);
    depthmap_with_reduced_black_px(depthmap_with_reduced_black_px == 0) = dilated_depthmap(depthmap_with_reduced_black_px == 0);
end    
    
end

