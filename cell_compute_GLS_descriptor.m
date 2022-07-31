function [tau, eta, kappa, phi] = cell_compute_GLS_descriptor(Pts_query, scale, Pts, Normals, varargin)

% scale can be a scalar or a 1 by m vector
% Pts_query is a m by 3 matrix
% Pts is a n by 3 matrix


numvararg = length(varargin);
if numvararg == 1
    if strcmp(varargin{:}, 'Multiscale')
        flag_multiscale = 1;
    else
        error('the only optional parameter is "Multiscale" ');
    end
    
else
    flag_multiscale = 0;
end

if ~flag_multiscale

    % get u and phi
    [u, phi] = cell_compute_u_and_phi(Pts, Normals, Pts_query, scale);

    % normalize u
    [u_normalized, pratt_norm] = normalize_u(u');

    % reparametrize su
    [tau, eta, kappa, su_nx] = compute_new_parametrization(u_normalized, Pts_query);

    % make all parameters scale-independant 
    % (phi and eta are already unitless so we dont have to correct them)
    tau = tau./scale;
    kappa = kappa.*scale;

    display(kappa)
    display(tau)
    display(phi)

    % % display fit
    % [x,y,z] = sphere;
    % fit_sphere_center = ul/(-2*uq);
    % fit_sphere_radius = sqrt(fit_sphere_center*fit_sphere_center' - uc/uq);
    % % interval = [-20 20 -20 20 -20 20];
    % % figure; pcshow(Pts); hold on; fimplicit3(su_nx, interval);
    % figure; pcshow(Pts); hold on; surf(x*fit_sphere_radius+fit_sphere_center(1),y*fit_sphere_radius+fit_sphere_center(2),z*fit_sphere_radius+fit_sphere_center(3));

else       % multiscale
    
     % get u and phi
    [u, phi] = cell_compute_u_and_phi(Pts, Normals, Pts_query, scale, 'Multiscale');

    % normalize u
    [u_normalized, pratt_norm] = normalize_u(permute(u,[2 1 3]));

    % reparametrize su
    [tau, eta, kappa, su_nx] = compute_new_parametrization(u_normalized, Pts_query);

    % make all parameters scale-independant 
    % (phi and eta are already unitless so we dont have to correct them)
    tau = tau./reshape(repelem(scale, size(Pts_query, 1)), [size(Pts_query, 1) 1 size(scale, 2)]);
    kappa = kappa.*reshape(repelem(scale, size(Pts_query, 1)), [size(Pts_query, 1) 1 size(scale, 2)]);
    
    % remove nan values (if any) and replace them by 0
    tau(isnan(tau)) = 0;
    eta(isnan(eta)) = 0;
    kappa(isnan(kappa)) = 0;
    phi(isnan(phi)) = 0;
    
end

end



