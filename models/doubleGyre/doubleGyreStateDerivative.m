function StateDerivative = doubleGyreStateDerivative(State, t)
% doubleGyreStateDerivative(State, t): Time derivative for the
% periodically-drive dobule gyre. "State" is an object of type SystemState,
% and output "StateDerivative" is a structure with fields matching those of
% "State" (e.g. StateDerivative.dxdt for State.x).

x = State.x;
y = State.y;
A = State.Parameters.A;
delta = State.Parameters.delta;
omega = State.Parameters.omega;

F = delta*sin(omega*t).*x.^2 + (1 - 2*delta*sin(omega*t)).*x;
dFdx = 2*delta*sin(omega*t)*x + 1 - 2*delta*sin(omega*t);

dxdt = -pi*A*sin(pi*F).*cos(pi*y);
dydt = pi*A*cos(pi*F).*sin(pi*y).*dFdx;

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2);
StateDerivative.dParametersdt.dAdt = 0;
StateDerivative.dParametersdt.ddeltadt = 0;
StateDerivative.dParametersdt.domegadt = 0;