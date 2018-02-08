function StateDerivative = stratosphereStateDerivative(State, t)
% stratosphereStateDerivative(State, t): Time derivative for an idealized
% stratospheric flow. "State" is an object of type SystemState, and output
% "StateDerivative" is a structure with fields matching those of "State"
% (e.g. StateDerivative.dxdt for State.x).

x = State.x;
y = State.y;
U0 = State.Parameters.U0;
L = State.Parameters.L;
c2 = State.Parameters.c2;
c3 = State.Parameters.c3;
A1 = State.Parameters.A1;
A2 = State.Parameters.A2;
A3 = State.Parameters.A3;
k1 = State.Parameters.k1;
k2 = State.Parameters.k2;
k3 = State.Parameters.k3;

sigma2 = k2*(c2 - c3);
sigma1 = sigma2*(sqrt(5) - 1); % NOTE: (sqrt(5) - 1)/2 is the incorrect value quoted in the literature
dxdt = -c3 + U0*sech(y/L).^2.*(1 + 2*tanh(y/L).*(A3*cos(k3*x) ...
    + A2*cos(k2*x - sigma2*t) + A1*cos(k1*x - sigma1*t)));
dydt = -U0*L*sech(y/L).^2.*(k3*A3*sin(k3*x) ...
    + k2*A2*sin(k2*x - sigma2*t) + k1*A1*sin(k1*x - sigma1*t));

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2);
StateDerivative.dParametersdt.dU0dt = 0;
StateDerivative.dParametersdt.dLdt = 0;
StateDerivative.dParametersdt.dc2dt = 0;
StateDerivative.dParametersdt.dc3dt = 0;
StateDerivative.dParametersdt.dA1dt = 0;
StateDerivative.dParametersdt.dA2dt = 0;
StateDerivative.dParametersdt.dA3dt = 0;
StateDerivative.dParametersdt.dk1dt = 0;
StateDerivative.dParametersdt.dk2dt = 0;
StateDerivative.dParametersdt.dk3dt = 0;