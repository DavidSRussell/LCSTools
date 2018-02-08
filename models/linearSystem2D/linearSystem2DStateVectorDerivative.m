function stateVectorDerivative = linearSystem2DStateVectorDerivative( ...
  stateVector, t, StatePrototype)
% linearSystem2DStateVectorDerivative(State, t, StatePrototype): Time
% derivative of state vector for a general 2D linear system. "stateVector"
% is a state vector as if converted from a SystemState object, and
% "StatePrototype" is a SystemState object to be used as a template for
% converting the vector back into a SystemState object as necessary.

State = convertVectorToStructure(stateVector, StatePrototype);
StateDerivative = linearSystem2DStateDerivative(State, t);
stateVectorDerivative = convertStructureToVector(StateDerivative);