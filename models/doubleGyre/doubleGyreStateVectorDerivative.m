function stateVectorDerivative = doubleGyreStateVectorDerivative( ...
  stateVector, t, StatePrototype)
% doubleGyreStateVectorDerivative(State, t, StatePrototype): Time
% derivative of state vector for the periodically-driven double gyre.
% "stateVector" is a state vector as if converted from a SystemState
% object, and "StatePrototype" is a SystemState object to be used as a
% template for converting the vector back into a SystemState object as
% necessary.

State = convertVectorToStructure(stateVector, StatePrototype);
StateDerivative = doubleGyreStateDerivative(State, t);
stateVectorDerivative = convertStructureToVector(StateDerivative);