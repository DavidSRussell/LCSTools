function [subVector, inds] = getCoveringSubGridVector(gridVector, valuesToCover)
% getCoveringSubGridVector(gridVector, valuesToCover): For a monotonic grid
% vector, returns a subvector that covers the values in valuesToCover, and
% the indices of this subvector within the main grid vector.

minValue = min(valuesToCover);
maxValue = max(valuesToCover);

if gridVector(2) > gridVector(1)
  ind1 = find(gridVector <= minValue, 1, 'last');
  ind2 = find(gridVector >= maxValue, 1);
elseif gridVector(1) > gridVector(2)
  ind1 = find(gridVector >= maxValue, 1, 'last');
  ind2 = find(gridVector <= minValue, 1);
end

inds = ind1 : ind2;
subVector = gridVector(inds);