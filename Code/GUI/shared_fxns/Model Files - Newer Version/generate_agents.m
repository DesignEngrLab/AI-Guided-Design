function [vehicles, trees] = generate_agents(num_agents, num_seeds, range,jobTime,G)
% Generate the cell or structure thing of the agent
% Each agent has:
%   Position (cell name and then index. always starts at H)
%   Amount of seeds in it
%   Battery/range

    single_agent = {struct('Node','H', 'NodeIndex',1,'Free',true, ...
        'Seeds',num_seeds, 'Battery',range,'Destination',false, ...
        'Plan',{'H'}, 'InternalTimer', jobTime)};%single full agent
    vehicles = repmat(single_agent, num_agents,1);
    
    total_nodes = numnodes(G);
    total_T = sum(cellfun(@(x) contains (x, 'T'), G.Nodes.Name));
    trees = cell(total_T,1);
    for i = 1:total_T
        trees{i} = struct('Node', strcat('T', int2str(i)), ...
        'NodeIndex', total_nodes-total_T+i, 'Assigned', false, ...
        'Complete', false);
    end

end