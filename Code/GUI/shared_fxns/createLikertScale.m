function createLikertScale
    % Create the GUI figure
    fig = uifigure('Name', 'Likert Scale', 'Position', [100 100 400 250]);

    % Add a question label
    uilabel(fig, ...
        'Position', [50 180 300 50], ...
        'Text', 'How satisfied are you with this design?', ...
        'FontSize', 14);

    % Create a button group for the Likert scale
    bg = uibuttongroup(fig, ...
        'Position', [50 100 300 50], ...
        'SelectionChangedFcn', @selectionChanged);

    % Add radio buttons to the button group
    uiradiobutton(bg, 'Text', '1', 'Position', [10 10 50 20]);
    uiradiobutton(bg, 'Text', '2', 'Position', [70 10 50 20]);
    uiradiobutton(bg, 'Text', '3', 'Position', [130 10 50 20]);
    uiradiobutton(bg, 'Text', '4', 'Position', [190 10 50 20]);
    uiradiobutton(bg, 'Text', '5', 'Position', [250 10 50 20]);

    % Add a submit button
    uibutton(fig, ...
        'Text', 'Submit', ...
        'Position', [150 40 100 30], ...
        'ButtonPushedFcn', @(btn, event) submitResponse(bg));
end

% Callback for selection change
function selectionChanged(src, event)
    disp(['Selected: ' event.NewValue.Text]);
end

% Callback for the submit button
function submitResponse(bg)
    selected = bg.SelectedObject.Text;
    disp(['You selected: ' selected]);
    % Save or process the response here
end
