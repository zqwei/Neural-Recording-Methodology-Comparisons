%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;
load ([TempDatDir 'DataListShuffle.mat']);

if ~exist([PlotDir 'CollectedUnitsPCALDACorr'],'dir')
    mkdir([PlotDir 'CollectedUnitsPCALDACorr'])
end

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
ROCThres            = 0.5;


for nData             = [3 4]
    load([TempDatDir DataSetList(nData).name '_withOLRemoval.mat'])
    selectedNeuronalIndex = DataSetList(nData).ActiveNeuronIndex(~neuronRemoveList)';
    selectedNeuronalIndex = selectedHighROCneurons(nDataSet, DataSetList(nData).params, ROCThres, selectedNeuronalIndex);
    nDataSet              = nDataSet(selectedNeuronalIndex);
    numUnits              = length(nDataSet);
    numT                  = length(DataSetList(nData).params.timeSeries);    
    coeffs                = nan(numUnits, numT);
    
    for nUnit             = 1:numUnits
        yesTrial          = mean(nDataSet(nUnit).unit_yes_trial);
        noTrial           = mean(nDataSet(nUnit).unit_no_trial);
        coeffs(nUnit, :)  = yesTrial - noTrial;
    end
    corrMat               = corr(coeffs);    
    
    figure;
    hold on
    
    imagesc(DataSetList(nData).params.timeSeries, DataSetList(nData).params.timeSeries, corrMat);
    xlim([min(DataSetList(nData).params.timeSeries) max(DataSetList(nData).params.timeSeries)]);
    ylim([min(DataSetList(nData).params.timeSeries) max(DataSetList(nData).params.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([DataSetList(nData).params.polein, DataSetList(nData).params.poleout, 0],[DataSetList(nData).params.polein, DataSetList(nData).params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA Time (s)')
    ylabel('LDA Time (s)')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    setPrint(8, 6, [PlotDir 'CollectedUnitsPCALDACorr/SimilarityActDiff_' DataSetList(nData).name '_withOLRemoval'])
end