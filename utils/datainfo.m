%------------------------------------------------------------------------
% Programmed by ejpark (2011-11-01)
%------------------------------------------------------------------------

function [ndat, nwaf, maxt, smat, wlen, repframe] = datainfo(dmat, cmat)
% VARIABLE DESCRIPTION
%     dmat: matrix of data
%     cmat: matrix of chamber step info
%     bmat: binary matrix
%     ndat: number of data 
%     nwaf: vector of number of wafers per data
%     maxt: vector of max time length per data
%     nrec: vector of number of records per data
%     floc: file location
%     dform: data format

ndat = size(dmat,2);
for dd = 1:ndat
    [nwaf(dd) maxt(dd)] = size(dmat{dd});
end

repframe = nan(max(maxt),ndat);

for dd = 1:ndat 
    if isempty(dmat{dd})==0
        % calculate stats (각 w에 대해)
        smat{1,dd} = nan(4,nwaf(dd));
        for ww = 1:nwaf(dd)
            smat{1,dd}(:,ww) = stats(dmat{dd}(ww,:));
        end
        % calculate stats (각 t에 대해)
        smat{2,dd} = nan(4,maxt(dd));
        for tt = 1:maxt(dd)  
            smat{2,dd}(:,tt) = stats(dmat{dd}(:,tt));
            tmp = stats(cmat{dd}(:,tt));
            repframe(tt,dd) = tmp(4);
        end
    end
end
% calculate wafer lengths
wlen = nan(max(nwaf),ndat);
for dd = 1:ndat
    for ww = 1:nwaf(dd)
        wlen(ww,dd) = sum(~isnan(dmat{dd}(ww, :)));
    end
end

end
