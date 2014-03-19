function [dagg_output, step_length] = agg_step(dagg, dagg_step)
    %%
    % dagg = dmat{36};
    % dagg_step = cmat{36};
    [n,m] = size(dagg_step);

    j_step_max = 0;
    for i = 1:n
        j_step = 1;
        step_label{1} = dagg_step(i,1);
        j = 1;
        while(j <= m && ~isnan(dagg_step(i,j)))
            if(dagg_step(i,j) ~= step_label{1})
                j_step = j_step + 1;
                step_label{1} = dagg_step(i,j);
            end
            j = j + 1;
        end
        if(j_step > j_step_max)
            i_max = i;
            j_step_max = j_step;
        end
    end
    
    % step_label
    j_step = 1;
    step_label{j_step} = dagg_step(i_max,1);
    j = 1;
    while(j <= m && ~isnan(dagg_step(i_max,j)))
        if(dagg_step(i_max,j) ~= step_label{j_step})
            j_step = j_step + 1;
            step_label{j_step} = dagg_step(i_max,j);
        end
        j = j + 1;
    end

    % step_length_mean
%     m_step = j_step;
%     step_length = zeros(1,m_step);
%     for i = 1:n
%         j_step = 1;
%         j = 1;
%         while(j <= m && ~isnan(dagg_step(i,j)))
%             if(dagg_step(i,j) ~= step_label{j_step})
%                 if(j_step == m_step)
%                     j = m + 1;
%                 else
%                     j_step = j_step + 1;
%                     j_inc = find(dagg_step(i, j:m) == step_label{j_step}, 1);
%                     if(~isempty(j_inc))
%                         j = j + j_inc - 1;
%                     end
%                 end
%             else
%                 step_length(j_step) = step_length(j_step) + 1;
%                 j = j + 1;
%             end
%         end
%     end
%     step_length = round(step_length/i);

    % step_length_median
    m_step = j_step;
    step_length_i = zeros(n,m_step);
    for i = 1:n
        j_step = 1;
        j = 1;
        while(j <= m && ~isnan(dagg_step(i,j)))
            if(dagg_step(i,j) ~= step_label{j_step})
                if(j_step == m_step)
                    j = m + 1;
                else
                    j_step = j_step + 1;
                    j_inc = find(dagg_step(i, j:m) == step_label{j_step}, 1);
                    if(~isempty(j_inc))
                        j = j + j_inc - 1;
                    end
                end
            else
                step_length_i(i,j_step) = step_length_i(i,j_step) + 1;
                j = j + 1;
            end
        end
    end
    step_length = round(median(step_length_i, 1));

    % dagg_output
    dagg_output = zeros(n, sum(step_length));
    for i = 1:n
        j = 1;
        j_output = 1;
        for j_step = 1:m_step
            j_inc = find(dagg_step(i,j:m) == step_label{j_step}, 1);
            if(~isempty(j_inc))
                j = j + j_inc - 1;
            end
            k = 1;
            while(k <= step_length(j_step))
                if(j > m || dagg_step(i,j) ~= step_label{j_step})
                    if(j == 1)
                        for k = k:step_length(j_step)
                            dagg_output(i,j_output) = dagg(i,1);
                            j_output = j_output + 1;
                        end
                    else
                        for k = k:step_length(j_step)
                            dagg_output(i,j_output) = dagg(i,j-1);
                            j_output = j_output + 1;
                        end
                    end
                else
                    dagg_output(i,j_output) = dagg(i,j);
                    j = j + 1;
                    j_output = j_output + 1;
                end
                k = k + 1;
            end
        end
    end
end
