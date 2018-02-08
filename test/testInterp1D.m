n = 6;
nqx = 3;
nqy = 2;
nqz = 2;

x = sort(rand(1, n))

xq = rand(nqx, nqy, nqz)
u = rand(nqx, nqy, nqz, n);
uq = interp1D(x, u, xq, 'linear');
figure
hold on
for ix = 1 : nqx
  for iy = 1 : nqy
    for iz = 1 : nqz
      plot(x, squeeze(u(ix, iy, iz, :)), '-')
      plot(xq(ix, iy, iz), uq(ix, iy, iz), 'o')
      fprintf('xq: %.4f, uq: %.4f\n', xq(ix, iy, iz), uq(ix, iy, iz))
      pause
    end
  end
end

xq = rand(nqx, nqy)
u = rand(nqx, nqy, n);
uq = interp1D(x, u, xq, 'linear');
figure
hold on
for ix = 1 : nqx
  for iy = 1 : nqy
    plot(x, squeeze(u(ix, iy, :)), '-')
    plot(xq(ix, iy), uq(ix, iy), 'o')
    fprintf('xq: %.4f, uq: %.4f\n', xq(ix, iy), uq(ix, iy))
    pause
  end
end