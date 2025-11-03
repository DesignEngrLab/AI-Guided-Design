function final_free_response

    
    
    %testing_ending
    global noteCell note_file iter moveforward
    
    moveforward=false;
    if iter < 6
        fig = uifigure('Position',[50 50 300 200]);
        rng(10);
        g = uigridlayout(fig,[2,2]);
        message = uilabel(g, "Text", sprintf("6 iterations not complete yet. Instructor will \n give you override key if we ran out of time :("));
        message.Layout.Row=1; message.Layout.Column = [1,2];
        
        codemessage = uilabel(g, "Text", "Code for exit survey");
        codemessage.Layout.Row=2;codemessage.Layout.Column = 1;

        check = uieditfield(g, "numeric","ValueChangedFcn",@(src,event) initSurvey(src,event,fig));
        check.Layout.Row=2;check.Layout.Column =2;
        uiwait(fig)

    else
        moveforward = true;
    
    end

    if moveforward

    % now move on the actual free response crap

    fig = uifigure('Position',[50 50 950 800]);
    
    qdif1 = sprintf("How difficult was this experiment?");
    s_dif1 = sprintf("Not Difficult \t \t Somewhat Difficult \t \t Difficult \t \t Very Difficult \t \t Extremely Difficult");

    qdif2 = sprintf("How overwhelming was the amount of information you had to process?");
    s_dif2 = sprintf("Not Overwhelming \t \t Somewhat Overwhelming \t \t Overwhelming \t \t Very Overwhelming \t \t Extremely Overwhelming");
    


    qa = sprintf("How confident are you that you understand how the fleet of devices behave?");
    qb = sprintf("How confident are you that understand the design tradeoffs?");
    qc = sprintf("If you designed a new device with the same carrying capacity, but you had to increase the range, what happens to the fleet effectiveness?");
    qd = sprintf("If you designed a new device with the same range, but you had to increase the capacity, what happens to the fleet  effectiveness?");
    qe = sprintf("If two devices have the same specifications, but the fleet size slightly decreased from 40 to 38, what happens to the fleet  effectiveness?");
    qf = sprintf("What device specifications do you believe would lead to optimal fleet effectiveness?");
    
    
    s_ab= sprintf("Not Confident \t \t Somewhat Confident \t \t Confident \t \t Very Confident \t \t Extremely Confident");
    
    
    
    
    frq1 = sprintf("What was the most challenging aspect of this experiment? Why?");
    frq2 = sprintf("If you were to design these devices again, what would you do differently?");
    frq3 = sprintf("Is there anything you would change about this experiment? Why?");
    
    
    g = uigridlayout(fig);
    %g.Padding = [0 0 0 0];
    g.RowSpacing = 0;
    g.RowHeight = [repmat({'1x','1x','2x'}, 1,4),repmat({'1x','1x'}, 1,4),repmat({'1x','2x'},1,3),'1x'];
    
    g.ColumnWidth = {'1x','3x','3x','3x','1x'};

    eA = createLikert(g, 1, qdif1, s_dif1);
    eB = createLikert(g, 4, qdif2, s_dif2);
    
    e1 = createLikert(g, 7, qa, s_ab);
    e2 = createLikert(g, 10, qb, s_ab);
    
    tc = uilabel(g, "Text",qc, "HorizontalAlignment","Center", "FontWeight","Bold");
    dc = uidropdown(g,"Items",["Decreases", "Stays the Same", "Increases"]);
    tc.Layout.Row = 13; tc.Layout.Column = [1 5];
    dc.Layout.Row = 14; dc.Layout.Column = 3;
    
    td = uilabel(g, "Text",qd,  "HorizontalAlignment","Center", "FontWeight","Bold");
    dd = uidropdown(g,"Items",["Decreases", "Stays the Same", "Increases"]);
    td.Layout.Row = 15; td.Layout.Column = [1 5];
    dd.Layout.Row = 16; dd.Layout.Column = 3;
    
    te = uilabel(g, "Text",qe,  "HorizontalAlignment","Center", "FontWeight","Bold");
    de = uidropdown(g,"Items",["Decreases", "Stays the Same", "Increases"]);
    te.Layout.Row = 17; te.Layout.Column = [1 5];
    de.Layout.Row = 18; de.Layout.Column = 3;
    
    tf = uilabel(g, "Text",qf, "HorizontalAlignment","Center","FontWeight", "Bold");
    tf.Layout.Row = 19; tf.Layout.Column = [1 5];
    
    
    marb_lab = uilabel(g,"Text","Marbles:","HorizontalAlignment","Left");
    rang_lab = uilabel(g, "Text","Range:","HorizontalAlignment","Left");
    marb_lab.Layout.Row=20; rang_lab.Layout.Row=20;
    marb_lab.Layout.Column=2; rang_lab.Layout.Column=4;
    
    marb_guess = uieditfield(g,'numeric','AllowEmpty','off','RoundFractionalValues','on');
    marb_guess.Limits = [4 14];
    rang_guess = uieditfield(g,'numeric',"AllowEmpty","off",'RoundFractionalValues','on');
    rang_guess.Limits = [200 350];
    marb_guess.Layout.Row=21; rang_guess.Layout.Row=22;
    marb_guess.Layout.Column = 3; rang_guess.Layout.Column = 5;
    
    
    
    p1 = uilabel(g, "Text",frq1, "HorizontalAlignment","Center","FontWeight","Bold");
    r1 = uitextarea(g);
    p1.Layout.Row=23; p1.Layout.Column = [1 5];
    r1.Layout.Row=24; r1.Layout.Column = [1 5];
    
    
    p2 = uilabel(g, "Text",frq2, "HorizontalAlignment","Center","FontWeight","Bold");
    r2 = uitextarea(g);
    p2.Layout.Row=25; p2.Layout.Column = [1 5];
    r2.Layout.Row=26; r2.Layout.Column = [1 5];
    
    p3 = uilabel(g, "Text",frq3, "HorizontalAlignment","Center","FontWeight","Bold");
    r3 = uitextarea(g);
    p3.Layout.Row=27; p3.Layout.Column = [1 5];
    r3.Layout.Row=28; r3.Layout.Column = [1 5];
    
    
    enterButton = uibutton(g,"Text","Submit", "ButtonPushedFcn",@(btn, event) ...
        submitAnswers(fig,eA.SelectedObject.UserData, eB.SelectedObject.UserData, e1.SelectedObject.UserData, e2.SelectedObject.UserData, dc.Value, dd.Value,de.Value, marb_guess.Value, rang_guess.Value, r1.Value,r2.Value, r3.Value));
    enterButton.Layout.Row=29; enterButton.Layout.Column = 3;

    
    uiwait(fig)


    end
    
    
    function submitAnswers(fig, AA,AB, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
 
        a8 = cell2mat(a8);
        a9 = cell2mat(a9);
        a10 = cell2mat(a10);
        noteCell(iter+1:iter+12, :) = [{AA, AB, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10}', repmat({[0]},12,7)];
        checkMissing = cellfun(@(x) any(isa(x,'missing')), noteCell);
        noteCell(checkMissing) = {[0]};
        writecell(noteCell, note_file, "Sheet", num2str(iter+1));
        close(fig)
    
    end

    function initSurvey(src,event,fig)
        rng(10);
        if src.Value == randi([0 1000])
           moveforward = true;
           close(fig)
        end
        
    end


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





end