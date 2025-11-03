function [cost_eff_best_track, cost_eff_all_track,cost_std_track] = recursive_cost_checking_ACTUAL(path, name)%,linecrap_1, linecrap_2,alpha_val)

    %addpath(genpath('Test Data'))
    %guidedFiles = dir(fullfile('C:\Users\colej\MATLAB Drive\Post Project Analysis\Test Data\Unguided','*.xls'));
    addpath(genpath(path))
    
    sheets = sheetnames(name);
    format compact
    

    
    %% super structure

    cost_eff_best_track = NaN(length(sheets), 6); %some have seven, need to cleean up data later
    cost_eff_all_track = cost_eff_best_track;
    cost_std_track = zeros(length(sheets),1);

  
   for i = 1:length(sheets)
        m = readmatrix(name, "Sheet",sheets{i});
        %disp(sheets{i})
    
        %theres an extra feasibility column leftover
        if width(m) == 21
            m(:,2) = []; %remove so indexing is the same
        end
    
        % find iters
        iter_max = max(m(:,1));
    
       
    
        %new
        actu = m(iter_max + 3: end-2,:);

     


        cost_diff_i =[];
        for j = 1:height(actu)
            n_bat = actu(j, end);
            required_base_cost = 20*n_bat + 10*3;% number of batteries and minimum wheels cost for that design%
            cost_diff_i =[cost_diff_i, actu(j,4)-required_base_cost];
            %scatter3(t.Marbles(j), t.Range(j),t.Cost(j),'ko')
    
        end

        
        cost_eff_all_i = cost_diff_i./actu(:,2)';
        cost_eff_best_i = cost_eff_all_i;

        
        for j = 2:length(cost_eff_best_i)
            if cost_eff_best_i(j) > cost_eff_best_i(j-1)
                cost_eff_best_i(j) = cost_eff_best_i(j-1);
            end
        end
       
        
        %lets s
        % ee what sort of analysis we
        
        %plot(1:length(s_best_i), s_best_i,linecrap)
        hold on
        
        %scatter3(t.Marbles, t.Range, cost_eff_all_i)
        
            cost_eff_best_i = [cost_eff_best_i, NaN(1, 6-length(cost_eff_best_i))];
            cost_eff_all_i = [cost_eff_all_i, NaN(1, 6-length(cost_eff_all_i))];

        
        cost_eff_best_track(i,:) = cost_eff_best_i;
        cost_eff_all_track(i,:) = cost_eff_all_i;
        cost_std_track(i) = std(cost_eff_all_i, "omitmissing");
        %}

        
    
    end

    %{
    mu_s = rmmissing(mean(cost_eff_track, "omitmissing"));
    s_s = rmmissing(std(cost_eff_track,"omitmissing"));


    
    fill([1:1:length(mu_s), length(mu_s):-1:1], [(mu_s + s_s),flip(mu_s-s_s)],linecrap_2, "FaceAlpha",alpha_val,"EdgeAlpha",0)
    hold on
    plot(1:length(mu_s), mu_s,linecrap_1,"LineWidth",1)
   
    %plot(1:8, mean(s_track,"omitmissing")+std(s_track,"omitmissing"),linecrap_2)
    %plot(1:8, mean(s_track,"omitmissing")-std(s_track,"omitmissing"),linecrap_2)
    %}
end