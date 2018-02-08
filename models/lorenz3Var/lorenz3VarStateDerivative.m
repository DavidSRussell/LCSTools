function StateDerivative = lorenz3VarStateDerivative(State, t)
% lorenz3VarStateDerivative(State, t): Time derivative for the Lorenz 1963
% 3-variable system. "State" is an object of type SystemState, and output
% "StateDerivative" is a structure with fields matching those of "State"
% (e.g. StateDerivative.dxdt for State.x).

x = State.x;
y = State.y;
z = State.z;
sigma = State.Parameters.sigma;
rho = State.Parameters.rho;
beta = State.Parameters.beta;

dxdt = sigma*(y - x);
dydt = x.*(rho - z) - y;
dzdt = x.*y - beta*z;

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dzdt = dzdt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2 + dzdt.^2);
StateDerivative.dParametersdt.dsigmadt = 0;
StateDerivative.dParametersdt.drhodt = 0;
StateDerivative.dParametersdt.dbetadt = 0;