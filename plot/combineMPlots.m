function combineMPlots(figFwd, figBwd)
% combineMPlots(figFwd, thresholdFwd, figBwd, thresholdBwd): Combine
% forward and backward FTLE plots by highlighting only those values of each that
% are beyond the chosen threshold (as if they indicate stable/unstable
% manifolds), then overlaying these highlighted values.

axFwd = gca(figFwd);
axBwd = gca(figBwd);

chFwd = axFwd.Children;
chBwd = axBwd.Children;

fig = figure;
hold on

for i = 1 : length(chFwd)
  plotFwd = chFwd(i);
  plotBwd = chBwd(i);
  XData = plotFwd.XData;
  YData = plotFwd.YData;
  CDataFwd = plotFwd.CData;
  CDataBwd = plotBwd.CData;
  CData = CDataFwd + CDataBwd;
  if length(plotFwd.ZData) > 0
    ZData = plotFwd.ZData;
    if isa(chFwd, 'matlab.graphics.primitive.Surface')
      surf(XData, YData, ZData, CData)
    elseif isa(chFwd, 'matlab.graphics.chart.primitive.Scatter')
      scatter3(XData(:), YData(:), ZData(:), CData(:))
    end
    zlim(axFwd.ZLim)
  else
    pcolor(XData, YData, CData)
  end
  xlim(axFwd.XLim)
  ylim(axFwd.YLim)
  shading interp
  axis equal tight
end
colorbar
colormap(jet(256))