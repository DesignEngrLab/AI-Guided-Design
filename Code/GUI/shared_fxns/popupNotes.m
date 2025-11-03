function note = popupNotes(notetype)
    % Note pop up to gather qualitative information


    if strcmp(notetype,'infeasible')
        prompt = "What made you decide this is infeasible?";

    elseif strcmp(notetype, 'design target')
        prompt = "What made you decide on this design?\nWas it easy to meet these specifications?";
    else
        prompt = "What made you decide on this design?\nWhy these specifications";
    end

    prompt = sprintf(prompt+"\nPlease enter any notes about your design or thought process.");

    popupFig = uifigure('Name','Note Entry', 'Position',[300,300,350,250]);
    pG = uigridlayout(popupFig,[3,1]);
    promptText = uilabel(pG, "Text",prompt);
    promptText.Layout.Row = 1;

    txtArea = uitextarea(pG);
    txtArea.Layout.Row = 2;

    submit = uibutton(pG, 'push','Text','Enter', 'ButtonPushedFcn',@(btn, event) submitText(txtArea, popupFig));
    submit.Layout.Row = 3;

    
    uiwait(popupFig)

    note = txtArea.Value;
    note = strjoin(note,newline);

    close(popupFig)

    function submitText(txtArea, fig)
        % Resume the execution of the main function
        uiresume(fig);
    
        % Optionally, you can close the figure here or let the main function handle it
        
    end

end