function Prototype = generatePrototype(Structure)
% generatePrototype(Structure): Utility for generating a prototypical
% (empty) state structure with fields and array sizes matching the input
% structure.

Prototype = Structure;
fields = fieldnames(Structure);
for i = 1:length(fields)
  if isstruct(Structure.(fields{i}))
    Prototype.(fields{i}) = generatePrototype(Structure.(fields{i}));
  else
    Prototype.(fields{i}) = NaN(size(Structure.(fields{i})));
  end
end