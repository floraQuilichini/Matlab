function e = compute_entropy(vector)
size_vec = length(vector);
figure; 
histo = histogram(vector, max(vector) - min(vector)+1);
probs = histo.Values/size_vec;
probs(probs == 0) = [];
 e = -sum(probs.*log2(probs));
end

