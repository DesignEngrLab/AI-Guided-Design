function [vehicles, trees] = update_vehicle(G, k, vehicles, trees, num_seeds, range, path, jobTime)
% Function for updating a single vehicle agents
% Main states/rules:
% If it's free, that means it has to do something. 
% It has four main things it is doing
% Going to the destination (target tree or home)
% Planting a tree
% Recharging?


if not(vehicles{k}.Free)
    % if it's at the destination, it has to be doing something!
    % Else it is moving in some way towards it's destination
    if strcmp(vehicles{k}.Node,vehicles{k}.Destination)
        % If it's at home, it needs to refill and recharge
        % This will likely be changed to something regarding general reset
        % time, such as 5 time steps or whatever. Or nothing.
        % Else it is placing something in the tree hole and reseting


        if strcmp(vehicles{k}.Destination,'H')
            % charging and constant relative rate
            %vehicles{k}.InternalTimer = vehicles{k}.InternalTimer - 1;
            vehicles{k}.Battery = vehicles{k}.Battery + 0.1*range;
            vehicles{k}.Seeds = vehicles{k}.Seeds + 1;
            if vehicles{k}.Battery >= range && vehicles{k}.Seeds >= num_seeds
                vehicles{k}.Seeds = num_seeds;
                vehicles{k}.Battery = range;
                vehicles{k}.Free = true;
                vehicles{k}.InternalTimer = jobTime;
            end
        else
            % Else it is at the tree. Needs time to complete the job and
            % expends energy on each time step.
            vehicles{k}.InternalTimer = vehicles{k}.InternalTimer - 1;
            vehicles{k}.Battery = vehicles{k}.Battery -1;
            if vehicles{k}.InternalTimer == 0
                % Find the tree it reached and reset the internal timer
                tree_reached = cellfun(@(x) strcmp(x.Node, vehicles{k}.Destination),trees);
                trees{tree_reached}.Complete = true;
                vehicles{k}.Free = true;
                vehicles{k}.InternalTimer = jobTime;

                % Reduce seeds and then reassign the home 
                vehicles{k}.Seeds = vehicles{k}.Seeds - 1;
                if vehicles{k}.Seeds == 0
                    vehicles{k}.Destination = 'H';
                    vehicles{k}.Plan = find_home(vehicles{k}, path);
                    vehicles{k}.Free = false;
                    vehicles{k}.InternalTimer = ceil(range / jobTime^2); %May change this
                end
            end
        end
    else
        
        %Note that only _ vehicles can be on one spot at a time...
        next_node_vehicles = cellfun(@(x) strcmp(x.Node, vehicles{k}.Plan{2}), vehicles);
        if sum(next_node_vehicles) < 4 || strcmp(vehicles{k}.Plan{2},'H') %|| strcmp(vehicles{k}.Plan{2},'P1') 
            vehicles{k}.Node = vehicles{k}.Plan{2};
            vehicles{k}.NodeIndex = find(cellfun(@(x) strcmp(x,vehicles{k}.Node), G.Nodes.Name));
            vehicles{k}.Plan(1) = [];
            vehicles{k}.Battery = vehicles{k}.Battery -1;
        end

    end

end

end