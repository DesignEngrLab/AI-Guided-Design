function actualRunSim(src, event, checkFig, marbleEntry, cost, path, cost_vals, simFig,resultsLabel, entryTable, rangeDisp, costDisp, fleetDisp,rangeLamp, wheelLamp, marbLamp)
    global dataTable iter file_name tableHeaders timeTrack
    rng(iter)
    secretCode = randi([1,1000]);

    if isequal(src.Value, secretCode)
        close(checkFig)
        %dt = datetime('now','Format','HH:mm');
        %h = hour(dt);
        %m = minute(dt);
        %s = second(dt);
        %locTime = h + m/100 + round(s)/10000;% time as a number. Convert back later, this is just for storage%toc(timeTrack);
        %noteTable.Notes{iter} = popupNotes('other');
        popupIterSurvey;
    
        [costVal,range, fleet_size] = calcFleetStuff(entryTable, marbleEntry.Value, cost_vals);
        % defaults
    
        steps= run_plot_sim(fleet_size, marbleEntry.Value, range, cost, path,simFig);
        score = (1 - (steps-500)/1250) *100;    
        dev_time = toc(timeTrack);
    
        %entry = [{iter,marbleEntry.Value,range,costVal, fleet_size, steps, score, locTime}, num2cell(entryTable.Data.Amount(:)')];
        entry = [{iter,marbleEntry.Value,range,costVal, fleet_size, steps, score, dev_time}, num2cell(entryTable.Data.Amount(:)')];
   
        iterTable = table(entry{:}, 'VariableNames', tableHeaders);
        dataTable = [dataTable;iterTable];
        writetable(dataTable,file_name,"Sheet",num2str(iter))
        %writetable(noteTable,note_file,"Sheet",num2str(iter))
    
        iter = iter + 1;
    
        resultsLabel.Text = sprintf("Previous design completed in " + num2str(steps) + " time steps.\n This is considered " + num2str(score) + "%% effective.");

        % clears the table
        entryTable.Data.Amount = zeros(12,1);
        marbleEntry.Value = 0;
        marbLamp.Color = [1 0 0];
        autoCalc(entryTable,0,rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbleEntry.Value, cost_vals)
        
        %reset timer for designers
        timeTrack = tic;
    end
end