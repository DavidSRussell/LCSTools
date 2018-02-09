function StratSys = setUpStratosphere
% setUpStratosphere: Set up an ODESystem object for idealized stratospheric
% flow, with fields (including parameters) set to various default values.
% Default options are split into run options, analysis options, and plot
% options.

global earthRadiusInMm % Earth radius in megameters
R_E = earthRadiusInMm;

StratSys = ODESystem;

%% Set essential features %%

StratSys.name = 'stratosphere';
StratSys.longName = 'Idealized Stratospheric Flow';
StratSys.stateVectorDerivative = @stratosphereStateVectorDerivative;
StratSys.stateDerivative = @stratosphereStateDerivative;
StratSys.spatialDimension = 2;
StratSys.isPeriodicInX = 1;
StratSys.isPeriodicInY = 0;
StratSys.xBounds = [0, R_E*pi]; % Mm
StratSys.yBounds = [-4, 4]; % Mm

%% Set default run options %%

% Set default parameter values
U0 = 62.66*86400e-6; % Mm/day
StratSys.DefaultRunOptions.Parameters.U0 = U0;
StratSys.DefaultRunOptions.Parameters.L = 1.77; % Mm
StratSys.DefaultRunOptions.Parameters.c2 = 0.205*U0;
StratSys.DefaultRunOptions.Parameters.c3 = 0.7*U0; % alternate: 0.6*U0
StratSys.DefaultRunOptions.Parameters.A1 = 0.075;
StratSys.DefaultRunOptions.Parameters.A2 = 0.4;
StratSys.DefaultRunOptions.Parameters.A3 = 0.2; % or 0.2
StratSys.DefaultRunOptions.Parameters.k1 = 2/R_E; % 1/Mm
StratSys.DefaultRunOptions.Parameters.k2 = 4/R_E;
StratSys.DefaultRunOptions.Parameters.k3 = 6/R_E;

% Set default integration options
StratSys.DefaultRunOptions.startTime = 20; % days
StratSys.DefaultRunOptions.timeSpan = [20, 30]; % days
StratSys.DefaultRunOptions.outputTimes = 30; % days
% StratSys.DefaultRunOptions.timeStep = 0.1; % days
StratSys.DefaultRunOptions.timeStep = 0.5; % days

% Set default initial state parameters
% StratSys.DefaultRunOptions.InitialState.xLimits = ...
%   [StratSys.DefaultRunOptions.dxInitialConditions/2, R_E*pi]; % Mm
% StratSys.DefaultRunOptions.InitialState.yLimits = ...
%   [-2.5 - 2*StratSys.DefaultRunOptions.dyInitialConditions, ...
%   2.5 + 2.001*StratSys.DefaultRunOptions.dyInitialConditions]; % Mm
StratSys.DefaultRunOptions.InitialStateMetadata.xLimits = [0, R_E*pi]; % Mm
StratSys.DefaultRunOptions.InitialStateMetadata.yLimits = [-2.5, 2.5]; % Mm
% StratSys.DefaultRunOptions.InitialStateMetadata.dx = R_E*pi/300/20; % Mm
% StratSys.DefaultRunOptions.InitialStateMetadata.dy = 16/300/20; % Mm
StratSys.DefaultRunOptions.InitialStateMetadata.dx = 0.01; % Mm
StratSys.DefaultRunOptions.InitialStateMetadata.dy = 0.01; % Mm

%% Set default analysis options %%

StratSys.DefaultAnalysisOptions.TransitionMatrixOptions.xLimFinal = [0, R_E*pi];
StratSys.DefaultAnalysisOptions.TransitionMatrixOptions.yLimFinal = [-4, 4];

%% Set default plot options %%

StratSys.DefaultPlotOptions.xLimits = [0, R_E*pi]; % Mm
StratSys.DefaultPlotOptions.yLimits = [-4, 4]; % Mm
StratSys.DefaultPlotOptions.xLabel = 'Mm';
StratSys.DefaultPlotOptions.yLabel = 'Mm';
StratSys.DefaultPlotOptions.plotWindowDimensions = [400, 170];