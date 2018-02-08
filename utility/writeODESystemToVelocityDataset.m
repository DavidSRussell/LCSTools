function ODESysDataset = writeODESystemToDataset(ODESys, ODESysGrid)
% writeODESystemToDataset(ODESys, ODESystemGrid): Converts "ODESys"
% (an object of type ODESystem) into an object of type Dataset, with
% underlying grid as given by "ODESysGrid" (an object of type Grid).

ODESysDataset = Dataset;
ODESysDataset.spatialDimension = ODESys.spatialDimension;
ODESysDataset.temporalDimension = ODESys.temporalDimension;
ODESysDataset.Grid = ODESysGrid;
if ODESys.spatialDimension == 2
    [X_u,Y_u] = meshgrid(ODESysGrid.xVector_u,ODESysGrid.yVector_u);
    [X_v,Y_v] = meshgrid(ODESysGrid.xVector_v,ODESysGrid.yVector_v);
    if ODESys.temporalDimension == 0
        [U,~] = ODESys.timeDerivative(X_u,Y_u);
        [~,V] = ODESys.timeDerivative(X_v,Y_v);
    elseif ODESys.temporalDimension == 1
        U = NaN([size(X_u),length(ODESysGrid.tVector)]);
        V = NaN([size(X_v),length(ODESysGrid.tVector)]);
        for i = 1:length(ODESysGrid.tVector)
            t = ODESysGrid.tVector(i);
            [U_t,~] = ODESys.timeDerivative(X_u,Y_u,t);
            [~,V_t] = ODESys.timeDerivative(X_v,Y_v,t);
            U(:,:,i) = U_t;
            V(:,:,i) = V_t;
        end
    end
    ODESysDataset.U = U;
    ODESysDataset.V = V;
elseif ODESys.spatialDimension == 3
    [X_u,Y_u,Z_u] = meshgrid(ODESysGrid.xVector_u, ...
      ODESysGrid.yVector_u,ODESysGrid.zVector_u);
    [X_v,Y_v,Z_v] = meshgrid(ODESysGrid.xVector_v, ...
      ODESysGrid.yVector_v,ODESysGrid.zVector_v);
    [X_w,Y_w,Z_w] = meshgrid(ODESysGrid.xVector_v, ...
      ODESysGrid.yVector_v,ODESysGrid.zVector_w);
    if ODESys.temporalDimension == 0
        [U,~,~] = ODESys.timeDerivative(X_u,Y_u,Z_u);
        [~,V,~] = ODESys.timeDerivative(X_v,Y_v,Z_v);
        [~,~,W] = ODESys.timeDerivative(X_w,Y_w,Z_w);
    elseif ODESys.temporalDimension == 1
        U = NaN([size(X_u),length(ODESysGrid.tVector)]);
        V = NaN([size(X_v),length(ODESysGrid.tVector)]);
        W = NaN([size(X_w),length(ODESysGrid.tVector)]);
        for i = 1:length(ODESysGrid.tVector)
            t = ODESysGrid.tVector(i);
            [U_t,~,~] = ODESys.timeDerivative(X_u,Y_u,Z_u,t);
            [~,V_t,~] = ODESys.timeDerivative(X_v,Y_v,Z_v,t);
            [~,~,W_t] = ODESys.timeDerivative(X_w,Y_w,Z_w,t);
            U(:,:,i) = U_t;
            V(:,:,i) = V_t;
            W(:,:,i) = W_t;
        end
    end
    ODESysDataset.U = U;
    ODESysDataset.V = V;
    ODESysDataset.W = W;
end