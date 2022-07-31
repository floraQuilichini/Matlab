function se = get_relative_scale(h, m_base)
%Compute the relative scale se between 2 point clouds given their relative
%shift h. 

se = 1/(m_base.^h);


end

