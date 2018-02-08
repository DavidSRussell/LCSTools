function PointVorticesSys = setUpPointVortices
% setUpPointVortices: Set up an ODESystem object for a system of
% arbitrarily many point vortices, with fields (including vortex strengths
% and positions) set to various default values.

PointVorticesSys = ODESystem;

% Set essential features
PointVorticesSys.name = 'pointVortices';
PointVorticesSys.longName = 'Point Vortex System';
PointVorticesSys.stateVectorDerivative = @pointVorticesStateVectorDerivative;
PointVorticesSys.stateDerivative = @pointVorticesStateDerivative;
PointVorticesSys.spatialDimension = 2;
PointVorticesSys.isPeriodicInX = 0;
PointVorticesSys.isPeriodicInY = 0;

% Set default parameter values
PointVorticesSys.DefaultRunOptions.Parameters.gammas = [10, 10];
PointVorticesSys.DefaultRunOptions.Parameters.xVortices = [1, -1];
PointVorticesSys.DefaultRunOptions.Parameters.yVortices = [0, 0];

% Set default integration options
PointVorticesSys.DefaultRunOptions.startTime = 0;
PointVorticesSys.DefaultRunOptions.timeSpan = [0, 25];
PointVorticesSys.DefaultRunOptions.outputTimes = [10, 25];
PointVorticesSys.DefaultRunOptions.timeStep = 0.01;

% Set default initial state parameters
PointVorticesSys.DefaultRunOptions.InitialStateMetadata.xLimits = [-3.5, 3.5];
PointVorticesSys.DefaultRunOptions.InitialStateMetadata.yLimits = [-3.5, 3.5];
PointVorticesSys.DefaultRunOptions.InitialStateMetadata.dx = 0.05;
PointVorticesSys.DefaultRunOptions.InitialStateMetadata.dy = 0.05;

% Set default plot options
PointVorticesSys.DefaultPlotOptions.xLimits = [-3.5, 3.5];
PointVorticesSys.DefaultPlotOptions.yLimits = [-3.5, 3.5];
PointVorticesSys.DefaultPlotOptions.xLabel = '$x$';
PointVorticesSys.DefaultPlotOptions.yLabel = '$y$';
PointVorticesSys.DefaultPlotOptions.plotWindowDimensions = [560, 420];