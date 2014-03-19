function [ conflg , extras] = isconti( flg )
%ISCONTI Summary of this function goes here
%   Detailed explanation goes here
    
    if length(flg) == 1
        extras = flg;
        conflg = [];
    else
        
        bln = zeros(1, length(flg));
        bln2 = zeros(1, length(flg));
        
        t = 0;
        for i = 1:length(flg)-1
            if flg(i) == flg(i+1)-1
                if t==0
                    bln(i) = 1; t = 1;
                end
            else
                if t==1
                    bln(i) = 1; t = 0;
                else
                    bln2(i) = 1;
                end
            end
        end
        bln(end) = 1;
        bln2(end) = 1;
        
        nflg = flg .* bln;
        nflg = nflg(nflg~=0);

        tmp = nflg;

        cnt = 0;

        for i = 1:length(nflg)/2
            if diff(tmp(2*i-1:2*i)) ~= 1
                cnt = cnt + 1;
            else
                tmp(2*i-1:2*i) = 0;
            end
        end

        tmp = tmp(tmp~=0); conflg = cell(1,cnt); extras = setdiff(nflg, tmp);
        for i = 1:cnt
            conflg{i} = tmp(2*i-1:2*i);
        end
        extras = [extras flg .* bln2];
        extras = extras(extras~=0);

    end
end

