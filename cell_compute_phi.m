function phi = cell_compute_phi(u)

% get phi
uc = u(1);
ul = u(2:end-1);
uq = u(end);
phi = ul'*ul - 4*uc*uq;

end

