function G = generate_sim()
% essentially you're

%Other things to consider: 

% Some of these are from the previous concept of generating. You're not
% going to do that as much but keep it for a second before you delete
% them. Oh actually. It's better to just control the number on each and
% fuck around with things. You could also include that as an input for this
% function that way you can test a few different simulations and maybe even
% keep this simulation for another time! It' just dumb enough to be useful
% elsewhere...


pathLength = 1; % path length
pathSplitFactor = 1.2; % how angles change

cPath = [255, 190, 72]/256;
cTree = [55, 182, 16 ]/256;


startPos = [2,2];
startAngle = pi/12;
pathAngle = pi/24; %delta in path
plantAngle = pi/4; %offshoot path angle from main (may not use)

seed = 7325;
rng(seed)



% For now it's easier to just add each thing manually

% add home
G = graph;
G = addnode(G, table({'H'}, {startPos},{startAngle},{'Home'},{cPath},...
    'VariableNames',{'Name', 'Pos','Angle','Type','Color'} ));

% Adding paths from the H node May need to modify this and the split node
% function to indicate what thing to attach to. I.E. return an index? Not
% entirely sure if that's necessary though. Might be for adding in
% additinoal split nodes.
[G, name_prev] = add_paths(G, 'H',0.125,25);

%add first split node thign
[G, split_1] = add_split(G,name_prev,pathSplitFactor);

%add paths in one direciton from that split node.
[G, p_up] = add_paths(G, split_1,0.5,20);

%Update split angle
G = update_angle(G,split_1,-0.5);


%add paths in other direction from that split node. 
[G, p_low] = add_paths(G, split_1,-0.75,15);


%add another split node up top
[G, split_up] = add_split(G,p_up,0);
[G, p_up_A] = add_paths(G, split_up,0.75,20);
G = update_angle(G,split_up,0);
[G, p_up_B] = add_paths(G, split_up,-1.2,25);

%add another split node in bottom.
[G, split_low] = add_split(G,p_low,pathSplitFactor);
[G, p_low_A] = add_paths(G, split_low,1.2,15);
G = update_angle(G,split_low,-0.5);
[G, p_low_B] = add_paths(G, split_low,0.5,20);

%one (or maybe more) splits
[G, split_low_A] = add_split(G, p_low_A, 0);
[G, p_low_AA] = add_paths(G, split_low_A,0.75,14);
G = update_angle(G,split_low_A,-0.5);
[G, p_low_AB] = add_paths(G, split_low_A,-1,10);


% one more set for making it look neato
[G, split_low_AA] = add_split(G, p_low_AB,pathSplitFactor-0.5);
[G, p_low_ABA] = add_paths(G, split_low_AA, 1.2, 20);
G = update_angle(G,split_low_AA,-0.5);
[G, p_low_ABB] = add_paths(G, split_low_AA, -1, 12);


% add in offshoots...
j = 1; %name indexing for the e
for i = 1:numnodes(G)

    % If it's
    if strcmp(G.Nodes.Type{i},'Path') & rand < 0.5
        name = strcat('T',int2str(j));
        dA = -(pi/2)*(2*randi([0,1])-1);
        newX = G.Nodes.Pos{i}(1) + pathLength*cos(G.Nodes.Angle{i}+dA);
        newY = G.Nodes.Pos{i}(2) + pathLength*sin(G.Nodes.Angle{i}+dA);
        newA = 0; %doesn't matter
        
        G = addnode(G, table({name},{[newX, newY]},{newA},{'Tree'},{cTree},...
            'VariableNames',{'Name', 'Pos','Angle','Type','Color'} ));
        G = addedge(G,G.Nodes.Name{i},name);
        j = j +1;
    end
    
end


%flip all the Y positions
for i = 1:numnodes(G)
    G.Nodes.Pos{i}(2) = 50-G.Nodes.Pos{i}(2);

end


function [G, name_prev] = add_paths(G,name_prev,curve_factor,total_p)
    % Function to add a set number of paths that curve a bit after
    % something.

    % figure out what number to be using for P nodes
    hasP = cellfun(@(x) contains(x, 'P'), G.Nodes.Name);
    numbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), G.Nodes.Name(hasP));

    if isempty(numbers)
        n_p = 1; % just means we're starting out
    else
        n_p = max(numbers)+1;
    end

    % Add in first one manually based on previous

    in_p = find(cellfun(@(x) contains(x, name_prev), G.Nodes.Name));

    for j = n_p+1:(n_p+total_p)

        name = strcat('P',int2str(j-1));
    
        newX = G.Nodes.Pos{in_p}(1) + pathLength*cos(G.Nodes.Angle{in_p});
        newY = G.Nodes.Pos{in_p}(2) + pathLength*sin(G.Nodes.Angle{in_p});
        newA = G.Nodes.Angle{in_p} + curve_factor*pathAngle;

        G = addnode(G, table({name}, {[newX, newY]},{newA},{'Path'},{cPath},...
        'VariableNames',{'Name', 'Pos','Angle','Type','Color'} ));
    
        G = addedge(G,name_prev,name);

        in_p = numnodes(G);
        name_prev = name;
    end


end

    function [G, name] = add_split(G, name_prev,split_factor)
        % function that adds the split node. Includes the split factor,
        % which is key for the next node. With that though, you'll need to
        % figure out if the curve factor on the other thing will work well
        % in the neagtive and positive direction.
        % Unsure if I should 

    % figure out what number to be using for P nodes
    hasS = cellfun(@(x) contains(x, 'S'), G.Nodes.Name);
    numbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), G.Nodes.Name(hasS));

    if isempty(numbers)
        name = 'S1';
    else
        name = strcat('S', int2str(max(numbers)+1));
    end
    
    i = find(cellfun(@(x) contains(x, name_prev), G.Nodes.Name));

    newX = G.Nodes.Pos{i}(1) + pathLength*cos(G.Nodes.Angle{i});
    newY = G.Nodes.Pos{i}(2) + pathLength*sin(G.Nodes.Angle{i});
    newA = G.Nodes.Angle{i} + split_factor*pathAngle*3;
    
    G = addnode(G, table({name}, {[newX, newY]},{newA},{'Split'},{cPath},...
    'VariableNames',{'Name', 'Pos','Angle','Type','Color'} ));
    
    G = addedge(G,name_prev,name);
    end

    function G = update_angle(G, name_prev,change)
    in_p = find(cellfun(@(x) contains(x, name_prev), G.Nodes.Name));
    G.Nodes.Angle{in_p} = G.Nodes.Angle{in_p}+change;
    end

end