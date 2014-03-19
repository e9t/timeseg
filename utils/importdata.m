%------------------------------------------------------------------------
% Programmed by ejpark (2011-10-12)
% Revised by jwyang, ejpark (2011-10-24)
% Revised by ejpark (2011-10-27)
%------------------------------------------------------------------------

function [dmat, cmat, bmat, nrec] = importdata(floc, dform)
% VARIABLE DESCRIPTION
%     dmat: matrix of data
%     cmat: matrix of chamber step info
%     ndat: number of data 
%     nwaf: vector of number of wafers per data
%     maxt: vector of max time length per data
%     nrec: vector of number of records per data
%     floc: file location
%     dform: data format

ndform = size(dform,2);
flabel = dform{1};
for i = 1:ndform
    flabel = union(flabel,dform{i});
end
ndat = flabel(end)-flabel(1)+1;

% file¿« format(category) √£±‚
for dd = 1:ndat
    if isnan(find(dform{1}==flabel(dd)))==0
        fcat(dd) = 1;
    end
    if isnan(find(dform{2}==flabel(dd)))==0
        fcat(dd) = 2;
    end
    if isnan(find(dform{3}==flabel(dd)))==0
        fcat(dd) = 3;
    end
    if isnan(find(dform{4}==flabel(dd)))==0
        fcat(dd) = 4;
    end
end

% csv to cells
for dd = 1:ndat
    if fcat(dd) == 1
        fname = sprintf('%sAutoFraming_Data_%d.csv',floc,flabel(dd));
        fprintf('Import %s\n', fname);
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
    end

    if fcat(dd) == 2
        fname = sprintf('%sAutoFraming_Data_%d.csv',floc,flabel(dd));
        fid = fopen(fname, 'r');
        rdata = textscan(fid, '%s %f %s %f %f %f', 'delimiter', ',', 'headerlines', 1);
        LinID = rdata{1,2};
        EqpID = rdata{1,3};
        SltNum = rdata{1,4};
        ChbStep = rdata{1,5};
        dataVal = rdata{1,6};

        Lots = unique(LinID);
        Slts = unique(SltNum);

        cnt = 0;
        for i = 1:length(Lots)
            for j = 1:length(Slts)
                lotidx = find(LinID == Lots(i,1));
                sltidx = find(SltNum == Slts(j,1));
                inter_idx = intersect(lotidx, sltidx);
                data{dd}{i,j} = dataVal(inter_idx);
                data_step{dd}{i,j} = ChbStep(inter_idx);
                cnt = cnt+length(inter_idx);
            end
        end
    end

    if fcat(dd) == 3
        fname = sprintf('%sAutoFraming_Data_%d.csv',floc,flabel(dd));
        fid = fopen(fname, 'r');
        rdata = textscan(fid, '%s %f %s %s %f %f %f', 'delimiter', ',', 'headerlines', 1);
        LinID = rdata{1,2};
        EqpID = rdata{1,3};
        LotID = rdata{1,4};
        SltNum = rdata{1,5};
        ChbStep = rdata{1,6};
        dataVal = rdata{1,7};

        Lots = unique(LinID);
        Slts = unique(SltNum);

        cnt = 0;
        for i = 1:length(Lots)
            for j = 1:length(Slts)
                lotidx = find(LinID == Lots(i,1));
                sltidx = find(SltNum == Slts(j,1));
                inter_idx = intersect(lotidx, sltidx);
                data{dd}{i,j} = dataVal(inter_idx);
                data_step{dd}{i,j} = ChbStep(inter_idx);
                cnt = cnt+length(inter_idx);
            end
        end
    end

    if fcat(dd) == 4
        fname = sprintf('%sAutoFraming_Data_%d.csv',floc,flabel(dd));
        fid = fopen(fname, 'r');
        rdata = textscan(fid, '%s %c %f %f %f', 'delimiter', ',', 'headerlines', 1);
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
                data_step{dd}{i,j} = ChbStep(inter_idx);
                cnt = cnt+length(inter_idx);
            end
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


