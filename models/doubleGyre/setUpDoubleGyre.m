function DoubleGyreSys = setUpDoubleGyre
% setUpDoubleGyre: Set up an ODESystem object for the periodically-driven
% double gyre, with fields set to various default values. Default options
% are split into run options, analysis options, and plot options.

DoubleGyreSys = ODESystem;

%% Set essential features %%

DoubleGyreSys.name = 'doubleGyre';
DoubleGyreSys.longName = 'Periodically Driven Double Gyre';
DoubleGyreSys.stateVectorDerivative = @doubleGyreStateVectorDerivative;
DoubleGyreSys.stateDerivative = @doubleGyreStateDerivative;
DoubleGyreSys.spatialDimension = 2;
DoubleGyreSys.isPeriodicInX = 0;
DoubleGyreSys.isPeriodicInY = 0;

%% Set default run options %%

% Set default system parameter values
DoubleGyreSys.DefaultRunOptions.Parameters.A = 0.25;
DoubleGyreSys.DefaultRunOptions.Parameters.delta = 0.25;
DoubleGyreSys.DefaultRunOptions.Parameters.omega = 2*pi;

% Set default integration options
DoubleGyreSys.DefaultRunOptions.startTime = 0;
DoubleGyreSys.DefaultRunOptions.timeSpan = [-10, 10];
DoubleGyreSys.DefaultRunOptions.outputTimes = [-10, -5, 5, 10];
DoubleGyreSys.DefaultRunOptions.timeStep = 0.01;

% Set default initial state parameter values
DoubleGyreSys.DefaultRunOptions.InitialStateMetadata.xLimits = [0, 2];
DoubleGyreSys.DefaultRunOptions.InitialStateMetadata.yLimits = [0, 1];
DoubleGyreSys.DefaultRunOptions.InitialStateMetadata.dx = 0.01;
DoubleGyreSys.DefaultRunOptions.InitialStateMetadata.dy = 0.01;

%% Set default analysis options %%

%% Set default plot options %%

DoubleGyreSys.DefaultPlotOptions.xLimits = [0, 2];
DoubleGyreSys.DefaultPlotOptions.yLimits = [0, 1];
DoubleGyreSys.DefaultPlotOptions.xLabel = '$x$';
DoubleGyreSys.DefaultPlotOptions.yLabel = '$y$';
DoubleGyreSys.DefaultPlotOptions.plotWindowDimensions = [430, 195];