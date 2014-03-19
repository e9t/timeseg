function [ merflg ] = merging( conflg, data, opt )
    merflg = cell(size(conflg,1), size(conflg,2));
    if opt == 1         % Simple Merging
        merflg = conflg;
    elseif opt == 2     % Monotonic
        for i = 1:length(conflg)
            idx = conflg{i}(1,1):conflg{i}(1,2);
            dev = diff(data(idx));
            new = find(abs(diff(sign(dev)))==2)+conflg{i}(1);

            if isempty(new)==0
                merflg{i} = sort([conflg{i} new]);
            else merflg{i} = conflg{i};
            end
        end
    elseif opt == 3     % Free Knot Spline
        fixknots = []; k = 2;
        option = struct('animation', 0, ...    % 0으로 설정하면 knot optimization 하는 graphic 과정이 보이지 않습니다.
        'figure', 0, ...
        'waitbar', 0, ...
        'display', 1, ...                       % 0으로 설정하면 command window 에 아무런 정보가 뜨지 않습니다. (RMSE, final knot 개수 등등)
        'd', 1, 'lambda', 1, 'regmethod', 'c', ...
        'qpengine', '', ...
        'sigma', []);
        
        for i = 1:size(conflg, 2)
            idx = conflg{i}(1,1):conflg{i}(1,2);
            nknots = length(idx);
            inmat = data(idx);
            [tmp, ~] = FR_FKS(inmat, k, nknots, fixknots, option);
            merflg{i} = tmp + conflg{i}(1,1)-1;
        end
    end
end

