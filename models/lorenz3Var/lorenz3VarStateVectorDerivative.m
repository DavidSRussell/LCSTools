function stateVectorDerivative = lorenz3VarStateVectorDerivative( ...
  stateVector, t, StatePrototype)
% lorenz3VarStateVectorDerivative(State, t, StatePrototype): Time
% derivative of state vector for the Lorenz 1963 3-variable system.
% "stateVector" is a state vector as if converted from a SystemState
% object, and "StatePrototype" is a SystemState object to be used as a
% template for converting the vector back into a SystemState object as
% necessary.

State = convertVectorToStructure(stateVector, StatePrototype);
StateDerivative = lorenz3VarStateDerivative(State, t);
stateVectorDerivative = convertStructureToVector(StateDerivative);