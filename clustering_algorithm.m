function [hists_array_labelled,nb_clusters] = clustering_algorithm(hists_array, percentage_of_similarity)

% cluster histograms
[hists_array_labelled, nb_clusters] = histogram_clustering(hists_array, percentage_of_similarity);


for iter=1:1:5
    % compute centroid for each cluster 
    centroids = zeros(nb_clusters, size(hists_array,2));
    for i=1:1:nb_clusters
        cluster_centroid = mean(hists_array_labelled(hists_array_labelled(:, 1) == i, 2:end), 1);
        centroids(i,:) = cluster_centroid;
    end

    % cluster second time the centroids
    [centroids_labelled, nb_clusters_centroids] = histogram_clustering(centroids, percentage_of_similarity-0);

    % correct hists_array labellization
    for i=1:1:nb_clusters
        hists_array_labelled(hists_array_labelled(:, 1) == i, 1) = centroids_labelled(i,1);
    end
    nb_clusters = nb_clusters_centroids;
    
end

end

