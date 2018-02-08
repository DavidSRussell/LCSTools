function uq = interp1D(x, u, xq, method)
% interp1D(x, u, xq, method): One-dimensional interpolation.
%
% interp1D interpolates values in u, given at points in vector x, to query
% points given in xq. If x has length n, then u must have dimensions
% [size(xq), n], and uq will have the same size as xq. "method" can be
% either 'linear' for piecewise linear interpolants, or 'cubic' for cubic
% Lagrange polynomials (CUBIC NOT YET IMPLEMENTED).

x = x(:);

if strcmpi(method, 'linear')
  xInds = discretize(xq, x);
  notNaNInds = find(~isnan(xInds));
  xIndsNotNaN = xInds(notNaNInds);
  w1q = NaN(size(xq));
  w1q(notNaNInds) = (x(xIndsNotNaN + 1) - xq(notNaNInds))./(x(xIndsNotNaN + 1) - x(xIndsNotNaN));
  w2q = 1 - w1q;
  if length(size(xq)) == 2
    [nqx, nqy] = size(xq);
    [iqArr, jqArr] = ndgrid(1 : nqx, 1 : nqy);
    u1q = NaN(nqx, nqy);
    u1qInds = sub2ind(size(u), iqArr, jqArr, xInds);
    u1q(notNaNInds) = u(u1qInds(~isnan(u1qInds)));
    u2q = NaN(nqx, nqy);
    u2qInds = sub2ind(size(u), iqArr, jqArr, xInds + 1);
    u2q(notNaNInds) = u(u2qInds(~isnan(u2qInds)));
  elseif length(size(xq)) == 3
    [nqx, nqy, nqz] = size(xq);
    [iqArr, jqArr, kqArr] = ndgrid(1 : nqx, 1 : nqy, 1 : nqz);
    u1q = NaN(nqx, nqy, nqz);
    u1qInds = sub2ind(size(u), iqArr, jqArr, kqArr, xInds);
    u1q(notNaNInds) = u(u1qInds(~isnan(u1qInds)));
    u2q = NaN(nqx, nqy, nqz);
    u2qInds = sub2ind(size(u), iqArr, jqArr, kqArr, xInds + 1);
    u2q(notNaNInds) = u(u2qInds(~isnan(u2qInds)));
  end
  uq = w1q.*u1q + w2q.*u2q;
elseif strcmpi(method, 'cubic')
  % stuff goes here
end



%   uq = NaN([size(xq), n]);
%   for i = 1 : length(xIndsNotNaN)
%     xqSubs = ind2sub(size(xq), notNaNInds(i));
%     subsString = sprintf('%.0f,', xqSubs);
%     subsString = subsString(1 : end - 1);
%     if length(sizeXq) == 2
%       eval(['uq(:, :, ', subsString, ') = w(i)*u(:, :, xIndsNotNaN(i)) + (1 - w(i))*u(:, :, xIndsNotNaN(i) + 1);']);
%     elseif length(sizeXq) == 3
%       eval(['uq(:, :, :, ', subsString, ') = w(i)*u(:, :, :, xIndsNotNaN(i)) + (1 - w(i))*u(:, :, :, xIndsNotNaN(i) + 1);']);
%     end
%   end
% end