function setUpLCSTools
% setUpLCSTools: Set up the LCSTools package, most importantly by setting
% the root directory and paths.

global rootDirectory
[rootDirectory, ~, ~] = fileparts(mfilename('fullpath'));
addpath(genpath(rootDirectory))

global outputDirectory
outputDirectory = [rootDirectory, '/output'];

global earthRadiusInMm
earthRadiusInMm = 6.371;

set(0, 'defaulttextinterpreter', 'latex')