function nb = has_neighbour(current_ind, im_bw)
sz = [size(im_bw,1), size(im_bw, 2)];
[row,col] = ind2sub(sz, current_ind);
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
    case 2
        neighborhood = im_bw(row-1:row, col-1:col+1);
    case 10
        neighborhood = im_bw(row-1:row+1, col:col+1);
    case 20
        neighborhood = im_bw(row-1:row+1, col-1:col);
    case 21
        neighborhood = im_bw(row:row+1, col-1:col);
    case 11
        neighborhood = im_bw(row:row+1, col:col+1);
    case 22
        neighborhood = im_bw(row-1:row, col-1:col);
    case 12
        neighborhood = im_bw(row-1:row, col:col+1);
    otherwise
        neighborhood = im_bw(row-1:row+1, col-1:col+1);
end

nb = sum(neighborhood ==1, 'all') -1;
end

