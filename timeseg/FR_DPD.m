function [ flg ] = FR_DPD( data, sig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    y = data;
    dy = abs(diff(y));
    flg = find(dy(1,:) > sig*std(dy));
    
end

