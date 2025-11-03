%%loading in stuff
addpath(genpath('shared_fxns'))
addpath('unguided_design_group_fxns')
addpath(genpath('dependencies'))

%%
load path.mat
load path_cost.mat
 
%% Hit just this cell if the previous has been started...

% code for creating the storage table and then being able to reopen it if
% need be.
global dataTable iter file_name tableHeaders fig timeTrack noteCell note_file

group_name = "example_test";
% Main parts of the table/calculation stuff for it (" is for those that
% need to be appended, those that 
[cost_vals, tableHeaders, materialsHeaders, Amount, entry] = shared_tables();

file_name = "data_unguided_group_"+group_name+".xls";
note_file = "notes_unguided_group_"+group_name+".xls";

% I am not sure how else to pass data out of the run. It's not efficient but it works

 if isfile(file_name)
    % This is here in case something went wrong and it closed out. That way
    % one can open it back up and everything is fine!
    sheet = sheetnames(file_name);
    dataTable = readtable(file_name,'Sheet',sheet(end));
    past_iter = sum(dataTable.Steps ~= 0);
    iter = past_iter + 1;

 else
    c = repmat({[]}, 1, 20);
    dataTable = table(c{:},'VariableNames', tableHeaders);
    iter = 1;
    writetable(dataTable,file_name,'Sheet',num2str(iter));
 end

 if isfile(note_file)
     sheet = sheetnames(note_file);
     noteCell= table2cell(readtable(note_file,'Sheet',sheet(end)));
     checkMissing = cellfun(@(x) any(isa(x,'missing')), noteCell);
     noteCell(checkMissing) = {[0]};
 else
     noteCell = repmat({[]},1,8);
     writecell(noteCell, note_file,'Sheet',num2str(0))
 end


% Note: I will likely need to make two versions. One

fig = uifigure('Name', 'Interactive Fleet Designer', 'Position', [100 100 1400 600]);
g = uigridlayout(fig);

g.RowHeight = {'1x', '8x', '3x'};
g.ColumnWidth = {'2x', '3x'};

% Let's test that simulation stuff a bit...

simFig = uiaxes(g);
simFig.Layout.Row = 2; simFig.Layout.Column = 2;

bR = imread('Final Background 4.png');
bX = [0,60];
bY = [0,40];
image(simFig, bX,bY,bR)
axis(simFig, 'equal')
xlim(simFig, bX) % for some reason, need to be at end??? Make sure to include in the plotting
ylim(simFig, bY)





% let's add in subgrids and teh first set of buttons
sg1 = uigridlayout(g,[5,3]);
sg1.ColumnWidth = {'3x','3x','1x'};
sg1.Layout.Row = 3; sg1.Layout.Column = 1;

% Placeholder: this message will be udpated by the Bayesian optimizer
goalInfo = uilabel(sg1, "Text","Unguided group: Set your own specifications.");
goalInfo.FontWeight = 'bold';
goalInfo.Layout.Row = 1; goalInfo.Layout.Column = [1 3];

% Lamp displays! These need to go first.
marbLamp = uilamp(sg1);
marbLamp.Color = 'red';
marbLamp.Layout.Row = 2; marbLamp.Layout.Column = 3;

wheelLamp = uilamp(sg1);
wheelLamp.Color = 'red';
wheelLamp.Layout.Row = 3; wheelLamp.Layout.Column = 3;


rangeLamp = uilamp(sg1);
rangeLamp.Color = 'red';
rangeLamp.Layout.Row = 4; rangeLamp.Layout.Column = 3;



% Will need to modify this so that it also somehow displays the goals
rangeDisp = uilabel(sg1, 'Text','Range: ');
rangeDisp.Layout.Row = 4; rangeDisp.Layout.Column = 1;

costDisp = uilabel(sg1, 'Text','Cost: ');
costDisp.Layout.Row = 5; costDisp.Layout.Column = 1;


% Showing the calculation based on the cost
fleetDisp = uilabel(sg1, 'Text', 'Resulting Fleet size: ');
fleetDisp.Layout.Row = 5; fleetDisp.Layout.Column = 2;

marblesDisp = uilabel(sg1, "Text","Marbles: ");
marblesDisp.Layout.Row = 2; marblesDisp.Layout.Column = 1;

wheelDisp = uilabel(sg1, "Text", "Wheels:");
wheelDisp.Layout.Row = 3; wheelDisp.Layout.Column = 1;

global entryTable

marblesEntry = uieditfield(sg1, 'numeric', ...
    'ValueChangedFcn', @(src, event) marbCheck(src, marbLamp, rangeDisp, costDisp, fleetDisp, wheelLamp, rangeLamp, cost_vals));
marblesEntry.Value = 0;
marblesEntry.Layout.Row = 2; marblesEntry.Layout.Column =2;



% Here's that table
entryTable = uitable(g, ...
    "Data",entry,...
    'ColumnEditable',[false, false, true],...
    'CellEditCallback',@(src, event) autoCalc(src, event,  rangeDisp, costDisp, fleetDisp, rangeLamp, wheelLamp, marblesEntry.Value, cost_vals));

entryTable.Layout.Row = 2; entryTable.Layout.Column = 1;

% just noticed that it's technically possible to fuck up the table. 

% Here's some labels


tableLabel = uilabel(g, 'Text', 'Device Building');
tableLabel.FontSize = 16;
tableLabel.FontWeight = 'bold';
tableLabel.HorizontalAlignment = 'center';
tableLabel.Layout.Row = 1; tableLabel.Layout.Column = 1;

plotLabel = uilabel(g, 'Text', 'Simulation Plot');
plotLabel.FontSize = 16;
plotLabel.FontWeight = 'bold';
plotLabel.HorizontalAlignment = 'center';
plotLabel.Layout.Row = 1; plotLable.Layout.Column = 2;


% Also now adding in the other buttons and display
sg2 = uigridlayout(g, [3,4]);
sg2.Layout.Row = 3; sg2.Layout.Column = 2;
sg2.RowHeight = {'1x', '3x', '1x'};
sg2.ColumnWidth = {'2x', '3x','2x','2x'};


if iter == 1
    resultsLabelText = 'No Design Run Yet';
else
    %resultsLabelText = "Previous design completed in " + num2str(dataTable.Steps(iter-1)) + " time steps.";
    resultsLabelText = sprintf("Previous design completed \nin " + ...
    num2str(dataTable.Steps(iter-1)) + " time steps.\nThis is considered "...
    + num2str(dataTable.PercentEffective(iter-1)) + "%% effective.");
end

resultsLabel = uilabel(sg2, 'Text', resultsLabelText); % add in callback later
resultsLabel.Layout.Row = 2; resultsLabel.Layout.Column = 2;


runButton = uibutton(sg2, 'push','Text',sprintf('Design entered and\nverified.'),...
    'ButtonPushedFcn', @(btn, event) pushRunButton('unguided',marbLamp, rangeLamp, wheelLamp, marblesEntry, entryTable, path_cost, path, cost_vals, simFig, resultsLabel,rangeDisp, costDisp, fleetDisp));
runButton.Layout.Row = 2; runButton.Layout.Column = 1;

viewPrevButton = uibutton(sg2, 'push', 'Text',sprintf('View Previous\n(this takes a while)'),...
    'ButtonPushedFcn',@(btn, event) dispPrevious());
viewPrevButton.Layout.Row = 2; viewPrevButton.Layout.Column =3;

finalResponseButton = uibutton(sg2, 'push', 'Text', sprintf('Press when done.'),...
    'ButtonPushedFcn',@(btn, event) final_free_response());
finalResponseButton.Layout.Row = 2; finalResponseButton.Layout.Column =4;

%start design timer
timeTrack = tic;


t = timer('ExecutionMode', 'fixedSpacing', ...
          'Period', 60, ...
          'TimerFcn', @(~,~) keepGUIActive(tableLabel), ...
          'StartDelay', 60);
start(t);

fig.CloseRequestFcn = @(src, event) closeGUI(src, t);

