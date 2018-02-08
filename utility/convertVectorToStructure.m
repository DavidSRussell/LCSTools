function [StateStructure, nScalars] = convertVectorToStructure(stateVector, StatePrototype)
% convertVectorToStructure(stateVector, StatePrototype): Convert state
% vector to state structure modeled on structure StatePrototype, and
% assuming alphabetical ordering of fields in stateVector, as accomplished
% by convertStructureToVector. All field values in StateStructure will be
% either numerical arrays or (sub-)structures with this same property.
% Warning: allows extra (unused) entries at end of vector for ease of
% recursion.

fields = sort(fieldnames(StatePrototype));
StateStructure = StatePrototype; % copies all info

j = 1;

for i = 1 : length(fields)
  if isstruct(StatePrototype.(fields{i}))
    [StateStructure.(fields{i}), n] = convertVectorToStructure(stateVector(j : end), StatePrototype.(fields{i}));
  else
    n = numel(StateStructure.(fields{i}));
    StateStructure.(fields{i}) = reshape(stateVector(j : j + n - 1), size(StatePrototype.(fields{i})));
  end
  j = j + n;
end

nScalars = j - 1;