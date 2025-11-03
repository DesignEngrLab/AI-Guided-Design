%uf = 'C:\Users\colej\MATLAB Drive\Post Project Analysis\Test Data\Unguided';
%gf = 'C:\Users\colej\MATLAB Drive\Post Project Analysis\Test Data\Guided';
uf = 'C:\Users\colej\MATLAB Drive\Second Experiment\Data\Cleaned up Data\Clean Unguided';
gf = 'C:\Users\colej\MATLAB Drive\Second Experiment\Data\Cleaned up Data\Clean Guided';

p = 'C:\Users\colej\MATLAB Drive\Second Experiment';

[Ueff,Us, Uav_m, Uen_c, Uvar_m, Uav_m2, Uen_c2, Uvar_m2, U_vM,U_c] = import_data(p, uf,false);
%%

[Geff, Gs,Gav_m, Gen_c, Gvar_m, Gav_m2, Gen_c2, Gvar_m2, G_vM,G_c] = import_data(p, gf, true);


%% Ks Test checks
auto_ks(Ueff,"Ueff")
auto_ks(Geff,"Geff")
auto_ks(Uvar_m2,"Uvar")
auto_ks(Gvar_m2,"Gvar")
auto_ks(U_vM, "U_vM")
auto_ks(G_vM, "G_vM")
%good, all of them pass

%% statistical tests


%%

%Gs(1)=[];
%Gs(end) =[];
%Gs(end-1)=[]; %remove GX
%Gav_m2(end-1)=[];
%Gvar_m2(end-1)=[];
%%
[fa, ta] = nice_hist_plot(Geff, Ueff, 1, [3.5 2.5], "Guided", "Unguided", [87 102], [0 12], 88:2:100, ["88","90","92","94","96","98","100"],"Maximum Fleet Effectiveness Acheived", "Count");

%%
%{
f1 = figure;
t1 = tiledlayout(2,1);
nexttile
histogram(Geff,"BinWidth",1,"FaceColor",[0 0 1])
legend("Guided")

xlim([87 102])
ylim([0 12])

xticks(88:2:100)
xticklabels(["88","90","92","94","96","98","100"])
set(gca,"FontName", "Times New Roman","FontSize",8)

nexttile

histogram(Ueff,"BinWidth",1,"FaceColor",[1 0 0])
legend("Unguided")

xlim([87 102])
ylim([0 12])


xticks(88:2:100)
xticklabels(["88","90","92","94","96","98","100"])
set(gca,"FontName", "Times New Roman","FontSize",8)
t1.TileSpacing = "compact";
t1.Padding = "compact";


xL = xlabel(t1,"Max Fleet Efficiency Acheived");
yL = ylabel(t1,"Count");
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';

f1.Units = "inches";
f1.Position([3,4]) = [3.5,2.5];
%}

%%
%{
figure
t2 = tiledlayout(1,2);
nexttile
boxplot(Us,"Whisker",.51)
ylim([480 660])
 xticklabels("Guided")
 

nexttile
boxplot(Gs,"Whisker",1)
ylim([480 660])
xticklabels("Guided")
yticklabels("")

t2.Padding = "compact";
t2.TileSpacing = "compact";

%}

%% entropy plots?
[fb, tb] = nice_hist_plot(Gen_c, Uen_c, .25, [3.5 2.5],"Guided", "Unguided",[0 3.5], [0 7],0:0.5:4, string(0:0.5:4),"Material Choice Entropy", "Count");

%% variance plots?
[fc, tc] = nice_hist_plot(Gvar_m2, Uvar_m2, .25, [3.5 2.5],"Guided", "Unguided",[0 2.5], [0 7],0:0.25:2.5, string(0:0.25:2.5),"Sum of Material Choice Variance", "Count");


%% new/final metric plots probably :/
[fd, td] = nice_hist_plot(G_vM, U_vM, 0.1, [3.5 2.5], "Guided", "Unguided", [-.05 1.05], [0 8],0:0.1:1,  string(0:0.1:1), "Material Choice Variety Based on Henderson et. al.", "Count");

%% finish later
figure
subplot(2,1,1)
histogram(G_c)
xlim([0.4 6.6])

subplot(2,1,2)
histogram(U_c)
ylim([0 20])

xlim([0.4 6.6])