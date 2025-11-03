function popupIterSurvey()

    popupFig = uifigure('Position',[50 50 900 800]);
    
    global noteCell note_file iter
    
    
    
    g = uigridlayout(popupFig);
    %g.Padding = [0 0 0 0];
    g.RowSpacing = 0;
    rows = repmat({'2x','2x','3x'}, 1,8);
    rows = [rows, {'2x'}];
    g.RowHeight = rows;
    g.ColumnWidth = {'1x','6x','1x'};
    
    
    s1 = sprintf("Not Confident \t \t Somewhat Confident \t \t Confident \t \t Very Confident \t \t Extremely Confident");
    q1 = createLikert(g, 1,"How confident are you that the performance of your current design will improve from your previous iterations?", s1);
    %bg1.SelectedObject.UserData
    
    s2 = sprintf("Not Effective \t \t Somewhat Effective \t \t Effective \t \t Very Effective \t \t Extremely Effective");
    q2 = createLikert(g, 4, "How effective do you think your design will be in planting trees?",s2);
    
    %n = enterEfficiency(g, 7, "What efficiency percentage do you think your design will be? (0-100%)");
    
    s3 = sprintf("Not Important \t \t Somewhat Important \t \t Important \t \t Very Important \t \t Extremely Important");
    q3 = createLikert(g, 7, "In this iteration, how important was cost in your design decisions?", s3);
    
    s4 = sprintf("Not Difficult \t \t Somewhat Difficult \t \t Difficult \t \t Very Difficult \t \t Extremely Difficult");
    q4 = createLikert(g, 10, "In this iteration, how important was time in your design decisions?",s3);
    
    q5 = createLikert(g, 13, "How difficult was it to meet the design requirements?",s4);
    
    
    s6 = sprintf("Not Innovative \t \t Somewhat Innovative \t \t Innovative \t \t Very Innovative \t \t Extremely Innovative");
    q6 = createLikert(g, 16, "How innovative was your current design iteration?",s6);
    
    q7 = createLikert(g, 19, "How important was the device's carrying capacity in your design decisions?", s3);
    
    q8 = createLikert(g, 22, "How important was the device's range in your design decisions?", s3);
    
    
    
    %enterButton =uibutton(g,"Text","Submit Answers", "ButtonPushedFcn",@(btn, event) close(popupFig));
    enterButton = uibutton(g,"Text","Submit", "ButtonPushedFcn",@(btn, event) submitAnswers(popupFig,q1.SelectedObject.UserData, q2.SelectedObject.UserData,...
        q3.SelectedObject.UserData, q4.SelectedObject.UserData, q5.SelectedObject.UserData, ...
        q6.SelectedObject.UserData, q7.SelectedObject.UserData, q8.SelectedObject.UserData));
    
    enterButton.Layout.Row = 25; enterButton.Layout.Column = 3;
    
    
    
    uiwait(popupFig)
    
    
    %q5 = createLikert(g, 13, "test5");
    
    function bg = createLikert(axes, row, question,s)
        q = uilabel(axes, "Text",question,"HorizontalAlignment","Center","FontWeight","Bold");
        q.Layout.Row = row;
        q.Layout.Column = [1 5];
        
    
        %scale = uilabel(axes, "Text",sprintf("Strongly Disagree \t \t Disagree \t \t Neutral \t \t Agree \t \t Strong Agree"), "HorizontalAlignment","Center");
        scale = uilabel(axes, "Text",s, "HorizontalAlignment","Center");
        scale.Layout.Row = row+1;
        scale.Layout.Column = [2 4];
    
        bg = uibuttongroup(axes);%, "SelectionChangedFcn", @(src) ChangeSelected(src));
        %bg.La
        
        bg.Layout.Row = row+2;
        bg.Layout.Column = [2 4];
        rb1 = uiradiobutton(bg,"Text","","Position",[40 10 80 20],"UserData",1); %rb1.Layout.Column =1;
        rb2 = uiradiobutton(bg,"Text","", "Position",[180 10 80 20],"UserData",2); %rb2.Layout.Column =2;
        rb3 = uiradiobutton(bg,"Text","", "Position",[320 10 80 20],"UserData",3); %rb3.Layout.Column =3;
        rb4 = uiradiobutton(bg,"Text","","Position",[460 10 80 20],"UserData",4); %rb4.Layout.Column =4;
        rb5 = uiradiobutton(bg,"Text","","Position",[600 10 20 20],"UserData",5); %rb5.Layout.Column =5;
    
        
    end
    %{
    function eff = enterEfficiency(axes, row, question)
        q = uilabel(axes, "Text",question,"HorizontalAlignment","Center","FontWeight","Bold");
        q.Layout.Row = row;
        q.Layout.Column = [2 4];
    
        label = uilabel(axes, "Text","Enter efficiency percentage: ", "HorizontalAlignment","Right");
        label.Layout.Row = row + 1;
        label.Layout.Column = [1 2];
    
        numericField = uieditfield(axes, 'numeric');
        numericField.Value = 0; 
        numericField.Limits = [0 100]; 
    
        numericField.Layout.Row = row +1;
        numericField.Layout.Column = 3;
    
        eff = numericField.Value;
    end
    %}
    
    
    function submitAnswers(popupFig, a1,a2,a3,a4,a5,a6,a7,a8)
        %disp([a1,a2,a3,a4,a5,a6,a7,a8,a9])
        noteCell(iter, 1:end) = {a1,a2,a3,a4,a5,a6,a7,a8};
        writecell(noteCell, note_file, "Sheet", num2str(iter));
        close(popupFig)
    
    end


end