zeta1 = ncread('chesroms_his_0840.nc', 'zeta');
zeta2 = ncread('chesroms_his_0841.nc', 'zeta');
zeta3 = ncread('chesroms_his_0842.nc', 'zeta');
zeta4 = ncread('chesroms_his_0843.nc', 'zeta');
zeta5 = ncread('chesroms_his_0844.nc', 'zeta');
zeta6 = ncread('chesroms_his_0845.nc', 'zeta');
zeta7 = ncread('chesroms_his_0846.nc', 'zeta');
zeta8 = ncread('chesroms_his_0847.nc', 'zeta');
zeta = NaN(size(zeta1, 1), size(zeta1, 2), 8*size(zeta1, 3));
L = size(zeta1, 3);
zeta(:, :, 1 : L) = zeta1;
zeta(:, :, L + 1 : 2*L) = zeta2;
zeta(:, :, 2*L + 1 : 3*L) = zeta3;
zeta(:, :, 3*L + 1 : 4*L) = zeta4;
zeta(:, :, 4*L + 1 : 5*L) = zeta5;
zeta(:, :, 5*L + 1 : 6*L) = zeta6;
zeta(:, :, 6*L + 1 : 7*L) = zeta7;
zeta(:, :, 7*L + 1 : 8*L) = zeta8;

figure

for k = 1 : 8*L
  pcolor(zeta(:, :, k)')
  shading flat
  axis equal tight
  caxis([-0.7, 0.7])
  colorbar
  title(sprintf('k = %i', k))
  drawnow
end