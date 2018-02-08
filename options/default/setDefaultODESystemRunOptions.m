function RunOpts = setDefaultODESystemRunOptions(ODESys)
% setDefaultODESystemRunOptions(ODESys): Set default options for a run of
% computeTrajectories on an ODE System, based on "ODESys", which is an
% object of type ODESystem.

RunOpts = ODESys.DefaultRunOptions;

RunOpts.integrationMethod = 'rk4';