function StateDerivative = duffingStateDerivative(State, t)
% duffingStateDerivative(State, t): Time derivative for the Duffing
% oscillator. "State" is an object of type SystemState, and
% "StateDerivative" is a structure with fields matching those of "State".

x = State.x;
y = State.y;
eps = State.Parameters.epsilon;
omega = State.Parameters.omega;

dxdt = y;
dydt = x - x.^3 + eps*sin(omega*t);

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2);
StateDerivative.dParametersdt.depsilondt = 0;
StateDerivative.dParametersdt.domegadt = 0;