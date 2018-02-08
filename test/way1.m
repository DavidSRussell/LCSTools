function [xACS, yACS] = way1(x0, y0, x, y, AnalysisOptions);

xLimitsInitial = AnalysisOptions.ACSOptions.xLimits;
yLimitsInitial = AnalysisOptions.ACSOptions.yLimits;
xLimitsFinal = [xLimitsInitial(1) - diff(xLimitsInitial)/4, ...
  xLimitsInitial(2) + diff(xLimitsInitial)/4];
yLimitsFinal = [yLimitsInitial(1) - diff(yLimitsInitial)/4, ...
  yLimitsInitial(2) + diff(yLimitsInitial)/4];

Qx = AnalysisOptions.ACSOptions.particleDimensionsPerGridBox(1);
Qy = AnalysisOptions.ACSOptions.particleDimensionsPerGridBox(2);
Q = Qx*Qy; % particles per box

dxParticles = x0(2,1) - x0(1,1);
dyParticles = y0(1,2) - y0(1,1);
dxBoxes = Qx*dxParticles;
dyBoxes = Qy*dyParticles;

% Grid vectors for AIS grid
xBoxGridVectorInitial = xLimitsInitial(1) - 0.5*dxParticles : dxBoxes : xLimitsInitial(2) + 0.51*dxParticles;
yBoxGridVectorInitial = yLimitsInitial(1) - 0.5*dyParticles : dyBoxes : yLimitsInitial(2) + 0.51*dyParticles;
xBoxGridVectorFinal = xLimitsFinal(1) - 0.5*dxParticles : dxBoxes : xLimitsFinal(2) + 0.51*dxParticles;
yBoxGridVectorFinal = yLimitsFinal(1) - 0.5*dyParticles : dyBoxes : yLimitsFinal(2) + 0.51*dyParticles;

% Dimensions of AIS grid
gridDimensionsInitial = [length(xBoxGridVectorInitial) - 1, length(yBoxGridVectorInitial) - 1];
gridDimensionsFinal = [length(xBoxGridVectorFinal) - 1, length(yBoxGridVectorFinal) - 1];

% Number of grid boxes for AIS grid
nBoxesInitial = prod(gridDimensionsInitial);
nBoxesFinal = prod(gridDimensionsFinal);

% Truncate particle grids to match AIS grid
x0 = x0(1 : gridDimensionsInitial(1)*Qx, 1 : gridDimensionsInitial(2)*Qy);
y0 = y0(1 : gridDimensionsInitial(1)*Qx, 1 : gridDimensionsInitial(2)*Qy);
x = x(1 : gridDimensionsInitial(1)*Qx, 1 : gridDimensionsInitial(2)*Qy);
y = y(1 : gridDimensionsInitial(1)*Qx, 1 : gridDimensionsInitial(2)*Qy);

% Transition matrix transpose (transpose makes loop faster below)
PTranspose = sparse(nBoxesFinal + 1, nBoxesInitial + 1);
fprintf('Initial size of transition matrix: %i by %i\n', nBoxesInitial + 1, nBoxesFinal + 1)

% Assign points to AIS grid boxes
x0BoxIndices = discretize(x0, xBoxGridVectorInitial);
y0BoxIndices = discretize(y0, yBoxGridVectorInitial);
xBoxIndices = discretize(x, xBoxGridVectorFinal);
yBoxIndices = discretize(y, yBoxGridVectorFinal);
i = sub2ind(gridDimensionsInitial, x0BoxIndices, y0BoxIndices);
j = sub2ind(gridDimensionsFinal, xBoxIndices, yBoxIndices);

% Fill in entries of P transpose
startTransitionMatrix = tic;
for nParticle = 1 : numel(xBoxIndices)
  if ~isnan(j(nParticle))
    PTranspose(j(nParticle), i(nParticle)) = PTranspose(j(nParticle), i(nParticle)) + 1;
  end
end
% for ix = 1:gridDimensionsInitial(1)
%     for iy = 1:gridDimensionsInitial(2)
%         i_box = ix + gridDimensionsInitial(1)*(iy-1);
%         PTranspose(1:end-1,i_box) = histcounts(j((ix-1)*Qx + (1:Qx), ...
%             (iy-1)*Qy + (1:Qy)),1:nBoxesFinal+1);
%     end
% end
PTranspose = PTranspose/Q;

% % Eliminate unoccupied boxes from range (zero columns in P)
% P_trans_rowsums = sum(PTranspose,2);
% zerocols_P = find(P_trans_rowsums == 0);
% nonzerocols_P = find(P_trans_rowsums ~= 0);
% PTranspose(zerocols_P,:) = [];

% Finish constructing P
PTranspose(end,:) = 1 - sum(PTranspose,1); % group together particles that exit domain
P = PTranspose';
transitionMatrixTime = toc(startTransitionMatrix);
fprintf('Time to construct transition matrix: %.4f s\n',transitionMatrixTime)

% Construct P0
p = ones(nBoxesInitial+1,1)/(nBoxesInitial+1); % initial density
Pi_p_12 = spdiags(p.^(1/2),0,nBoxesInitial+1,nBoxesInitial+1);
Pi_p_m12 = spdiags(p.^(-1/2),0,size(P,1),size(P,1));
q = PTranspose*p; % final density
Pi_q_m12 = spdiags(q.^(-1/2),0,size(P,2),size(P,2));
P0 = Pi_p_12*P*Pi_q_m12;

% Get SVD of P0    
startSVD = tic;
nSingularVectors = AnalysisOptions.ACSOptions.nSingularVectors;
[U, S, V] = svds(P0, nSingularVectors);
sVDTime = toc(startSVD);
fprintf('Time for SVD up to %i singular values: %.4f s\n', nSingularVectors, sVDTime)

xACS = Pi_p_m12*U;
yACS = Pi_q_m12*V;