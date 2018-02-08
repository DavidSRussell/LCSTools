function stateVectorDerivative = duffingStateVectorDerivative(stateVector, ...
  t, StatePrototype)
% duffingStateVectorDerivative(stateVector, t, StatePrototype): Time
% derivative of state vector for the Duffing oscillator. "stateVector" is a
% state vector as if converted from a state structure (SystemState object),
% and "StatePrototype" is a SystemState object to be used as a template for
% converting the vector back into a SystemState as necessary.

State = convertVectorToStructure(stateVector, StatePrototype);
StateDerivative = duffingStateDerivative(State, t);
stateVectorDerivative = convertStructureToVector(StateDerivative);