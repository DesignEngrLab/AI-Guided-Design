function wheelLoad = calcWheelLoad(wheels)
    % simple support function. Note that it also helps the output to ensure
    % that there are at least 3 wheels... This does not stop students from
    % adding more than necessary though...
    if wheels < 3
        wheelLoad = 0;
    elseif wheels == 3
        wheelLoad = 8;
    elseif wheels == 4
        wheelLoad = 12;
    elseif wheels == 5
        wheelLoad = 16;
    elseif wheels > 5
        wheelLoad = 20;
    end
    
end