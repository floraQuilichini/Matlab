%% test autoencoder

%% Reading images
% im_size = [51 51];
% training_images_folder = "C:\Registration\MATLAB\carte_profondeur\depth_images\training";
% test_images_folder = "C:\Registration\MATLAB\carte_profondeur\depth_images\test";
% trainingFilePattern = fullfile(training_images_folder, '*.png');
% testingFilePattern = fullfile(test_images_folder, '*.png');
% pngTrainingFiles = dir(trainingFilePattern);
% pngTestingFiles = dir(testingFilePattern);
% 
% training_images = zeros(im_size(1), im_size(2), length(pngTrainingFiles));
% for k = 1:length(pngTrainingFiles)
%   baseFileName = pngTrainingFiles(k).name;
%   fullFileName = fullfile(training_images_folder, baseFileName);
%   image = imread(fullFileName);
%   training_images(:,:,k) = image;
% end
% 
% test_images = zeros(im_size(1), im_size(2), length(pngTestingFiles));
% for k = 1:length(pngTestingFiles)
%   baseFileName = pngTestingFiles(k).name;
%   fullFileName = fullfile(test_images_folder, baseFileName);
%   image = imread(fullFileName);
%   test_images(:,:,k) = image;
% end
% 
% %% Data and parameters definition
%     % training database
% training_images = double(training_images)/255;
% training_data = cell(1, size(training_images, 3));
% training_data = digitTrainCellArrayData;
% for i=1:size(training_images, 3)
%     training_data{1,i} = training_images(:, :, i);
% end
training_data = digitTrainCellArrayData;
    % testing database
% test_images = double(test_images)/255;
% test_data = cell(1, size(test_images, 3));
% %figure;
% for i = 1:size(test_images, 3)
%     test_im_i = test_images(:,:, i);
%     test_data{1, i} = test_im_i;
%     %subplot(nearest(sqrt(size(test_images, 3))), nearest(size(test_images, 3)/sqrt(size(test_images, 3))),i);
%     %imshow(test_im_i, [0, 1]);
% end
test_data = digitTestCellArrayData;

    % parameters first autoencoder
hidden_size = 25;
lambda = 0.004; %(0.0005:0.002:0.02);
beta = 4;  %(2:0.5:6);
rho = 0.15; %(0.05:0.02:0.3);

count = 1;
%test_features = zeros(hidden_size, size(test_images, 3), length(lambda)*length(rho));
test_features = zeros(hidden_size, 5000, length(lambda)*length(rho));
    
%% Creating and training autoencoder
for l =1:1:length(lambda)
    for r =1:1:length(rho)
        % train first autoencoder
        autoenc = trainAutoencoder(training_data, hidden_size, 'EncoderTransferFunction', 'satlin', 'DecoderTransferFunction', 'purelin', 'MaxEpochs', 400, 'L2WeightRegularization', lambda(l), 'SparsityRegularization', beta, 'SparsityProportion', rho(r), 'ScaleData', false);
        feat = encode(autoenc, training_data);
        output = decode(autoenc, feat);
        %% Getting output from autoencoder
        %% Plot
            % autoencoder
        %view(autoenc);
            % compare actual nd predicted images
        figure;
        plotWeights(autoenc);

            % compare actual and predicted images
        %figure;
%         for i = 1:size(training_images, 3)
%             subplot(nearest(sqrt(size(training_images, 3))), nearest(size(training_images, 3)/sqrt(size(training_images, 3))), i);
%             imshow(training_data{i}, [0 1]);
%         end
        %figure;
%         for i=1:size(training_images, 3)
%             subplot(nearest(sqrt(size(training_images, 3))), nearest(size(training_images, 3)/sqrt(size(training_images, 3))),i);
%             imshow(output{i}, [0 1]);
%         end

%         %% Test data
%             % Find the closet images in the database (in mean square error sense)
%         errors = zeros(size(test_images, 3), size(training_images, 3));
%         for i=1:size(test_images, 3)
%             for j=1:size(training_images, 3)
%                 errors(i, j) = immse(test_images(:, :, i),training_images(:,:,j));
%             end
%         end
%         [~, nearest_im_indices] = min(errors, [], 2);
%         %figure;
% %         for i = 1:size(test_images, 3)
% %             subplot(size(test_images, 3), 2, 1+ 2*(i-1));
% %             imshow(test_images(:,:,i), [0, 1]);
% %             subplot(size(test_images, 3), 2, 2+ 2*(i-1));
% %             imshow(training_images(:,:, nearest_im_indices(i)), [0, 1]);
% %         end
        %% Prediction
        test_features(:, :, count) = encode(autoenc, test_data);
        xReconstructed = predict(autoenc,test_data);
%         figure;
%         for i = 1:size(test_images, 3)
%             subplot(nearest(sqrt(size(test_images, 3))), nearest(size(test_images, 3)/sqrt(size(test_images, 3))),i);
%             imshow(xReconstructed{i}, [0, 1]);
%         end
        
        count = count+1;
    end
end

%% Proof 
% proof_image_filename = "C:\Registration\MATLAB\carte_profondeur\depth_images\test\temp\bear_0_0_0.5_0.7854_0.3927.png";
% proof_im = double(imread(proof_image_filename))/255;
% proof_data{1, 1} = proof_im;
proof_data{1, 1} = test_data{1, randi(500, 1)};
proof_feature = encode(autoenc, proof_data);
proofReconstructed = predict(autoenc, proof_data);
     % find closest image (in real space) from test data base (L2 dist)
im_proof_error = zeros(size(test_images, 3), 1);
for j=1:size(test_images, 3)
    im_proof_error(j) = immse(proof_im, test_images(:,:,j));
end
[~, L2_nearest_imTest_index] = min(im_proof_error);
    % find closest hidden vector from test data base hidden vectors (L2 dist)
latent_vector_proof_L2_error = zeros(size(test_images, 3), 1);
for j=1:size(test_images, 3)
    latent_vector_proof_L2_error(j) = immse(proof_feature, test_features(:, j));
end
[~, L2_nearest_featureTest_index] = min(latent_vector_proof_L2_error);   
     % find closest hidden vector from test data base hidden vectors ( auto-correlation )
latent_vector_proof_Corr_error = zeros(size(test_images, 3), 1);
for j=1:size(test_images, 3)
    [r, lag] = xcorr(proof_feature, test_features(:, j));
    latent_vector_proof_Corr_error(j, :) = max(r);
end
[~, Corr_nearest_featureTest_index] = max(latent_vector_proof_Corr_error(:, 1));
