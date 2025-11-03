function path_home = find_home(vehi, path)
% Find the distance to home and then determine the path there 
% Note. There's error that gets thrown up every once and a while. Check to
% make sure that the path length is fine. (>200)

    tree_index = str2double(regexp(vehi.Node, '\d+', 'match'));
    path_home = flip(path{1,tree_index});

end