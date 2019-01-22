function [sumFt, sumFt2, storeBeta, storeObsVariance, storeObsModel,...
    storeStateTransitions, storeFt] = kowTest(yt, Xt, Sims,...
    burnin, initBeta, initobsmod, initGamma, Factor, v0, r0  )
[K,T] = size(yt);
betaDim=size(Xt,2);
obsPrecision = ones(K,1);
obsVariance = 1./obsPrecision;
currobsmod = initobsmod;
StateObsModel = currobsmod;
stateTransitions = initGamma;
beta = initBeta(:);
resids = yt(:) - Xt*beta;

ydemut = reshape(resids, K,T);
r2 = resids'*resids;
Si = kowStatePrecision(stateTransitions, 1, T);
blocks = 1;
EqnsPerBlock = K/blocks;
lastMeanWorld = zeros(K,1);
lastHessianWorld = eye(K);
ObsPriorMean = initobsmod';
ObsPriorVar = eye(K).*1e2;
WorldObsModelPriorPrecision = 1e-2.*eye(EqnsPerBlock);
WorldObsModelPriorlogdet = EqnsPerBlock*log(1e-2);
% Ft = zeros(1,T);
Ft = Factor(1,1:end-1);
residuals = reshape(resids, K,T) - StateObsModel*Ft;
sumFt = zeros(1, T);
sumFt2 = sumFt;
sumResiduals2 = zeros(K,1);
storeFt = zeros(1,T, Sims-burnin);
storeBeta = zeros(betaDim, Sims -burnin);
storeObsVariance = zeros(K,Sims -burnin);
storeObsModel = zeros(K, 1, Sims-burnin);
storeStateTransitions = zeros(K, 1, Sims-burnin);
ss= sqrt(diag(reshape(resids,K,T)*reshape(resids,K,T)'./T));
for i = 1 : Sims
    fprintf('\n\n  Iteration %i\n', i)
    %% Update mean function
%     [beta, ydemut] = kowBetaUpdate(yt(:), Xt, obsPrecision,...
%         StateObsModel, Si,  T);
    
    %% Update Obs model 
    % WORLD: Zero out the world to demean y conditional on country, region
%     [update,lastMeanWorld, lastHessianWorld, f] = kowWorldBlocks(ydemut, obsPrecision, currobsmod(:,1),...
%         stateTransitions(1), blocks, lastMeanWorld, lastHessianWorld,...
%         WorldObsModelPriorPrecision, WorldObsModelPriorlogdet, ObsPriorMean,ObsPriorVar, Ft, i, burnin);
%     currobsmod(:,1) = update;

    

    %% Update Obs Equation Variances
%     residuals = ydemut - StateObsModel*Ft;
%     [obsVariance,r2] = kowUpdateObsVariances(residuals, v0,r0,T);
%     obsPrecision = 1./obsVariance;
    
    %% Update State Transition Parameters
%     [WorldAr] = kowUpdateArParameters(stateTransitions(1), Ft(1,:), 1);
%     stateTransitions = [WorldAr]
    
    %% Update the State Variance Matrix
%     Si = kowStatePrecision(stateTransitions, 1, T);

    %% Store means and second moments
    if i > burnin
        v = i -burnin;
        storeFt(:,:,v) = Ft;
        storeBeta(:,v) = beta;
        sumFt = sumFt + Ft;
        sumFt2 = sumFt2 + Ft.^2;
        storeObsVariance(:,v) = obsVariance;
        storeObsModel(:,:,v) = currobsmod;
        storeStateTransitions(:,:,v) = stateTransitions;
        sumResiduals2 = sumResiduals2 + r2;

    end
end
Runs = Sims- burnin;
sumFt = sumFt./Runs;
sumFt2 = sumFt2./Runs;
end

