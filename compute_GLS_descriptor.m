function [tau, eta, kappa, phi] = compute_GLS_descriptor(pt, scale, Pts, Normals)

display(scale)

% get u
[uc, ul, uq, phi] = compute_u_and_phi(Pts, Normals, pt, scale);

% normalize u
u = [uc, ul, uq];
[u_normalized, pratt_norm] = normalize_u(u);

% reparametrize su
[tau, eta, kappa, su_nx] = compute_new_parametrization(u_normalized, pt);

% make all parameters scale-independant 
% (phi and eta are already unitless so we dont have to correct them)
tau = tau/scale;
kappa = kappa*scale;

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

end

