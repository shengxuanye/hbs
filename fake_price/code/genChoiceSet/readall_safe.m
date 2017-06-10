function data = readall(ds)
%READALL Read all of the data from a TabularTextDatastore.
%   T = readall(TDS) reads all of the data from TDS.
%   T is a table with variables governed by TDS.SelectedVariableNames.
%   readall(TDS) resets TDS both before and after reading all the data.
%
%   Example:
%      % Create a TabularTextDatastore
%      tabds = datastore('airlinesmall.csv')
%      % Handle erroneous data
%      tabds.TreatAsMissing = 'NA';
%      tabds.MissingValue = 0;
%      % We are only interested in the Arrival Delay data
%      tabds.SelectedVariableNames = 'ArrDelay'       
%      tab = readall(tabds);
%      sumAD = sum(tab.ArrDelay)
%
%   See also - matlab.io.datastore.TabularTextDatastore, hasdata, read, preview, reset. 

%   Copyright 2014 The MathWorks, Inc.

try
    reset(ds);
    
    data = table.empty;
    if ~hasdata(ds)
        return;
    end
    
    % resets and sets the old rows per read value
    currRowsPerRead = ds.RowsPerRead;
    cleanup = onCleanup(@()cleanupDatastore(ds, currRowsPerRead));
    
    % estimate max rows per read by num variables
    ds.RowsPerRead = max( 1, floor(1e6/numel(ds.VariableNames)) );
    
    tblCells = cell(1, numel(ds.Splitter.Splits));
    readIdx = 1;
    while hasdata(ds)
        try 
            tblCells{readIdx} = read(ds);
        catch EE
            
        end
        readIdx = readIdx + 1;
    end
    
    data = vertcat(tblCells{:});
    delete(cleanup);
catch ME
    throw(ME);
end
end

function cleanupDatastore(ds, rowsPerRead)
    % safe to reset, as reset works for empty files as well
    ds.RowsPerRead = rowsPerRead;
    reset(ds);
end