% 
% generateDPCAData.m
% 
% version 1.0
%
% Comparison list
%
% Output:
% SpikeDataSet     --- yDim x nStim x nDecision (usually ignored) x T x N
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

function firingRates        = generateDPCADataLinearData(nDataSet, numTrials)

    numUnits          = length(nDataSet);
    T                 = size(nDataSet(1).unit_yes_trial_linear, 2);
    numStim           = 2;
    firingRates       = zeros(numUnits, numStim, T, numTrials);
    
    for nTrial        = 1:numTrials
        firingRates(:, 1, :, nTrial)  = cell2mat(arrayfun(@(x) ...
                                      x.unit_yes_trial_linear(...
                                      ceil(size(x.unit_yes_trial_linear,1)*rand()),:),...
                                      nDataSet, 'UniformOutput', false));
        firingRates(:, 2, :, nTrial)  = cell2mat(arrayfun(@(x) ...
                                      x.unit_no_trial_linear(...
                                      ceil(size(x.unit_no_trial_linear,1)*rand()),:),...
                                      nDataSet, 'UniformOutput', false));
        
    end


end
