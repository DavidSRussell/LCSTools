function StateDerivative = linearSystem2DStateDerivative(State, t)
% linearSystem2DStateDerivative(State, t): Time derivative for a general 2D
% linear system. "State" is an object of type SystemState, and output
% "StateDerivative" is a structure with fields matching those of "State"
% (e.g. StateDerivative.dxdt for State.x).

x = State.x;
y = State.y;
a = State.Parameters.a;
b = State.Parameters.b;
c = State.Parameters.c;
d = State.Parameters.d;

dxdt = a*x + b*y;
dydt = c*x + d*y;

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2);
StateDerivative.dParametersdt.dadt = 0;
StateDerivative.dParametersdt.dbdt = 0;
StateDerivative.dParametersdt.dcdt = 0;
StateDerivative.dParametersdt.dddt = 0;