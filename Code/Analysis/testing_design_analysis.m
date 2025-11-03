addpath(genpath("C:\Users\colej\MATLAB Drive\Second Experiment\Data\"))

name = "Design Evolution.xlsx";
data = readcell(name);

%% Let's start by identifying where we need to break things up

first = data(:,1);

%%
split = find(strcmp(first,"Subject")) + 2; 
first = first(split:end);
data = data(split:end, 1:(end-2)); %last two in there are extra notes, so



%%
subjects = find(cellfun(@ischar, first)); %get index of designs
% we know that there is a one space between each one, so we can iter
% through

count_devices = 0;

%%
ent = ones(length(subjects),1);
design_variety_track = zeros(length(subjects),5);
hold_track_all = zeros(length(subjects),11);
hold_track_means = hold_track_all;
for i = 1:(length(subjects))-1
    %disp(data(subjects(i),1))
    subset = cellfun(@ischar,data(subjects(i):(subjects(i+1)-2),3:end));
    count_devices = count_devices + height(subset);
    %disp(calc_variety(subset))
    [A,B,C,D,E,H1,H2] = calc_variety(subset);
    design_variety_track(i,:) = [A,B,C,D,E];
    hold_track_all(i,:) = H1;
    hold_track_means(i,:) = H2;
    
end

subset = cellfun(@ischar,data(subjects(end):end,3:end));
design_variety_track(end) = calc_variety(subset);
%disp(calc_variety(subset))

%% Let's take that and split a
GVall = design_variety_track(1:25,:);
UVall = design_variety_track(26:end,:);
gdv = GVall(:,1);
h_varG =GVall(:,2);
a_varG = GVall(:,3);
s_varG = GVall(:,4);
w_varG = GVall(:,5);

udv = UVall(:,1);
h_varU =UVall(:,2);
a_varU = UVall(:,3);
s_varU = UVall(:,4);
w_varU = UVall(:,5);


%% Plot




[fdv, tdv] = nice_hist_plot(gdv,udv, 0.1, [3.5 2.75], "Guided", "Unguided", [-.05 1.05], [0 9],0:0.1:1,  string(0:0.1:1), sprintf("Material Application Variety\n(How Participants Used the Materials)"), "Count");
%%
[h1,p1]=ttest2(gdv,udv,"VarType","Unequal")
[h2,p2]=ttest2(h_varG, h_varU,"VarType","Unequal")
[h3,p3]=ttest2(a_varG, a_varU,"VarType","Unequal")
[h4,p4]=ttest2(s_varG, s_varU,"VarType","Unequal")
[h5,p5]=ttest2(w_varG, w_varU,"VarType","Unequal")

%%

function [t_var,h_var,a_var,s_var,w_var,hold_comm_all,hold_comm_mu] = calc_variety(subset)
    holding = subset(:,1:11); %ignore the multiple container thing
    attach = subset(:,15:18);
    support = subset(:,19:28);
    wheels = subset(:, 31:33); %ignore how many they use, that's not the purpose\

    h_var = mean(vecnorm(holding-mean(holding,1)));
    a_var = mean(vecnorm(attach-mean(attach,1)));
    s_var = mean(vecnorm(support-mean(support,1)));
    w_var = mean(vecnorm(wheels-mean(wheels,1)));

    t_var = 0.25*sum([h_var, a_var, s_var, w_var]);

    hold_comm_all =sum(holding);
    hold_comm_mu = mean(holding);



end
