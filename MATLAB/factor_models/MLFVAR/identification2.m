function [ retval, lastMean, lastCovar] = identification2( x0, yt, obsPrecision, Ft, FtPrecision,...
    lastMean, lastCovar, options  )

[K,T] = size(yt);
df = 15;
w1 = sqrt(chi2rnd(df,1)/df);
ObsPriorMean = ones(1, K-1);
ObsPriorPrecision = eye(K-1);
LL = @(g) -LLRestrict (g, yt,ObsPriorMean,...
    ObsPriorPrecision, obsPrecision, Ft,FtPrecision);

[themean, ~,exitflag,~,~, Hessian] = fminunc(LL, x0(2:end), options);

[~, p] = chol(Hessian);

if p ~= 0
    themean = lastMean';
    V = lastCovar;
else
    lastMean = themean';
    lastCovar = Hessian\eye(K-1);
    V = lastCovar;
end
proposalDist = @(q) mvstudenttpdf(q, themean', V, df);

LogLikePositive = @(v) LLRestrict (v, yt,ObsPriorMean,...
    ObsPriorPrecision, obsPrecision, Ft,FtPrecision);
proposal = themean + chol(V, 'lower')*normrnd(0,1, K-1,1)./w1;
freeElems = x0(2:end);
Num = LogLikePositive(proposal) + proposalDist(freeElems');
Den = LogLikePositive(freeElems) + proposalDist(proposal');
alpha = min(0,Num - Den);
if log(unifrnd(0,1,1)) <= alpha
    retval = [1;proposal];
else
    retval = x0;

end
end

