function popupWarning(marbLamp, rangeLamp, wheelLamp, guidedOrUnguided)
    % Just the easy warning if they pop it without things be ready yet

    popupFig = uifigure('Name','Oopsies', 'Position',[300,300,350,250]);
    pG = uigridlayout(popupFig, [5,3]);
    tellUser = uilabel(pG, "Text","Please meet the conditions to run simulation");
    tellUser.Layout.Row = 1; tellUser.Layout.Column = [1 3];

    if strcmp('unguided', guidedOrUnguided)
        marbWarnText = "(between 4 and 14)."; % change to and 20 for old one
        rangeWarnText = "(between 200 and 350).";
    else
        marbWarnText = "(check specification).";
        rangeWarnText = "(check specification).";
    end

    % Tell user what the error iss
    if isequal(marbLamp.Color, [1 0 0])
        marbWarn = uilabel(pG, "Text","Marble condition unsatisfied " + marbWarnText);
        marbWarn.Layout.Row = 2; marbWarn.Layout.Column = [1 3];
    end

    if isequal(rangeLamp.Color, [1 0 0])
        rangeWarn = uilabel(pG, 'Text',"Range condition unsatisied " + rangeWarnText);
        rangeWarn.Layout.Row = 3; rangeWarn.Layout.Column = [1 3];
    end

    if isequal(wheelLamp.Color, [1 0 0])
        wheelWarn = uilabel(pG, 'Text',"Wheel load cannot support amount of marbles");
        wheelWarn.Layout.Row = 4; wheelWarn.Layout.Column = [1 3];
    end

    


    oopsButton = uibutton(pG, 'push', 'Text', 'Okay', ...
        'ButtonPushedFcn', @(btn, event) close(popupFig));
    oopsButton.Layout.Row = 5; oopsButton.Layout.Column = 2;
    uiwait(popupFig);
end