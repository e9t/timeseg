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
        option = struct('animation', 0, ...    % 0���� �����ϸ� knot optimization �ϴ� graphic ������ ������ �ʽ��ϴ�.
        'figure', 0, ...
        'waitbar', 0, ...
        'display', 1, ...                       % 0���� �����ϸ� command window �� �ƹ��� ������ ���� �ʽ��ϴ�. (RMSE, final knot ���� ���)
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

