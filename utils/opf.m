function [ newflg ] = opf( tmpflg, data )

    tmp = diff(tmpflg);
    idx = find(tmp == 1);
    for i = 1:length(idx)
        if tmpflg(idx(i)) <= length(data)-3
            lf = abs(data(tmpflg(idx(i)))-data(tmpflg(idx(i))+1));
            rg = abs(data(tmpflg(idx(i))+1)-data(tmpflg(idx(i))+2));

            if lf < rg
                tmpflg(idx(i)) = tmpflg(idx(i)+1);
            else
                tmpflg(idx(i)+1) = tmpflg(idx(i));
            end
        else
            tmpflg(idx(i)) = length(data);
        end
    end
    newflg = unique(tmpflg);
    if newflg(1) == 1
        newflg = newflg(1, 2:end);
    elseif newflg(end) == length(data)-1
        newflg = newflg(1, 1:end-1);
    end
    
    if length(find(diff(newflg)==1)) > 0
        newflg = opf(newflg, data);
    end
end

