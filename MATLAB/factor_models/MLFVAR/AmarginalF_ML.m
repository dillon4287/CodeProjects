function [obsupdate, backup, f, alphaj] = ...
    AmarginalF_ML(Info, Factor, yt, currobsmod,  stateTransitions, factorVariance,...
    obsPrecision, backup)

[K,T] = size(yt);
Regions = size(Info,1);
f = zeros(Regions,T);
obsupdate = zeros(K,1);
alphaj = zeros(Regions,1);
df = 15;
w1 = sqrt(chi2rnd(df,1)/df);

for r = 1:Regions
    subsetSelect = Info(r,1):Info(r,2);
    littlek = length(subsetSelect);
    ObsPriorMean = ones(1, littlek-1);
    ObsPriorPrecision = eye(littlek-1);
    ySlice = yt(subsetSelect,:);
    precisionSlice = obsPrecision(subsetSelect);

    factorPrecision = kowStatePrecision(stateTransitions(r), 1./factorVariance(r), T);
    
    meanA = backup{r,1};
    Covariance = backup{r,2};
    xj = meanA' + chol(Covariance, 'lower')*normrnd(0,1, littlek-1,1)./w1;
    xstar = currobsmod(subsetSelect);
    
    LogLikePositive = @(v) LLRestrict (v, ySlice, ObsPriorMean,...
        ObsPriorPrecision, precisionSlice, Factor(r,:), factorPrecision);
    proposalDist = @(q) mvstudenttpdf(q, meanA, Covariance, df);

    
    Num = LogLikePositive(xj) + proposalDist(xstar(2:end)');
    Den = LogLikePositive(xstar(2:end)) + proposalDist(xj');
    alphaj(r)  = min(0,Num - Den) ;
    
    if  log(unifrnd(0,1)) < alphaj(r) 
        obsupdate(subsetSelect) = [1;xj];
    else
        obsupdate(subsetSelect) = xstar;
    end
    f(r,:) =  kowUpdateLatent(ySlice(:), obsupdate(subsetSelect), factorPrecision, precisionSlice);
end

end

