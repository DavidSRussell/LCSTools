function CSOutput = computeCoherentSets(InitialState, FinalState, ...
  TransitionMatrixOptions, spatialDimension)
% computeCoherentSets(InitialState, FinalState, TransitionMatrixOptions,
% spatialDimension): Compute coherent set vectors based on the initial and
% final states of a system.
%
% computeCoherentSets calculates the coherent set vectors for a flow based
% on the initial and final system states, as well as various transition
% matrix options. The initial state is presumed to lie in a grid, from
% which a coarser grid is built for the transition matrix. Outputs a
% structure containing the left and right coherent vectors, the
% corresponding singular values, and arrays for plotting these vectors.

% Unpack initial and final states
x0 = InitialState.x;
y0 = InitialState.y;
x = FinalState.x;
y = FinalState.y;
if spatialDimension == 3
  z0 = InitialState.z;
  z = FinalState.z;
end

% Set boundaries for coherent set grid
xLimInit = TransitionMatrixOptions.xLimInit;
yLimInit = TransitionMatrixOptions.yLimInit;
if ~isempty(TransitionMatrixOptions.xLimFinal)
  xLimFinal = TransitionMatrixOptions.xLimFinal;
else
  xLimFinal = [xLimInit(1) - diff(xLimInit)/4, xLimInit(2) + diff(xLimInit)/4];
end
if ~isempty(TransitionMatrixOptions.yLimFinal)
  yLimFinal = TransitionMatrixOptions.yLimFinal;
else
  yLimFinal = [yLimInit(1) - diff(yLimInit)/4, ...
    yLimInit(2) + diff(yLimInit)/4];
end
if spatialDimension == 3
  zLimInit = TransitionMatrixOptions.zLimInit;
  if ~isempty(TransitionMatrixOptions.zLimFinal)
    zLimFinal = TransitionMatrixOptions.zLimFinal;
  else
    zLimFinal = [zLimInit(1) - diff(zLimInit)/4, zLimInit(2) + diff(zLimInit)/4];
  end
end

% Get parameters for particle grid
Qx = TransitionMatrixOptions.particleDimensionsPerGridBox(1);
Qy = TransitionMatrixOptions.particleDimensionsPerGridBox(2);
if spatialDimension == 2
  Q = Qx*Qy; % particles per box
elseif spatialDimension == 3
  Qz = TransitionMatrixOptions.particleDimensionsPerGridBox(3);
  Q = Qx*Qy*Qz; % particles per box
end

% Set grid spacing
if spatialDimension == 2
  dxPart = x0(2, 1) - x0(1, 1);
  dyPart = y0(1, 2) - y0(1, 1);
elseif spatialDimension == 3
  dxPart = x0(2, 1, 1) - x0(1, 1, 1);
  dyPart = y0(1, 2, 1) - y0(1, 1, 1);
  dzPart = z0(1, 1, 2) - z0(1, 1, 1);
  dzBox = Qz*dzPart;
end
dxBox = Qx*dxPart;
dyBox = Qy*dyPart;

% Grid vectors for AIS grid
eps = 0.01;
xBoxGVInit = xLimInit(1) : dxBox : xLimInit(2) + eps*dxBox;
yBoxGVInit = yLimInit(1) : dyBox : yLimInit(2) + eps*dxBox;
xBoxGVFinal = xLimFinal(1) : dxBox : xLimFinal(2) + eps*dyBox;
yBoxGVFinal = yLimFinal(1) : dyBox : yLimFinal(2) + eps*dyBox;
if spatialDimension == 3
  zBoxGVInit = zLimInit(1) : dzBox : zLimInit(2) + eps*dzBox;
  zBoxGVFinal = zLimFinal(1) : dzBox : zLimFinal(2) + eps*dzBox;
end

% Dimensions of AIS grid
if spatialDimension == 2
  gridDimInit = [length(xBoxGVInit) - 1, length(yBoxGVInit) - 1];
  gridDimFinal = [length(xBoxGVFinal) - 1, length(yBoxGVFinal) - 1];
elseif spatialDimension == 3
  gridDimInit = [length(xBoxGVInit) - 1, length(yBoxGVInit) - 1, length(zBoxGVInit) - 1];
  gridDimFinal = [length(xBoxGVFinal) - 1, length(yBoxGVFinal) - 1, length(zBoxGVFinal) - 1];
end

% Number of grid boxes for AIS grid
nBoxInit = prod(gridDimInit);
nBoxFinal = prod(gridDimFinal);

% Truncate particle grids to match AIS grid
if spatialDimension == 2
  x = x(1 : gridDimInit(1)*Qx, 1 : gridDimInit(2)*Qy);
  y = y(1 : gridDimInit(1)*Qx, 1 : gridDimInit(2)*Qy);
elseif spatialDimension == 3
  x = x(1 : gridDimInit(1)*Qx, 1 : gridDimInit(2)*Qy, 1 : gridDimInit(3)*Qz);
  y = y(1 : gridDimInit(1)*Qx, 1 : gridDimInit(2)*Qy, 1 : gridDimInit(3)*Qz);
  z = z(1 : gridDimInit(1)*Qx, 1 : gridDimInit(2)*Qy, 1 : gridDimInit(3)*Qz);
end

% Transition matrix transpose (transpose makes loop faster below)
PTranspose = sparse(nBoxFinal + 1, nBoxInit);
fprintf('Constructing transition matrix (initial size %i by %i)\n', nBoxInit, nBoxFinal + 1)

% Assign points to AIS grid boxes
xBoxInd = discretize(x, xBoxGVFinal);
yBoxInd = discretize(y, yBoxGVFinal);
if spatialDimension == 2
  j = sub2ind(gridDimFinal, xBoxInd, yBoxInd);
elseif spatialDimension == 3
  zBoxInd = discretize(z, zBoxGVFinal);
  j = sub2ind(gridDimFinal, xBoxInd, yBoxInd, zBoxInd);
end

% Fill in entries of P transpose
startP = tic;
for i = 1 : nBoxInit
  if spatialDimension == 2
    [ix, iy] = ind2sub(gridDimInit, i);
    PTranspose(1 : end - 1, i) = histcounts(j((ix - 1)*Qx + (1 : Qx), ...
      (iy - 1)*Qy + (1 : Qy)), 1 : nBoxFinal + 1);
  elseif spatialDimension == 3
    [ix, iy, iz] = ind2sub(gridDimInit, i);
    PTranspose(1 : end - 1, i) = histcounts(j((ix - 1)*Qx + (1 : Qx), ...
      (iy - 1)*Qy + (1 : Qy), (iz - 1)*Qz + (1 : Qz)), 1 : nBoxFinal + 1);
  end
end

% Eliminate unoccupied boxes from range (zero columns in P)
PTransposeRowSums = sum(PTranspose, 2);
PZeroColumns = PTransposeRowSums == 0;
PNonZeroColumns = PTransposeRowSums ~= 0;
PTranspose(PZeroColumns, :) = [];

% Finish constructing P
PTranspose(end, :) = Q - sum(PTranspose, 1); % group together particles that exit domain
PTranspose = PTranspose/Q;
P = PTranspose';
PTime = toc(startP);
fprintf('Transition matrix done (final size %i by %i)\n', size(P, 1), size(P, 2))
fprintf('Time to construct transition matrix: %.4f s\n', PTime)

% Construct P0
p = ones(nBoxInit, 1)/nBoxInit; % initial density
Pi_p_OneHalfPower = spdiags(p.^(1/2), 0, nBoxInit, nBoxInit);
Pi_p_MinusOneHalfPower = spdiags(p.^(-1/2), 0, size(P, 1), size(P, 1));
q = PTranspose*p; % final density
Pi_q_MinusOneHalfPower = spdiags(q.^(-1/2), 0, size(P, 2), size(P, 2));
P0 = Pi_p_OneHalfPower*P*Pi_q_MinusOneHalfPower;

% Get SVD of P0
startSVD = tic;
nSingVect = max(TransitionMatrixOptions.singularVectorNumbers);
[U, S, V] = svds(P0, nSingVect);
while (size(S,1) < nSingVect)
  nSingVect = nSingVect + 1
  [U, S, V] = svds(P0, nSingVect);
end
sVDTime = toc(startSVD);
fprintf('Time for SVD up to %i singular values: %.4f s\n', nSingVect, sVDTime)

xCS = Pi_p_MinusOneHalfPower*U;
yCS = NaN(nBoxFinal, nSingVect);
yCS(PNonZeroColumns, :) = Pi_q_MinusOneHalfPower*V;

xCSxGridVector = xBoxGVInit(1 : end - 1) + dxBox/2;
xCSyGridVector = yBoxGVInit(1 : end - 1) + dyBox/2;
yCSxGridVector = xBoxGVFinal(1 : end - 1) + dxBox/2;
yCSyGridVector = yBoxGVFinal(1 : end - 1) + dyBox/2;

if spatialDimension == 2
  [xCSxArray, xCSyArray] = ndgrid(xCSxGridVector, xCSyGridVector);
  [yCSxArray, yCSyArray] = ndgrid(yCSxGridVector, yCSyGridVector);
elseif spatialDimension == 3
  xCSzGridVector = zBoxGVInit(1 : end - 1) + dzBox/2;
  yCSzGridVector = zBoxGVFinal(1 : end - 1) + dzBox/2;
  [xCSxArray, xCSyArray, xCSzArray] = ndgrid(xCSxGridVector, xCSyGridVector, xCSzGridVector);
  [yCSxArray, yCSyArray, yCSzArray] = ndgrid(yCSxGridVector, yCSyGridVector, yCSzGridVector);
end

CSOutput.xCS = xCS;
CSOutput.yCS = yCS;
CSOutput.xCSxArray = xCSxArray;
CSOutput.xCSyArray = xCSyArray;
CSOutput.yCSxArray = yCSxArray;
CSOutput.yCSyArray = yCSyArray;
CSOutput.singularValues = diag(S);

if spatialDimension == 3
  CSOutput.xCSzArray = xCSzArray;
  CSOutput.yCSzArray = yCSzArray;
end