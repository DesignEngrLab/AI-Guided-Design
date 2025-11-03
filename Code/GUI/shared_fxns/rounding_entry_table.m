function entryTable = rounding_entry_table(entryTable)
    % each part of the ui
    %roundTableVec = [0.25*ones(10,1);ones(4,1)];
    roundTableVec = [0.25*ones(10,1);ones(2,1)]; %changed
    entryTable.Data.Amount = ceil(entryTable.Data.Amount./roundTableVec).*roundTableVec;

end