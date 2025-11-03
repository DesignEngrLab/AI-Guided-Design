uf = 'C:\Users\colej\MATLAB Drive\Second Experiment\Data\Cleaned up Data\Clean Unguided';
gf = 'C:\Users\colej\MATLAB Drive\Second Experiment\Data\Cleaned up Data\Clean Guided';

p = 'C:\Users\colej\MATLAB Drive\Second Experiment';

%%
[G_imp,G_last3, G_best] =data_first_last_3_test(p,gf);

%%
[U_imp,U_best,U_all] =data_first_last_3_test(p,uf);



%%
%{
Z = (mean(G_c_b)-mean(U_c_b))/sqrt(mean([G_c_b,U_c_b])*(1-mean([G_c_b,U_c_b]))*(1/23 + 1/24));
normcdf(Z)
ans =
    0.8545
1-normcdf(Z)
ans =
    0.1455
2 * (1 - normcdf(Z))
ans =
    0.2910
%}

%%
f1 = figure;
t1 = tiledlayout(1,1);
nexttile

recursive_best_eff(p,uf,'r-','r', 0.2);
recursive_best_eff(p,gf,'b-', 'b', 0.4);


set(gca,"FontName", "Times New Roman","FontSize",8)




ylim([70 100])
xlim([1 6])
xticks(1:6)

xticklabels(["1", "2", "3", "4", "5", "6"])

set(gca,"FontName", "Times New Roman","FontSize",8)

f1.Units = "inches";
f1.Position([3,4]) = [3.5,2.5];

t1.Padding = 'compact';
t1.TileSpacing = 'compact';


xL = xlabel(t1,'Iteration');
yL = ylabel(t1,'Max Recorded Fleet Effectiveness ');
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';
legend(["","Unguided Aggregate","","Guided Aggregate"],"Location","southeast")



%%
b = [0 0 255]/255;
b = [b,0.25];

f2  = figure;
t = tiledlayout(2,1);
nexttile


r = [255 0 0]/255;
r = [r,0.25];



plot_iters_eff(p,gf,b)%, 'b', 0.6);
ylim([45 100])


xlim([1 6])

xticks(1:6)
xticklabels(["1", "2", "3", "4", "5", "6"])


set(gca,"FontName", "Times New Roman","FontSize",8)

L = legend("Guided Individuals","Location","southeast");
L.EdgeColor = [1 1 1];

nexttile 

plot_iters_eff(p,uf,r)%_%,'r', 0.3);
ylim([45 100])
xlim([1 6])
xticks(1:6)
xticklabels(["1", "2", "3", "4", "5", "6"])
set(gca,"FontName", "Times New Roman","FontSize",8)
L2 = legend("Unguided Individuals","Location","southeast");
L2.EdgeColor = [1 1 1];
%L.Position = [0.5777 0.3807 0.5423 0.0633]%[0.5777 0.3807 0.5423 0.0633]




f2.Units = "inches";
f2.Position([3,4]) = [3.5,2.5];

xL = xlabel(t,'Iteration');
yL = ylabel(t,'Fleet Effectiveness');
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';
t.TileSpacing = 'Compact';
t.Padding = 'Compact';
