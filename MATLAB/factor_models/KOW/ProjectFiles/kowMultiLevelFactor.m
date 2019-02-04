    function [sumFt, sumFt2, storeBeta, storeObsPrecision, storeObsModel,...
    storeStateTransitions,  ml] = ...
    kowMultiLevelFactor(yt, Xt, RegionIndices,...
        CountriesThatStartRegions, Countries, SeriesPerCountry,...
        Sims, burnin, blocks, blocksRegion, blockSize, initBeta, initobsmod, initGamma, v0, r0,...
        ReducedRuns)

% All Indexing information intialized here
[K,T, betaDim, EqnsPerBlock, RegionIndicesInFt,...
CountryIndicesInFt, nFactors, Regions] = ...
kowInitializeIndexInfo(yt,Xt,blocks,RegionIndices,Countries);
% All Storage containers made here
[IRegion, ICountry] = kowMakeObsModelIdentityMatrices(K, RegionIndices,...
SeriesPerCountry, Countries);
[lastMeanWorld,lastHessianWorld, lastMeanRegion, ...
lastHessianRegion, lastMeanCountry, lastHessianCountry] =...
    kowBackupMeansAndHessians(SeriesPerCountry,Countries, EqnsPerBlock,blocks, blockSize, blocksRegion );

[sumFt,sumFt2, sumResiduals2,  storeBeta,...
storeObsPrecision, storeObsModel, storeStateTransitions,...
zeroOutWorld , zeroOutRegion, zeroOutCountry, ...
sumLastMeanCountry,  sumLastMeanRegion, sumLastMeanWorld,...
sumLastHessianCountry,sumLastHessianRegion, sumLastHessianWorld] =...
  kowMakeStorageContainers(Sims,burnin,betaDim, K, T,nFactors, SeriesPerCountry,Countries,...
    EqnsPerBlock, blocks,IRegion,ICountry, Regions, blocksRegion, blockSize);
% All priors initialized and initial states of variables
[Si, ObsPriorMean, ObsPriorVar, stateTransitions,...
beta, currobsmod, StateObsModel, Ft, obsVariance,obsPrecision] = ...
    kowInitializePriors(K,T,initobsmod,EqnsPerBlock,...
        SeriesPerCountry, initGamma, initBeta, IRegion,ICountry,...
        nFactors,yt);

speyet = speye(T,T);

for i = 1 : Sims
    fprintf('\n\n  Iteration %i\n', i)
    %% Update mean function
    [beta, ydemut] = kowBetaUpdate(yt(:), Xt, obsPrecision,...
          StateObsModel,Si,T);

    %% Update Obs model

      %% COUNTRY: Zero out the country to demean y conditional on world, region        
        tempStateObsModel = [currobsmod(:,1), IRegion .* currobsmod(:,2),...
        zeroOutCountry ];
        tempydemut = ydemut - tempStateObsModel*Ft;
        [obsupdate, lastMeanCountry, lastHessianCountry,f ] =...
        kowCountryBlocks(tempydemut, obsPrecision, currobsmod(:,3),...
            stateTransitions(CountryIndicesInFt), SeriesPerCountry,...
            Countries, lastMeanCountry, lastHessianCountry,...
            ObsPriorMean,ObsPriorVar,...
            Ft(CountryIndicesInFt,:), i, burnin);
        currobsmod(:,3) = obsupdate;
        Ft(CountryIndicesInFt, :) = f;
%                 %% REGION: Zero out the region to demean y conditional on the world,country 
%         tempStateObsModel = [currobsmod(:,1),...
%         zeroOutRegion, ICountry.* currobsmod(:,3)];
%         tempydemut = ydemut - tempStateObsModel*Ft;
%         [obsupdate,lastMeanRegion,lastHessianRegion,f ] =...
%         kowRegionBlocks( tempydemut,obsPrecision, currobsmod(:,2),...
%             stateTransitions(RegionIndicesInFt), RegionIndices, lastMeanRegion, lastHessianRegion,...
%             ObsPriorMean,ObsPriorVar, Ft(RegionIndicesInFt,:), i, burnin, CountriesThatStartRegions );
%         currobsmod(:,2) = obsupdate;
%         Ft(RegionIndicesInFt,:) = f;
%                 %% WORLD: Zero out the world to demean y conditional on country, region
%         tempStateObsModel = [zeroOutWorld, IRegion .* currobsmod(:,2),...
%         ICountry.* currobsmod(:,3)];
%         tempydemut = ydemut - tempStateObsModel*Ft; 
%         [obsupdate,lastMeanWorld, lastHessianWorld, f] = ...
%         kowWorldBlocks(tempydemut, obsPrecision, currobsmod(:,1),...
%             stateTransitions(1), blocks, lastMeanWorld, lastHessianWorld,...
%             ObsPriorMean,ObsPriorVar, Ft(1,:), i, burnin);
%         currobsmod(:,1) = obsupdate;
%          Ft(1,:) = f;   
   
    StateObsModel = [currobsmod(:,1), IRegion.*currobsmod(:,2),...
    ICountry.*currobsmod(:,3)];

    %% Update Obs Equation Variances
    residuals = ydemut - StateObsModel*Ft;
    [obsVariance,r2] = kowUpdateObsVariances(residuals, v0,r0,T);
    obsPrecision = 1./obsVariance;

    %% Update State Transition Parameters
    [WorldAr] = kowUpdateArParameters(stateTransitions(1), Ft(1,:), 1);
    [RegionAr] = kowUpdateArParameters(stateTransitions(RegionIndicesInFt),...
    Ft(RegionIndicesInFt,:), 1);
    [CountryAr] = kowUpdateArParameters(stateTransitions(CountryIndicesInFt),...
    Ft(CountryIndicesInFt,:), 1);
    stateTransitions = [WorldAr;RegionAr;CountryAr];

    %% Update the State Variance Matrix
    stateTransitionsAll = stateTransitions.*eye(nFactors);
    Si = kowStatePrecision(stateTransitionsAll, 1, T);

    %% Store means and second moments
    if i > burnin
        v = i -burnin;
        storeBeta(:,v) = beta;
        sumFt = sumFt + Ft;
        sumFt2 = sumFt2 + Ft.^2;
        storeObsPrecision(:,v) = obsPrecision;
        storeObsModel(:,:,v) = currobsmod;
        storeStateTransitions(:,:,v) = stateTransitions;
        sumResiduals2 = sumResiduals2 + r2;

    end

    end

Runs = Sims- burnin;
sumFt = sumFt./Runs;
sumFt2 = sumFt2./Runs;
storeRRobsModel = zeros(K, 3, ReducedRuns);
betaStar = zeros(betaDim,1);  
gammaStar = mean(storeStateTransitions,3);
omegaGammaParameter = sumResiduals2./Runs;
sumFtRR = zeros(1,nFactors*T);
Sstar = kowStatePrecision(gammaStar.*eye(nFactors), 1, T);
obsPrecisionStar = mean(storeObsPrecision,2);
 omegaStar= 1./obsPrecisionStar;
sumBetaVar = zeros(betaDim,betaDim);
Astar = zeros(K,3);
% for rr = 1:3
%     fprintf('Reduced Run %i\n', rr)
%     if rr == 1
%         for n = 1:ReducedRuns        
%             %% Reduced Run 1
%             %% Update mean function
%             [beta, ydemut, betaVar] = kowBetaUpdate(yt(:), Xt, obsPrecisionStar,...
%                 StateObsModel, Sstar,  T);
%             sumBetaVar = sumBetaVar + betaVar;
%             betaStar = betaStar + beta;
%       %% COUNTRY: Zero out the country to demean y conditional on world, region        
%         tempStateObsModel = [currobsmod(:,1), IRegion .* currobsmod(:,2),...
%         zeroOutCountry ];
%         tempydemut = ydemut - tempStateObsModel*Ft;
%         [obsupdate, lastMeanCountry, lastHessianCountry,f ] =...
%         kowCountryBlocks(tempydemut, obsPrecision, currobsmod(:,3),...
%         stateTransitions(CountryIndicesInFt), SeriesPerCountry,...
%         Countries, lastMeanCountry, lastHessianCountry,...
%         ObsPriorMean,ObsPriorVar,...
%         Ft(CountryIndicesInFt,:), i, burnin);
%         currobsmod(:,3) = obsupdate;
%         Ft(CountryIndicesInFt, :) = f;
%                 %% REGION: Zero out the region to demean y conditional on the world,country 
%         tempStateObsModel = [currobsmod(:,1),...
%         zeroOutRegion, ICountry.* currobsmod(:,3)];
%         tempydemut = ydemut - tempStateObsModel*Ft;
%         [obsupdate,lastMeanRegion,lastHessianRegion,f ] =...
%         kowRegionBlocks( tempydemut,obsPrecision, currobsmod(:,2),...
%         stateTransitions(RegionIndicesInFt), RegionIndices, lastMeanRegion, lastHessianRegion,...
%         ObsPriorMean,ObsPriorVar, Ft(RegionIndicesInFt,:), i, burnin, CountriesThatStartRegions );
%         currobsmod(:,2) = obsupdate;
%         Ft(RegionIndicesInFt,:) = f;
%                 %% WORLD: Zero out the world to demean y conditional on country, region
%         tempStateObsModel = [zeroOutWorld, IRegion .* currobsmod(:,2),...
%         ICountry.* currobsmod(:,3)];
%         tempydemut = ydemut - tempStateObsModel*Ft; 
%         [obsupdate,lastMeanWorld, lastHessianWorld, f] = ...
%         kowWorldBlocks(tempydemut, obsPrecision, currobsmod(:,1),...
%         stateTransitions(1), blocks, lastMeanWorld, lastHessianWorld,...
%         ObsPriorMean,ObsPriorVar, Ft(1,:), i, burnin);
%         currobsmod(:,1) = obsupdate;
%          Ft(1,:) = f;   
% 
%          StateObsModel = [currobsmod(:,1), IRegion .* currobsmod(:,2),...
%                 ICountry.* currobsmod(:,3)];
%     end
%     betaStar = betaStar./ReducedRuns;
%     sumBetaVar = sumBetaVar./ReducedRuns;
%     ydemut = reshape(yt(:) - Xt*betaStar, K, T);    
%     elseif rr == 2
%         for n = 1:ReducedRuns
%             %% Update Obs model 
%           %% COUNTRY: Zero out the country to demean y conditional on world, region        
%             tempStateObsModel = [currobsmod(:,1), IRegion .* currobsmod(:,2),...
%             zeroOutCountry ];
%             tempydemut = ydemut - tempStateObsModel*Ft;
%             [obsupdate, lastMeanCountry, lastHessianCountry,f ] =...
%             kowCountryBlocks(tempydemut, obsPrecision, currobsmod(:,3),...
%             stateTransitions(CountryIndicesInFt), SeriesPerCountry,...
%             Countries, lastMeanCountry, lastHessianCountry,...
%             ObsPriorMean,ObsPriorVar,...
%             Ft(CountryIndicesInFt,:), i, burnin);
%             currobsmod(:,3) = obsupdate;
%             Ft(CountryIndicesInFt, :) = f;
%                     %% REGION: Zero out the region to demean y conditional on the world,country 
%             tempStateObsModel = [currobsmod(:,1),...
%             zeroOutRegion, ICountry.* currobsmod(:,3)];
%             tempydemut = ydemut - tempStateObsModel*Ft;
%             [obsupdate,lastMeanRegion,lastHessianRegion,f ] =...
%             kowRegionBlocks( tempydemut,obsPrecision, currobsmod(:,2),...
%             stateTransitions(RegionIndicesInFt), RegionIndices, lastMeanRegion, lastHessianRegion,...
%             ObsPriorMean,ObsPriorVar, Ft(RegionIndicesInFt,:), i, burnin, CountriesThatStartRegions );
%             currobsmod(:,2) = obsupdate;
%             Ft(RegionIndicesInFt,:) = f;
%                     %% WORLD: Zero out the world to demean y conditional on country, region
%             tempStateObsModel = [zeroOutWorld, IRegion .* currobsmod(:,2),...
%             ICountry.* currobsmod(:,3)];
%             tempydemut = ydemut - tempStateObsModel*Ft; 
%             [obsupdate,lastMeanWorld, lastHessianWorld, f] = ...
%             kowWorldBlocks(tempydemut, obsPrecision, currobsmod(:,1),...
%                 stateTransitions(1), blocks, lastMeanWorld, lastHessianWorld,...
%                 ObsPriorMean,ObsPriorVar, Ft(1,:), i, burnin);
%             currobsmod(:,1) = obsupdate;
%              Ft(1,:) = f;
%              StateObsModel = [currobsmod(:,1), IRegion .* currobsmod(:,2),...
%                 ICountry.* currobsmod(:,3)];
%             storeRRobsModel(:,:,n) = currobsmod;             
%             sumLastHessianCountry = sumLastHessianCountry + lastHessianCountry;
%             sumLastHessianRegion = sumLastHessianRegion + lastHessianRegion; 
%             sumLastHessianWorld = sumLastHessianWorld + lastHessianWorld;
%             sumLastMeanCountry = sumLastMeanCountry + lastMeanCountry;
%             sumLastMeanRegion = sumLastMeanRegion + lastMeanRegion;
%             sumLastMeanWorld = sumLastMeanWorld + lastMeanWorld;  
%         end
%         Astar = mean(storeRRobsModel,3);        
%         StateObsModelStar = [Astar(:,1), IRegion .* Astar(:,2),...
%             ICountry .* Astar(:,3)]; 
%         sumLastHessianCountry = sumLastHessianCountry./ReducedRuns;
%         sumLastHessianRegion = sumLastHessianRegion./ReducedRuns;
%         sumLastHessianWorld = sumLastHessianWorld./ReducedRuns;
%         sumLastMeanCountry = sumLastMeanCountry./ReducedRuns;
%         sumLastMeanRegion = sumLastMeanRegion ./ ReducedRuns;
%         sumLastMeanWorld = sumLastMeanWorld ./ReducedRuns;
%         Astar = Astar./ReducedRuns;
%     else
%             StateObsModelStar = [Astar(:,1), IRegion .* Astar(:,2),...
%                 ICountry .* Astar(:,3)]; 
%         for n = 1:ReducedRuns
%             [Ftrr, P] = kowUpdateLatent(ydemut(:), StateObsModelStar, Sstar,...
%                 obsPrecisionStar);
%             sumFtRR = sumFtRR + Ftrr;                 
%         end
%     end
% end
% 
% Ftstar = sumFtRR./ReducedRuns;
% pistargamma = kowArMl(storeStateTransitions, gammaStar, sumFt);
% Ftstart = reshape(Ftstar,nFactors,T);
% piastarworld = kowObsModelReducedRunWorld(squeeze(storeRRobsModel(:,1,:)),...
%     ydemut, obsPrecisionStar, Astar(:,1), sumLastMeanWorld,...
%     sumLastHessianWorld, WorldAr, blocks, K,...
%     ObsPriorMean, ObsPriorVar, Ftstart(1,:));
% piastarregion = kowObsModelReducedRunRegion(squeeze(storeRRobsModel(:,2,:)), ydemut,...
%     obsPrecisionStar, Astar(:,2), sumLastMeanRegion,...
%     sumLastHessianRegion, RegionAr, blocksRegion, K,...
%     CountriesThatStartRegions,  ObsPriorMean, ObsPriorVar, Ftstart(RegionIndicesInFt,:));
% piastarcountry = kowObsModelReducedRunCountry(squeeze(storeRRobsModel(:,3,:)),...
%     ydemut, obsPrecisionStar, Astar(:,3), sumLastMeanCountry,...
%     sumLastHessianCountry, CountryAr, Countries,...
%     ObsPriorMean, ObsPriorVar, Ftstart(CountryIndicesInFt,:));
% 
% % Integrate out Ft
% mu2 = StateObsModelStar*Ftstart;
% nomeany = ydemut(:) - mu2(:);
% OmegaStar = spdiags(repmat(omegaStar, T,1), K*T,K*T); 
% fyGivenThetaStar = logmvnpdf(nomeany', zeros(1, K*T), OmegaStar) +...
%     logmvnpdf(Ftstar, zeros(1,nFactors*T), eye(nFactors*T)*100) -...
%     logmvnpdf(Ftstar,Ftstar, P);
% % ML calc
% priorBetaStar = logmvnpdf(betaStar', zeros(1,betaDim), eye(betaDim)*100);
% priorAstar = logmvnpdf(Astar, zeros(size(Astar,1), size(Astar,2)),...
%     eye(size(Astar,2)).*100)';
% priorOmegaStar = logigampdf(obsPrecisionStar, .5*v0, .5*r0);
% priorGammaStar = logmvnpdf(gammaStar, zeros(size(gammaStar,1), size(gammaStar,2)),...
%     eye(size(gammaStar,2)).*100)';
% priorStar = sum([priorBetaStar;priorAstar;priorOmegaStar;priorGammaStar]);
% posteriorStar = sum([pistargamma;...
%     logigampdf(omegaStar, (T+v0)/2, (omegaGammaParameter + r0)./2);...
%     logmvnpdf(betaStar',betaStar', sumBetaVar);...
%     piastarcountry;piastarworld;piastarregion],1);
% ml = fyGivenThetaStar + priorStar - posteriorStar;
end

