function popupAndRun(entryTable, marblesEntry,cost, path, cost_vals, simFig,resultsLabel,  rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbLamp)  % This will also need to take values from then main one to plug into the simulation
    % If it's able to run, it pops again again and allows the user to start
    % running stuff.

    popupFig = uifigure('Name','Check', 'Position',[300,300,250,150]);
    pG = uigridlayout(popupFig, [2,3]);
    tellUser = uilabel(pG, "Text","Are you sure? Please verify everything.");
    tellUser.Layout.Row = 1; tellUser.Layout.Column = [1 3];

    yesButton = uibutton(pG, 'push','Text', 'Yes', ... 
        'ButtonPushedFcn', @(btn, event) runSim(popupFig, entryTable, marblesEntry, cost, path, cost_vals, simFig, resultsLabel, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp,marbLamp)); % This will also need to take values from then main one to plug into the simulation
    yesButton.Layout.Row = 2; yesButton.Layout.Column = 1;
    
    noButton = uibutton(pG, 'Text', 'No', ... 
        'ButtonPushedFcn', @(btn, event) close(popupFig)); % This will also need to take values from then main one to plug into the simulation
    noButton.Layout.Row = 2; noButton.Layout.Column = 3;

    uiwait(popupFig)

end