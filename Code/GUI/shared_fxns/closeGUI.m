function closeGUI(fig, t)
    % Stop and delete the timer before closing the figure
    if isvalid(t)
        stop(t);
        delete(t);
    end
    delete(fig); % Close the figure
end