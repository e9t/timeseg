function [b, res, haty] = linreg(x, y, del)

if nargin < 3
    del = 0;
end

[N,d] = size(x);

c = x'*x + del * eye(d,d);
b = inv(c)*x'*y;

haty = x*b;
res  = y-haty;