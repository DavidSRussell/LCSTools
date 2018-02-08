function stateVector = convertStructureToVector(StateStructure)
% convertStructureToVector(StateStructure): Convert state structure to
% state vector using alphabetical ordering of fields. All field values in
% StateStructure must be either numerical arrays or structures with this
% same property.

fields = sort(fieldnames(StateStructure));
stateVector = [];
for i = 1 : length(fields)
  if isstruct(StateStructure.(fields{i}))
    nextPart = convertStructureToVector(StateStructure.(fields{i}));
  else
    nextPart = StateStructure.(fields{i})(:);
  end
  stateVector = [stateVector; nextPart];
end