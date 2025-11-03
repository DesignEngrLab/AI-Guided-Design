function keepGUIActive(label)
    % Store the existing text
    originalText = label.Text;

    
    % Temporarily change the text to force an update
    label.Text = [' ', originalText, ' '];
    
    % Restore the original text
    pause(0.01); % Small delay to ensure UI update
    label.Text = originalText;
    
    % Force a UI refresh
    drawnow;
end