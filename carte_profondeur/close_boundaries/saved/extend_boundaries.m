% function [stacked_boundaries, additional_ending_leaves] = extend_boundaries(stacked_boundaries, additional_ending_leaves, ind1, ind2)
% k1 =0;
% k2 = 0;
% for k =1:length(stacked_boundaries)
%     if (stacked_boundaries{1, k}.leaf_end == ind1 || stacked_boundaries{1, k}.leaf_init == ind1)
%         k1 = k;
%         if k2
%             break;
%         end
%     end
%     if (stacked_boundaries{1, k}.leaf_end == ind2 || stacked_boundaries{1, k}.leaf_init == ind2)
%         k2 = k;
%         if k1
%             break;
%         end
%     end
% end
% 
% if ~(k2 ==0 && k1 ==0)
%     if k2 ==0 || k1 ==0
%         if k2 ==0 
%             if stacked_boundaries{1, k1}.leaf_end == ind1
%                 stacked_boundaries{1, k1}.leaf_end = ind2;
%                 additional_ending_leaves(end+1) = ind1;
%             else
%                 stacked_boundaries{1, k1}.leaf_init = ind2;
%                 additional_ending_leaves(end+1) = ind1;
%             end
% %             if isfield(stacked_boundaries{1, k1}, 'ext1')
% %                 if stacked_boundaries{1, k1}.ext1 ~= ind2
% %                     stacked_boundaries{1, k1}.leaf_init = ind2;
% %                     stacked_boundaries{1, k1}.leaf_end = ind2;
% %         %                 if stacked_boundaries.leaf_init == ind1 
% %         %                     stacked_boundaries{1, k1}.leaf_end = ind2;
% %         %                 else
% %         %                     stacked_boundaries{1, k1}.leaf_init = ind2;
% %         %                 end
% %                 end
% %             else
% %                 stacked_boundaries{1, k1}.ext1 = ind2;
% %             end
%         else
%             if stacked_boundaries{1, k2}.leaf_end == ind2
%                 stacked_boundaries{1, k2}.leaf_end = ind1;
%                 additional_ending_leaves(end+1) = ind2;
%             else
%                 stacked_boundaries{1, k2}.leaf_init = ind1;
%                 additional_ending_leaves(end+1) = ind2;
%             end
% %             if isfield(stacked_boundaries{1, k2}, 'ext1')
% %                 if stacked_boundaries{1, k2}.ext1 ~= ind1
% %                     stacked_boundaries{1, k2}.leaf_init = ind1;
% %                     stacked_boundaries{1, k2}.leaf_end = ind1;
% %                 end
% %             else
% %                 stacked_boundaries{1, k2}.ext1 = ind1;
% %             end
%         end
%     else
%         if stacked_boundaries{1, k2}.leaf_init == ind2
%             if stacked_boundaries{1, k1}.leaf_end == ind1
%                 additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_init, stacked_boundaries{1, k1}.leaf_end];
%                 list1 = stacked_boundaries{1, k1}.list;
%                 list2 = stacked_boundaries{1, k2}.list;
%                 new_list = [list1, list2];
%                 stacked_boundaries{1, k1}.list = new_list;
%                 stacked_boundaries{1, k1}.leaf_end = stacked_boundaries{1, k2}.leaf_end;
%                 stacked_boundaries{1, k1}.prev = stacked_boundaries{1, k2}.prev;
%                 stacked_boundaries(k2) = [];
%             else
%                 additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_init, stacked_boundaries{1, k1}.leaf_init];
%                 list1 = stacked_boundaries{1, k1}.list;
%                 list2 = stacked_boundaries{1, k2}.list;
%                 new_list = [flip( list2), list1];
%                 stacked_boundaries{1, k1}.list = new_list;
%                 stacked_boundaries{1, k1}.leaf_init = stacked_boundaries{1, k2}.leaf_end;
%                 stacked_boundaries{1, k1}.sec = stacked_boundaries{1, k2}.prev;
%                 stacked_boundaries(k2) = [];
% 
%             end
%         else
%             if stacked_boundaries{1, k1}.leaf_end == ind1
%                 additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_end, stacked_boundaries{1, k1}.leaf_end];
%                 list1 = stacked_boundaries{1, k1}.list;
%                 list2 = stacked_boundaries{1, k2}.list;
%                 new_list = [list1, flip(list2)];
%                 stacked_boundaries{1, k1}.list = new_list;
%                 stacked_boundaries{1, k1}.leaf_end = stacked_boundaries{1, k2}.leaf_init;
%                 stacked_boundaries{1, k1}.prev = stacked_boundaries{1, k2}.sec;
%                 stacked_boundaries(k2) = [];
%             else
%                 additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_end, stacked_boundaries{1, k1}.leaf_init];
%                 list1 = stacked_boundaries{1, k1}.list;
%                 list2 = stacked_boundaries{1, k2}.list;
%                 new_list = [list2, list1];
%                 stacked_boundaries{1, k1}.list = new_list;
%                 stacked_boundaries{1, k1}.leaf_init = stacked_boundaries{1, k2}.leaf_init;
%                 stacked_boundaries{1, k1}.sec = stacked_boundaries{1, k2}.sec;
%                 stacked_boundaries(k2) = [];
%             end
%         end
%     end
% 
% end  
% end



function [stacked_boundaries, additional_ending_leaves] = extend_boundaries(stacked_boundaries, additional_ending_leaves, ind1, ind2)
k1 =0;
k2 = 0;
for k =1:length(stacked_boundaries)
    if (stacked_boundaries{1, k}.leaf_end == ind1 || stacked_boundaries{1, k}.leaf_init == ind1)
        k1 = k;
        if k2
            break;
        end
    end
    if (stacked_boundaries{1, k}.leaf_end == ind2 || stacked_boundaries{1, k}.leaf_init == ind2)
        k2 = k;
        if k1
            break;
        end
    end
end

if ~(k2 ==0 && k1 ==0)
    if k2 ==0 || k1 ==0
        if k2 ==0 
            if stacked_boundaries{1, k1}.leaf_end == ind1
                stacked_boundaries{1, k1}.leaf_end = ind2;
                additional_ending_leaves(end+1) = ind1;
            else
                stacked_boundaries{1, k1}.leaf_init = ind2;
                additional_ending_leaves(end+1) = ind1;
            end
%             if isfield(stacked_boundaries{1, k1}, 'ext1')
%                 if stacked_boundaries{1, k1}.ext1 ~= ind2
%                     stacked_boundaries{1, k1}.leaf_init = ind2;
%                     stacked_boundaries{1, k1}.leaf_end = ind2;
%         %                 if stacked_boundaries.leaf_init == ind1 
%         %                     stacked_boundaries{1, k1}.leaf_end = ind2;
%         %                 else
%         %                     stacked_boundaries{1, k1}.leaf_init = ind2;
%         %                 end
%                 end
%             else
%                 stacked_boundaries{1, k1}.ext1 = ind2;
%             end
        else
            if stacked_boundaries{1, k2}.leaf_end == ind2
                stacked_boundaries{1, k2}.leaf_end = ind1;
                additional_ending_leaves(end+1) = ind2;
            else
                stacked_boundaries{1, k2}.leaf_init = ind1;
                additional_ending_leaves(end+1) = ind2;
            end
%             if isfield(stacked_boundaries{1, k2}, 'ext1')
%                 if stacked_boundaries{1, k2}.ext1 ~= ind1
%                     stacked_boundaries{1, k2}.leaf_init = ind1;
%                     stacked_boundaries{1, k2}.leaf_end = ind1;
%                 end
%             else
%                 stacked_boundaries{1, k2}.ext1 = ind1;
%             end
        end
    else
        if stacked_boundaries{1, k2}.leaf_init == ind2
            if stacked_boundaries{1, k1}.leaf_end == ind1
                list1 = stacked_boundaries{1, k1}.list;
                list2 = stacked_boundaries{1, k2}.list;
                new_list = [list1, list2];
                stacked_boundaries{1, k1}.list = new_list;
                stacked_boundaries{1, k1}.leaf_end = stacked_boundaries{1, k2}.leaf_end;
                stacked_boundaries{1, k1}.prev = stacked_boundaries{1, k2}.prev;
                stacked_boundaries(k2) = [];
            else
                list1 = stacked_boundaries{1, k1}.list;
                list2 = stacked_boundaries{1, k2}.list;
                additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_init, stacked_boundaries{1, k1}.leaf_init];
                new_list = [flip( list2), list1];
                stacked_boundaries{1, k1}.list = new_list;
                stacked_boundaries{1, k1}.leaf_init = stacked_boundaries{1, k2}.leaf_end;
                stacked_boundaries{1, k1}.sec = stacked_boundaries{1, k2}.prev;
                stacked_boundaries(k2) = [];

            end
        else
            if stacked_boundaries{1, k1}.leaf_end == ind1
                list1 = stacked_boundaries{1, k1}.list;
                list2 = stacked_boundaries{1, k2}.list;
                new_list = [list1, flip(list2)];
                stacked_boundaries{1, k1}.list = new_list;
                stacked_boundaries{1, k1}.leaf_end = stacked_boundaries{1, k2}.leaf_init;
                stacked_boundaries{1, k1}.prev = stacked_boundaries{1, k2}.sec;
                additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_end, stacked_boundaries{1, k1}.leaf_end];
                stacked_boundaries(k2) = [];
            else
                list1 = stacked_boundaries{1, k1}.list;
                list2 = stacked_boundaries{1, k2}.list;
                new_list = [list2, list1];
                stacked_boundaries{1, k1}.list = new_list;
                stacked_boundaries{1, k1}.leaf_init = stacked_boundaries{1, k2}.leaf_init;
                stacked_boundaries{1, k1}.sec = stacked_boundaries{1, k2}.sec;
                additional_ending_leaves(end+1:end+2) = [stacked_boundaries{1, k2}.leaf_end, stacked_boundaries{1, k1}.leaf_init];
                stacked_boundaries(k2) = [];
            end
        end
    end

end  
end


