function DuffingSys = setUpDuffing
% setUpDuffing: Set up ODESystem object for the Duffing oscillator with
% fields set to various default values. Default options are split into run
% options, analysis options, and plot options.

DuffingSys = ODESystem;

%% Set essential features %%

DuffingSys.name = 'duffing';
DuffingSys.longName = 'Duffing Oscillator';
DuffingSys.stateVectorDerivative = @duffingStateVectorDerivative;
DuffingSys.stateDerivative = @duffingStateDerivative;
DuffingSys.spatialDimension = 2;
DuffingSys.isPeriodicInX = 0;
DuffingSys.isPeriodicInY = 0;

%% Set default run options %%

% Set default system parameter values
DuffingSys.DefaultRunOptions.Parameters.epsilon = 0.1;
DuffingSys.DefaultRunOptions.Parameters.omega = 1;

% Set default integration options
DuffingSys.DefaultRunOptions.startTime = 0;
DuffingSys.DefaultRunOptions.timeSpan = [-20, 20];
DuffingSys.DefaultRunOptions.outputTimes = [-20, -5, 5, 20];
DuffingSys.DefaultRunOptions.timeStep = 0.01;

% Set default initial state parameter values
DuffingSys.DefaultRunOptions.InitialStateMetadata.xLimits = [-1.7, 1.7];
DuffingSys.DefaultRunOptions.InitialStateMetadata.yLimits = [-1.2, 1.2];
DuffingSys.DefaultRunOptions.InitialStateMetadata.dx = 0.02;
DuffingSys.DefaultRunOptions.InitialStateMetadata.dy = 0.02;

%% Set default analysis options %%

%% Set default plot options %%

DuffingSys.DefaultPlotOptions.xLimits = [-1.7,1.7];
DuffingSys.DefaultPlotOptions.yLimits = [-1.2,1.2];
DuffingSys.DefaultPlotOptions.xLabel = '$x$';
DuffingSys.DefaultPlotOptions.yLabel = '$y$';
DuffingSys.DefaultPlotOptions.plotWindowDimensions = [560, 420];

% % Set maximum speed
% xmax = max(1/sqrt(3), max(abs(ODESys.xPlotLimits)));
% ymax = max(abs(ODESys.yPlotLimits));
% ODESys.maximumSpeed = sqrt((abs(xmax - xmax^3))^2 + (ymax)^2);