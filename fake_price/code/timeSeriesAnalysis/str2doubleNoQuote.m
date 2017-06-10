function out = str2doubleNoQuote(in)

if numel(in) == 0; out=nan; return; end
if (in(1) == '"')
    in = in(2:end-1); 
end
out = str2double(in); 


end