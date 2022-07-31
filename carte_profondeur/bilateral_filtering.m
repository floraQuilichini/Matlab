function [px_filtered] = bilateral_filtering(input_px, input_image, window_size, intensity_std, spatial_std)
wp = 0;
px_filtered = 0;
for k=-fix(window_size(1)/2):1:fix(window_size(1)/2)
    for l=-fix(window_size(2)/2):1:fix(window_size(2)/2)
        if input_px(1)+k > 0 && input_px(2)+l > 0 && input_px(1)+k < size(input_image, 1) && input_px(2)+l < size(input_image, 2) 
            fr = exp(-(input_image(input_px(1), input_px(2)) - input_image(input_px(1)+k, input_px(2)+l)).^2/(2*intensity_std.^2));
            gs  = exp(- ((k).^2 + (l).^2)/(2*spatial_std.^2));
            px_filtered = px_filtered + input_image(k+input_px(1), l+input_px(2))*fr*gs;
            wp = wp + fr*gs;
        end
    end
end
px_filtered = px_filtered/wp;
    

end

