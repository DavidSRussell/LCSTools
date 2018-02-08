% testInterp2

xgv = 0 : 0.1 : 1;
ygv = 0 : 0.1 : 1;
[X, Y] = meshgrid(xgv, ygv);

xqgv = 0 : 0.05 : 1;
yqgv = 0 : 0.05 : 1;
zqgv = 0 : 0.05 : 1;
[Xq, Yq, ~] = meshgrid(xqgv, yqgv, zqgv);

U = cos(X.*Y);

Uq = interp2(X, Y, U, Xq, Yq);
size(Uq)