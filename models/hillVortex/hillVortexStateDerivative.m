function StateDerivative = hillVortexStateDerivative(State, t)
% hillVortexStateDerivative(State, t): Time derivative for Hill's spherical
% vortex. "State" is an object of type SystemState, and output
% "StateDerivative" is a structure with fields matching those of "State"
% (e.g. StateDerivative.dxdt for State.x).

x = State.x;
y = State.y;
z = State.z;
U = State.Parameters.U;
a = State.Parameters.a;

dxdt = -3*U*x.*z/(2*a^2);
dydt = -3*U*y.*z/(2*a^2);
dzdt = 3*U*(2*x.^2 + 2*y.^2 + z.^2 - a^2)/(2*a^2);

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dzdt = dzdt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2 + dzdt.^2);
StateDerivative.dParametersdt.du0dt = 0;
StateDerivative.dParametersdt.dadt = 0;