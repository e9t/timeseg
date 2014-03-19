function newflg = postfilter(flg, data, pfopt)
    % pfopt: option matrix for postfiltering (단순 merging, monotonic 증감, FKS)
    % ex: pfopt = [1,1,1]
    [conflg, nconflg] = isconti(flg);
    for opt = 1:length(pfopt)
        if pfopt(opt) == 1
            merflg{opt} = merging(conflg,data,opt);
            tmpflg{opt} = nconflg;
            for i = 1:size(conflg, 2)
                tmpflg{opt} = [tmpflg{opt} merflg{opt}{i}];
            end
            tmpflg{opt} = unique(sort(tmpflg{opt}));

            newflg{opt} = opf(tmpflg{opt},data);
        else
            newflg{opt} = [];
        end
    end
end
