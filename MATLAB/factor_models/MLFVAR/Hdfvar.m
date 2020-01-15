function [storeFt, storeVAR, storeOM, storeStateTransitions,...
    storeObsPrecision, storeFactorVar,varianceDecomp, ml] =...
    Hdfvar(yt, x,  InfoCell,  Sims,burnin, initFactor, initobsmodel,...
    initStateTransitions, v0, r0, s0, d0, identification, estML, DotMatFile)
periodloc = strfind(DotMatFile, '.') ;
checkpointdir = join( [ '~/CodeProjects/MATLAB/factor_models/MLFVAR/Checkpoints/',...
    DotMatFile(1:periodloc-1),'Checkpoints/'] )

checkpointfilename = 'ckpt';
start = 1;
saveFrequency = 50;
finishedMainRun = 0;
finishedFirstReducedRun = 0;
finishedSecondReducedRun = 0;
finishedThirdReducedRun = 0;
[nFactors, lagState] = size(initStateTransitions);
[K,T] = size(yt);
KT = K*T;
SurX = surForm(x,K);
[~, dimX] = size(SurX);
[Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);
levels = length(sectorInfo);
[~,dimx]=size(x);
FtIndexMat = CreateFactorIndexMat(InfoCell);
subsetIndices = zeros(K,T);
for k = 1:K
    subsetIndices(k,:)= k:K:KT;
end

% Initializatitons
factorVariance = ones(nFactors,1);
obsPrecision = ones(K,1);
stateTransitions = initStateTransitions;
currobsmod = setObsModel(initobsmodel, InfoCell, identification);
Ft = initFactor;
[iP, ssState] =initCovar(initStateTransitions);
Si = FactorPrecision(ssState, iP, 1./factorVariance, T);
fakeX = zeros(T,1);
fakeB = zeros(1,1);
betaPriorPre= eye(dimx);
betaPriorMean = zeros(dimx,1);
g0 = zeros(1,lagState);
G0 = eye(lagState);
% Storage
Runs = Sims - burnin;
storeVAR = zeros(dimx,K,Runs);
storeOM = zeros(K, levels, Runs);
storeFt = zeros(nFactors, T, Runs);
storeStateTransitions = zeros(nFactors, lagState, Runs);
storeObsPrecision = zeros(K, Runs);
storeFactorVar = zeros(nFactors,Runs);
keepOmMeans = currobsmod;
keepOmVariances = currobsmod;
runningAvgOmMeans = zeros(K,levels);
runningAvgOmVars = ones(K,levels);

if exist(checkpointdir, 'dir')
    ckptfilename = join([checkpointdir, checkpointfilename, '.mat']);
    if exist(ckptfilename, 'file')
        fprintf('Found a checkpoint file\n')
        load(ckptfilename)
        fprintf('Loaded checkpoint file\n')
    end
else
    fprintf('Created a checkpoint dir in %s\n', checkpointdir')
    mkdir(checkpointdir)
end

if finishedMainRun == 0
    for iterator = start : Sims
        if mod(iterator, saveFrequency) == 0
            fprintf('File saved at iteration count %i\n', iterator)
            start = iterator;
            save(join( [checkpointdir, 'ckpt'] ) )
        end
        fprintf('Simulation %i\n',iterator)
        %% Draw VAR params
        [VAR, Xbeta] = VAR_ParameterUpdate(yt, x, obsPrecision,...
            currobsmod, stateTransitions, factorVariance, betaPriorMean,...
            betaPriorPre, FtIndexMat, subsetIndices);
        
        %% Draw loadings and factors
        [currobsmod, Ft, keepOmMeans, keepOmVariances]=...
            LoadingsFactorsUpdate(yt,Xbeta, Ft, currobsmod, stateTransitions,...
            obsPrecision, factorVariance, Identities, InfoCell, keepOmMeans, keepOmVariances,...
            runningAvgOmMeans, runningAvgOmVars);
        
        %% Variance
        StateObsModel = makeStateObsModel(currobsmod, Identities, 0);
        resids = yt - StateObsModel*Ft - Xbeta;
        [obsVariance,~] = kowUpdateObsVariances(resids, v0,r0,T);
        obsPrecision = 1./obsVariance;
        
        %% Factor AR Parameters
        for n=1:nFactors
            [L0, ~] = initCovar(stateTransitions(n,:));
            Linv = chol(L0,'lower')\eye(lagState);
            stateTransitions(n,:) = drawPhi(Ft(n,:), fakeX, fakeB, stateTransitions(n,:), factorVariance(n), Linv);
        end
        
        if identification == 2
            [factorVariance, factorParamb]  = drawFactorVariance(Ft, stateTransitions, factorVariance, s0, d0);
        end
        %% Storage
        if iterator > burnin
            v = iterator - burnin;
            storeVAR(:,:,v)=VAR;
            storeOM(:,:,v) = currobsmod;
            storeStateTransitions(:,:,v) = stateTransitions;
            storeFt(:,:,v) = Ft;
            storeObsPrecision(:,v) = obsPrecision;
            storeFactorVar(:,v) = factorVariance;
            runningAvgOmMeans = (runningAvgOmMeans.*(v-1) + keepOmMeans)/v;
            runningAvgOmVars = (runningAvgOmVars.*(v-1) + keepOmVariances)/v;
        else
            runningAvgOmMeans=keepOmMeans;
            runningAvgOmVars=keepOmVariances;
        end
    end
    
    Runs = Sims- burnin;
    betaBar = reshape(mean(storeVAR,3), dimx*K,1);
    Ftbar = mean(storeFt,3);
    omBar = mean(storeOM,3);
    %% Variance Decompositions
    varMu = var(reshape(SurX*betaBar,K,T), [],2);
    facCount = 1;
    vd = zeros(size(currobsmod,1),size(currobsmod,2));
    for k = 1:levels
        Info = InfoCell{1,k};
        Regions = size(Info,1);
        for r = 1:Regions
            subsetSelect = Info(r,1):Info(r,2);
            vd(subsetSelect,k) = var(omBar(subsetSelect,k).*Ftbar(facCount,:),[],2);
            facCount = facCount + 1;
        end
    end
    varianceDecomp = [varMu,vd];
    varianceDecomp = varianceDecomp./sum(varianceDecomp,2);
    
    %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%
    %% Marginal Likelihood
    %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%
    
    [K,T] = size(yt);
    finishedMainRun = 1;
    startRR = 1;
    save(join( [checkpointdir, 'ckpt'] ) )
end

if estML == 1
    if finishedFirstReducedRun == 0
        Astar = mean(storeOM,3);
        stoAlphaj = zeros(nFactors, Runs);
        stoAlphag = zeros(nFactors, Runs);
        storeObsPrecisiong = storeObsPrecision;
        storeStateTransitionsg = storeStateTransitions;
        storeVARj = storeVAR;
        storeFtj = storeFt;
        storeObsPrecisionj = storeObsPrecision;
        storeFactorVarj = storeFactorVar;
        storeStateTransitionsj = storeStateTransitions;
        stj = mean(storeStateTransitions,3);
        Ftj = mean(storeFt,3);
        obsPrecisionj = mean(storeObsPrecision,2);
        fvj = mean(storeFactorVar,2);
        [iP, ssState] =initCovar(stj);
        Si = FactorPrecision(ssState, iP, 1./fvj, T);
        %% MH for factor loadings
        fprintf('Reduced run for factor loadings\n')
        for r = startRR:Runs
            fprintf('RR = %i\n', r)
            [VAR, Xbeta] = VAR_ParameterUpdate(yt, x, obsPrecisionj,...
                Astar, stj, fvj, betaPriorMean, betaPriorPre, FtIndexMat, subsetIndices);
            storeVARj(:,:,r) = VAR;
            Ftg = storeFt(:,:,r);
            stg = storeStateTransitionsg(:,:,r);
            opg = storeObsPrecisiong(:,r);
            
            [~, Ftj, keepOmMeans, keepOmVariances, stoAlphaj(:,r)] = ...
                LoadingsFactorsUpdate(yt,Xbeta,Ftj, Astar, stj,...
                obsPrecisionj,fvj, Identities, InfoCell, keepOmMeans, keepOmVariances,...
                runningAvgOmMeans, runningAvgOmVars);
            
            stoAlphag(:,r) = LoadingsFactorsCJ_GStep(Astar, storeOM(:,:,r), ...
                yt, Xbeta, Ftg, stg, opg, storeFactorVar(:,r), Identities,...
                InfoCell, runningAvgOmMeans, runningAvgOmVars);
            
            StateObsModel = makeStateObsModel(Astar,Identities,0);
            
            %% Variance
            resids = yt - StateObsModel*Ftj - Xbeta;
            [obsVariance,r2] = kowUpdateObsVariances(resids, v0,r0,T);
            obsPrecisionj = 1./obsVariance;
            storeObsPrecisionj(:,r) = obsPrecisionj;
            
            %% State Transitions
            for n=1:nFactors
                [L0, ~] = initCovar(stj(n,:));
                Linv = chol(L0,'lower')\eye(lagState);
                stj(n,:) = drawPhi(Ftj(n,:), fakeX, fakeB, stj(n,:), fvj(n), Linv);
            end
            storeStateTransitionsj(:,:,r) = stj;
            
            if identification == 2
                [fvj, factorParamb]  = drawFactorVariance(Ftj, stj, fvj,s0, d0);
                storeFactorVarj(:,r) = fvj;
            end
        end
        piA = sum(logAvg(stoAlphag) - logAvg(stoAlphaj));
        StateObsModelStar =  makeStateObsModel(Astar,Identities,0);
        stStar = mean(storeStateTransitionsg,3);
        storeFtg = storeFtj;
        storeObsPrecisiong = storeObsPrecisionj;
        storeFactorVarg = storeFactorVarj;
        storeStateTransitionsg = storeStateTransitionsj;
        Ftj = mean(storeFtg,3);
        obsPrecisionj = mean(storeObsPrecisiong,2);
        fvj = mean(storeFactorVarg,2);
        stoAlphaj = zeros(nFactors, Runs);
        stoAlphag = zeros(nFactors, Runs);
        finishedFirstReducedRun = 1;
        save(join( [checkpointdir, 'ckpt'] ) )
    end
    %% MH Step for State Transitions
    if finishedSecondReducedRun == 0
        fprintf('Reduced run for state transitions\n')
        for r = startRR:Runs
            fprintf('RR = %i\n', r)
            [~, alphaj] = drawSTAlphaj(stStar, Ftj, fvj, g0, G0);
            alphag = drawSTAlphag(storeStateTransitionsg(:,:,r), stStar,...
                storeFtg(:,:,r), storeFactorVarg(:,r), g0, G0);
            stoAlphaj(:,r) = alphaj;
            stoAlphag(:,r) = alphag;
            if identification == 2
                [fvj, factorParamb]  = drawFactorVariance(Ftj, stStar, fvj, s0, d0);
                storeFactorVarj(:,r) = fvj;
            end
            [VAR, Xbeta] = VAR_ParameterUpdate(yt, x, obsPrecisionj,...
                Astar, stStar, fvj, betaPriorMean, betaPriorPre, FtIndexMat, subsetIndices);
            storeVARj(:,:,r) = VAR;
            [iP, ssState] =initCovar(stStar);
            Si = FactorPrecision(ssState, iP, 1./fvj, T);
            vecy = reshape(yt-Xbeta, K*T,1);
            Ftj = reshape(kowUpdateLatent(vecy, StateObsModelStar,...
                Si, obsPrecisionj), nFactors, T);
            storeFtj(:,:,r) = Ftj;
            %% Variance
            resids = yt - StateObsModelStar*Ftj - Xbeta;
            [obsVariance,r2] = kowUpdateObsVariances(resids, v0,r0,T);
            obsPrecisionj = 1./obsVariance;
            storeObsPrecisionj(:,r) = obsPrecisionj;
        end
        piST = sum(logAvg(stoAlphag) - logAvg(stoAlphaj));
        VARstar = mean(storeVARj,3);
        betaStar = reshape(VARstar, dimx*K,1);
        xbtStar = reshape(SurX*betaStar,K,T);
        ydemutStar = yt - xbtStar;
        storePiBeta = zeros(K,Runs);
        finishedSecondReducedRun = 1;
        save(join( [checkpointdir, 'ckpt'] ) )
    end
    %% Reduced Run for beta
    if finishedThirdReducedRun == 0
        fprintf('Reduced run for beta\n')
        for r = startRR:Runs
            fprintf('RR = %i\n', r)
            storePiBeta(:,r) = piBetaStar(VARstar, yt, x, obsPrecisionj,...
                Astar, stStar, fvj, betaPriorMean, betaPriorPre, subsetIndices, FtIndexMat);
            Ftj = reshape(kowUpdateLatent(ydemutStar(:), StateObsModelStar,...
                Si,  obsPrecisionj), nFactors, T);
            storeFtj(:,:,r) = Ftj;
            %% Variance
            resids = yt - StateObsModelStar*Ftj - xbtStar;
            [obsVariance,~] = kowUpdateObsVariances(resids, v0,r0,T);
            obsPrecisionj = 1./obsVariance;
            storeObsPrecisionj(:,r) = obsPrecisionj;
            if identification == 2
                [fvj, ~]  = drawFactorVariance(Ftj, stStar, fvj, s0, d0);
                storeFactorVarj(:,r) = fvj;
            end
            [iP, ssState] =initCovar(stStar);
            Si = FactorPrecision(ssState, iP, 1./fvj, T);
        end
        piBeta = sum(logAvg(storePiBeta),1);
        obsPrecisionStar = mean(storeObsPrecisionj, 2);
        obsVarianceStar = 1./obsPrecisionStar;
        factorVarianceStar = mean(storeFactorVarj,2);
        finishedThirdReducedRun = 1;
        save(join( [checkpointdir, 'ckpt'] ) )
    end
    FtStar = mean(storeFtj,3);
    storePiFt = zeros(nFactors, Runs);
    muStar = StateObsModelStar*FtStar + xbtStar;
    residsStar = yt - muStar;
    r2Star = sum(residsStar.*residsStar,2);
    for r = startRR:Runs
        [obsVariance,~] = kowUpdateObsVariances(residsStar, v0,r0,T);
        obsPrecisionj = 1./obsVariance;
        storeObsPrecisionj(:,r) = obsPrecisionj;
        if identification == 2
            [fvj, ~]  = drawFactorVariance(FtStar, stStar, fvj, s0, d0);
            storeFactorVarj(:,r) = fvj;
        end
        storePiFt(:,r) = piFtStar(FtStar, yt, xbtStar, Astar, stStar,...
            obsPrecisionj, fvj, Identities, InfoCell);
    end

    piFt = sum(logAvg(storePiFt));
    obsPrecisionStar = mean(storeObsPrecisionj,2);
    factorVarianceStar = mean(storeFactorVarj,2);
    piObsVariance = sum(logigampdf(1./obsPrecisionStar, .5.*(v0+T), .5.*(r0+r2Star)));
    piFactorVariance = sum(piOmegaStar(factorVarianceStar, stStar, FtStar, s0,d0));
    
    posteriors = [piFt, piBeta, piA , piST, piObsVariance, piFactorVariance]
    posteriorStar = sum(posteriors)
    
    LogLikelihood=sum(logmvnpdf(residsStar', zeros(1,K), diag(obsVarianceStar)))

    priorST = sum(logmvnpdf(stStar, zeros(1,lagState), eye(lagState)));
    priorObsVariance = sum(logigampdf(obsVarianceStar, .5.*v0, .5.*d0));
    priorFactorVar = sum(logigampdf(factorVarianceStar, .5.*s0, .5.*d0));
    priorBeta = logmvnpdf(betaStar', zeros(1, dimX), eye(dimX));
    priorAstar = Apriors(InfoCell, Astar);
    [iP, ssState] =initCovar(stStar);
    Kprecision = FactorPrecision(ssState, iP, 1./factorVarianceStar, T);
    Fpriorstar = logmvnpdf(FtStar(:)', zeros(1,nFactors*T ), Kprecision\eye(nFactors*T));
    
    priors = [Fpriorstar, priorST,priorObsVariance, priorFactorVar, sum(priorAstar), priorBeta]
    priorStar = sum(priors)
    
   
    ml = (LogLikelihood+priorStar)-posteriorStar;
    fprintf('Marginal Likelihood of Model: %.3f\n', ml)
    rmdir(checkpointdir, 's')
    
%     fytheta = LogLikelihood + Fpriorstar - piFt;
%     my = fytheta + sum([priorST,priorObsVariance, priorFactorVar, sum(priorAstar), priorBeta]) - sum([piBeta, piA , piST, piObsVariance, piFactorVariance])
else
    ml = 'nothing';
    rmdir(checkpointdir, 's')
end
end




