function newStateVector = rK4Step(oldStateVector, t, dt, stateVectorDerivative)
% rK4Step(oldStateVector, t, dt, stateVectorDerivative): Performs a single
% fourth-order Runge-Kutta step on oldStateVector with derivative function
% stateVectorDerivative.

k1 = stateVectorDerivative(oldStateVector, t);
k2 = stateVectorDerivative(oldStateVector + k1*dt/2, t + dt/2);
k3 = stateVectorDerivative(oldStateVector + k2*dt/2, t + dt/2);
k4 = stateVectorDerivative(oldStateVector + k3*dt, t + dt);

newStateVector = oldStateVector + (k1 + 2*k2 + 2*k3 + k4)/6*dt;