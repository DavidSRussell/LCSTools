function stateVectorDerivative = datasetStateVectorDerivative( ...
  stateVector, t, StateVectorPrototype, VelocityData, tGridVector, ...
  GridArrays, InterpolationMethods)
% datasetStateVectorDerivative( stateVector, t, StateVectorPrototype,
% VelocityData, tGridVector, GridArrays, InterpolationMethods): Calculate
% state vector derivative by interpolating a velocity dataset. "stateVector"
% and "stateVectorDerivative" are both vectors, with corresponding entries
% matching up.

State = convertVectorToStructure(stateVector, StateVectorPrototype);
StateDerivative = datasetStateDerivative(State, t, VelocityData, tGridVector, GridArrays, InterpolationMethods);
stateVectorDerivative = convertStructureToVector(StateDerivative);