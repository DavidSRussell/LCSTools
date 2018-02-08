function thinnedFile = thinRunOutputFile(runOutputFile, newOutputTimes)
% thinRunOutputFile(runOutputFile, outputTimes): Takes a .mat file name put out from the computeTrajectories function 

load(runOutputFile)

thinnedFile = [runOutputFile, '_thinned'];
save(thinnedFile)