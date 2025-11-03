function [f, t] = nice_hist_plot(top, bot, bW, sz, tLe, bLe, xLi, yLi, xT,  xTiLa, xLa, yLa)

f = figure;
t = tiledlayout(2,1);
nexttile
histogram(top,"BinWidth",bW,"FaceColor",[0 0 1])
legend(tLe)

xlim(xLi)
ylim(yLi)

xticks(xT)
xticklabels(xTiLa)
set(gca,"FontName", "Times New Roman","FontSize",8)

nexttile

histogram(bot,"BinWidth",bW,"FaceColor",[1 0 0])
legend(bLe)

xlim(xLi)
ylim(yLi)

xticks(xT)
xticklabels(xTiLa)

set(gca,"FontName", "Times New Roman","FontSize",8)
t.TileSpacing = "compact";
t.Padding = "compact";


xL = xlabel(t,xLa);
yL = ylabel(t,yLa);
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';

f.Units = "inches";
f.Position([3,4]) = sz;


end