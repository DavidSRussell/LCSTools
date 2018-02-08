function StateDerivative = pointVorticesStateDerivative(State, t)
% pointVorticesStateDerivative(State, t): Time derivative for a system of
% arbitrarily many point vortices. "State" is an object of type
% SystemState, including dynamic vortex positions as parameters, and output
% "StateDerivative" is a structure with fields matching those of "State"
% (e.g. StateDerivative.dxdt for State.x and
% StateDerivative.dParametersdt.xVortices for State.Parameters.xVortices).

x = State.x;
y = State.y;
xVortices = State.Parameters.xVortices;
yVortices = State.Parameters.yVortices;
gammas = State.Parameters.gammas;

z = x + 1i*y;
zVortices = xVortices + 1i*yVortices;
dzdt = zeros(size(z));
dzVorticesdt = NaN(size(zVortices));

for j = 1:numel(xVortices)
    dzdt = dzdt + 1i*gammas(j)/(2*pi).*(z - zVortices(j))./abs(z - zVortices(j)).^2;
    dzVorticesdt(j) = sum(1i*gammas([1:j-1,j+1:end])/(2*pi).*(zVortices(j) - zVortices([1:j-1,j+1:end]))./abs(zVortices(j) - zVortices([1:j-1,j+1:end])).^2);
end

dxdt = real(dzdt);
dydt = imag(dzdt);
dParametersdt.dxVorticesdt = real(dzVorticesdt);
dParametersdt.dyVorticesdt = imag(dzVorticesdt);
dParametersdt.dgammasdt = zeros(size(gammas));

StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = sqrt(dxdt.^2 + dydt.^2);
StateDerivative.dParametersdt = dParametersdt;