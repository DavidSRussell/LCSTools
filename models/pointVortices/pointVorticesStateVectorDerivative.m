function stateVectorDerivative = pointVorticesStateVectorDerivative(stateVector, t, StatePrototype)
% pointVorticesStateVectorDerivative(State, t, StatePrototype): Time
% derivative of state vector for a system of arbitrarily many point
% vortices. "stateVector" is a state vector as if converted from a
% SystemState object, including dynamic vortex positions as parameters, and
% "StatePrototype" is a SystemState object to be used as a template for
% converting the vector back into a SystemState object as necessary.

State = convertVectorToStructure(stateVector, StatePrototype);
StateDerivative = pointVorticesStateDerivative(State, t);
stateVectorDerivative = convertStructureToVector(StateDerivative);