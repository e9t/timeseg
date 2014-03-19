function [ xrange, yrange ] = plotFP(data, avg, stdv, flg, chs, shadowon)
%PLOT Summary of this function goes here
%   Detailed explanation goes here
%   data: data value
%   stdv: standard deviation
%   flg: framing point (ex: [5 10 20])
%   chs: chamber step point (ex: [5 10 20])
%   shadowon: shadow on(1) or not(0)
        
    if chs(1) == 0;
        chs = chs(2:end);
    end

    load ColorLabels
    
    xrange.min = 0;
    xrange.max = length(data) + 3;
    yrange.min = min(avg-stdv) - (max(avg+stdv)-min(avg-stdv))/15;
    yrange.max = max(avg+stdv) + (max(avg+stdv)-min(avg-stdv))/15;
    
    st=1;
    for k = 1:length(flg)
        ed = min(floor(flg(k)), length(data));
        scatter(st:1:ed, data(:,st:ed), 10, rgbs{k,1}, 'filled'); hold on;
        line([ed; ed], [yrange.min; yrange.max], 'LineStyle', '-.', 'Color', 'k');
        st = ed+1;
    end
    k=k+1;
    scatter(st:length(data), data(:,st:end), 10, rgbs{k,1}, 'filled'); hold on;
    scatter(chs, data(chs), 40,'k^','filled'); hold on;
    line([length(data); length(data)], [yrange.min; yrange.max], 'LineWidth', 2, 'LineStyle', '-', 'Color', 'k');
    
    if shadowon==1
        fill([1:1:length(avg) length(avg):-1:1],[(avg+stdv) fliplr((avg-stdv))],[0.8,0.8,0.8],'EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.3,'EdgeAlpha',0.3);
    end
    
    ylim([yrange.min, yrange.max]); xlim([xrange.min, xrange.max]);

end

