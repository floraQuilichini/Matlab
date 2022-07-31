function [theta, phi, pts] = sphere_sampling(n_subdiv_theta, n_subdiv_phi, center, radius)
% theta is sampled from 0 to 2pi and phi from 0 to pi
theta_step = 2*pi/n_subdiv_theta;
phi_step = 2*pi/n_subdiv_phi;
theta=0:theta_step:2*pi-theta_step;
phi = 0:phi_step:2*pi-phi_step;

X=center(1)+radius*repelem(cos(theta), length(phi)).*repmat(cos(phi), 1, length(theta));
Y=center(2)+radius*repelem(sin(theta), length(phi)).*repmat(cos(phi), 1, length(theta));
Z= center(3) + radius*repmat(sin(phi), 1, length(theta));
pts = [X; Y; Z]';

figure;
plot3(X, Y, Z);

end

