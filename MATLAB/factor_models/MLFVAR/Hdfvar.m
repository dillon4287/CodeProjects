function [storeFt, storeVAR, storeOM, storeStateTransitions,...
    storeObsPrecision, storeFactorVar,varianceDecomp, ml] =...
    Hdfvar(yt, x,  InfoCell, BlockingInfo, Sims,burnin, initFactor, initobsmodel,...
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
restrictions = restrictedElements(InfoCell);
backupMeanAndHessian=setBackupsForBlocks(BlockingInfo, identification, restrictions);
backupIndices = setBackupIndices(BlockingInfo);
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
StateObsModel = makeStateObsModel(currobsmod,Identities,0);
[iP, ssState] =initCovar(initStateTransitions);
Si = FactorPrecision(ssState, iP, 1./factorVariance, T);
fakeX = zeros(T,1);
fakeB = zeros(1,1);
betaPriorPre=eye(dimx).*.1;
betaPriorMean = zeros(dimx,1);
% Storage
Runs = Sims - burnin;
VAR = zeros(dimx,K);
Xbeta = zeros(K,T);
storeVAR = zeros(dimx,K,Runs);
storeOM = zeros(K, levels, Runs);
storeFt = zeros(nFactors, T, Runs);
storeStateTransitions = zeros(nFactors, lagState, Runs);
storeFactorParamb = zeros(nFactors, Runs);
storeObsPrecision = zeros(K, Runs);
storeFactorVar = zeros(nFactors,Runs);
sumBackup = backupMeanAndHessian;

options = optimoptions(@fminunc,'FiniteDifferenceType', 'forward',...
    'StepTolerance', 1e-14, 'Display', 'off', 'OptimalityTolerance', 1e-14);

levelVec = levels:(-1):1;

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
        fprintf('\nSimulation %i\n',iterator)
        for k=1:K
            tempI = subsetIndices(k,:);
            tempy = yt(k,:);
            tempx = x(tempI,:);
            tempObsPrecision = obsPrecision(k);
            tempOm = currobsmod(k,:);
            fidx=FtIndexMat(k,:);
            gammas = stateTransitions(fidx,:);
            [L0, ssgam] = initCovar(diag(gammas));
            StatePrecision = FactorPrecision(ssgam, L0, 1./factorVariance(fidx), T);
            [VAR(:,k), Xbeta(k,:),bhat1(:,k)] = betaDraw(tempy(:), tempx,...
                tempObsPrecision,tempOm,StatePrecision, betaPriorMean, betaPriorPre, T);
        end
        
        for q = levelVec
            fprintf('Level %i\n', q)
            COM = makeStateObsModel(currobsmod, Identities, q);
            mut = Xbeta + COM*Ft;
            ydemut = yt - mut;
            Info = InfoCell{1,q};
            factorIndx = factorInfo(q,:);
            facSelect = factorIndx(1):factorIndx(2);
            facVarSubset = factorVariance(facSelect);
            tempBackupIndices = backupIndices(:,q);
            tempBackupIndices = tempBackupIndices(1):tempBackupIndices(2);
            tempbackup = backupMeanAndHessian(tempBackupIndices,:);
            [currobsmod(:,q),tempbackup,f] = ExperimentalAmF(Info,...
                BlockingInfo{q}, Ft(facSelect, :), ydemut, currobsmod(:,q), ...
                stateTransitions(facSelect,:), facVarSubset,obsPrecision,...
                tempbackup, options, identification,restrictions(:,q));
            tempBackupIndices = backupIndices(:,q);
            tempBackupIndices = tempBackupIndices(1):tempBackupIndices(2);
            backupMeanAndHessian(tempBackupIndices,:) = tempbackup;
            
            Ft(facSelect,:) = f;
        end
        StateObsModel = makeStateObsModel(currobsmod,Identities,0);
        [iP, ssState] =initCovar(stateTransitions);
        Si = FactorPrecision(ssState, iP, 1./factorVariance, T);
        %% Variance
        resids = yt - StateObsModel*Ft - Xbeta;
        [obsVariance,r2] = kowUpdateObsVariances(resids, v0,r0,T);
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
            if identification == 2
                %                 storeFactorParamb(:, v) =  factorParamb;
            end
            if estML == 1
                rback = size(backupMeanAndHessian,1);
                for r = 1:rback
                    sumBackup{r,1} = sumBackup{r,1} + backupMeanAndHessian{r,1};
                    sumBackup{r,2} = sumBackup{r,2} + backupMeanAndHessian{r,2};
                end
                options = optimoptions(@fminunc,'FiniteDifferenceType', 'forward',...
                    'StepTolerance', 1e-14, 'Display', 'off', 'OptimalityTolerance', 1e-14,...
                    'MaxIterations', 10);
            end
        end
    end
    
    Runs = Sims- burnin;
    sumBackup = cellfun(@(b)rdivide(b,Runs), sumBackup, 'UniformOutput', false);
    
    betaBar = reshape(mean(storeVAR,3), dimx*K,1);
    Ftbar = mean(storeFt,3);
    omBar = mean(storeOM,3);
    %% Variance Decompositions and resizing. (Hopefully
    % Resizing gets removed, it is unneccessary.
    
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
    
    
    %% Marginal Likelihood
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
        storeFtg = storeFt;
        storeObsPrecisiong = storeObsPrecision;
        storeFactorVarg = storeFactorVar;
        storeStateTransitionsg = storeStateTransitions;
        storeVARj = storeVAR;
        storeVARg = storeVAR;
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
            for k=1:K
                tempI = subsetIndices(k,:);
                tempy = yt(k,:);
                tempx = x(tempI,:);
                tempObsPrecision = obsPrecision(k);
                tempOm = currobsmod(k,:);
                fidx=FtIndexMat(k,:);
                gammas = stateTransitions(fidx,:);
                [L0, ssgam] = initCovar(diag(gammas));
                StatePrecision = FactorPrecision(ssgam, L0, 1./factorVariance(fidx), T);
                [VAR(:,k), Xbeta(k,:),bhat1(:,k)] = betaDraw(tempy(:), tempx,...
                    tempObsPrecision,tempOm,StatePrecision, betaPriorMean, betaPriorPre, T);
            end
            storeVARj(:,:,r) = VAR;
            storeVARj(:,:,r) = VAR;
            Ftg = storeFtg(:,:,r);
            stg = storeStateTransitionsg(:,:,r);
            fv = storeFactorVar(:,r);
            opg = storeObsPrecisiong(:,r);
            betag=reshape(storeVARg(:,:,r), dimx*K,1);
            for q = levelVec
                ConditionalObsModel = makeStateObsModel(Astar, Identities, q);
                mutj = Xbeta + ConditionalObsModel*Ftj;
                ydemut = yt - mutj;
                Info = InfoCell{1,q};
                factorIndx = factorInfo(q,:);
                facSelect = factorIndx(1):factorIndx(2);
                facVarSubset = fvj(facSelect);
                tempBackupIndices = backupIndices(:,q);
                tempBackupIndices = tempBackupIndices(1):tempBackupIndices(2);
                tempbackup = sumBackup(tempBackupIndices,:);
                [~, ~, f, alphaj] = Amfj(Info, BlockingInfo{q},...
                    Ftj(facSelect, :), ydemut,  Astar(:,q), stj(facSelect),...
                    facVarSubset,obsPrecisionj, tempbackup, restrictions(:,q));
                stoAlphaj(tempBackupIndices, r) = alphaj;
                Ftj(facSelect,:) = f;
                omg = storeOM(:,:,r);
                ConditionalObsModel = makeStateObsModel(omg, Identities, q);
                mutg =  reshape(SurX*betag,K,T) + ConditionalObsModel*Ftg;
                ydemut = yt - mutg;
                stoAlphag(tempBackupIndices,r) = Amfg(Info,...
                    BlockingInfo{q}, Ftg(facSelect,:), ydemut, Astar(:,q), omg(:,q),...
                    stg(facSelect,:), fv(facSelect),opg, tempbackup,...
                    restrictions(:,q));
            end
            StateObsModel = makeStateObsModel(Astar,Identities,0);
            [iP, ssState] =initCovar(stj);
            Si = FactorPrecision(ssState, iP, 1./fvj, T);
            storeFtj(:,:,r) = Ftj;
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
        storeVARg = storeVARj;
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
            [stj, alphaj] = drawSTAlphaj(stStar, Ftj, fvj,lagState);
            alphag = drawSTAlphag(storeStateTransitionsg(:,:,r), stStar,...
                storeFtg(:,:,r), storeFactorVarg(:,r), lagState);
            storeStateTransitionsg(:,:,r) = stj;
            stoAlphaj(:,r) = alphaj;
            stoAlphag(:,r) = alphag;
            if identification == 2
                [fvj, factorParamb]  = drawFactorVariance(Ftj, stj, fvj, s0, d0);
                storeFactorVarj(:,r) = fvj;
            end
            [iP, ssState] =initCovar(stj);
            Si = FactorPrecision(ssState, iP, 1./fvj, T);
            for k=1:K
                tempI = subsetIndices(k,:);
                tempy = yt(k,:);
                tempx = x(tempI,:);
                tempObsPrecision = obsPrecision(k);
                tempOm = currobsmod(k,:);
                fidx=FtIndexMat(k,:);
                gammas = stateTransitions(fidx,:);
                [L0, ssgam] = initCovar(diag(gammas));
                StatePrecision = FactorPrecision(ssgam, L0, 1./factorVariance(fidx), T);
                [VAR(:,k), Xbeta(k,:),bhat1(:,k)] = betaDraw(tempy(:), tempx,...
                    tempObsPrecision,tempOm,StatePrecision, betaPriorMean, betaPriorPre, T);
            end
            storeVARj(:,:,r) = VAR;
            vecy = reshape(yt-Xbeta, K*T,1);
            Ftj = reshape(kowUpdateLatent(vecy, StateObsModelStar,...
                Si, obsPrecisionj), nFactors, T);
            storeFtj(:,:,r) = Ftj;
            StateObsModel = makeStateObsModel(Astar,Identities,0);
            %% Variance
            resids = yt - StateObsModel*Ft - Xbeta;
            [obsVariance,r2] = kowUpdateObsVariances(resids, v0,r0,T);
            obsPrecisionj = 1./obsVariance;
            storeObsPrecisionj(:,r) = obsPrecisionj;
        end
        piST = sum(logAvg(stoAlphag) - logAvg(stoAlphaj));
        VARstar = mean(storeVARj,3);
        betaStar = reshape(VARstar, dimx*K,1);
        xbtStar = reshape(SurX*betaStar,K,T);
        ydemut = yt - xbtStar;
        storePiBeta = zeros(1,Runs);
        finishedSecondReducedRun = 1;
        save(join( [checkpointdir, 'ckpt'] ) )
    end
    %% Reduced Run for beta
    if finishedThirdReducedRun == 0
        fprintf('Reduced run for beta\n')
        for r = startRR:Runs
            fprintf('RR = %i\n', r)
            storePiBeta(r) = piBetaStar(betaStar, yt(:), SurX, obsPrecisionj,...
                StateObsModelStar, Si,  T);
            Ftj = reshape(kowUpdateLatent(ydemut(:), StateObsModelStar,...
                Si,  obsPrecisionj), nFactors, T);
            storeFtj(:,:,r) = Ftj;
            %% Variance
            resids = yt - StateObsModelStar*Ftj - xbtStar;
            [obsVariance,r2] = kowUpdateObsVariances(resids, v0,r0,T);
            obsPrecisionj = 1./obsVariance;
            storeObsPrecisionj(:,r) = obsPrecisionj;
            if identification == 2
                [fvj, factorParamb]  = drawFactorVariance(Ftj, stStar, fvj, s0, d0);
                storeFactorVarj(:,r) = fvj;
            end
            [iP, ssState] =initCovar(stStar);
            Si = FactorPrecision(ssState, iP, 1./fvj, T);
        end
        piBeta = logAvg(storePiBeta);
        FtStar = mean(Ft,3);
        muStar = StateObsModelStar*FtStar + xbtStar;
        resids = yt - muStar;
        fMean = zeros(1, nFactors*T);
        storePiFactor = zeros(K,Runs);
        obsPrecisionStar = mean(storeObsPrecisionj, 2);
        obsVarianceStar = 1./obsPrecisionStar;
        factorVarianceStar = mean(storeFactorVarj,2);
        storePiObsVariance = zeros(K, Runs);
        storePiFactorVarianceStar = zeros(nFactors, Runs);
        finishedThirdReducedRun = 1;
        save(join( [checkpointdir, 'ckpt'] ) )
    end
    fprintf('Reduced run for obs variance and factor variance\n')
    for r = startRR:Runs
        fprintf('RR = %i\n', r)
        [iP, ssState] =initCovar(stStar);
        Si = FactorPrecision(ssState, iP, 1./fvj, T);
        Ftj = reshape(kowUpdateLatent(ydemut(:), StateObsModelStar,...
            Si,  obsPrecisionStar), nFactors, T);
        mutj = StateObsModelStar*Ftj + xbtStar;
        resids = yt - mutj;
        r2 = sum(resids.^2,2);
        storeFtj(:,:,r) = Ftj;
        storePiObsVariance(:,r) = logigampdf(obsVarianceStar, .5.*(v0+T), .5.*(r0+r2));
        obsPrecisionj = 1./obsVariance;
        storeObsPrecisionj(:,r) = obsPrecisionj;
        if identification == 2
            storePiFactorVarianceStar(:,r) = piOmegaStar(factorVarianceStar, stStar, Ftj, s0,d0);
        end
    end
    
    % Theta star
    piObsVariance = sum(logAvg(storePiObsVariance))
    piFactorVariance = sum(logAvg(storePiFactorVarianceStar))
    posteriors = [piBeta, piA , piST,piObsVariance,piFactorVariance]
    posteriorStar = sum(posteriors);
    LogLikelihood = sum(logmvnpdf(yt', muStar', diag(obsVarianceStar)))
    % Priors
    priorST = sum(logmvnpdf(stStar, zeros(1,lagState), eye(lagState)));
    priorObsVariance = sum(logigampdf(obsVarianceStar, .5.*v0, .5.*d0));
    priorFactorVar = sum(logigampdf(factorVarianceStar, .5.*s0, .5.*d0));
    priorBeta = logmvnpdf(betaStar', zeros(1, dimX), eye(dimX));
    priorAstar = Apriors(Info, Astar);
    priors = [priorST,priorObsVariance,priorFactorVar, sum(priorAstar),priorBeta ]
    priorStar = sum([priorST,priorObsVariance,priorFactorVar, sum(priorAstar),priorBeta ]);
    % Integrated log likelihood
    [iP, ssState] =initCovar(stStar);
    Kprecision = FactorPrecision(ssState, iP, 1./factorVarianceStar, T);
    Fpriorstar = logmvnpdf(FtStar(:)', zeros(1,nFactors*T ), Kprecision\speye(nFactors*T))
    G = kron(eye(T), StateObsModelStar);
    J = Kprecision + G'*spdiags(repmat(obsPrecisionStar,T,1), 0, K*T, K*T)*G;
    piFtstarGivenyAndthetastar = .5*(  logdet(J) -  (log(2*pi)*nFactors*T)  )
    fyGiventhetastar =  LogLikelihood + Fpriorstar - piFtstarGivenyAndthetastar;
    % Log ml
    ml = fyGiventhetastar + priorStar - posteriorStar;
    fprintf('Marginal Likelihood of Model: %.3f\n', ml)
    rmdir(checkpointdir, 's')
else
    ml = 'nothing';
    rmdir(checkpointdir, 's')
end
end




