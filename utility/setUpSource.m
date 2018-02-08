function Source = setUpSource(name)
% setUpSource(name): Set up ODESystem or Dataset object
% with given name. Acceptable names (so far) are:
%
%   ODE Systems:
%     'linearSystem2D'  General 2D linear system
%     'duffing'         Duffing oscillator
%     'pointVortices'   Point Vortex system (each vortex advects with the flow)
%     'doubleGyre'      Double-gyre
%     'stratosphere'    Idealized stratospheric flow (Bollt and Santitissadeekorn)
%     'hillVortex'      Hill's Spherical Vortex
%     'lorenz3Var'      Lorenz 1963 3-variable system
%
%   Datasets:
%     'chesROMS'        Chesapeake Bay ROMS

switch name
  case 'linearSystem2D'
    Source = setUpLinearSystem2D;
  case 'duffing'
    Source = setUpDuffing;
  case 'pointVortices'
    Source = setUpPointVortices;
  case 'stratosphere'
    Source = setUpStratosphere;
  case 'doubleGyre'
    Source = setUpDoubleGyre;
  case 'hillVortex'
    Source = setUpHillVortex;
  case 'lorenz3Var'
    Source = setUpLorenz3Var;
  case 'chesROMS'
    Source = setUpChesROMS;
end