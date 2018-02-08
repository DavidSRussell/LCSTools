function Lorenz3VarSys = setUpLorenz3Var
% setUpLorenz3Var: Set up an ODESystem object for the Lorenz 1963
% 3-variable system, with fields set to various default values.

Lorenz3VarSys = ODESystem;

% Set essential features
Lorenz3VarSys.name = 'lorenz3Var';
Lorenz3VarSys.longName = 'Lorenz 1963 Three-Variable System';
Lorenz3VarSys.stateVectorDerivative = @lorenz3VarStateVectorDerivative;
Lorenz3VarSys.stateDerivative = @lorenz3VarStateDerivative;
Lorenz3VarSys.spatialDimension = 3;
Lorenz3VarSys.isPeriodicInX = 0;
Lorenz3VarSys.isPeriodicInY = 0;
Lorenz3VarSys.isPeriodicInZ = 0;

% Set default parameter values
Lorenz3VarSys.DefaultRunOptions.Parameters.sigma = 10;
Lorenz3VarSys.DefaultRunOptions.Parameters.rho = 28;
Lorenz3VarSys.DefaultRunOptions.Parameters.beta = 8/3;

% Set default integration options
Lorenz3VarSys.DefaultRunOptions.startTime = 0;
Lorenz3VarSys.DefaultRunOptions.timeSpan = [0, 10];
Lorenz3VarSys.DefaultRunOptions.outputTimes = [5, 10];
Lorenz3VarSys.DefaultRunOptions.timeStep = 0.1;

% Set default initial state parameters
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.xLimits = [-25, 25];
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.yLimits = [-25, 25];
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.zLimits = [0, 50];
% Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dx = 0.2;
% Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dy = 0.2;
% Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dz = 0.2;
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dx = 1;
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dy = 1;
Lorenz3VarSys.DefaultRunOptions.InitialStateMetadata.dz = 1;

% Set default plot options
Lorenz3VarSys.DefaultPlotOptions.xLimits = [-25, 25];
Lorenz3VarSys.DefaultPlotOptions.yLimits = [-25, 25];
Lorenz3VarSys.DefaultPlotOptions.zLimits = [0, 50];
Lorenz3VarSys.DefaultPlotOptions.xLabel = '$x$';
Lorenz3VarSys.DefaultPlotOptions.yLabel = '$y$';
Lorenz3VarSys.DefaultPlotOptions.zLabel = '$z$';
Lorenz3VarSys.DefaultPlotOptions.plotWindowDimensions = [560, 420];

% % Set maximum speed
% Lorenz3VarSys.maximumSpeed = 120;