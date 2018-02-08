function LinearSys2D = setUpLinearSystem2D
% setUpLinearSystem2D: Set up an ODESystem object for a general 2D linear
% ODE system, with fields set to various default values.

LinearSys2D = ODESystem;

% Set essential features
LinearSys2D.name = 'linearSystem2D';
LinearSys2D.longName = 'Two-Dimensional Linear System';
LinearSys2D.stateVectorDerivative = @linearSystem2DStateVectorDerivative;
LinearSys2D.stateDerivative = @linearSystem2DStateDerivative;
LinearSys2D.spatialDimension = 2;
LinearSys2D.isPeriodicInX = 0;
LinearSys2D.isPeriodicInY = 0;

% Set default parameter values
LinearSys2D.DefaultRunOptions.Parameters.a = 1;
LinearSys2D.DefaultRunOptions.Parameters.b = 2;
LinearSys2D.DefaultRunOptions.Parameters.c = 3;
LinearSys2D.DefaultRunOptions.Parameters.d = 4;

% Set default integration options
LinearSys2D.DefaultRunOptions.startTime = 0;
LinearSys2D.DefaultRunOptions.timeSpan = [-10, 10];
LinearSys2D.DefaultRunOptions.outputTimes = [-10, 10];
LinearSys2D.DefaultRunOptions.timeStep = 0.01;

% Set default initial state parameters
LinearSys2D.DefaultRunOptions.InitialStateMetadata.xLimits = [-1, 1];
LinearSys2D.DefaultRunOptions.InitialStateMetadata.yLimits = [-1, 1];
LinearSys2D.DefaultRunOptions.InitialStateMetadata.dx = 0.01;
LinearSys2D.DefaultRunOptions.InitialStateMetadata.dy = 0.01;

% Set default plot options
LinearSys2D.DefaultPlotOptions.xLimits = [-1, 1];
LinearSys2D.DefaultPlotOptions.yLimits = [-1, 1];
LinearSys2D.DefaultPlotOptions.xLabel = '$x$';
LinearSys2D.DefaultPlotOptions.yLabel = '$y$';
LinearSys2D.DefaultPlotOptions.plotWindowDimensions = [560, 420];