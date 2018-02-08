n = 100;
dimensions = [n, n, n, n];
reps = 100;

time1 = 0;
time2 = 0;
time3 = 0;
time4 = 0;

for rep = 1 : reps
  arr = rand(dimensions);
  tic
  x1 = arr(n/2, :, :, :);
  time1 = time1 + toc;
  tic
  x2 = arr(:, n/2, :, :);
  time2 = time2 + toc;
  tic
  x3 = arr(:, :, n/2, :);
  time3 = time3 + toc;
  tic
  x4 = arr(:, :, :, n/2);
  time4 = time4 + toc;
end

fprintf('Time 1: %.4f\n', time1)
fprintf('Time 2: %.4f\n', time2)
fprintf('Time 3: %.4f\n', time3)
fprintf('Time 4: %.4f\n', time4)