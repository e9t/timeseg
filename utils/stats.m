%------------------------------------------------------------------------
% Programmed by ejpark (2011-10-24)
% Revised by jspark (2011-10-25): Minor modifications
% Revised by ejpark (2011-10-31): Minor modifications
%------------------------------------------------------------------------

function outvec = stats(invec)
    [n m] = size(invec);
    if min(n,m)~=1
        error('Wrong type of input. Input should be a vector.')
    end
    if m>n
        invec = invec';
    end

    tmp = invec;
%     j = 1;
%     for i = 1:max(n,m)
%         if isnan(invec(i))==0
%             tmp(j) = invec(i);
%             j = j+1;
%         end
%     end 
    outvec(1) = mean(tmp);
    outvec(2) = std(tmp);
    outvec(3) = median(tmp);
    outvec(4) = mode(tmp);
end