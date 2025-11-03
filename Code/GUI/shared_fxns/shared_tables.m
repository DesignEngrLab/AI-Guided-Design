function [cost_vals, tableHeaders, materialsHeaders, Amount, entry ] = shared_tables()
    % modifications from original indicated by highlighted and unlighted
    % areas
%{
    Materials = {'Thick Popsicle Stick', 'Thin Popsicle Stick', 'Dowels', ...
        'Pipe Cleaner', 'Construction Paper', 'Small Cardboard Tubes',...
        'Large Cardboard Tubes', 'Small Styrofoam Spheres', ...
        'Large Styrofoam Spheres', 'Fabric', 'Small Wheels','Large Wheels',...
        'Blue (Short Range) Batteries', 'White (Long Range) Batteries'}';
   
    
    cost_vals = [10, 5, 10, 5, 10, 40, 60, 15, 30, 5, 5, 10, 20, 50];
    
    Cost = {" Per Inch", " Per Inch", " Per Inch", " Per Inch", ...
        " Per Square Inch", " Per Inch", " Per Inch", " Per Sphere",...
        " Per Sphere", " Per Square Inch", " Per Wheel", " Per Wheel", ...
        " Per Battery", " Per Battery"}'; %needs to be this for appending val
    
    tableHeaders = {'Iteration', 'Marbles', 'Range','Cost','Fleet_Size', 'Steps','iterTime'}';
%} 
    Materials = {'Thick Popsicle Stick', 'Thin Popsicle Stick', 'Dowels', ...
        'Pipe Cleaner', 'Construction Paper', 'Small Cardboard Tubes',...
        'Large Cardboard Tubes', 'Small Styrofoam Spheres', ...
        'Large Styrofoam Spheres', 'Fabric', 'Wheels',...
        'Blue Batteries (Beads)'}';
   
    
    cost_vals = [10, 5, 10, 5, 10, 40, 60, 20, 50, 5, 10, 20];
    
    Cost = {" Per Inch", " Per Inch", " Per Inch", " Per Inch", ...
        " Per Square Inch", " Per Inch", " Per Inch", " Per Sphere",...
        " Per Sphere", " Per Square Inch", " Per Wheel", ...
        " Per Battery"}'; %needs to be this for appending val
    
    tableHeaders = {'Iteration', 'Marbles', 'Range','Cost','Fleet_Size', 'Steps', 'PercentEffective','iterTime'}';


    materialsHeaders = cellfun(@(x) strrep(x, ' ', '_'), Materials, 'UniformOutput', false);
    materialsHeaders = cellfun(@(x) erase(x,["(",")"]), materialsHeaders, 'UniformOutput', false);
    tableHeaders = [tableHeaders;materialsHeaders]';
    
    
    for i = 1:length(Cost)
        Cost{i} = num2str(cost_vals(i)) + Cost{i};
    end
    
    
    Amount = zeros([length(Materials), 1]);
    
    entry = table(Materials, Cost, Amount);

end