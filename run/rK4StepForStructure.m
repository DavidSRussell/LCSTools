function NewState = rK4StepForStructure(OldState, t, dt, stateDerivative)
% rK4StepForStructure(OldState, t, dt, stateDerivative): Perform a single
% fourth-order Runge-Kutta step on structure OldState, given structure
% derivative function stateDerivative.

oldStateVector = convertStructureToVector(OldState);

K1Struct = stateDerivative(OldState, t);
k1 = convertStructureToVector(K1Struct);
NextState1 = convertVectorToStructure(oldStateVector + k1*dt/2, OldState);
K2Struct = stateDerivative(NextState1, t + dt/2);
k2 = convertStructureToVector(K2Struct);
NextState2 = convertVectorToStructure(oldStateVector + k2*dt/2, OldState);
K3Struct = stateDerivative(NextState2, t + dt/2);
k3 = convertStructureToVector(K3Struct);
NextState3 = convertVectorToStructure(oldStateVector + k3*dt, OldState);
K4Struct = stateDerivative(NextState3, t + dt);
k4 = convertStructureToVector(K4Struct);

newStateVector = oldStateVector + (k1 + 2*k2 + 2*k3 + k4)/6*dt;
NewState = convertVectorToStructure(newStateVector, OldState);
NewState.m = OldState.m + abs(NewState.m - OldState.m);