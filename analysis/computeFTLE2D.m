function Lambda = computeFTLE2D(x0, y0, xf, yf, t0, tf)
% computeFTLE2D: Comput finite-time Lyapunov exponent of a two-dimensional
% flow.
%
% Given a two-dimensional flow of particles with initial positions x0, y0
% and final positions xf, yf over time interval t0 to tf, calculates the
% finite-time Lyapunov exponent for each particle in this flow. Particles
% must be intially laid out in a grid (as if produced by ndgrid) in order
% to calculate finite difference approximations for partial derivatives.
% (Eigenvalue calculation follows Wikipedia article on "Eigenvalue
% Algorithm".)

% Get entries in transition matrix L
a = (xf(3:end,2:end-1) - xf(1:end-2,2:end-1))./(x0(3:end,2:end-1) - x0(1:end-2,2:end-1)); % Transition matrix L:
b = (xf(2:end-1,3:end) - xf(2:end-1,1:end-2))./(y0(2:end-1,3:end) - y0(2:end-1,1:end-2)); %
c = (yf(3:end,2:end-1) - yf(1:end-2,2:end-1))./(x0(3:end,2:end-1) - x0(1:end-2,2:end-1)); %     L = [ a b ]
d = (yf(2:end-1,3:end) - yf(2:end-1,1:end-2))./(y0(2:end-1,3:end) - y0(2:end-1,1:end-2)); %         [ c d ]

% Get eigenvalues
Eig1 = 1/2*(a.^2 + b.^2 + c.^2 + d.^2 + sqrt((a.^2 + b.^2 + c.^2 + d.^2).^2 - 4*(a.*d - b.*c).^2));
Eig2 = 1/2*(a.^2 + b.^2 + c.^2 + d.^2 - sqrt((a.^2 + b.^2 + c.^2 + d.^2).^2 - 4*(a.*d - b.*c).^2));
Eig = max(Eig1,Eig2);

% Get FTLE
Lambda = 1/(2*abs(tf - t0))*log(Eig);