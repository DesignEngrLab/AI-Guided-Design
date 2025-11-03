function [s_imp_track,s_best_last3_track, s_best_all] =data_first_last_3_test(path, filename)

    %addpath(genpath('Test Data'))
    %guidedFiles = dir(fullfile('C:\Users\colej\MATLAB Drive\Post Project Analysis\Test Data\Unguided','*.xls'));
    addpath(genpath(path));
    files = dir(fullfile(filename, '*.xls'));
    files = {files.name};
    
    format compact
    
    %%
    dataTable = readtable(files{1});
    dataTable.("Sample_Name") = repmat('_',height(dataTable),1);
    dataTable = [dataTable(:,end), dataTable(:, 1:(end-1))];
    dataTable = dataTable([],:);
    
    %% super structure


    s_imp_track = [];
    s_best_last3_track =[];
    s_best_all =[];


  
    for i = 1:length(files)
        s = max(double(sheetnames(files{i}))); %sheet names, they are strings so do some magic
        t = readtable(files{i}, "Sheet",int2str(s));
    
        %there's some fun issues, so drop things that we know we don't need.
        %there's some fun issues, so drop things that we know we don't need.

        while table2array(t(end,1)) == 0
            t(end,:) = [];
        end

        t.("Sample_Name") = repmat({files{i}},height(t),1); %modify this later
        dataTable = [dataTable;t];

        try
            s_best_first3 = min(t.("Steps")(1:3));
            s_best_last3 = min(t.("Steps")(4:end));
            s_imp = s_best_first3-s_best_last3;
            %disp([s_best_first3, s_best_last3, s_imp])
        catch
            disp(files{i})
        end
        
        if ~isempty(s_best_last3)
            s_imp_track = [s_imp_track, s_imp];
            s_best_last3_track =[s_best_last3_track, s_best_last3];
        end

    
        s_best_all = [s_best_all, min(t.("Steps"))];
        %lets see what sort of analysis we
        
    
    end

end