function combineFTLEPlots(figFwd, thresholdFwd, figBwd, thresholdBwd)
% combineFTLEPlots(figFwd, thresholdFwd, figBwd, thresholdBwd): Combine
% forward and backward FTLE plots by highlighting only those values of each that
% are beyond the chosen threshold (as if they indicate stable/unstable
% manifolds), then overlaying these highlighted values.

axFwd = gca(figFwd);
axBwd = gca(figBwd);

chFwd = axFwd.Children;
chBwd = axBwd.Children;

fig = figure;
fig.Position = figFwd.Position;
hold on

for i = 1 : length(chFwd)
  plotFwd = chFwd(i);
  plotBwd = chBwd(i);
  XData = plotFwd.XData;
  YData = plotFwd.YData;
  CDataFwd = plotFwd.CData;
  CDataBwd = plotBwd.CData;
  manifoldIndsFwd = CDataFwd > thresholdFwd;
  manifoldIndsBwd = CDataBwd > thresholdBwd;
  CDataFwd(~manifoldIndsFwd) = NaN;
  CDataBwd(~manifoldIndsBwd) = NaN;
  CDataFwd(manifoldIndsFwd) = 1;
  CDataBwd(manifoldIndsBwd) = -1;
  if length(plotFwd.ZData) > 0 && min(plotFwd.ZData(:)) < max(plotFwd.ZData(:))
    ZData = plotFwd.ZData;
    if isa(chFwd, 'matlab.graphics.primitive.Surface')
      surf(XData, YData, ZData, CDataBwd)
      shading interp
      surf(XData, YData, ZData, CDataFwd)
      shading interp
    elseif isa(chFwd, 'matlab.graphics.chart.primitive.Scatter')
      scatter3(XData(:), YData(:), ZData(:), CDataBwd(:))
      scatter3(XData(:), YData(:), ZData(:), CDataFwd(:))
    end
    zlim(axFwd.ZLim)
  else
    pcolor(XData, YData, CDataBwd)
    shading interp
    pcolor(XData, YData, CDataFwd)
    shading interp
  end
  xlim(axFwd.XLim)
  ylim(axFwd.YLim)
  axis equal tight
end
colormap(jet(256))