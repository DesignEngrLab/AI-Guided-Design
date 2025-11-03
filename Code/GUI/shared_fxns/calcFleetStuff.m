function [costAgent, range, fleet] = calcFleetStuff(entryTable, marbles, cost_vals)

    % General function for calculating the cost, range, and fleet based on
    % the table entries that they gave.
    maxFleet = 40;
    totalCost = 10000;
    %totalCost = 8000; I tried it with this but that just made everything
    %abd
    rnd_range = 10;

    costAgent = cost_vals*entryTable.Data.Amount(:); % I need to make this it's own function
    %range = floor((200*(entryTable.Data.Amount(13) + 2*entryTable.Data.Amount(14))/marbles)/rnd_range)*rnd_range;
    range = floor((200*entryTable.Data.Amount(12)/marbles)/rnd_range)*rnd_range;
    fleet = min([floor(totalCost / costAgent), maxFleet]);
end