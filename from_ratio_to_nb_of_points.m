function nb_of_points = from_ratio_to_nb_of_points(fraction_kept_points, original_pc_source)

nb_original_source_points = original_pc_source.Count;
nb_of_points = round(fraction_kept_points*nb_original_source_points);

end

