function x_nPlus1 = milneHammingStep(x_n, x_nMinus1, x_nMinus2, ...
  x_nMinus3, t_n, dt, derivFunc)
% x_nPlus1 = milneHammingStep(x_n, x_nMinus1, x_nMinus2, x_nMinus3,t, dt,
% derivFunc): Performs a single Milne-Hamming step on vector x_n with
% derivative function derivFunc. Milne-Hamming is a fourth-order
% predictor-corrector method using Milne for the predictor and Hamming for
% the corrector.
%
% I am assuming times are equally-spaced. Can Milne-Hamming be used
% otherwise?

% Predictor
xHat_nPlus1 = x_nMinus3 + 4*dt/3*(2*derivFunc(x_n, t_n) - ...
  derivFunc(x_nMinus1, t_n - dt) + 2*derivFunc(x_nMinus2, t_n - 2*dt));

% Corrector
x_nPlus1 = 9/8*x_n - 1/8*x_nMinus2 + 3*dt/8*(derivFunc(xHat_nPlus1, ...
  t_n + dt) + 2*derivFunc(x_n, t_n) - derivFunc(x_nMinus1, t_n - dt));