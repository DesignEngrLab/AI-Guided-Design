function [vehicles, trees] = assign_paths(unassignedVehis, vehicles, trees,cost, path,jobTime)


unassignedTrees = cellfun(@(x) not(x.Assigned) , trees);
indexVehicles = cellfun(@(x) x.NodeIndex, vehicles);
indexUnassignedVehis = find(unassignedVehis);
indexNodesVehis = indexVehicles(unassignedVehis);

% Use that to pull out cost matrix from it.
subcost_i = cost(indexNodesVehis,unassignedTrees);

% Ensure that each unassigned vehicle is able to make it to there based on
% their current battery level. If that's the case, then remove the vehicle
%
keep = ones(length(indexUnassignedVehis),1);

for i = 1:length(indexUnassignedVehis)
    batt_left = vehicles{indexUnassignedVehis(i)}.Battery;
    check = subcost_i(i,:) + cost(1, unassignedTrees) + jobTime >= batt_left; % distance there and distance home from there
    % 
    if sum(check) == length(subcost_i)
        keep(i) = 0;
        unassignedVehis(indexUnassignedVehis(i)) =0;
        vehicles{indexUnassignedVehis(i)}.Destination = 'H';
        vehicles{indexUnassignedVehis(i)}.Plan = find_home(vehicles{indexUnassignedVehis(i)}, path);
        vehicles{indexUnassignedVehis(i)}.Free = false;
        vehicles{indexUnassignedVehis(i)}.InternalTimer = jobTime*2;
    end
end

subcost_i = subcost_i(logical(keep),:);

% Make assignments from
assignments = matchpairs(subcost_i, 10000);


% mapping indexes and using that as assignments
map_tree = zeros(length(unassignedTrees),1);
j = 1;
for i = 1:length(unassignedTrees)
    if unassignedTrees(i)
        map_tree(i) = j;
        j=j+1;
    end
end

total_unassigned_trees = j-1;

j = 1;

for i = 1:length(unassignedVehis)
%    i
    if unassignedVehis(i)

        % I don't know what happened here but it appears to work.
        % Figure out which tree to assign based on previous map
        try
            index = assignments(assignments(:,1)==j,2);
            tree_index = find(map_tree==index);
        catch
            index = assignments(1,2); % Weird case when there's more free vehicles than not. For some reason this wasn't needed befoer!!?
            tree_index = find(map_tree==index);
        end
        % Use that and unassigned vehicle index to pull out plan from the
        % preplanned paths to a tree.
        vehicles{i}.Plan = path{vehicles{i}.NodeIndex, tree_index};
        vehicles{i}.Destination = trees{tree_index}.Node;
        trees{tree_index}.Assigned = true;
        vehicles{i}.Free = false;
        j=j+1;
        
        if j > total_unassigned_trees
            break
        end

    end
end


end