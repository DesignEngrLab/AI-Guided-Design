function dispPrevious()
   global dataTable
   tableFig = uifigure('Position',[400,300,1000,600],'Name','Previous Designs');
   g = uigridlayout(tableFig, [1 1]);
   t = uitable(g, 'Data',table2cell(dataTable),...
       'ColumnName',dataTable.Properties.VariableNames);
   t.Layout.Row = 1; t.Layout.Column = 1;
end