function [ flg, bestk ] = FR_FKS( data, k, nknots, fixknots, option )
%DKS Summary of this function goes here
%   Detailed explanation goes here
    
    y = data';
    x = [1:1:length(data)]';
    
    for i = 1:length(k)
        [pp(i) , ~, rmse(i)] = BSFK(x, y, k(i), nknots, fixknots, option);
    end
    
    [~, minidx] = min(rmse);
    flg = unique(round(pp(i).breaks));
    flg = flg(flg~=1);
    bestk = k(minidx);
end

