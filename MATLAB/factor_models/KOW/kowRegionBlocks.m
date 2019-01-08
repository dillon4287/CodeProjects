function [obsupdate,lastMeanUpdate,lastHessianUpdate,f  ] = kowRegionBlocks( yt,precision,RegionObsModel,...
    StateTransitions, CountriesThatStartRegions, SeriesPerCountry, Countries, lastMean, lastHessian, PriorPre, logdetPriorPre )
T = size(yt,2);
NF = length(StateTransitions);
saveStatePrecisions = zeros(T,T,NF);
lastMeanUpdate = zeros(SeriesPerCountry, Countries);
lastHessianUpdate = zeros(SeriesPerCountry, SeriesPerCountry, Countries);
obsupdate = zeros(length(RegionObsModel),1);
regioncount = 1;
regionselect = 0;
t = 1:SeriesPerCountry;
for b = 1:Countries
    selectC = t + (b-1)*SeriesPerCountry;
    guess = RegionObsModel(selectC);
    yslice = yt(selectC, :);
    pslice = precision(selectC, :);
    if b == CountriesThatStartRegions(regioncount) 
        Restricted = 1;
        regioncount = regioncount + 1;
        regionselect = regionselect + 1;
        [StatePrecision] = kowMakePrecision(StateTransitions(regionselect,:), 1, T);
        [obsupdate(selectC),lastMeanUpdate(:,b),lastHessianUpdate(:,:,b)] =...
            kowObsModelUpdate(yslice(:), pslice, StatePrecision, lastMean(:,b),...
            lastHessian(:,:,b), Restricted, PriorPre, logdetPriorPre, guess);
        saveStatePrecisions(:,:,regionselect) = StatePrecision;

    else
        Restricted =0;
        [obsupdate(selectC),lastMeanUpdate(:,b), lastHessianUpdate(:,:,b)] =...
            kowObsModelUpdate(yslice(:), pslice, StatePrecision, lastMean(:,b),...
            lastHessian(:,:,b), Restricted, PriorPre, logdetPriorPre, guess);
    end
end
f = zeros(NF, T);
for i = 1:NF
    f(i,:) = kowUpdateLatent(yt(:), RegionObsModel,saveStatePrecisions(:,:,i), precision);
end
end
