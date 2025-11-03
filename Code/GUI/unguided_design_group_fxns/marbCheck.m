function marbCheck(src, marbLamp, rangeDisp, costDisp, fleetDisp, wheelLamp,rangeLamp, cost_vals)
    % Turns marble light on based on condition
    % Control group is a range. Make modified one for targets

    %if src.Value >= 4 && src.Value <= 20 
    if src.Value >= 4 && src.Value <= 14 
        marbLamp.Color = 'green';
    else
        marbLamp.Color = 'red';
    end
    
    global entryTable
    
    autoCalc(entryTable, [], rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, src.Value, cost_vals)
end