function [cost, path] = preplan_paths(G)

% Generate cells  for storing relationships
% count none
total_nodes = numnodes(G);
total_T = sum(cellfun(@(x) contains (x, 'T'), G.Nodes.Name));
cost = zeros(total_nodes-total_T, total_T);
path = cell(total_nodes-total_T, total_T);

%Because of indexing, we know that the first total_nodes-total_T are not T
%and the next total_T ones are...

% This takes a bit of time. But totally worth it!
for i = 1:total_nodes
    for j = (total_nodes-total_T+1):total_nodes
        [p_ij, c_ij] = shortestpath(G, G.Nodes.Name{i}, G.Nodes.Name{j});
        path(i,j-total_nodes+total_T) = {p_ij};
        cost(i,j-total_nodes+total_T) = c_ij;
    end
end




end