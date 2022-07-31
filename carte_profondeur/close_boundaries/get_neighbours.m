function [neighbour_px, neighbour_ind] = get_neighbours(current_ind, im_bw)
sz= [size(im_bw, 1), size(im_bw, 2)];
[row,col] = ind2sub(sz,current_ind);

c = 0;
if row== 1
    c =c+ 1;
end
if row==size(im_bw, 1)
    c = c +2;
end
if col == 1
    c = c+10;
end
if col == size(im_bw, 2)
    c = c + 20;
end

switch c
    case 1
        neighborhood = im_bw(row:row+1, col-1:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==3) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1) + 1;
                case 4
                    neighbour_ind(i) = current_ind + 1;
                case 5
                   neighbour_ind(i) =  current_ind + size(im_bw, 1);
                case 6
                    neighbour_ind(i) = current_ind + size(im_bw, 1)+1;
                otherwise
                     error('wrong neighborhood');
            end

        end
        
    case 2
        neighborhood = im_bw(row-1:row, col-1:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==4) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - size(im_bw, 1) - 1;
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 3
                    neighbour_ind(i) = current_ind - 1;
                case 5
                   neighbour_ind(i) =  current_ind + size(im_bw, 1) - 1;
                case 6
                    neighbour_ind(i) = current_ind + size(im_bw, 1);
                otherwise
                     error('wrong neighborhood');
            end

        end
        
    case 10
        neighborhood = im_bw(row-1:row+1, col:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==2) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - 1;
                case 3
                    neighbour_ind(i) = current_ind +1;
                case 4
                    neighbour_ind(i) = current_ind  + size(im_bw, 1) - 1;
                case 5
                   neighbour_ind(i) =  current_ind + size(im_bw, 1);
                case 6
                    neighbour_ind(i) = current_ind + size(im_bw, 1) +1;
                otherwise
                     error('wrong neighborhood');
            end

        end
        
    case 20
        neighborhood = im_bw(row-1:row+1, col-1:col);
        n_indices = find(neighborhood);
        n_indices(n_indices==5) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - size(im_bw, 1) - 1;
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 3
                    neighbour_ind(i) = current_ind  - size(im_bw, 1) + 1;
                case 4
                   neighbour_ind(i) =  current_ind -1;
                case 6
                    neighbour_ind(i) = current_ind  +1;
                otherwise
                     error('wrong neighborhood');
            end

        end
        
    case 21
        neighborhood = im_bw(row:row+1, col-1:col);
        n_indices = find(neighborhood);
        n_indices(n_indices==3) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1) +1;
                case 4
                    neighbour_ind(i) = current_ind  +1;
                otherwise
                     error('wrong neighborhood');
            end

        end
    case 11
        neighborhood = im_bw(row:row+1, col:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==1) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 2
                    neighbour_ind(i) = current_ind + 1;
                case 3
                    neighbour_ind(i) = current_ind + size(im_bw, 1);
                case 4
                    neighbour_ind(i) = current_ind  + size(im_bw, 1) +1;
                otherwise
                     error('wrong neighborhood');
            end

        end
    case 22
        neighborhood = im_bw(row-1:row, col-1:col);
        n_indices = find(neighborhood);
        n_indices(n_indices==4) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind  - size(im_bw, 1) -1;
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 3
                    neighbour_ind(i) = current_ind - 1;
                otherwise
                     error('wrong neighborhood');
            end

        end
    case 12
        neighborhood = im_bw(row-1:row, col:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==2) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind  -1;
                case 3
                    neighbour_ind(i) = current_ind + size(im_bw, 1) -1;
                case 4
                    neighbour_ind(i) = current_ind + size(im_bw, 1);
                otherwise
                     error('wrong neighborhood');
            end

        end
    otherwise
        neighborhood = im_bw(row-1:row+1, col-1:col+1);
        n_indices = find(neighborhood);
        n_indices(n_indices==5) = [];
        
        neighbour_ind = zeros(1, length(n_indices));
        for i=1:length(neighbour_ind)
            ind = n_indices(i);
            switch ind
                case 1
                    neighbour_ind(i) = current_ind - size(im_bw, 1) - 1;
                case 2
                    neighbour_ind(i) = current_ind - size(im_bw, 1);
                case 3
                    neighbour_ind(i) = current_ind - size(im_bw, 1) + 1;
                case 4
                    neighbour_ind(i) = current_ind - 1;
                case 6
                    neighbour_ind(i) = current_ind + 1;
                case 7
                    neighbour_ind(i) = current_ind + size(im_bw, 1) - 1;
                case 8
                    neighbour_ind(i) = current_ind + size(im_bw, 1);
                case 9
                    neighbour_ind(i) = current_ind + size(im_bw, 1) + 1;
                otherwise
                     error('wrong neighborhood');
            end

        end
end


neighbour_px = im_bw(neighbour_ind);

end

