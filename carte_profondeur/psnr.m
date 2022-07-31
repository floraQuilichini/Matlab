function val = psnr(original_depthmap, reconstructed_depthmap, max_val)

mse = mean((double(original_depthmap) - double(reconstructed_depthmap)).^(2), 'all');
    if (mse == 0)
        val = 100.0;
    else
        val = 20 * log10(double(max_val) / sqrt(mse));
    end 
end

