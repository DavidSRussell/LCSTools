function [RunOpts, InitialState] = changeRunOptions(RunOpts, InitialState)
% changeRunOptions(RunOpts, InitialState): Change run options (including
% parameter values) and from the default values set in file
% 'setDefaultRunOptions.m'. For dynamic parameters, the values entered
% below will be initial values.

%% Change integration options
%
% RunOpts.startTime =
% RunOpts.timeSpan =
% RunOpts.timeStep =
% RunOpts.outputTimes =
% RunOpts.integrationMethod =

%% Change dataset-specific run options
%
% RunOpts.startFileName =
% RunOpts.horizontalInterpolationMethod =
% RunOpts.verticalInterpolationMethod =
% RunOpts.temporalInterpolationMethod =

%% Change parameters of initial state grid...
%
% RunOpts.InitialStateMetadata.xLimits =
% RunOpts.InitialStateMetadata.yLimits =
% RunOpts.InitialStateMetadata.zLimits =
% RunOpts.InitialStateMetadata.dx =
% RunOpts.InitialStateMetadata.dy =
% RunOpts.InitialStateMetadata.dz =

%% ...or set initial state directly if not a grid
%
% RunOpts.InitialState.x =
% RunOpts.InitialState.y =
% RunOpts.InitialState.z =
% RunOpts.InitialState.m =

%% Change system parameter values
%
% Double Gyre:
% RunOpts.Parameters.A =
% RunOpts.Parameters.delta =
% RunOpts.Parameters.omega =
%
% Duffing:
% RunOpts.Parameters.epsilon =
% RunOpts.Parameters.omega =
%
% 2D Linear System:
% RunOpts.Parameters.a =
% RunOpts.Parameters.b =
% RunOpts.Parameters.c =
% RunOpts.Parameters.d =
%
% Point vortices:
% RunOpts.Parameters.gammas =
% RunOpts.Parameters.xVortices =
% RunOpts.Parameters.yVortices =
%
% Idealized stratospheric flow:
% R_E = 6.371
% U0 = 62.66*86400e-6; % Mm/day
% RunOpts.Parameters.U0 =
% RunOpts.Parameters.L =
% RunOpts.Parameters.c2 =
% RunOpts.Parameters.c3 =
% RunOpts.Parameters.A1 =
% RunOpts.Parameters.A2 =
% RunOpts.Parameters.A3 =
% RunOpts.Parameters.k1 =
% RunOpts.Parameters.k2 =
% RunOpts.Parameters.k3 =
%
% Hill Vortex:
% RunOpts.Parameters.U =
% RunOpts.Parameters.a =
%
% Lorenz 1963 3-variable system:
% RunOpts.Parameters.sigma =
% RunOpts.Parameters.rho =
% RunOpts.Parameters.beta =