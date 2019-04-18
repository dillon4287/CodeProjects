function [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
    sumBeta, sumBeta2, sumObsVariance, sumObsVariance2,...
    sumFactorVar, sumFactorVar2,sumVarianceDecomp,...
   sumVarianceDecomp2] = ...
    ...
    SMDFVAR_SimVersion(yt,  InfoCell, Sims,...
    burnin, ReducedRuns, initFactor, initBeta, initobsmodel,...
    initStateTransitions, v0, r0, s0, d0, identification)
% Spatial version of MDFVAR

% yt is K x T


% Index information
[nFactors, arFactor] = size(initStateTransitions);
[K,T] = size(yt);
% [~, dimX] = size(Xt);

[Identities, sectorInfo, factorInfo] = SpatialIdentities( InfoCell);
% levels = length(sectorInfo);
% 
% backupMeanAndHessian  = setBackups(InfoCell, identification);
% 
% % Initializatitons
% obsPrecision = ones(K,1);
% stateTransitions = initStateTransitions;
% currobsmod = setObsModel(initobsmodel, InfoCell, identification);
% Ft = initFactor;
% StateObsModel = makeStateObsModel(currobsmod,Identities,0);
% Si = kowStatePrecision(diag(initStateTransitions),1,T);
% factorVariance = ones(nFactors,1);
% variancedecomp = zeros(K,levels);
% % Storage
% sumFt = zeros(nFactors, T);
% sumFt2 = sumFt;
% sumBeta = zeros(dimX,1);
% sumBeta2 = sumBeta;
% sumResiduals2 = zeros(K,1);
% storeStateTransitions = zeros(nFactors, arFactor, Sims-burnin);
% sumST = zeros(nFactors, 1);
% sumST2 = zeros(nFactors, 1);
% sumObsVariance = zeros(K,1);
% sumObsVariance2 = sumObsVariance;
% sumOM = zeros(K, levels);
% sumOM2= sumOM ;
% sumFactorVar = zeros(nFactors,1);
% sumFactorVar2 = sumFactorVar;
% sumVarianceDecomp = variancedecomp;
% sumVarianceDecomp2 = variancedecomp;
% 
% options = optimoptions(@fminunc,'FiniteDifferenceType', 'forward',...
%     'StepTolerance', 1e-10, 'Display', 'off', 'OptimalityTolerance', 1e-9);
% 
% DisplayHelpfulInfo(K,T,nFactors,  Sims,burnin,ReducedRuns, options);
% vy = var(yt,0,2);
% 
% for i = 1 : Sims
%     fprintf('\nSimulation %i\n',i)
% %     [beta, ydemut] = kowBetaUpdate(yt(:), Xt, obsPrecision,...
% %         StateObsModel, Si,  T);
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
%         Ft(factorSelect,:) = f;
%         variancedecomp(:,q) = vdecomp;
%     end
%     StateObsModel = makeStateObsModel(currobsmod,Identities,0);
%     
%     %% Variance
%     residuals = ydemut - StateObsModel*Ft;
%     [obsVariance,r2] = kowUpdateObsVariances(residuals, v0,r0,T);
%     obsPrecision = 1./obsVariance;
%     
%     %% AR Parameters
%     stateTransitions = kowUpdateArParameters(stateTransitions, Ft, 1);
%     
%     if identification == 2
%         factorVariance = drawFactorVariance(Ft, stateTransitions, s0, d0);
%     end
%     
%     Si = kowStatePrecision(diag(initStateTransitions),1,T);
%     
%     %% Storage
%     if i > burnin
%         v = i - burnin;
%         sumFt = sumFt + Ft;
%         sumFt2 = sumFt2 + Ft.^2;
%         sumBeta = sumBeta + beta;
%         sumBeta2 = sumBeta2 + beta.^2;
%         sumObsVariance = sumObsVariance +  obsVariance;
%         sumObsVariance2 = sumObsVariance2 + obsVariance.^2;
%         sumOM= sumOM + currobsmod;
%         sumOM2 = sumOM2 + currobsmod.^2;
%         sumST = sumST + stateTransitions;
%         storeStateTransitions(:,:,v) = stateTransitions;
%         sumST2 = sumST2 + stateTransitions.^2;
%         sumResiduals2 = sumResiduals2 + r2;
%         sumFactorVar = sumFactorVar + factorVariance;
%         sumFactorVar2 = sumFactorVar2 + factorVariance.^2;
%         sumVarianceDecomp = sumVarianceDecomp + variancedecomp;
%         sumVarianceDecomp2 = sumVarianceDecomp2 + variancedecomp.^2;
%     end
% end
% 
% Runs = Sims- burnin;
% sumFt = sumFt./Runs;
% sumFt2 = sumFt2./Runs;
% sumBeta = sumBeta./Runs;
% sumBeta2 = sumBeta2./Runs;
% sumObsVariance = sumObsVariance./Runs;
% sumObsVariance2 = sumObsVariance2 ./Runs;
% sumOM= sumOM ./Runs;
% sumOM2 = sumOM2 ./Runs;
% sumST = sumST./Runs;
% sumST2 = sumST2 ./Runs;
% sumResiduals2 = sumResiduals2 ./Runs;
% sumVarianceDecomp = sumVarianceDecomp./Runs;
% sumVarianceDecomp2 = sumVarianceDecomp2./Runs;
% 
% obsPrecisionStar = 1./sumObsVariance;

% MLFML(yt,Xt, sumST, sumObsVariance, nFactors)

end
