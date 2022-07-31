function left_boundaries = merge_corners(stacked_boundaries)

possible_corners = {};
indices = [];
left_boundaries = stacked_boundaries;
for k =1:length(stacked_boundaries)
    list = stacked_boundaries{1, k}.list;
    if (length(list)<3)
        possible_corners{1, end+1} = stacked_boundaries{1, k};
        indices(1, end+1) = k;
    end
end

left_boundaries(indices) = [];
for k=1:length(possible_corners)
    list = possible_corners{1 ,k}.list;
    flag = 0;
    if length(list) == 2
        ind1 = list(1);
        ind2 = list(2);
        for i =1:length(left_boundaries)
            list_q = left_boundaries{1, i}.list;
            if ismember(ind1, list_q)
                left_boundaries{1, i}.corner = ind2;
                break; 
            end
            if ismember(ind2, list_q)
                left_boundaries{1, i}.corner = ind1;
                break; 
            end
            flag = flag +1;
        end
        if flag == length(left_boundaries)
            left_boundaries{1, end+1} = possible_corners{1, k};
        end
    end
end
        
        


end

