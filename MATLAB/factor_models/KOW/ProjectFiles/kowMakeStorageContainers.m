function [sumFt,sumFt2, sumResiduals2,  storeBeta,...
storeObsVariance, storeObsModel, storeStateTransitions,...
zeroOutWorld, zeroOutRegion, zeroOutCountry, sumLastMeanCountry, ...
sumLastMeanRegion, sumLastMeanWorld, sumLastHessianCountry,...
sumLastHessianRegion, sumLastHessianWorld] =...
    kowMakeStorageContainers(Sims,burnin, betaDim,...
        NumberYequations, NumberTimePeriods,NumberOfFactors,...
        SeriesPerCountry,Countries, EqnsPerBlock, blocks, IRegion, ICountry, Regions, RegionBlocks, RegionBlockSize)
    
sumFt = zeros(NumberOfFactors, NumberTimePeriods);
sumFt2 = sumFt;
sumResiduals2 = zeros(NumberYequations,1);
storeBeta = zeros(betaDim, Sims -burnin);
storeObsVariance = zeros(NumberYequations,Sims -burnin);
storeObsModel = zeros(NumberYequations, 3, Sims-burnin);
storeStateTransitions = zeros(NumberOfFactors, 1, Sims-burnin);
zeroOutWorld = zeros(NumberYequations, 1);
zeroOutRegion = zeros(size(IRegion));
zeroOutCountry = zeros(size(ICountry));
sumLastMeanCountry = zeros(SeriesPerCountry, Countries);
sumLastMeanRegion = zeros(RegionBlockSize, RegionBlocks);
sumLastMeanWorld = zeros(EqnsPerBlock, blocks);
sumLastHessianCountry = reshape(repmat(eye(SeriesPerCountry), 1, Countries), ...
    SeriesPerCountry, SeriesPerCountry, Countries);
sumLastHessianRegion = reshape(repmat(eye(RegionBlockSize), 1, RegionBlocks),...
    RegionBlockSize,RegionBlockSize ,RegionBlocks);
sumLastHessianWorld = reshape(repmat(eye(EqnsPerBlock),1,blocks), EqnsPerBlock,...
    EqnsPerBlock, blocks);

end

