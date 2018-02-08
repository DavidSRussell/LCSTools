file = 'chesroms_his_0840.nc';

uForInterp = ncread(file, 'u'); uForInterp = uForInterp(:, :, :, 1:2);
vForInterp = ncread(file, 'v'); vForInterp = vForInterp(:, :, :, 1:2);
wForInterp = ncread(file, 'w'); wForInterp = wForInterp(:, :, :, 1:2);
omegaForInterp = ncread(file, 'omega'); omegaForInterp = omegaForInterp(:, :, :, 1:2);
zetaForInterp = ncread(file, 'zeta'); zetaForInterp = zetaForInterp(:, :, 1:2);
hForInterp = ncread(file, 'h');
pmForInterp = ncread(file, 'pm');
pnForInterp = ncread(file, 'pn');
Cs_wForInterp = ncread(file, 'Cs_w');
hc = ncread(file, 'hc');

xgv4u = 0.5 : 149;
xgv4v = 0 : 149;
xgv4w = 0 : 149;
ygv4u = 0 : 479;
ygv4v = 0.5 : 479;
ygv4w = 0 : 479;
zgv4u = 1/20*(-19.5 : 0);
zgv4v = 1/20*(-19.5 : 0);
zgv4w = 1/20*(-20 : 0);
tgv = [0, 120];

n = 1e4;
xi = rand(n, 1)*149;
eta = rand(n, 1)*479;
sigma = rand(n, 1)*(-1);
t = 60;

uForTempInterp = NaN([2, size(xi)]);
uForTempInterp(1, :, :) = interpn(xgv4u, ygv4u, zgv4u, ...
  uForInterp(:, :, :, 1), xi, eta, sigma);
uForTempInterp(2, :, :) = interpn(xgv4u, ygv4u, zgv4u, ...
  uForInterp(:, :, :, 2), xi, eta, sigma);
u = interp1(tgv, uForTempInterp, t)';

vForTempInterp = NaN([2, size(xi)]);
vForTempInterp(1, :, :) = interpn(xgv4v, ygv4v, zgv4v, ...
  vForInterp(:, :, :, 1), xi, eta, sigma);
vForTempInterp(2, :, :) = interpn(xgv4v, ygv4v, zgv4v, ...
  vForInterp(:, :, :, 2), xi, eta, sigma);
v = interp1(tgv, vForTempInterp, t)';

wForTempInterp = NaN([2, size(xi)]);
wForTempInterp(1, :, :) = interpn(xgv4w, ygv4w, zgv4w, ...
  wForInterp(:, :, :, 1), xi, eta, sigma);
wForTempInterp(2, :, :) = interpn(xgv4w, ygv4w, zgv4w, ...
  wForInterp(:, :, :, 2), xi, eta, sigma);
w = interp1(tgv, wForTempInterp, t)';

omegaForTempInterp = NaN([2, size(xi)]);
omegaForTempInterp(1, :, :) = interpn(xgv4w, ygv4w, zgv4w, ...
  omegaForInterp(:, :, :, 1), xi, eta, sigma);
omegaForTempInterp(2, :, :) = interpn(xgv4w, ygv4w, zgv4w, ...
  omegaForInterp(:, :, :, 2), xi, eta, sigma);
omega = interp1(tgv, omegaForTempInterp, t)';

zetaForTempInterp = NaN([2, size(xi)]);
zetaForTempInterp(1, :, :) = interpn(xgv4w, ygv4w, ...
  zetaForInterp(:, :, 1), xi, eta);
zetaForTempInterp(2, :, :) = interpn(xgv4w, ygv4w, ...
  zetaForInterp(:, :, 2), xi, eta);
zeta = interp1(tgv, zetaForTempInterp, t)';

h = interpn(xgv4w, ygv4w, hForInterp, xi, eta);

pm = interpn(xgv4w, ygv4w, pmForInterp, xi, eta);

pn = interpn(xgv4w, ygv4w, pnForInterp, xi, eta);

Cs = interp1(zgv4w, Cs_wForInterp, sigma);

S = hc*sigma + (h - hc).*Cs;

z = S + zeta.*(1 + S./h);

delzetadelt = squeeze(diff(zetaForTempInterp, 1)/diff(tgv))';

sizeWForInterp = size(wForInterp);
zForInterp = NaN(sizeWForInterp([1,2,4,3]));
hForZ = NaN([size(hForInterp), 2]);
for tInd = 1 : 2
  hForZ(:, :, tInd) = hForInterp;
end
for zInd = 1 : length(zgv4w)
  SForZ = hc*zgv4w(zInd) + (hForZ - hc).*Cs_wForInterp(zInd);
  zForInterp(:, :, :, zInd) = SForZ + zetaForInterp.*(1 + SForZ./hForZ);
end
zForInterp = permute(zForInterp, [1, 2, 4, 3]);

sigmaForInterp = repmat(zgv4w', 1, 150, 480, 2);
sigmaForInterp = permute(sigmaForInterp, [2, 3, 1, 4]);

HzForInterp = diff(zForInterp, [], 3)./diff(sigmaForInterp, [], 3);
size(HzForInterp)

HzForTempInterp = NaN([2, size(xi)]);
HzForTempInterp(1, :, :) = interpn(xgv4w, ygv4w, zgv4u, HzForInterp(:, :, :, 1), xi, eta, sigma);
HzForTempInterp(2, :, :) = interpn(xgv4w, ygv4w, zgv4u, HzForInterp(:, :, :, 2), xi, eta, sigma);
Hz = interp1(tgv, HzForTempInterp, t)';

% suspicious (something like CN better?)
delzetadelxiForInterp = diff(zetaForInterp(:, :, 1), 1);
delzetadelxi = interpn(xgv4u, ygv4w, delzetadelxiForInterp, xi, eta);

delzetadeletaForInterp = diff(zetaForInterp(:, :, 1), [], 2);
delzetadeleta = interpn(xgv4w, ygv4v, delzetadeletaForInterp, xi, eta);

delhdelxiForInterp = diff(hForInterp(:, :, 1), 1);
delhdelxi = interpn(xgv4u, ygv4w, delhdelxiForInterp, xi, eta);

delhdeletaForInterp = diff(hForInterp(:, :, 1), [], 2);
delhdeleta = interpn(xgv4w, ygv4v, delhdeletaForInterp, xi, eta);

DzetaDt = delzetadelt + delzetadelxi.*pm.*u + delzetadeleta.*pn.*v;

DhDt = delhdelxi.*pm.*u + delhdeleta.*pn.*v;




shouldBeW = omega + DzetaDt.*(1 + S./h) + zeta.*(h.*omega - S.*DhDt)./h.^2;

notNaNInds = ~isnan(shouldBeW) & ~isnan(w);
shouldBeW = shouldBeW(notNaNInds);
w = w(notNaNInds);
wRelError = (shouldBeW - w)/norm(w);
shouldBeZeroW = norm(wRelError)

shouldBeS = hc*sigma + (h - hc).*Cs;
shouldBeZeroS = norm(S - shouldBeS)

h = h(notNaNInds);
zeta = zeta(notNaNInds);
omega = omega(notNaNInds);
pm = pm(notNaNInds);
pn = pn(notNaNInds);
Cs = Cs(notNaNInds);
S = S(notNaNInds);
DzetaDt = DzetaDt(notNaNInds);
DhDt = DhDt(notNaNInds);
xi = xi(notNaNInds);
eta = eta(notNaNInds);
sigma = sigma(notNaNInds);
Hz = Hz(notNaNInds);
sum1 = sum(isnan(Hz(:)))
z = z(notNaNInds);

figure
scatter3(xi(:),eta(:),z(:),100,Hz(:),'.')
xlim([0, 149])
ylim([0, 479])
colormap(jet(256))
colorbar

figure
scatter3(xi(:),eta(:),z(:),100,w(:),'.')
xlim([0, 149])
ylim([0, 479])
colormap(jet(256))
colorbar

figure
scatter3(xi(:),eta(:),z(:),100,wRelError(:),'.')
xlim([0, 149])
ylim([0, 479])
colormap(jet(256))
colorbar

figure
scatter3(xi(:),eta(:),z(:),100,(w(:) - omega(:))./norm(w),'.')
xlim([0, 149])
ylim([0, 479])
colormap(jet(256))
colorbar
pause

figure
plot(w)
hold on
plot(omega)
plot(shouldBeW)
legend('w', 'omega', 'shouldBeW')
pause
% plot(DzetaDt.*(1 + S./h))
% plot(zeta.*(h.*omega + S.*DhDt)./h.^2)
plot(zeta)
plot(xi)
plot(eta)
plot(sigma)
plot(S)
pause
% legend('shouldBeW','w','omega','second term','third term','zeta')
legend('w','omega','zeta','xi','eta','sigma','S')