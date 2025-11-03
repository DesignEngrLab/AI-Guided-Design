function pushRunButton(guidedOrUnguided,marbLamp, rangeLamp, wheelLamp, marblesEntry, entryTable, cost, path, cost_vals, simFig,resultsLabel,rangeDisp, costDisp, fleetDisp)
    % Run button 
    % Warn if not correct yet, else run the actual thing
    % the check with the
    if isequal(marbLamp.Color,[1 0 0]) || isequal(rangeLamp.Color,[1 0 0]) || isequal(wheelLamp.Color, [1 0 0])
        popupWarning(marbLamp, rangeLamp,wheelLamp,guidedOrUnguided);
    else
        popupAndRun(entryTable, marblesEntry,cost, path, cost_vals, simFig,resultsLabel, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbLamp);
    end

end