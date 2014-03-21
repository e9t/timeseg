%------------------------------------------------------------------------
% Programmed by ejpark (2011-10-12)
% Revised by jwyang, ejpark (2011-10-24)
% Revised by ejpark (2011-10-27)
%------------------------------------------------------------------------

function [dmat, cmat, bmat, nrec] = importdata(floc)
% VARIABLE DESCRIPTION
%     dmat: matrix of data
%     cmat: matrix of chamber step info
%     ndat: number of data 
%     nwaf: vector of number of wafers per data
%     maxt: vector of max time length per data
%     nrec: vector of number of records per data
%     floc: file location

% csv to cells
filenames = sprintf('%s/*.csv', floc);
files = dir(filenames);
ndat = length(files);
for dd = 1:ndat
    fname = files(dd).name;
    fprintf('%s\n', fname);
    fid = fopen(fname, 'r');
    rdata = textscan(fid, '%s %c %f %c %f', 'delimiter', ',', 'headerlines', 1);
    LotID = rdata{1,2};
    SltNum = rdata{1,3};
    ChbStep = rdata{1,4};
    dataVal = rdata{1,5};

    Lots = unique(LotID);
    Slts = unique(SltNum);
    Chbs = unique(ChbStep);

    cnt = 0;
    for i = 1:length(Lots)
        for j = 1:length(Slts)
            lotidx = find(LotID == Lots(i,1));
            sltidx = find(SltNum == Slts(j,1));
            inter_idx = intersect(lotidx, sltidx);
            data{dd}{i,j} = dataVal(inter_idx);
            buf{i,j} = ChbStep(inter_idx);
            for k = 1:length(buf{i,j})
                data_step{dd}{i,j}(k) = buf{i,j}(k)-96;
            end
            cnt = cnt+length(inter_idx);
        end
    end 
    nrec(dd) = cnt;
end

% cells to matrix 
for dd = 1:ndat          
    [n,m] = size(data{dd});
    s=[]; t=[];
    for i = 1:n
        for j = 1:m
            s(i,j) = isempty(data{dd}{i,j});
            t(i,j) = length(data{dd}{i,j});
        end
    end
    nwaf(dd) = n*m - sum(sum(s));
    maxt(dd) = max(max(t));
    k = 1;
    dmat{dd} = NaN(nwaf(dd),maxt(dd));
    cmat{dd} = NaN(nwaf(dd),maxt(dd));

    for i = 1:n
        for j = 1:m
            if (isempty(data{dd}{i,j})==0)
                dmat{dd}(k,[1:length(data{dd}{i,j})]) = data{dd}{i,j}';
                cmat{dd}(k,[1:length(data{dd}{i,j})]) = data_step{dd}{i,j}';
                k = k+1;
            end
        end
    end
end

bmat = NaN(max(nwaf),ndat);
for dd = 1:ndat           
    % bin
    for ww = 1:nwaf(dd)
        bmat(ww,dd) = 1;
    end
end

end


