function runAllInitials(cost, path,simFig)
    % This function runs all the initial ones.
    global dataTable
    % needs to be able to 

    for i = 1:3
        if dataTable.Feasibility(i) == 1
            fleet_size = dataTable.Fleet_Size(i);
            marbles = dataTable.Marbles(i);
            range = dataTable.Range(i);

            steps= run_plot_sim(fleet_size, marbles, range,cost, path,simFig);
            dataTable.Steps(i) = steps;
            score = (1 - (steps-500)/1250) *100;
            dataTable.PercentEffective(i) = score;

            popup = uifigure("Name","Initial Samples",'Position',[300,300,450,300]);
            pG = uigridlayout(popup,[2,1]);
            checkMessage = uilabel(pG,"Text",sprintf(['Sample #',num2str(i),...
                ' with\n', num2str(marbles),' marbles and a range of ',...
                num2str(range),'\ncompleted in ', num2str(steps),' steps.'...
                'This is considered ', num2str(score), '%% effective.']));
            checkMessage.Layout.Row = 1;
            closeButton = uibutton(pG,"Text","Okay", "ButtonPushedFcn",@(btn, event) close(popup));
            closeButton.Layout.Row = 2;
            uiwait(popup)

            
        end
    end
end