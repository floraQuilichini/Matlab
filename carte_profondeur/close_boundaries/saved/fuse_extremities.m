% function  stacked_boundaries = fuse_extremities(stacked_boundaries, im_bw)
% 
% i = 1;
% while i < length(stacked_boundaries)
%     e1= stacked_boundaries{1, i}.leaf_init;
%     e2= stacked_boundaries{1, i}.leaf_end;
%     if has_neighbour(e1, im_bw)
%         [~, n1_ind] = get_neighbours(e1, im_bw);
%         n1_next = get_next_index(n1_ind, stacked_boundaries{1, i}.sec);
%     end
%     
%     if has_neighbour(e2, im_bw)
%         [~, n2_ind] = get_neighbours(e2, im_bw);
%         n2_next = get_next_index(n2_ind, stacked_boundaries{1, i}.prev);
%     end
%         
%     flag = 0;
%     for k = i+1:length(stacked_boundaries)
%         ee1 = stacked_boundaries{1, k}.leaf_init;
%         ee2 = stacked_boundaries{1, k}.leaf_end;
%         
%         if (any(n1_next(:) == ee1 ))
%             list = [flip(stacked_boundaries{1, k}.list), stacked_boundaries{1, i}.list];
%             stacked_boundaries{1, i}.list = list;
%             stacked_boundaries{1, i}.leaf_init = stacked_boundaries{1, k}.leaf_end;
%             stacked_boundaries{1, i}.sec = stacked_boundaries{1, k}.prev;
%             stacked_boundaries(k) = [];
%             break;
%         end
%         if (any(n2_next == ee1))
%             list = [stacked_boundaries{1, i}.list, stacked_boundaries{1, k}.list];
%             stacked_boundaries{1, i}.list = list;
%             stacked_boundaries{1, i}.leaf_end = stacked_boundaries{1, k}.leaf_end;
%             stacked_boundaries{1, i}.prev = stacked_boundaries{1, k}.prev;
%             stacked_boundaries(k) = [];
%             break;
%         end
%         
%         if (any(n1_next ==ee2 ))
%             list = [stacked_boundaries{1, k}.list, stacked_boundaries{1, i}.list];
%             stacked_boundaries{1, i}.list = list;
%             stacked_boundaries{1, i}.leaf_init = stacked_boundaries{1, k}.leaf_init;
%             stacked_boundaries{1, i}.sec = stacked_boundaries{1, k}.sec;
%             stacked_boundaries(k) = [];
%             break;
%         end
%         if (any(n2_next== ee2 ))
%             list = [stacked_boundaries{1, i}.list, flip(stacked_boundaries{1, k}.list)];
%             stacked_boundaries{1, i}.list = list;
%             stacked_boundaries{1, i}.leaf_end = stacked_boundaries{1, k}.leaf_init;
%             stacked_boundaries{1, i}.prev = stacked_boundaries{1, k}.sec;
%             stacked_boundaries(k) = [];
%             break;
%         end
%             
%         flag = flag +1;
%     end
%     if flag == length(stacked_boundaries)-i
%         i = i+1;
%     end
% end
% end


function  stacked_boundaries = fuse_extremities(stacked_boundaries, im_bw)

i = 1;
while i < length(stacked_boundaries)
    e1= stacked_boundaries{1, i}.leaf_init;
    e2= stacked_boundaries{1, i}.leaf_end;
    if has_neighbour(e1, im_bw)
        [~, n1_ind] = get_neighbours(e1, im_bw);
        n1_next = get_next_index(n1_ind, stacked_boundaries{1, i}.sec);
    end
    
    if has_neighbour(e2, im_bw)
        [~, n2_ind] = get_neighbours(e2, im_bw);
        n2_next = get_next_index(n2_ind, stacked_boundaries{1, i}.prev);
    end
        
    flag = 0;
    for k = i+1:length(stacked_boundaries)
        ee1 = stacked_boundaries{1, k}.leaf_init;
        ee2 = stacked_boundaries{1, k}.leaf_end;
        
        if (any(n1_next(:) == ee1 ))
            list = [flip(stacked_boundaries{1, k}.list), stacked_boundaries{1, i}.list];
            stacked_boundaries{1, i}.list = list;
            stacked_boundaries{1, i}.leaf_init = stacked_boundaries{1, k}.leaf_end;
            stacked_boundaries{1, i}.sec = stacked_boundaries{1, k}.prev;
            stacked_boundaries(k) = [];
            break;
        end
        if (ee1 == n2_next)
            list = [stacked_boundaries{1, i}.list, stacked_boundaries{1, k}.list];
            stacked_boundaries{1, i}.list = list;
            stacked_boundaries{1, i}.leaf_end = stacked_boundaries{1, k}.leaf_end;
            stacked_boundaries{1, i}.prev = stacked_boundaries{1, k}.prev;
            stacked_boundaries(k) = [];
            break;
        end
        
        if (ee2 == n1_next)
            list = [stacked_boundaries{1, k}.list, stacked_boundaries{1, i}.list];
            stacked_boundaries{1, i}.list = list;
            stacked_boundaries{1, i}.leaf_init = stacked_boundaries{1, k}.leaf_init;
            stacked_boundaries{1, i}.sec = stacked_boundaries{1, k}.sec;
            stacked_boundaries(k) = [];
            break;
        end
        if (ee2 == n2_next)
            list = [stacked_boundaries{1, i}.list, flip(stacked_boundaries{1, k}.list)];
            stacked_boundaries{1, i}.list = list;
            stacked_boundaries{1, i}.leaf_end = stacked_boundaries{1, k}.leaf_init;
            stacked_boundaries{1, i}.prev = stacked_boundaries{1, k}.sec;
            stacked_boundaries(k) = [];
            break;
        end
            
        flag = flag +1;
    end
    if flag == length(stacked_boundaries)-i
        i = i+1;
    end
end
end


