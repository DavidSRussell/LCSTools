function [xACS, yACS] = testComputePTiming(x0, y0, x, y, AnalysisOptions)

tic
[xACS, yACS] = way1(x0, y0, x, y, AnalysisOptions);
fprintf('Way 1 (sparse) Time: %.4f', toc)

tic
[xACS, yACS] = way2(x0, y0, x, y, AnalysisOptions);
fprintf('Way 2 (nonsparse) Time: %.4f', toc)
% 
% tic
% [xACS, yACS] = way3(x0, y0, x, y, AnalysisOptions);
% fprintf('Way 3 Time: %.4f', toc)
% 
% tic
% [xACS, yACS] = way4(x0, y0, x, y, AnalysisOptions);
% fprintf('Way 4 Time: %.4f', toc)