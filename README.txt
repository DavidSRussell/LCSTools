LCSTools README (updated 2/1/2018)

By:
David Russell
(240) 997-1091
davidscottrussell@gmail.com

======

GETTING STARTED

To get started with LCSTools, navigate to the LCSTools directory and run the script setUpLCSTools. This will make sure that all relevant subdirectories are added to the MATLAB path.

=====

INTRODUCTION

In LCSTools, a Lagrangian analysis is split into three steps: 1) compute tracer trajectories through the flow, 2) apply some analysis of the resulting system states, and 3) plot the fields resulting from this analysis.

1. To compute trajectories:

a) Choose an ODE System or Dataset from the following options:

     2D ODE Systems:
       'doubleGyre'      Double-gyre
       'duffing'         Duffing oscillator
       'linearSystem2D'  General 2D linear system
       'pointVortices'   Point Vortex system (each vortex advects with the flow)
       'stratosphere'    Idealized stratospheric flow (Bollt and Santitissadeekorn)

     3D ODE Systems:
       'hillVortex'      Hill's Spherical Vortex
       'lorenz3Var'      Lorenz 1963 3-variable system
  
     Datasets:
       'chesROMS'        Chesapeake Bay ROMS

Relevant information on these velocity field sources can be found in the directories models/ and datasets/.

b) Any desired changes to the default run options for the chosen system or dataset can be entered into the file /options/changeRunOptions.m. This includes options for the system parameters, the integration parameters, and the initial state. The default options will mostly be found in the aforementioned directories models/ and datasets/,  with a few additional settings in options/default/.

c) Run the function computeTrajectories with the system or dataset name as the argument (for example, computeTrajectories(‘duffing’). The output from this function will be a .mat file containing all relevant information from the run, stored in directory /output/.

2. To analyze the states put out by computeTrajectories:

a) Make any desired changes to the default analysis options by entering them in the file /options/changeAnalysisOptions.m. This includes a choice of which Lagrangian fields to obtain, as well as transition matrix parameters if the coherent set method is used. Default options are mostly set in /options/default/ but some may also be attached to the ODE system or dataset itself (in /models/ or /datasets/).

b) Run the function analyzeStates with the output .mat file from computeTrajectories as input. For example, if computeTrajectories put out the following string:

‘duffing_-20to20_run_20171006T172812.mat’,

run the command:

analyzeStates(‘duffing_-20to20_run_20171006T172812.mat’).

The output will again be a .mat file containing all relevant information for plotting.

3. To plot the Lagrangian fields:

a) Change any default plot options in /options/changePlotOptions.m, including axis limits and labels, colormap, 3D plot types, 3D view angles, and many others. Default options can be found in directories /models/ or /datasets/ and /options/default.

b) Run the function plotFields with the .mat file name put out by analyzeStates as argument. Plots will be produced and (optionally) saved to the /output/ directory.

A few additional visualization options exist outside this normal workflow. Like plotFields, these will also incorporate any options set in changePlotOptions.m:

- Direct ``spaghetti’’ plots of trajectories can be produced by running plotTrajectories with the output file name from computeTrajectories as argument.

- Trajectories can be animated by running animateTrajectories with the output file name from computeTrajectories as argument (to get smooth animations, make sure that ‘RunOpts.outputTimes’ contains each desired time).

- Lagrangian fields can also be animated by running animateFields with the output file name from analyzeStates as argument.

- Forward and backward FTLE plots can be cut off at some threshold and the resulting manifolds overlaid by calling combineFTLEPlots with the appropriate figures and thresholds as arguments.

- combineMPlots is similar to combineFTLEPlots but adds two M-function plots directly (no thresholding), since this still has a physical meaning.

New ODE systems and datasets can be incorporated by adding the appropriate directories and files to /models/ or /datasets/, following the format of the existing systems, and adding the name as a new option in setUpSource.m.

When storing multidimensional data, LCSTools uses the convention (as in the ChesROMS dataset) that the order of dimensions follows the typical ordering of variables, i.e. $x$ increases along the first dimension, $y$ along the second, $z$ along the third, and $t$ along the fourth when applicable. This conflicts with the convention used by many of MATLAB's plotting functions (e.g. pcolor) but LCSTools' plotting utilities will temporarily swap dimensions to produce correct plots.