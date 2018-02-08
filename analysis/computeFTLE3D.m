function Lambda = computeFTLE3D(x0, y0, z0, xf, yf, zf, t0, tf)
% computeFTLE3D: Compute finite-time Lyapunov exponent of a
% three-dimensional flow.
%
% Given a three-dimensional flow of particles with initial positions x0,
% y0, z0 and final positions xf, yf, zf over time interval t0 to tf,
% calculates the finite-time Lyapunov exponent at each initial particle
% location. Particles must be intially laid out in a grid (as if produced
% by ndgrid) in order to calculate finite difference approximations for
% partial derivatives. (Eigenvalue calculation follows Wikipedia article on
% "Eigenvalue Algorithm".)

% Get entries of finite difference approimation to transition matrix L
% (Jacobian of final position with respect to initial position)
L11 = (xf(3:end,2:end-1,2:end-1) - xf(1:end-2,2:end-1,2:end-1))./(x0(3:end,2:end-1,2:end-1) - x0(1:end-2,2:end-1,2:end-1));
L12 = (xf(2:end-1,3:end,2:end-1) - xf(2:end-1,1:end-2,2:end-1))./(y0(2:end-1,3:end,2:end-1) - y0(2:end-1,1:end-2,2:end-1));
L13 = (xf(2:end-1,2:end-1,3:end) - xf(2:end-1,2:end-1,1:end-2))./(z0(2:end-1,2:end-1,3:end) - z0(2:end-1,2:end-1,1:end-2));
L21 = (yf(3:end,2:end-1,2:end-1) - yf(1:end-2,2:end-1,2:end-1))./(x0(3:end,2:end-1,2:end-1) - x0(1:end-2,2:end-1,2:end-1));
L22 = (yf(2:end-1,3:end,2:end-1) - yf(2:end-1,1:end-2,2:end-1))./(y0(2:end-1,3:end,2:end-1) - y0(2:end-1,1:end-2,2:end-1));
L23 = (yf(2:end-1,2:end-1,3:end) - yf(2:end-1,2:end-1,1:end-2))./(z0(2:end-1,2:end-1,3:end) - z0(2:end-1,2:end-1,1:end-2));
L31 = (zf(3:end,2:end-1,2:end-1) - zf(1:end-2,2:end-1,2:end-1))./(x0(3:end,2:end-1,2:end-1) - x0(1:end-2,2:end-1,2:end-1));
L32 = (zf(2:end-1,3:end,2:end-1) - zf(2:end-1,1:end-2,2:end-1))./(y0(2:end-1,3:end,2:end-1) - y0(2:end-1,1:end-2,2:end-1));
L33 = (zf(2:end-1,2:end-1,3:end) - zf(2:end-1,2:end-1,1:end-2))./(z0(2:end-1,2:end-1,3:end) - z0(2:end-1,2:end-1,1:end-2));

% Find entries of L'L
LTL11 = L11.*L11 + L21.*L21 + L31.*L31;
LTL12 = L11.*L12 + L21.*L22 + L31.*L32;
LTL13 = L11.*L13 + L21.*L23 + L31.*L33;
LTL21 = L12.*L11 + L22.*L21 + L32.*L31;
LTL22 = L12.*L12 + L22.*L22 + L32.*L32;
LTL23 = L12.*L13 + L22.*L23 + L32.*L33;
LTL31 = L13.*L11 + L23.*L21 + L33.*L31;
LTL32 = L13.*L12 + L23.*L22 + L33.*L32;
LTL33 = L13.*L13 + L23.*L23 + L33.*L33;

% Initialize eignevalues
Eig1 = zeros(size(LTL11));
Eig2 = zeros(size(LTL11));
Eig3 = zeros(size(LTL11));

% Simple formula if LTL is diagonal
P1 = LTL12.^2 + LTL13.^2 + LTL23.^2;
diagInds = (P1 == 0); % indices for which LTL is diagonal
Eig1(diagInds) = LTL11(diagInds);
Eig2(diagInds) = LTL22(diagInds);
Eig3(diagInds) = LTL33(diagInds);

% Proceed for non-diagonal LTL
if any(P1 ~= 0)

    % Find entries of B
    Q = (LTL11 + LTL22 + LTL33)/3;
    P2 = (LTL11-Q).^2 + (LTL22-Q).^2 + (LTL33-Q).^2 + 2*P1;
    P = sqrt(P2/6);
    B11 = (LTL11-Q)./P;
    B12 = LTL12./P;
    B13 = LTL13./P;
    B21 = LTL21./P;
    B22 = (LTL22-Q)./P;
    B23 = LTL23./P;
    B31 = LTL31./P;
    B32 = LTL32./P;
    B33 = (LTL33-Q)./P;
        
    % Get det(B)
    detB = B11.*(B22.*B33 - B23.*B32) - B12.*(B21.*B33 - B23.*B31) + B13.*(B21.*B32 - B22.*B31);
    R = detB/2;
    
    % Get phi
    Phi = acos(R)/3;
    Phi(R <= 1) = pi/3;
    Phi(R >= 1) = 0;

    % Get eigenvalues
    notDiag = ~diagInds; % indices for which LTL is not diagonal
    QNotDiag = Q(notDiag);
    PNotDiag = P(notDiag);
    PhiNotDiag = Phi(notDiag);
    Eig1(notDiag) = QNotDiag + 2*PNotDiag.*cos(PhiNotDiag);
    Eig3(notDiag) = QNotDiag + 2*PNotDiag.*cos(PhiNotDiag + 2*pi/3);
    Eig2(notDiag) = 3*QNotDiag - Eig1(notDiag) - Eig3(notDiag);

end

% Get maximum eigenvalues
Eig = max(max(Eig1,Eig2),Eig3);

% Get FTLE
Lambda = 1/(2*(tf - t0))*log(Eig);