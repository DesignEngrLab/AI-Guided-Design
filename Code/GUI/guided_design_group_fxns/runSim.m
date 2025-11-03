function runSim(popupFig, entryTable, marbleEntry, cost, path, cost_vals, simFig,resultsLabel, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbLamp)
    % In this folder, the    

    global dataTable iter file_name tableHeaders %ugly but it works
    close(popupFig)
    
    checkFig = uifigure("Name","Code Entry",'Position',[300,300,450,150]);
    
    pG = uigridlayout(checkFig,[2,2]);
    checkMessage = uilabel(pG,"Text","Please check feasibility and receive code from coordinator");
    checkMessage.Layout.Row = 1; checkMessage.Layout.Column = [1 2];
    
    codeMessage = uilabel(pG, "Text", ["Code for iter ", num2str(iter)]);
    codeMessage.Layout.Row = 2; codeMessage.Layout.Column = 1;
    
    checkEntry = uieditfield(pG, "numeric","ValueChangedFcn",@(src, event) actualRunSim(src,event, checkFig, marbleEntry, cost, path, cost_vals, simFig,resultsLabel, entryTable, rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marbLamp));
    checkEntry.Layout.Row = 2; checkEntry.Layout.Column = 2;

    uiwait(checkFig)


end