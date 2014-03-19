function screen2eps(filename, color)

    % Author: lucypark
    % Date: 2012-06-07
    % 
    % Employing the function at the following address: 
    %   http://www.mathworks.co.kr/company/newsletters/digest/june00/export/exportfig.m
    
    
    if nargin < 2, color = 'cmyk';
        
    exportfig(gcf, [filename, '.eps'], 'color', color)
end