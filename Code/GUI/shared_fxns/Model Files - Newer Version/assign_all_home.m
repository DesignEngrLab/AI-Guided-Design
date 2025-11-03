function vehicles = assign_all_home(G, vehicles)
% Assign vehicles to move home
    for i = 1:length(vehicles)
        vehicles{i}.Destination = 'H';
        vehicles{i}.Plan = shortestpath(G,vehicles{i}.Node, 'H');
        vehicles{i}.Free = false;
    end

end