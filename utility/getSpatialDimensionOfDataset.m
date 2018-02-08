function spatialDimension = getSpatialDimensionOfDataset(DS)
% getSpatialDimensionOfDataset(DS): A utility functiont to determine the
% spatial dimension of a dataset from just the velocity data.

dataFileName = DS.fileNames{1};
uInfo = ncinfo(dataFileName, 'u');
dimNames = {uInfo.Dimensions.Name};
spatialDimension = sum(~strcmpi(dimNames,'ocean_time'));