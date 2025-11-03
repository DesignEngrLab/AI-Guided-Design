function autoCalc(entryTable, event, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbles, cost_vals)
    % Function for updating how everything appears on the GUI
    global dataTable iter

    entryTable = rounding_entry_table(entryTable);
    
    
    [costAgent,rangeVal, fleet_size] = calcFleetStuff(entryTable, marbles, cost_vals);
    rangeDisp.Text = ['Range: ' num2str(rangeVal)];
    
    % Range check (marble is done elsewhere)
    % For control, just have it be above a certain value.
    if rangeVal == dataTable.Range(iter)
        rangeLamp.Color = 'green';
    else
        rangeLamp.Color = 'red';
    end
    
    %wheelLoad = 2*entryTable.Data.Amount(11) + 4*entryTable.Data.Amount(12);
    %wheelLoad = calcWheelLoad(entryTable.Data.Amount(11));

    %wheelDisp.Text = ['Current wheels rated for ', num2str(wheelLoad), ' marbles.'];

    % if wheelLoad >= number or marbles?
    if entryTable.Data.Amount(11) >= 3
        wheelLamp.Color = 'green';
    else
        wheelLamp.Color = 'red';
    end

    costDisp.Text = ['Cost: ', num2str(costAgent)];
    fleetDisp.Text = ['Resulting Fleet size: ', num2str(fleet_size)];

    

end