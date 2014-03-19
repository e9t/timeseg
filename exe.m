%------------------------------------------------------------------------
% 2011-12-01 Programmed by ejpark <ejpark04@snu.ac.kr>
%------------------------------------------------------------------------

clear;
clc;
clf;
settings;
addpath(genpath('./'))
addpath(genpath(fksadir));
 
%% input parameters
exeopt(1) = inputData;
    dataselected = selectedData;
exeopt(2) = runPreprocessing;
    avgmed = avgmed;
exeopt(3) = plotBasicInfo;
exeopt(4) = runDPD;
    sig = DPD_sigma;
    conthr = DPD_continuous_range_threshold;
exeopt(5) = runFKS;
    fks_k = FKS_k;
    fks_lambda = FKS_lambda;
exeopt(9) = runDPDwithoutPruning;
exeopt(6) = runDPDwithPruning;
    postopt = pruningOption;
exeopt(7) = runEvaluation;
    lambda = evaluationParameter;
exeopt(8) = plotAnalyticalMeasures;


%% DATA INPUT
if exeopt(1) == 1
    % input each data's format
    dform{1} = [1:4];                      % data format 1 - VARIABLEs: Time, Lot ID, Slot, CH Step(character), Parameter
    dform{2} = [5:19];                     % data format 2 - VARIABLEs: Time, Line, EQP ID, Slot, CH Step, Parameter
    dform{3} = [23,39,40];                 % data format 3 - VARIABLEs: Time, Line, EQP ID, Lot ID, Slot, CH Step, Parameter
    dform{4} = [20:22,24:38,41:62];        % data format 4 - VARIABLEs: Time, Lot ID, Slot, CH Step(number), Parameter
    % data import
    [dmat, cmat, bmat, nrec] = importdata(datadir, dform); 
    % save data
    save('data.mat','dform','dmat','cmat','bmat','nrec');
else
    load('data.mat')
end

%% calculate data specifications
[ndat, nwaf, maxt, smat, wlen, ~] = datainfo(dmat,cmat);
datasize = size(wlen);
for dd = 1:ndat 
    initialtl(dd) = size(dmat{dd},2);
end

%% PREPROCESSING - step alignment
if exeopt(2) == 1 
    for i = 1:size(dmat,2)
        [dmat{i}, chs{i}] = agg_step(dmat{i}, cmat{i});
        chs{i} = cumsum(chs{i}); 
        ch = 1;cmat{i} = [];
        for j = 1:size(dmat{i},2)
            if j > chs{i}(ch)
                ch = ch + 1;
            end
            cmat{i}(j) = ch;
        end
        cmat{i} = repmat(cmat{i}, size(dmat{i},1), 1);
        chs{i} = chs{i}(1,1:end-1);
    end
    % recalculate data specifications
    [ndat, nwaf, maxt, smat, wlen, ~] = datainfo(dmat,cmat);
    datasize = size(wlen);
    save('data_SA.mat');
else % ?? ??? ??? -lucy
    [~,~,~,~,~, repframe] = datainfo(dmat,cmat);
    for i = 1:size(dmat,2)
        tmp = repframe(~isnan(repframe(:,i)), i);
        dtmp = diff(tmp);
        chs{i} = find(dtmp~=0);
    end
end

%% data preview 
if exeopt(3) == 1
    % plot basic info
    mkdir('results\\Plots\\01.basicinfo');
    plotbasicinfo(ndat, maxt, nwaf, nrec,1);
    % plot data
    mkdir('results/Plots/02.datapreview')
    figure('Position', [250, 250, 1280, 480])
    for dd = 1:ndat
        datapreview(dd,dmat{dd},smat{2,dd},initialtl)
        if exeopt(2) == 1 
            filename = sprintf('results/Plots/02.datapreview/D%d_SA_datapreview.png',dd);
        else
            filename = sprintf('results/Plots/02.datapreview/D%d_datapreview.png',dd);
        end
        screen2png(filename);
%         saveas(gcf, filename, 'png');
%         saveas(gcf, filename, 'eps');
    end
end

%% FRAMING 
mkdir('results/Plots/04.framing/')
% result file naming
switch avgmed
    case 1
        avgmedfn = sprintf('AVG');
    case 3
        avgmedfn = sprintf('MED');
    otherwise
    error('Unexpected avgmed file name. Cmon you can do better than this.');
end
switch exeopt(2)
    case 0
        prefn = sprintf('null');
    case 1
        prefn = sprintf('sa');  % step alignment
    otherwise
    error('Unexpected preprocessing file name. Cmon you can do better than this.');
end   
switch exeopt(6)
    case 0
        postfn = sprintf('null');
    case 1
        switch postopt
            case 1
                postfn = sprintf('type1'); 
            case 2
                postfn = sprintf('type2'); % piecewise linear      
            case 3
                postfn = sprintf('type3');
            otherwise 
                error('Unexpected postprocessing file name 1. Cmon you can do better than this.');
        end
    otherwise
    error('Unexpected postprocessing file name 2. Cmon you can do better than this.');
end      
switch postopt
    case 1
        postopt2 = [1,0,0];
    case 2
        postopt2 = [0,1,0];
    case 3
        postopt2 = [0,0,1]; 
end
figure('Position', [0, 0, 1000, 800]);   
for dd = 1:length(dataselected)  
    clf
    inmat = smat{2,dataselected(dd)}(avgmed,:);
    avg = smat{2,dataselected(dd)}(1,:);
    stdv = smat{2,dataselected(dd)}(2,:);
   %% DPD
   if exeopt(4) == 1 
        for j = 1:length(sig)
        
            flg = FR_DPD(inmat, sig(j));
            FP_DPD{1, dataselected(dd)} = flg;
            conratio(dataselected(dd)) = length(flg)/maxt(dataselected(dd)); % continuous range ratio
 
            
       % FP pruning null
            if exeopt(9) == 1
                flgs = cell(1,1); flgs{1} = flg;
                % plotting
                subplot(2,2,1)
                [dpd_xrange(dd), dpd_yrange(dd)] = plotFP(inmat, smat{2,dataselected(dd)}(1,:), stdv, flg, chs{dataselected(dd)}, 1);
                title('DPD');box on
            end
            
        % FP pruning 
                if exeopt(6) == 1
                tic
                    flgs = postfilter(flg, inmat, postopt2);
                    FP_DPD{1, dataselected(dd)} = [FP_DPD{1, dataselected(dd)} flgs];
                    flg = flgs{postopt};
                dpd_time(j,dd) = toc;
                % plotting
                subplot(2,2,2)
                [dpd_xrange(dd), dpd_yrange(dd)] = plotFP(inmat, smat{2,dataselected(dd)}(1,:), stdv, flg, chs{dataselected(dd)}, 1);
                title('DPD+pruning');box on
                end
                
           % EVALUATION
            if exeopt(7) == 1 
                dpd_evaloutput(dataselected(dd)) = evaluate(inmat, flg) + lambda*(size(flg,2)+1)/size(inmat,2);
                evaloutputprint = sprintf('e=%2.2f\nt=%2.4f', dpd_evaloutput(dataselected(dd)),dpd_time(j,dd));
                text (length(inmat)+4,min(avg-stdv),evaloutputprint,'EdgeColor','red','HorizontalAlignment','left');
            end
        
        end
   end
    %% FKS
    if exeopt(5)==1      
        for lamidx = 1:length(fks_lambda)    
            % Parameter Setting
            nknots = 20; fixknots = [];
            option = struct('animation', 0, ...    % 0?? ???? knot optimization ?? graphic ??? ??? ????.
            'figure', 0, ...
            'waitbar', 0, ...
            'display', 1, ...                       % 0?? ???? command window ? ??? ??? ?? ????. (RMSE, final knot ?? ??)
            'd', min(fks_k-1,2), 'lambda', fks_lambda(lamidx), 'regmethod', 'c', ...
            'qpengine', '', ...
            'sigma', []);

            % Framing
            tic
                [flg, bestk] = FR_FKS(inmat, fks_k, nknots, fixknots, option);
                fks_time(lamidx,dd) = toc;
                % Plotting
                subplot(2,2,lamidx+2);
                [fks_xrange(lamidx,dd), fks_yrange(lamidx,dd)] = plotFP(inmat, smat{2,dataselected(dd)}(1,:), stdv, flg, chs{dataselected(dd)}, 1);            
    %             plottext = sprintf('k(best)=%d\nlambda=%.2f', bestk, fks_lambda);
    %             text(xrange.min+5 , yrange.min+(yrange.max-yrange.min)/10 , plottext);
                titlename = sprintf('FKS (lambda=%.2f)',fks_lambda(lamidx));
                title(titlename);
                box on
        
               % EVALUATION
                if exeopt(7) == 1 
                    fks_evaloutput(lamidx,dataselected(dd)) = evaluate(inmat, flg) + lambda*(size(flg,2)+1)/size(inmat,2);
                    evaloutputprint = sprintf('e=%2.2f\nt=%2.2f', fks_evaloutput(lamidx,dataselected(dd)),fks_time(lamidx,dd));
                    text (length(inmat)+4,min(avg-stdv),evaloutputprint,'EdgeColor','red','HorizontalAlignment','left');
                end
        end
    end
    
    %% select min(e) method and overwrite plotfile
        evaloutput = [dpd_evaloutput; fks_evaloutput];
        bestmethod(dd) = find(evaloutput(:,dd) == min(evaloutput(:,dd))); 
        
        switch bestmethod(dd)
            case 1
                subplot(2,2,2), line([1;1],[0,100]);
                line([dpd_xrange(1,dd).min,dpd_xrange(1,dd).max],[dpd_yrange(1,dd).min,dpd_yrange(1,dd).min],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([dpd_xrange(1,dd).min,dpd_xrange(1,dd).max],[dpd_yrange(1,dd).max,dpd_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([dpd_xrange(1,dd).min,dpd_xrange(1,dd).min],[dpd_yrange(1,dd).min,dpd_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([dpd_xrange(1,dd).max,dpd_xrange(1,dd).max],[dpd_yrange(1,dd).min,dpd_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
            case 2
                subplot(2,2,3)
                line([fks_xrange(1,dd).min,fks_xrange(1,dd).max],[fks_yrange(1,dd).min,fks_yrange(1,dd).min],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(1,dd).min,fks_xrange(1,dd).max],[fks_yrange(1,dd).max,fks_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(1,dd).min,fks_xrange(1,dd).min],[fks_yrange(1,dd).min,fks_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(1,dd).max,fks_xrange(1,dd).max],[fks_yrange(1,dd).min,fks_yrange(1,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
            case 3
                subplot(2,2,4)
                line([fks_xrange(2,dd).min,fks_xrange(2,dd).max],[fks_yrange(2,dd).min,fks_yrange(2,dd).min],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(2,dd).min,fks_xrange(2,dd).max],[fks_yrange(2,dd).max,fks_yrange(2,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(2,dd).min,fks_xrange(2,dd).min],[fks_yrange(2,dd).min,fks_yrange(2,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
                line([fks_xrange(2,dd).max,fks_xrange(2,dd).max],[fks_yrange(2,dd).min,fks_yrange(2,dd).max],'LineWidth', 3, 'LineStyle', '-','Color', 'r')
            otherwise
                error('Houston, we have a problem.');
        end      
        
    %% save plot
    resultfilename = sprintf('results\\Plots\\04.framing\\D%d_selected',dd);
    screen2png(resultfilename);
end 

%% plotting analytical measures
if exeopt(8) == 1
    % continuous data selection
    clf
    hold on 
    bar(conratio,1)
    xlim([1,ndat])
    conidx = find((conratio-conthr)>0);
    bar(conidx,conratio([conidx]),'r')
    line([1:ndat],[conthr:conthr])
    legend('DPD','FKS')
    text(ndat,1.03,num2str(conidx),'HorizontalAlignment','right','EdgeColor','red')
    filename = [resultfileloc 'continuousdata'];
    saveas(gcf, filename, 'png')

    if (exeopt(4) == 1 && exeopt(5) == 1)
    % time
        clf
        hold on
        plot([1:ndat],dpd_time,'k.-')
        plot([1:ndat],fks_time(1,:),'r.-')
        plot([1:ndat],fks_time(2,:),'b.-')
        legend('DPD','FKS(0.10)','FKS(0.01)')
        xlim([1,ndat])
        filename = [resultfileloc 'time'];
        saveas(gcf, filename, 'png')
    end
end
