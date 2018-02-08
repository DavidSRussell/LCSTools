function plotTwoVorticesManifolds
% Utility function for plotting the 

xGridVec = -3.5 : 0.01 : 3.5;
yGridVec = -3.5 : 0.01 : 3.5;
[X, Y] = meshgrid(xGridVec, yGridVec);

Z = X + Y*1i;

Psi = -2*log(abs(Z.^2 - 1)) + (X.^2 + Y.^2)/2;

Psi2 = Psi;
Psi2(X.^2 + Y.^2 > 4) = NaN;

figure
contour(X, Y, Psi, (-2*log(4)+5/2)*[1, 1], 'k', 'LineWidth', 2)
hold on
contour(X, Y, Psi2, (-2*log(4)+5/2)*[0, 0], 'k', 'LineWidth', 2)
contour(X, Y, Psi, 20, 'k--')
axis equal tight