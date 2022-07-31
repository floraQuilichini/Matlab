function nb_proxies = convert_kept_point_fraction_to_nb_proxies(fraction_kept_points)


if (fraction_kept_points == 0.6)
    nb_proxies = 3500;
elseif (fraction_kept_points == 0.5)
    nb_proxies = 2500;
elseif (fraction_kept_points == 0.4)
    nb_proxies = 2000;
elseif (fraction_kept_points == 0.3)
    nb_proxies = 1300;
elseif (fraction_kept_points == 0.2)
    nb_proxies = 800;
elseif (fraction_kept_points == 0.1)
    nb_proxies = 540;
else
     nb_proxies = 540;
end



end

