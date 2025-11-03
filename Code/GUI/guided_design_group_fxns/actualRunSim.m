function actualRunSim(src, event, checkFig, marbleEntry, cost, path, cost_vals, simFig,resultsLabel, entryTable, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbLamp)
    global dataTable iter file_name goalInfo  timeTrack
    rng(iter)
    secretCode = randi([1,1000]);
    
    if isequal(src.Value, secretCode)
        
        close(checkFig)

        % enter time, but don't reset clock until after it's saved.
        %dt = datetime('now','Format','HH:mm');
        %h = hour(dt);
        %m = minute(dt);
        %s = second(dt);
        %dataTable.iterTime(iter) = h + m/100 + round(s)/10000;
        dataTable.iterTime(iter) = toc(timeTrack);
        %noteTable.Notes{iter} = popupNotes('design target');
        popupIterSurvey;
        
    
        % Enter the current design.
        [costVal,range, fleet_size] = calcFleetStuff(entryTable, marbleEntry.Value, cost_vals);
        dataTable(iter,10:end)= num2cell(entryTable.Data.Amount(:)');
        dataTable.Range(iter) = range;
        dataTable.Fleet_Size(iter) = fleet_size;
        dataTable.Cost(iter) = costVal;
        dataTable.Feasibility(iter) = 1;
        dataTable.Iteration(iter) = iter;
        

        bayes_run = false;

        if iter < 3

            % popup letting them know
            popup = uifigure("Name","Initial Samples",'Position',[300,300,500,200]);
            
            pG = uigridlayout(popup,[2,1]);
            checkMessage = uilabel(pG,"Text",sprintf(['Sample #',num2str(iter),' entered.\nComplete all three initial.']));
            checkMessage.Layout.Row = 1;
            closeButton = uibutton(pG,"Text","Okay", "ButtonPushedFcn",@(btn, event) close(popup));
            closeButton.Layout.Row = 2;
            uiwait(popup)


        elseif iter == 3
            popup = uifigure("Name","Initial Samples",'Position',[300,300,300,300]);
            pG = uigridlayout(popup,[2,1]);
            checkMessage = uilabel(pG,"Text","All initial samples added. Click close to watch all designs.");
            checkMessage.Layout.Row = 1;
            closeButton = uibutton(pG,"Text","Okay", "ButtonPushedFcn",@(btn, event) close(popup));
            closeButton.Layout.Row = 2;
            uiwait(popup)

            % This is where all get run all the initial ones.
            runAllInitials(cost, path,simFig);
            [marb_next, range_next] = runConstrainedBayes();
            resultsLabel.Text = "Initial designs run, see table.";
            
            bayes_run = true;

        else
            % now we're just onto the regular running stuff.
            steps = run_plot_sim(fleet_size, marbleEntry.Value, range, cost, path,simFig);
            dataTable.Steps(iter) = steps;
            score = (1 - (steps-500)/1250) *100;
            dataTable.PercentEffective(iter) = score;
            resultsLabel.Text = sprintf("Previous design completed in " + num2str(steps) + " time steps.\n This is considered " + num2str(score) + "%% effective.");
            [marb_next, range_next] = runConstrainedBayes();
            bayes_run = true;
        end

        % this needs to be done afterward? I think. There may be a save
        % issue and I'll need to write it again. Com
        if bayes_run
            dataTable = [dataTable;array2table(zeros(1,21), 'VariableNames', dataTable.Properties.VariableNames)];
            dataTable.Marbles(iter+1) = marb_next;
            dataTable.Range(iter+1) = range_next;
        end

        % Now we save and go to the next iteration. 
        writetable(dataTable,file_name,"Sheet",num2str(iter))
        %writetable(noteTable,note_file,"Sheet",num2str(iter))

        iter = iter + 1;

        if iter<7
            goalInfo.Text = ['Current design goal: ', ...
            num2str(dataTable.Marbles(iter)), ' Marbles and ', ...
            num2str(dataTable.Range(iter)), ' Range'];
        else
            goalInfo.Text = 'Finished. Complete final Survey'; %Make sure they don't see final
        end
        
        marbleEntry.Value = 0;
        marbLamp.Color = [1 0 0];
        entryTable.Data.Amount = zeros(12,1);
        autoCalc(entryTable,0,rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbleEntry.Value, cost_vals)
        
        % now reset timer
        timeTrack = tic;

    end
end