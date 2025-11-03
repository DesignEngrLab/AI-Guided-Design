function steps_to_completion = run_plot_sim(num_agents, num_seeds, range, cost, path,simFig)

jobTime = 20;

cla(simFig)
G = generate_sim_v3;
pos = cell2mat(G.Nodes.Pos);

[vehicles, trees] = generate_agents(num_agents,num_seeds,range,jobTime, G);




max_steps = 100000; 
bR = imread('Final Background 4.png');
bX = [0,60];
bY = [0,40];

returning_home = false;


for i = 1:max_steps % Switch to while loop later, this is safer for testing
    % actually I think that it's better if I start with assignment function
    % up here on each step! m
    %
    image(simFig, bX,bY,bR)
    hold(simFig, 'on')
    axis(simFig, 'equal')
    xlim(simFig, bX) % for some reason, need to be at end??? Make sure to include in the plotting
    ylim(simFig, bY)
    %}
    % assign agents
    unassignedVehis = cellfun(@(x) x.Free, vehicles);
    unassignedTrees = cellfun(@(x) not(x.Assigned) , trees);

    if any(unassignedVehis) && sum(unassignedTrees) > 0
        
        [vehicles, trees] = assign_paths(unassignedVehis, vehicles, trees,cost, path,jobTime);
        % unassignedVehis = cellfun(@(x) x.Free, vehicles);
    end


    % move all agents...
    plot_agent = [];
    for k = 1:num_agents
        [vehicles, trees] = update_vehicle(G, k, vehicles, trees, ...
            num_seeds, range, path, jobTime);
        node = vehicles{k}.NodeIndex;
        plot_agent = [plot_agent;G.Nodes.Pos{node}(1),G.Nodes.Pos{node}(2)];
        %plot(G.Nodes.Pos{node}(1),G.Nodes.Pos{node}(2),'o','MarkerFaceColor','r')
        %text(G.Nodes.Pos{node}(1),G.Nodes.Pos{node}(2), num2str(k))
    end
    %hmm = sum(cellfun(@(x) not(x.Complete) , trees))
    %disp([num_agents, num_seeds, range])
    %plot_agent
    
    %
    plot(simFig, plot_agent(:,1), plot_agent(:,2),'o','MarkerFaceColor','r', 'MarkerEdgeColor','y')

    plot_tree = [];
    for k = 1:length(trees)
        if trees{k}.Complete
            plot_tree = [plot_tree; G.Nodes.Pos{trees{k}.NodeIndex}(1),G.Nodes.Pos{trees{k}.NodeIndex}(2)];
        end
    end

    if ~isempty(plot_tree)
        plot(simFig, plot_tree(:,1), plot_tree(:,2),'o', 'Color','w')
    end
    

    hold(simFig, 'off') 
    
    pause(0.01)
    %}
    % if all complete, send out the order to return home!
    %disp(sum(cellfun(@(x) not(x.Complete) , trees)))
    if sum(cellfun(@(x) not(x.Complete) , trees)) == 0
        % See if the order is sent yet and if its home. Else, send order
        if returning_home
            v_home = cellfun(@(x) strcmp('H', x.Node), vehicles);
            if sum(v_home) == num_agents
                steps_to_completion = i;
                break
            end
        
        else
            vehicles = assign_all_home(G, vehicles);
            returning_home = true;
        end

    end

end

% Computational complexity penalt:
% Since linear assignment is O(n^2), add in an additional coordination cost
% to add an additional tradeoff.
steps_to_completion = steps_to_completion + ceil(0.1*num_agents^2);



end