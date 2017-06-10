function [styles] = extractChoiceSetFromMinMax (minMaxTable, targetDate)

styles = minMaxTable.uStyle(minMaxTable.minDate <= targetDate & minMaxTable.maxDate >= targetDate); 

end