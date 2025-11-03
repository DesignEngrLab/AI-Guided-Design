path = "C:\Users\colej\MATLAB Drive\Second Experiment\Data\Material Comparison Sheets";

mc_G = "Guided Material Comparison.xlsx";
mc_U = "Unguided Material Comparison.xlsx";


variety_G = gen_metrics_from_actual(path, mc_G);
%%
variety_U = gen_metrics_from_actual(path, mc_U);
%%

auto_ks(variety_G,"Variety G")
auto_ks(variety_U, "variety U")
[h,p]=ttest2(variety_G, variety_U, "VarType", "Unequal")
[h,p]=vartest2(variety_G, variety_U)%, "VarType", "Unequal")



%%

[fd, td] = nice_hist_plot(variety_G, variety_U, 0.1, [3.5 2.75], "Guided", "Unguided", [-.05 1.05], [0 9],0:0.1:1,  string(0:0.1:1), sprintf("Material Choice Variety\n(What Materials the Participants Used)"), "Count");
