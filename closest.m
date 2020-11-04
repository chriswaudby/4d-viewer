function idx = closest(array, val)
if length(val) == 1
    [~, idx] = min(abs(array - val));
else
    for n=1:length(val)
        [~, idx(n)] = min(abs(array - val(n)));
    end
end
