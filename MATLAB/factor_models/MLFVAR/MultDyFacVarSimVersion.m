function [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
    sumObsVariance, sumObsVariance2, sumVarianceDecomp,...
    sumVarianceDecomp2] = ...
    ...
    MultDyFacVarSimVersion(yt, InfoCell, Sims,...
    burnin, ReducedRuns, initFactor, initobsmodel, initStateTransitions, v0, r0, s0,d0, identification)
%% INPUT
% % yt is K x T
% % initobsmodel must be [Level1, Level2,...] and is K x Levels,
% % Levels are the number of factors that appear in each equation
% % initStateTransitions must be nFactors x p where
% % p is the number of lagged factors in every Factor equation
% % InfoCell is a cell matrix with:
% % InfoCell{1,g} All the information about the beginning and ending
% % indices of the equations in the gth sector stored as
% % row 1 = [beg, end]
% % row 2 = [beg, end]
% % .
% % .
% % .
% % row j = [beg, end]
%
% % Index information

% [nFactors, arFactor] = size(initStateTransitions);
% [K,T] = size(yt);
% [Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);
% levels = length(sectorInfo);
% Countries = sectorInfo(3);
% Regions = sectorInfo(2);
% backupMeanAndHessian  = setBackups(InfoCell, identification);
% 
% % Initializatitons
% obsPrecision = ones(K,1);
% stateTransitions = initStateTransitions;
% currobsmod = setObsModel(initobsmodel, InfoCell, identification);
% Ft = initFactor;
% factorVariance = ones(nFactors,1);
% variancedecomp = zeros(K,3);
% % Storage
% sumFt = zeros(nFactors, T);
% sumFt2 = sumFt.^2;
% sumResiduals2 = zeros(K,1);
% storeStateTransitions = zeros(nFactors, arFactor, Sims-burnin);
% sumST = zeros(nFactors, 1);
% sumST2 = zeros(nFactors, 1);
% sumObsVariance = zeros(K,1);
% sumObsVariance2 = sumObsVariance;
% sumOM = zeros(K, 3);
% sumOM2= sumOM ;
% sumFactorVar = zeros(nFactors,1);
% sumFactorVar2 = sumFactorVar;
% sumVarianceDecomp = variancedecomp;
% sumVarianceDecomp2 = variancedecomp;
% storeFactorParamb = zeros(nFactors, Sims-burnin);
% options = optimoptions(@fminunc,'FiniteDifferenceType', 'forward',...
%     'StepTolerance', 1e-10, 'Display', 'off', 'OptimalityTolerance', 1e-9);
% 
% DisplayHelpfulInfo(K,T,nFactors,  Sims,burnin,ReducedRuns, options);
% vy = var(yt,0,2);
% for i = 1 : Sims
%     fprintf('\nSimulation %i\n',i)
% 
%     %% Update loadings and factors
% 
%     for q = 1:levels
%         ConditionalObsModel = makeStateObsModel(currobsmod, Identities, q);
%         ty = yt - ConditionalObsModel*Ft;
%         Info = InfoCell{1,q};
%         factorIndx = factorInfo(q,:);
%         factorSelect = factorIndx(1):factorIndx(2);
%         factorVarianceSubset = factorVariance(factorSelect);
%         tempbackup = backupMeanAndHessian(factorSelect,:);
%         [currobsmod(:,q), tempbackup, f, vdecomp] = AmarginalF(Info, ...
%             Ft(factorSelect, :), ty, currobsmod(:,q), stateTransitions(factorSelect), factorVarianceSubset,...
%             obsPrecision, tempbackup, options, identification, vy);
%         backupMeanAndHessian(factorSelect,:) = tempbackup;
%         Ft(factorSelect,:) = f;
%         variancedecomp(:,q) = vdecomp;
%     end
% 
%     StateObsModel = makeStateObsModel(currobsmod,Identities,0);
% 
%     %% Variance
%     residuals = yt - StateObsModel*Ft;
%     [obsVariance,r2] = kowUpdateObsVariances(residuals, v0,r0,T);
%     obsPrecision = 1./obsVariance;
% 
%     %% AR Parameters
%     stateTransitions = kowUpdateArParameters(stateTransitions, Ft, 1);
% 
%     if identification == 2
%         [factorVariance, factorParamb]  = drawFactorVariance(Ft, stateTransitions, s0, d0);
%     end
%     %% Storage
%     if i > burnin
%         v = i - burnin;
%         sumFt = sumFt + Ft;
%         sumFt2 = sumFt2 + Ft.^2;
%         sumObsVariance = sumObsVariance +  obsVariance;
%         sumObsVariance2 = sumObsVariance2 + obsVariance.^2;
%         sumOM= sumOM + currobsmod;
%         sumOM2 = sumOM2 + sumOM.^2;
%         sumST = sumST + stateTransitions;
%         storeStateTransitions(:,:,v) = stateTransitions;
%         sumST2 = sumST2 + stateTransitions.^2;
%         sumResiduals2 = sumResiduals2 + r2;
%         sumFactorVar = sumFactorVar + factorVariance;
%         sumFactorVar2 = sumFactorVar2 + factorVariance.^2;
%         sumVarianceDecomp = sumVarianceDecomp + variancedecomp;
%         sumVarianceDecomp2 = sumVarianceDecomp2 + variancedecomp.^2;
%         storeFactorParamb(:, v) =  factorParamb;
%     end
% 
% end
% 
% Runs = Sims- burnin;
% sumFt = sumFt./Runs;
% sumFt2 = sumFt2./Runs;
% sumObsVariance = sumObsVariance./Runs;
% sumObsVariance2 = sumObsVariance2 ./Runs;
% sumOM= sumOM ./Runs;
% sumOM2 = sumOM2 ./Runs;
% sumST = sumST./Runs;
% sumVarianceDecomp = sumVarianceDecomp./Runs;
% sumVarianceDecomp2 = sumVarianceDecomp2./Runs;
% sumST2 = sumST2 ./Runs;
% 
% sumResiduals2 = sumResiduals2 ./Runs;
% obsPrecisionStar = 1./sumObsVariance;
% save('testdata')
load('testdata.mat')
[K,T] = size(yt);
obsPrecisionStar = 1./sumObsVariance;
piObsVarianceStar = logigampdf(obsPrecisionStar, .5.*(T+v0), .5.*(sumResiduals2 + r0));
piFactorVarianceStar = logigampdf(sumFactorVar, .5.*(T+s0), .5.*(d0+mean(storeFactorParamb,2)));
piFactorTransitionStar = kowArMl(storeStateTransitions, sumST, sumFt);
Ag = zeros(K,levels,ReducedRuns);
for r = 1:ReducedRuns
    for q = 1:levels
        ConditionalObsModel = makeStateObsModel(currobsmod, Identities, q);
        ty = yt - ConditionalObsModel*Ft;
        Info = InfoCell{1,q};
        factorIndx = factorInfo(q,:);
        factorSelect = factorIndx(1):factorIndx(2);
        factorVarianceSubset = sumFactorVar(factorSelect);
        tempbackup = backupMeanAndHessian(factorSelect,:);
        [currobsmod(:,q), tempbackup, f, ~] = AmarginalF(Info, ...
            Ft(factorSelect, :), ty, currobsmod(:,q), sumST(factorSelect), factorVarianceSubset,...
            obsPrecisionStar, tempbackup, options, identification, vy);
        backupMeanAndHessian(factorSelect,:) = tempbackup;
        Ft(factorSelect,:) = f;
    end
    Ag(:,:,r) = currobsmod;
    
end
Astar = mean(Ag,3);
piAstarsum = 0;
for q = 1:levels
    ConditionalObsModel = makeStateObsModel(Astar, Identities, q);
    ty = yt - ConditionalObsModel*Ft;
    Info = InfoCell{1,q};
    factorIndx = factorInfo(q,:);
    factorSelect = factorIndx(1):factorIndx(2);
    factorVarianceSubset = sumFactorVar(factorSelect);
    tempbackup = backupMeanAndHessian(factorSelect,:);
    
    piAstarsum = piAstarsum + sum(piAstar(Info, Ft(factorSelect, :), ty, squeeze(Ag(:,q,:)),...
        Astar, sumST(factorSelect), factorVarianceSubset,...
        obsPrecisionStar, tempbackup,identification));
    
end
 piAstarsum

kowStatePrecision(diag(sumST), 

StateObsModelStar = makeStateObsModel(Astar, Identities, 0) ;
mu = StateObsModelStar*sumFt ;
LogLikelihood = sum(logmvnpdf(yt', mu', diag(sumObsVariance)));

    
    
    

end


