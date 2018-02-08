function ChesROMSDS = setUpChesROMS
% setUpChesROMS: Set up the ChesROMS dataset for the computeTrajectories
% function.

% Set essential dataset features
ChesROMSDS = Dataset;
ChesROMSDS.name = 'chesROMS';
ChesROMSDS.longName = 'Chesapeake Bay ROMS';
ChesROMSDS.fileFormat = 'netcdf';
global rootDirectory
ChesROMSDS.dataDirectory = [rootDirectory, '/datasets/chesROMS/data'];
ChesROMSDS.spatialDimension = 3;
ChesROMSDS.tVariable = 'ocean_time';
ChesROMSDS.getPhysicalPositionsFunction = @getPhysicalPositionsChesROMS;

% Set file names
%nFilesFwd = 3;
nFilesFwd = 1;
nFilesBwd = 0;
fileNames = cell(1, nFilesBwd + 1 + nFilesFwd);
for i = 0 : nFilesFwd
  fileNames{nFilesBwd + 1 + i} = ['chesroms_his_0', num2str(840 + i), '.nc'];
end
for i = 1 : nFilesBwd
  fileNames{nFilesBwd + 1 - i} = ['chesroms_his_0', num2str(840 - i), '.nc'];
end
ChesROMSDS.fileNames = fileNames;

% Set default integration options
ChesROMSDS.DefaultRunOptions.startTime = 3024000; % 'ocean_time' value
ChesROMSDS.DefaultRunOptions.timeStep = 300;
ChesROMSDS.DefaultRunOptions.timeSpan = [3024000, 3024000 + 900];
ChesROMSDS.DefaultRunOptions.outputTimes = 3024000 + 900;
ChesROMSDS.DefaultRunOptions.integrationMethod = 'rk4';

% Set dataset-specific options
ChesROMSDS.DefaultRunOptions.startFileName = 'chesroms_his_0840.nc';
ChesROMSDS.DefaultRunOptions.horizontalInterpolationMethod = 'bilinear';
ChesROMSDS.DefaultRunOptions.verticalInterpolationMethod = 'linear';
ChesROMSDS.DefaultRunOptions.temporalInterpolationMethod = 'linear';

% Set initial state parameter values
% ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dx = 1;
% ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dy = 1;
% ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dz = 0.025;
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dx = 5;
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dy = 5;
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.dz = 0.025;
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.xLimits = [0, 149];
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.yLimits = [0, 479];
ChesROMSDS.DefaultRunOptions.InitialStateMetadata.zLimits = [-1, 0];
    
% Set default grid-space plot options
ChesROMSDS.DefaultGridSpacePlotOptions.xLimits = [0, 149];
ChesROMSDS.DefaultGridSpacePlotOptions.yLimits = [0, 479];
ChesROMSDS.DefaultGridSpacePlotOptions.zLimits = [-1, 0];
ChesROMSDS.DefaultGridSpacePlotOptions.xLabel = '$\xi$';
ChesROMSDS.DefaultGridSpacePlotOptions.yLabel = '$\eta$';
ChesROMSDS.DefaultGridSpacePlotOptions.zLabel = '$\sigma$';
ChesROMSDS.DefaultGridSpacePlotOptions.plotWindowDimensions = [560, 420];
ChesROMSDS.DefaultGridSpacePlotOptions.dataAspectRatio3D = [50, 50, 1];

% Set default analysis options
ChesROMSDS.DefaultAnalysisOptions.TransitionMatrixOptions.particleDimensionsPerGridBox = [5, 5, 5];

% Set default physical-space plot options (longitude, latitude, depth in meters)
ChesROMSDS.DefaultPhysicalSpacePlotOptions.xLimits = [-77.5, -74.5];
ChesROMSDS.DefaultPhysicalSpacePlotOptions.yLimits = [35, 40];
ChesROMSDS.DefaultPhysicalSpacePlotOptions.zLimits = [-50, 5];
ChesROMSDS.DefaultPhysicalSpacePlotOptions.xLabel = '$\lambda$';
ChesROMSDS.DefaultPhysicalSpacePlotOptions.yLabel = '$\phi$';
ChesROMSDS.DefaultPhysicalSpacePlotOptions.zLabel = '$z$ (m)';
ChesROMSDS.DefaultPhysicalSpacePlotOptions.plotWindowDimensions = [560, 420];
ChesROMSDS.DefaultPhysicalSpacePlotOptions.dataAspectRatio3D = [1, 1, 50];
ChesROMSDS.DefaultPhysicalSpacePlotOptions.viewAngle3D = [-27.5, 33.2];