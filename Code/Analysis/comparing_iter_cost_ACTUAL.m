path = "C:\Users\colej\MATLAB Drive\Second Experiment\Data\Material Comparison Sheets";

mc_G = "Guided Material Comparison.xlsx";
mc_U = "Unguided Material Comparison.xlsx";

[a_u,b_u,c_u] = recursive_cost_checking_ACTUAL(path,mc_U);

%%
f1a = figure;
t1a = tiledlayout(1,1);
nexttile;
mu_a_u = rmmissing(mean(a_u, "omitmissing"));
mu_b_u = rmmissing(mean(b_u, "omitmissing"));
s_a_u = rmmissing(std(a_u, "omitmissing"));
s_b_u = rmmissing(std(b_u, "omitmissing"));

%plot(mu_a_u,'r-')
hold on
%fill([1:length(mu_a_u), length(mu_a_u):-1:1], [mu_a_u+s_a_u, flip(mu_a_u-s_a_u)], 'r', "FaceAlpha",0.7)
%plot(mu_b,'r--')
xlim([1 6])

[a_g,b_g,c_g] = recursive_cost_checking_ACTUAL(path,mc_G);


b_g(isinf(b_g))=NaN;
mu_a_g = rmmissing(mean(a_g, "omitmissing"));
mu_b_g = rmmissing(mean(b_g, "omitmissing"));
s_a_g = rmmissing(std(a_g, "omitmissing"));
s_b_g = rmmissing(std(b_g, "omitmissing"));



hold on
fill([1:length(mu_a_g), length(mu_a_g):-1:1], [mu_a_g+s_a_g, flip(mu_a_g-s_a_g)], 'b', "FaceAlpha",0.2,"EdgeAlpha",0)

%plot(mu_b,'k--')



hold on
fill([1:length(mu_a_u), length(mu_a_u):-1:1], [mu_a_u+s_a_u, flip(mu_a_u-s_a_u)], 'r', "FaceAlpha",0.4,"EdgeAlpha",0)


%plot(mu_b,'r--')
xlim([1 6])


ylim([0 50])


xlim([1 6])
xticks(1:6)

plot(mu_a_g,'b-',"LineWidth",1)
plot(mu_a_u,'r-',"LineWidth",1)


set(gca,"FontName", "Times New Roman","FontSize",8)
xticklabels(["1", "2", "3", "4", "5", "6"])


f1a.Units = "inches";
f1a.Position([3,4]) = [3.5,2.5];

t1a.Padding = 'compact';
t1a.TileSpacing = 'compact';


xL = xlabel(t1a,'Iteration');
yL = ylabel(t1a,'Minimum Recorded \it{C_m}',"Interpreter","tex");
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';
legend(["","","Guided Aggregate","Unguided Aggregate"],"Location","northeast")



%%
figure
plot(mu_b_u,'r')
hold on
fill([1:length(mu_b_u), length(mu_b_u):-1:1], [mu_b_u+s_b_u, flip(mu_b_u-s_b_u)], 'r', "FaceAlpha",0.7)
plot(mu_b_g,'k')
hold on
fill([1:length(mu_b_g), length(mu_b_g):-1:1], [mu_b_g+s_b_g, flip(mu_b_g-s_b_g)], 'b', "FaceAlpha",0.3)
xlim([1 6])


%%

%%
b = [0 0 255]/255;
b = [b,0.25];


r = [255 0 0]/255;
r = [r,0.25];


%%
f2 = figure;
t = tiledlayout(2,1);
nexttile

plot(1:6,b_g',"-","Color",b, "LineWidth",1.5)

ylim([0 100])


xlim([1 6])

xticks(1:6)
xticklabels(["1", "2", "3", "4", "5", "6"])


set(gca,"FontName", "Times New Roman","FontSize",8)

L = legend("Guided Individuals","Location","northeast");
L.EdgeColor = [1 1 1];


nexttile
plot(1:6,b_u',"-","Color",r, "LineWidth",1.5)
ylim([0 100])

xlim([1 6])
xticks(1:6)
xticklabels(["1", "2", "3", "4", "5", "6"])
set(gca,"FontName", "Times New Roman","FontSize",8)
L2 = legend("Unguided Individuals","Location","northeast");
L2.EdgeColor = [1 1 1];



f2.Units = "inches";
f2.Position([3,4]) = [3.5,2.5];

xL = xlabel(t,'Iteration');
yL = ylabel(t,'Adjusted Cost per Marble');
xL.FontSize = 10;
xL.FontName = 'Times New Roman';
xL.FontWeight = 'bold';

yL.FontSize = 10;
yL.FontName = 'Times New Roman';
yL.FontWeight = 'bold';
t.TileSpacing = 'Compact';
t.Padding = 'Compact';


%%
%{
figure

subplot(1,2,1)
boxplot(c_u)
ylim([0 60])

subplot(1,2,2)
boxplot(c_g)
ylim([0 60])
%}

%% statistical testing...
ind_U_c = mean(b_u, 2,"omitmissing");
ind_G_c = mean(b_g, 2,"omitmissing");
[h,p]=ttest2(ind_U_c, ind_G_c,"Vartype","unequal")

[fq,tq] = nice_hist_plot(ind_G_c, ind_U_c, 2.5, [3.5 2.5], "Guided", "Unguided",[0 40], [0 10], 0:10:40,string(0:10:40),"Mean Device Required Cost to Capacity","Count");


%%
m_u = min(b_u')';
m_g = min(b_g')';
[h2,p2]=ttest2(m_u,m_g,"Vartype","unequal")

[fp,tp] = nice_hist_plot(m_g, m_u, 2.5, [3.5 2.5], "Guided", "Unguided",[0 40], [0 10], 0:10:40,string(0:10:40),"Minimum Device Required Cost to Capacity","Count");
