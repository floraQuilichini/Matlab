function [depth_im] = generateDepthCard(mesh_filename, nb_cameras, cameras_positions, cameras_angles, image_size, px_size)
%This function is used to generate depth card from a mesh. 
% the user has to precise : the mesh filename, the number n of cameras he wants
% to put around the object, the cameras positions (n by 3 matrix) and the
% cameras angles (n by 2 vector). Rotation are along the OZ and OX axis. There is no rotation along the camera direction (OY). The angles are expressed in rad
%and the image size l*c (with odd values in px) and the pixel size

% mesh reading
[faces, pts, ~, ~] = plyread(mesh_filename, 'tri');

% mesh refinement
mesh.faces = faces;
mesh.vertices = pts;
figure, set(gcf, 'Renderer', 'opengl'); axis equal;
for iter=1:1 %trop long dès que le nombre de vertex dépasse les 50000
  patch(mesh,'facecolor',[1 0 0]);
  [mesh]=refinepatch(mesh);
end
pts_extended = mesh.vertices;

% % mesh upsampling (adds only the barycenter of the faces of the mesh)
% F=faces.'; 
% V=pts.';
% Q=mean(reshape(V(:,F),3,3,[]),2); % take barycenter of the faces
% Q=num2cell(reshape(Q,3,[]).',1);
% [x2,y2,z2]=deal(Q{:});   %"Interpolated" new points (i.e barycenter of the faces)
% pts_extended = [pts; [x2,y2,z2]];


% cameras directions computation
Y2 = zeros(nb_cameras, 3);
Y2(:, 1) = -cos(cameras_angles(:, 2)).*sin(cameras_angles(:, 1));
Y2(:, 2) = cos(cameras_angles(:, 2)).*cos(cameras_angles(:, 1));
Y2(:, 3) = sin(cameras_angles(:, 2));

% image planes computation
% Y2 is a normal vector to those planes
Planes_coeffs = [Y2 , -sum(Y2.*cameras_positions, 2)];

% point to image plane distance computation
nb_points = size(pts_extended, 1);
dist_point_to_image_plane = abs(sum(repmat(Planes_coeffs, nb_points, 1).*repelem([pts_extended, ones(nb_points, 1)], nb_cameras, 1), 2));
dist_point_to_image_plane = reshape(dist_point_to_image_plane, nb_cameras, nb_points);

% depth computation
gray_values = 1 - (dist_point_to_image_plane - min(min(dist_point_to_image_plane)))/(max(max(dist_point_to_image_plane)) - min(min(dist_point_to_image_plane)));
    % quantization
    step = ((max(max(gray_values)) - min(min(gray_values))))/255;
    gray_values_quantized = floor(gray_values/step)+1;
    % computation of the vector from the center of camera to the orthogonal
    % projection of the points. (in world coordinates)
CP = (repelem(pts_extended, nb_cameras, 1) - repmat(cameras_positions, nb_points, 1))- repmat(reshape(dist_point_to_image_plane, nb_cameras*nb_points, 1), 1, 3).*(repmat(Y2, nb_points, 1));
CP = reshape(CP, nb_cameras, nb_points, 3);
    % computation of frame coordinates 
X2 = cos(cameras_angles(:, 1)).*CP(:,:,1)+ sin(cameras_angles(:, 1)).*CP(:,:,2);
Z2 = sin(cameras_angles(:, 1)).*sin(cameras_angles(:, 2)).*CP(:,:,1) - sin(cameras_angles(:, 2)).*cos(cameras_angles(:, 1)).*CP(:,:,2) + cos(cameras_angles(:, 2)).*CP(:,:,3);
X2_px = floor(X2/px_size) +1;
Z2_px = floor(Z2/px_size) +1;
    % image computation
depth_im = zeros(image_size(1), image_size(2), nb_cameras);
inside_px_X2 = X2_px > - (image_size(1) -1)/2 -1 &  X2_px < (image_size(1) -1)/2 + 1;
inside_px_Z2 = Z2_px > - (image_size(2) -1)/2 -1 &  Z2_px < (image_size(2) -1)/2 + 1;
inside_px = inside_px_X2 & inside_px_Z2;
for k = 1:1:nb_cameras
    im = zeros(image_size(1), image_size(2));
    X2_px_k = X2_px(k, :);
    Z2_px_k = Z2_px(k, :);
    gray_values_quantized_k = gray_values_quantized(k, :);
    % get j values
    j_k = Z2_px_k(inside_px(k, :)) + (image_size(2) -1)/2 +1;
    % get i values
    i_k = abs(X2_px_k(inside_px(k, :)) - (image_size(1) -1)/2) +1;
    % get px coords of depth image
    ind = sub2ind([image_size(1), image_size(2)], i_k, j_k);
     % fill image   
    im(int32(ind)) = gray_values_quantized_k(inside_px(k, :));
    % get contours of the object and fill the inside of the object for each
    % level of gray
    im2 = zeros(image_size(1), image_size(2));
    for g = 0:1:254
        % threshold
        bin_im = im > g & im< g+2;
        im2(bin_im == 1) = g;
%         if nnz(bin_im)>1
%             figure; imshow(bin_im);
%             % connecting contour points
%             px_range = (1:1:image_size(1)*image_size(2));
%             [l, c] = ind2sub(image_size, px_range(bin_im(:)));
%                 % vector of 1-D look-up table "j" points
%                 JI = linspace(min(c),max(c), 10);
%                 % obtain vector of 1-D look-up table "i" points
%                 II = lsq_lut_piecewise( c', l', JI );
%                 % plot fit
%             hold on; plot(c',l','.',JI,II,'+-');
%             % fill contours
%             bin_im_filled = imfill(bin_im, 8, 'holes');
%             bin_im_filled(bin_im == 1) = g;
%         end
    end
     depth_im(:,:, k) = im2;
     image_name = strcat('bear_', num2str(cameras_positions(k, 1)), '_', num2str(cameras_positions(k, 2)), '_', num2str(cameras_positions(k, 3)), '_', num2str(cameras_angles(k, 1)), '_', num2str(cameras_angles(k, 2)));
     imwrite(im2/255,strcat('C:\Registration\MATLAB\carte_profondeur\depth_images\', image_name, '.png'));
end



end

