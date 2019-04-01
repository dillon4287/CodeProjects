function [ retval, lastMean, lastHessian] = identification2( x0, yt, obsPrecision, Ft, FtPrecision,...
    lastMean, lastHessian, options  )
[K,T] = size(yt);
df = 20;
w1 = sqrt(chi2rnd(df,1)/df);
ObsPriorMean = .5.*ones(1, K-1);
ObsPriorPrecision = eye(K-1);

LogLikePositive = @(v) LLRestrict (v, yt,ObsPriorMean,...
    ObsPriorPrecision, obsPrecision, Ft,FtPrecision);
LL = @(guess) -LLRestrict(guess, yt,ObsPriorMean,...
    ObsPriorPrecision, obsPrecision, Ft,FtPrecision);
freeElems = x0(2:end);
[themean, ~,exitflag,~,~, Hessian] = fminunc(LL, freeElems, options);
[~, p] = chol(Hessian);
[themean, Hessian, lastMean, lastHessian] = ...
    optimCheck(p, themean,Hessian, lastMean, lastHessian);
V = Hessian \ eye(length(themean));
n = length(themean);
proposal = themean + chol(V, 'lower')*normrnd(0,1, n,1)./w1;
proposalDist = @(q) mvstudenttpdf(q, themean', V, df);
Num = LogLikePositive(proposal) + proposalDist(freeElems');
Den = LogLikePositive(freeElems) + proposalDist(proposal');
alpha = Num - Den;
u = log(unifrnd(0,1,1));
if u <= alpha 
    retval = [1;proposal];
else
   retval = x0; 
end
end
