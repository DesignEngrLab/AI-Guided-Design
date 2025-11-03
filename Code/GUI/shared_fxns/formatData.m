function formattedData = formatData(entryTable)
    % formats the data to look
    topData = arrayfun(@(x) sprintf('%.2f', x), entryTable.Data.Amount(1:10), 'UniformOutput',false);
    bottomData = arrayfun(@(x) sprintf('%.0f', x), entryTable.Data.Amount(11:14), 'UniformOutput',false);
    formattedData = entryTable;
    formattedData.Data.Amount = [topData;bottomData];
end