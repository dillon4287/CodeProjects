function [storeMeans, storeLoadings, storeOmArTerms,...
    storeStateArTerms, storeFt, storeObsV, storeFactorVariance,...
    varianceDecomp] = Baseline(InfoCell,yt, xt, Ft, MeansLoadings,  omArTerms,...
    factorArTerms, v0,d0, Sims, burnin, autoRegressiveErrors)
%% Definitions
% yt comes in as
%[ y11...y1T;
% ...
% yK1...yKT'

% xt comes in as
%[1 x11;
%...
% 1 x1K;
% ...
% 1 xT1;
% ...
% 1 xTK]

% MeansLoadings comes in as
% [mu1...muK;
% Load1...LoadK]

% omArTerms comes in as  (p lags)
% [delta1p ... delta11;
% ...
% deltaKp ... deltaK1]

% gammas comes in as deltas.
%% Setup and indices

[K,T] = size(yt);
[KT, meanIndex]= size(xt);
[nFactors,  lagState] = size(factorArTerms);
meanRange = 1:meanIndex;
levels=length(InfoCell);
[~,M] =size(MeansLoadings);
factorRange  = (meanIndex+1):M;


[~, lagObs] = size(omArTerms);
[Identities,~,~]=MakeObsModelIdentity(InfoCell);
restrictions = restrictedElements(InfoCell);
FtIndexMat = CreateFactorIndexMat(InfoCell);
subsetIndices = zeros(K,T);

for k = 1:K
    subsetIndices(k,:)= k:K:KT;
end
lagind = 1:lagObs;
IT = eye(T);
[Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);

%% Posterior Storage
Runs = Sims-burnin;
storeMeans = zeros(K,meanIndex, Runs);
storeLoadings = zeros(K, levels, Runs);
storeOmArTerms = zeros(K, lagObs,Runs);
storeStateArTerms = zeros(nFactors, lagState,Runs);
storeFt = zeros(nFactors, T, Runs);
storeObsV = zeros(K,Runs);
storeFactorVariance = zeros(nFactors,Runs);
%% Initializations
igParamA = .5.*(v0 + T);
obsVariance = ones(K,1);
factorVariance = ones(nFactors,1);
beta = zeros(levels+meanIndex,K);
mut=zeros(K,T);
meanFunction = MeansLoadings(:,meanRange)';
loadings = MeansLoadings(:, factorRange);
fakeX = zeros(T,1);
fakeB = zeros(1,1);
if autoRegressiveErrors == 0
    omArTerms=zeros(K,lagObs);
end
for i = 1:Sims
    fprintf('Simulation i = %i\n',i)
    
    %% Draw Mean, Loadings and AR Parameters
    for k = 1:K
        tempI = subsetIndices(k,:);
        tempy = yt(k,:);
        tempx=[xt(tempI,:),Ft(FtIndexMat(k,:),:)'];
        tempdel=omArTerms(k,:);
        tempD0 = initCovar(omArTerms(k,:));
        tempobv = obsVariance(k);
        [beta(:,k), ~,~,ystar,xstar, Cinv] = drawBeta(tempy, tempx,  tempdel, tempobv, tempD0);
        meanFunction(meanRange,k) = beta(meanRange,k)';
        loadings(k,:) = beta(factorRange,k);
        loadings(k,:) = (loadings(k,:) + restrictions(k,:)) - (loadings(k,:).*restrictions(k,:));
        if autoRegressiveErrors == 1
            omArTerms(k,:) = drawPhi(tempy, tempx, beta(:,k),tempdel, tempobv, Cinv);
        end
        igParamB=d0+sum((ystar - beta(:,k)'*xstar').^2,2);
        obsVariance(k) = 1./gamrnd(igParamA, 2./igParamB);
    end
    
    %% Draw Factors
    SurX = surForm(xt,K);
    mu1t = reshape(SurX*meanFunction(:),K,T);
    demuyt = yt - mu1t;
    c=0;
    for q = 1:levels
        Info = InfoCell{1,q};
        COM = makeStateObsModel(loadings, Identities, q);
        alpha =loadings(:,q);
        tempyt = demuyt - COM*Ft;
        for w = 1:size(Info,1)
            % Factor level
            c=c+1;
            subsI = Info(w,1):Info(w,2);
            commonPrecisionComponent = zeros(T,T);
            commonMeanComponent = zeros(T,1);
            if autoRegressiveErrors == 1
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    [D0, ssOmArTerms] = initCovar(omArTerms(k,:));
                    OmPrecision = FactorPrecision(ssOmArTerms, D0, 1./obsVariance(k), T);
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
            else
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    OmPrecision = kron(IT,1./obsVariance(k));
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
                
            end
            [L0, ssGammas] = initCovar(factorArTerms(c,:));
            StatePrecision = FactorPrecision(ssGammas, L0, 1./factorVariance(c), T);
            OmegaInv = commonPrecisionComponent + StatePrecision;
            Linv = chol(OmegaInv,'lower')\IT;
            omega = Linv'*Linv*commonMeanComponent;
            Ft(c,:) = omega + Linv' * normrnd(0,1,T,1);
        end
    end
    
    %% Draw Factor AR Parameters
    for n=1:nFactors
        [L0, ~] = initCovar(factorArTerms(n,:));
        Linv = chol(L0,'lower')\eye(lagState);
        factorArTerms(n,:) = drawPhi(Ft(n,:), fakeX, fakeB, factorArTerms(n,:), factorVariance(n), Linv);
    end
    
    %% Draw Factor Variances
    [factorVariance, factorParamb]  = drawFactorVariance(Ft, factorArTerms, factorVariance, v0, d0);
    
    %% Store post burn-in runs
    if i > burnin
        v = i - burnin;
        storeMeans(:,:,v)=beta(meanRange,:)';
        storeLoadings(:,:,v) = loadings;
        storeOmArTerms(:, :,v) = omArTerms;
        storeStateArTerms(:,:,v) = factorArTerms;
        storeFt(:,:,v) = Ft;
        storeObsV(:,v) = obsVariance;
        storeFactorVariance(:,v) = factorVariance;
    end
end

%% Variance decomposition
beta = mean(storeMeans,3);
om = mean(storeLoadings,3);
Ft = mean(storeFt,3);
mu1 = reshape(surForm(xt,K)*beta(:),K,T);
varMu1 = var(mu1, [], 2);
facCount = 1;
vd = zeros(K,levels);
for k = 1:levels
    Info = InfoCell{1,k};
    Regions = size(Info,1);
    for r = 1:Regions
        subsetSelect = Info(r,1):Info(r,2);
        vd(subsetSelect,k) = var(om(subsetSelect,k).*Ft(facCount,:),[],2);
        facCount = facCount + 1;
    end
end
varianceDecomp = [varMu1,vd];
varianceDecomp = varianceDecomp./sum(varianceDecomp,2);

%% Marginal likelihood
ReducedRuns = Sims-burnin;
betaStar = mean([storeMeans, storeLoadings],3);
storePiBeta = zeros(K,ReducedRuns);
storeFactorRR = zeros(nFactors, T,ReducedRuns);

%% Reduced run for betas
for rr = 1:ReducedRuns
    for k = 1:K
        tempI = subsetIndices(k,:);
        tempy = yt(k,:);
        tempx=[xt(tempI,:),Ft(FtIndexMat(k,:),:)'];
        tempdel=omArTerms(k,:);
        tempD0 = initCovar(omArTerms(k,:));
        tempobv = obsVariance(k);
        [storePiBeta(k,rr), ystar, xstar, Cinv] = drawBetaML(betaStar(k,:), tempy, tempx,  tempdel, tempobv, tempD0);
        if autoRegressiveErrors == 1
            omArTerms(k,:) = drawPhi(tempy, tempx, betaStar(k,:)',tempdel, tempobv, Cinv);
        end
        igParamB=d0+sum((ystar - betaStar(k,:)*xstar').^2,2);
        obsVariance(k) = 1./gamrnd(igParamA, 2./igParamB);
    end
    %% Draw Factors
    SurX = surForm(xt,K);
    mu1t = reshape(SurX*meanFunction(:),K,T);
    demuyt = yt - mu1t;
    c=0;
    for q = 1:levels
        Info = InfoCell{1,q};
        COM = makeStateObsModel(loadings, Identities, q);
        alpha =loadings(:,q);
        tempyt = demuyt - COM*Ft;
        for w = 1:size(Info,1)
            % Factor level
            c=c+1;
            subsI = Info(w,1):Info(w,2);
            commonPrecisionComponent = zeros(T,T);
            commonMeanComponent = zeros(T,1);
            if autoRegressiveErrors == 1
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    [D0, ssOmArTerms] = initCovar(omArTerms(k,:));
                    OmPrecision = FactorPrecision(ssOmArTerms, D0, 1./obsVariance(k), T);
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
            else
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    OmPrecision = kron(IT,1./obsVariance(k));
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
                
            end
            [L0, ssGammas] = initCovar(factorArTerms(c,:));
            StatePrecision = FactorPrecision(ssGammas, L0, 1./factorVariance(c), T);
            OmegaInv = commonPrecisionComponent + StatePrecision;
            Linv = chol(OmegaInv,'lower')\IT;
            omega = Linv'*Linv*commonMeanComponent;
            Ft(c,:) = omega + Linv' * normrnd(0,1,T,1);
        end
    end
    storeFactorRR(:,:, rr) = Ft;
    
    %% Draw Factor AR Parameters
    for n=1:nFactors
        [L0, ~] = initCovar(factorArTerms(n,:));
        Linv = chol(L0,'lower')\eye(lagState);
        factorArTerms(n,:) = drawPhi(Ft(n,:), fakeX, fakeB, factorArTerms(n,:), factorVariance(n), Linv);
    end
    
    %% Draw Factor Variances
    [factorVariance, factorParamb]  = drawFactorVariance(Ft, factorArTerms, factorVariance, v0, d0);
end

piBeta = sum(logAvg(storePiBeta));
%%%%%%%%%%%%%%%%
%% Reudced Runs for Factors
FactorStar = mean(storeFactorRR,3);
storePiFactor = zeros(nFactors,ReducedRuns);
storeOMARRRg = zeros(K, lagObs,ReducedRuns);
storeFactorARRR = zeros(nFactors, lagState, ReducedRuns);
for rr = 1:ReducedRuns
    for k = 1:K
        tempI = subsetIndices(k,:);
        tempy = yt(k,:);
        tempx=[xt(tempI,:),FactorStar(FtIndexMat(k,:),:)'];
        tempdel=omArTerms(k,:);
        tempD0 = initCovar(tempdel);
        tempobv = obsVariance(k);
        [~, ystar, xstar, Cinv] = drawBetaML(betaStar(k,:), tempy, tempx,  tempdel, tempobv, tempD0);
        if autoRegressiveErrors == 1
            omArTerms(k,:) = drawPhi(tempy, tempx, betaStar(k,:)',tempdel, tempobv, Cinv);
        end
        igParamB=d0+sum((ystar - betaStar(k,:)*xstar').^2,2);
        obsVariance(k) = 1./gamrnd(igParamA, 2./igParamB);
    end
    storeOMARRRg(:,:,rr)=omArTerms;
    %% Draw Factors
    SurX = surForm(xt,K);
    mu1t = reshape(SurX*meanFunction(:),K,T);
    demuyt = yt - mu1t;
    c=0;
    for q = 1:levels
        Info = InfoCell{1,q};
        COM = makeStateObsModel(loadings, Identities, q);
        alpha =loadings(:,q);
        tempyt = demuyt - COM*FactorStar;
        for w = 1:size(Info,1)
            % Factor level
            c=c+1;
            subsI = Info(w,1):Info(w,2);
            commonPrecisionComponent = zeros(T,T);
            commonMeanComponent = zeros(T,1);
            if autoRegressiveErrors == 1
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    [D0, ssOmArTerms] = initCovar(omArTerms(k,:));
                    OmPrecision = FactorPrecision(ssOmArTerms, D0, 1./obsVariance(k), T);
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
            else
                for k = subsI
                    % Equation level
                    ty = tempyt(k,:);
                    OmPrecision = kron(IT,1./obsVariance(k));
                    A = kron(IT,alpha(k,:));
                    commonMeanComponent = commonMeanComponent + A'*OmPrecision*ty(:);
                    commonPrecisionComponent = commonPrecisionComponent + A'*OmPrecision*A;
                end
                
            end
            [L0, ssGammas] = initCovar(factorArTerms(c,:));
            StatePrecision = FactorPrecision(ssGammas, L0, 1./factorVariance(c), T);
            OmegaInv = commonPrecisionComponent + StatePrecision;
            Linv = chol(OmegaInv,'lower')\IT;
            omega = Linv'*Linv*commonMeanComponent;
            storePiFactor(c,rr)=logmvnpdf(FactorStar(c,:), omega', Linv'*Linv);
        end
    end
    
    %% Draw Factor AR Parameters
    for n=1:nFactors
        
        [L0, ~] = initCovar(factorArTerms(n,:));
        Linv = chol(L0,'lower')\eye(lagState);
        factorArTerms(n,:) = drawPhi(FactorStar(n,:), fakeX, fakeB, factorArTerms(n,:), factorVariance(n), Linv);
    end
    storeFactorARRR(:,:, rr) = factorArTerms;
    %% Draw Factor Variances
    [factorVariance, factorParamb]  = drawFactorVariance(FactorStar, factorArTerms, factorVariance, v0, d0);
end
piFactor =sum(logAvg(storePiFactor));

%% OM AR Reduced Run
omARStar = mean(storeOMARRRg,3);
factorARStar = mean(storeFactorARRR,3);
storeAlphaOMARj = zeros(K, ReducedRuns);
storeAlphaFactorj = zeros(K,ReducedRuns);
quantOMARg = zeros(K,ReducedRuns);
quantFactorg = zeros(K,ReducedRuns);
for rr = 1:ReducedRuns
    for k = 1:K
        tempI = subsetIndices(k,:);
        tempy = yt(k,:);
        tempx=[xt(tempI,:),Ft(FtIndexMat(k,:),:)'];
        tempdelstar=omARStar(k,:);
        tempD0Star = initCovar(tempdelstar);
        tempdelg=storeOMARRRg(k,:,rr);
        tempD0g = initCovar(tempdelg);
        tempobv = obsVariance(k);
        [~, ~, ~, Cinvstar] = drawBetaML(betaStar(k,:), tempy, tempx,...
            omARStar(k,:), tempobv, tempD0Star);
        [~, ystar, xstar, Cinvg] = drawBetaML(betaStar(k,:), tempy, tempx,...
            tempdelg, tempobv, tempD0g);
        if autoRegressiveErrors == 1
            [~, storeAlphaOMARj(k,rr)]  = drawPhi(tempy, tempx, betaStar(k,:)', omARStar(k,:), tempobv, Cinvstar);
            quantOMARg(k,rr) = drawPhiG(omARStar(k,:),tempy, tempx, betaStar(k,:)', tempdelg, tempobv, Cinvg);
        end
        igParamB=d0+sum((ystar - betaStar(k,:)*xstar').^2,2);
        obsVariance(k) = 1./gamrnd(igParamA, 2./igParamB);
    end
    
    %% Draw Factor AR Parameters
    for n=1:nFactors
        [L0g, ~] = initCovar(storeFactorARRR(n,:,rr));
        Linvg = chol(L0g,'lower')\eye(lagState);
        [L0star, ~] = initCovar(factorARStar(n,:));
        Linvstar = chol(L0star,'lower')\eye(lagState);
        [~, storeAlphaFactorj(n,rr)] = drawPhi(FactorStar(n,:), fakeX, fakeB, factorARStar(n,:), factorVariance(n), Linvstar);
        quantFactorg(k,rr)=drawPhiG(factorARStar(n,:), FactorStar(n,:), fakeX, fakeB,...
            factorArTerms(n,:), factorVariance(n), Linvg);
    end
    
    %% Draw Factor Variances
    [factorVariance, factorParamb]  = drawFactorVariance(FactorStar, factorARStar, factorVariance, v0, d0);
end

piOMAR = sum(logAvg(quantOMARg) - logAvg(storeAlphaOMARj));
piFactorAR = sum(logAvg(quantFactorg)-logAvg(storeAlphaFactorj));

end

