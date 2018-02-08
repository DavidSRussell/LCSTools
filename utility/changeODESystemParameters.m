function ODESys = changeODESystemParameters(ODESys, NewParameters)
% changeODESystemParameters(ODESys, NewParameters): Utility function for
% changing the parameters in an ODESystem object.

Params = ODESys.Parameters;
fields = fieldnames(NewParameters);
for i = 1 : length(fields)
  Params.(fields{i}) = NewParameters.(fields{i});
end
ODESys.Parameters = Params;