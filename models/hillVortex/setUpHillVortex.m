function HillVortexSys = setUpHillVortex
% setUpHillVortex: Set up an ODESystem object for Hill's spherical vortex,
% with fields set to various default values.

HillVortexSys = ODESystem;

% Set essential features
HillVortexSys.name = 'hillVortex';
HillVortexSys.longName = 'Hill''s Spherical Vortex';
HillVortexSys.stateVectorDerivative = @hillVortexStateVectorDerivative;
HillVortexSys.stateDerivative = @hillVortexStateDerivative;
HillVortexSys.spatialDimension = 3;
HillVortexSys.isPeriodicInX = 0;
HillVortexSys.isPeriodicInY = 0;
HillVortexSys.isPeriodicInZ = 0;

% Set default parameter values
HillVortexSys.DefaultRunOptions.Parameters.U = 1;
HillVortexSys.DefaultRunOptions.Parameters.a = 1;

% Set default integration options
HillVortexSys.DefaultRunOptions.startTime = 0;
HillVortexSys.DefaultRunOptions.timeSpan = [0, 10];
HillVortexSys.DefaultRunOptions.outputTimes = [5, 10];
HillVortexSys.DefaultRunOptions.timeStep = 0.1;

% Set default initial state parameter values
HillVortexSys.DefaultRunOptions.InitialStateMetadata.xLimits = [-2, 2];
HillVortexSys.DefaultRunOptions.InitialStateMetadata.yLimits = [-2, 2];
HillVortexSys.DefaultRunOptions.InitialStateMetadata.zLimits = [-2, 2];
% HillVortexSys.DefaultRunOptions.InitialStateMetadata.dx = 0.025;
% HillVortexSys.DefaultRunOptions.InitialStateMetadata.dy = 0.025;
% HillVortexSys.DefaultRunOptions.InitialStateMetadata.dz = 0.025;
HillVortexSys.DefaultRunOptions.InitialStateMetadata.dx = 0.05;
HillVortexSys.DefaultRunOptions.InitialStateMetadata.dy = 0.05;
HillVortexSys.DefaultRunOptions.InitialStateMetadata.dz = 0.05;

% Set default plot options
HillVortexSys.DefaultPlotOptions.xLimits = [-2, 2];
HillVortexSys.DefaultPlotOptions.yLimits = [-2, 2];
HillVortexSys.DefaultPlotOptions.zLimits = [-2, 2];
HillVortexSys.DefaultPlotOptions.xLabel = '$x$';
HillVortexSys.DefaultPlotOptions.yLabel = '$y$';
HillVortexSys.DefaultPlotOptions.zLabel = '$z$';
HillVortexSys.DefaultPlotOptions.plotWindowDimensions = [560, 420];

% % Set maximum speed
% HillVortexSys.maximumSpeed = 3/2*HillVortexSys.Parameters.U;