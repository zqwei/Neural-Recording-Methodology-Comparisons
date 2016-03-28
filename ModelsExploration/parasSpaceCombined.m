%
% Example neurons for neuronal trace from S2C model and C2S model
% This code is only for plots, where computation is done by server
%
%

addpath('../Func');
setDirV1Cells;
load([TempDatDir 'DataListCells.mat'], 'totCell');

if ~exist([PlotDir 'ModelExampleCellFits'],'dir')
    mkdir([PlotDir 'ModelExampleCellFits'])
end

load([TempDatDir 'ParamsFitCells_S2CModel_Fmfix.mat'], 'paras');

group    = nan(length(paras), 1);
for nGroup = 1:length(expression)    
    indexExpression = strcmp(expression{nGroup}, {paras.expression});
    indexCaInd      = strcmp(CaIndicator{nGroup}, {paras.CaIndicator});
    group(indexExpression & indexCaInd)     = nGroup;
end
nTitles = {'\tau_{r} (ms)', '\tau_{d} (s)', 'n', 'K', 'Fm'};
groupColor = [         0    0.4470    0.7410
    0.9290    0.6940    0.1250
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

figure;

timeSeriesData = 0:1/60:2;
NLx            = 0:1:20;

for nCell   = 1:length(totCell)  
    K       = paras(nCell).K;
    n       = paras(nCell).n;
    tau_d   = paras(nCell).tau_d;
    tau_r   = paras(nCell).tau_r;   
    Delta_t = max(timeSeriesData-0.05,0);
    linePlot= exp(-Delta_t/tau_d).*(1-exp(-Delta_t/tau_r));
    NLPlot  = NLx.^n./(NLx.^n+K^n);
    
    subplot(1, 2, 1)
    hold on
    plot(timeSeriesData, linePlot./max(linePlot), '-', 'color', groupColor(group(nCell),:));
    title('linear integration')
    xlabel('Time (sec)')
    ylabel('Normalized [Ca++]')
    xlim([0 2])
    
    subplot(1, 2, 2)
    hold on
    plot(NLx, NLPlot./max(NLPlot), '-', 'color', groupColor(group(nCell),:));
    title('nonlinear integration')
    xlabel('[Ca++]')
    ylabel('Normalized F')
    xlim([0 20])   
end

setPrint(8*2, 6, [PlotDir 'ModelCellFits/ParamsComparisonCombined'])
setPrint(8*2, 6, [PlotDir 'ModelCellFits/ParamsComparisonCombined'],'png')