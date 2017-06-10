% ds = datastore('D:/users/jerry/data/subsampled_subsampleData_do.csv'); 
% ds.SelectedFormats{3} = '%s'; 
% ds.SelectedFormats{6} = '%s'; 
% ds.SelectedFormats{17} = '%s'; 
% data = readall(ds); 
% 
% ugid = unique(data.gid); 
% ugid = ugid(randperm(length(ugid)));   % this is to make sure random subselect



choicesetPath = 'D:\users\jerry\data\choiceset\'; 

for i = 1:length(ugid)
    
    if rem(i, 1000) == 0
        fprintf('\n%d', i); 
    end
    
    if rem(i, 10000) == 0
        fprintf('saving...\n'); 
        save logitTable logitTable -v7.3
    end
    
    cData = data(data.gid == ugid(i),:); 
    
    loadPath = [choicesetPath sprintf('%d/choice-%d-%d.mat', cData.store_code(1), cData.store_code(1), cData.transaction_date(1))]; 
    
    
    if ~exist(loadPath, 'file')
        warning('choice set does not exist.. ignored transaction');
        continue; 
    end
    load(loadPath); 
    
    choice.gid = ugid(i)*ones(height(choice),1); 
    choice.purchased = zeros(height(choice),1);
    cData.purchased = ones(height(cData),1); 
    
    % replace choice set data with real purchases
    count = 0; 
    for j = 1:height(cData)
        removeRows = strcmp(choice.style, cData.style{j}); 
        if sum(removeRows) > 0
            choice = choice(~removeRows,:); 
        else
            %warning('found purchase not in the choice set. no rows will be removed.');
            count = count + 1; 
        end
    end
    
    cCompleteChoiceSet = [choice; cData]; 
    
    % add to memory 
    if i == 1
        logitTable = cCompleteChoiceSet;
    else
        logitTable = [logitTable; cCompleteChoiceSet]; 
    end
    
    fprintf('^'); 
    
end


fprintf('\n'); 


