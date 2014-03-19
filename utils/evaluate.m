function output = evaluate(inmat, step_point)
    %%
    % step_point = flg;
    n = size(inmat, 2);
    step_point = [step_point, n];
    m_step = size(step_point, 2);

    % linreg
    j = 1;
    MSE = 0;
    for j_step = 1:m_step
        j2 = step_point(j_step);
        if(j ~= j2)
            val_X = [ones(j2 - j + 1,1), (j:j2)'];
            val_Y = [inmat(j:j2)'];
            
            [b, res] = linreg(val_X, val_Y);
            val_Y_hat = val_X*b;
            MSE = MSE + sum((val_Y - val_Y_hat).^2);
        end
        j = j2 + 1;
    end
    
    output = sqrt(MSE / ((n - 2) * var(inmat)));

    % R2
%     j = 1;
%     output = 0;
%     for j_step = 1:m_step
%         j2 = step_point(j_step);
%         if(j + 1 < j2)
%             corr = corrcoef([(j:j2)', inmat(j:j2)']);
%             R = corr(1,2);
%             if(isnan(R))
%                 R = 1;
%             end
%             output = output + (j2 - j + 1) * R^2;
%         end
%         j = j2 + 1;
%     end
%     
%     output = output / n;
end
