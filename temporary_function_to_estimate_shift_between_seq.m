function [opt_shift, max_sim] = temporary_function_to_estimate_shift_between_seq(source_array, target_array, w, ratio, alpha)

p = size(source_array, 2);
q = size(target_array, 2);

if (p >= q)

    min_shift = - floor((1.0-ratio)*q);
    max_shift = (p-q) + floor((1.0-ratio)*q);

    max_sim = 0.0;
    opt_shift = 0.0;

    for shift = min_shift:1:max_shift
        if (shift < 0) % extrémités cas gauche
            w = 1.0./max(abs(target_array(:, abs(shift)+1:end) - source_array(:, 1:q-abs(shift))), [], 2);
            diss = sum(repmat(w, 1, q-abs(shift)) .* (target_array(:, abs(shift)+1:end) - source_array(:, 1:q-abs(shift))).^(2));
            delta_sim =  sum(1.0 - tanh(alpha*diss))/(q-abs(shift));
        elseif (shift > p - q)  % extrémités cas droit
            w = 1.0./max(abs(target_array(:, 1:p-shift) - source_array(:, shift+1:end)), [], 2);
            diss = sum(repmat(w, 1, p-shift) .* (target_array(:, 1:p-shift) - source_array(:, shift+1:end)).^(2));
            delta_sim =  sum(1.0 - tanh(alpha*diss))/(p - shift);
        else % cas général
            w = 1.0./max(abs(target_array - source_array(:, shift +1 : shift+q)), [], 2);
            diss = sum(repmat(w, 1, q) .* (target_array - source_array(:, shift +1 : shift+q)).^(2));
            delta_sim =  sum(1.0 - tanh(alpha*diss))/q;
        end

       if (delta_sim > max_sim)
           max_sim = delta_sim;
           opt_shift = shift;
       end
    end

else
    [opt_shift, max_sim] = temporary_function_to_estimate_shift_between_seq(target_array, source_array, w, ratio, alpha);
    opt_shift = - opt_shift;

end

