function State = wrapBounds(State, ODESys)
% wrapBounds(State, ODESys): Wraps the positions in "State" (an object of
% type SystemState) according to the periodic boundary conditions
% established in "ODESys" (an object of type ODESystem).

if ODESys.isPeriodicInX
  xBounds = ODESys.xBounds;
  State.x = xBounds(1) + mod(State.x - xBounds(1), diff(xBounds));
end
if ODESys.isPeriodicInY
  yBounds = ODESys.yBounds;
  State.y = yBounds(1) + mod(State.y - yBounds(1), diff(yBounds));
end
if ODESys.spatialDimension == 3 && ODESys.isPeriodicInZ
  zBounds = ODESys.zBounds;
  State.z = yBounds(1) + mod(State.z - zBounds(1), diff(zBounds));
end