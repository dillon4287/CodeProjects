function [] = arkMLSimulator(N, coefs, Sims, batches, seed)
rng(seed);
ark = zeros(Sims, 1);
p = length(coefs);
X = normrnd(1,1,N,p);
er = normrnd(0,1,N,1);
y = X*coefs  + er;
XpX = (X'*X);
XpXinv = (XpX)^(-1);
Xpy = X'*y;
bMLE = XpX^(-1) * Xpy;
e = y - X*bMLE;
sSqd = (e'*e)/N;  
thetaMLE = [sSqd; bMLE];
empty = zeros(p,1);
invFisher = [(2*sSqd^2)/N, empty' ;...
        empty, sSqd*XpXinv];
rng(randi(100))
for i = 1:Sims
    [K, z] = arkMarginalLikelihood(0, Inf, thetaMLE', invFisher, 2000);
    b = z(2:p+1)';
    s = z(1);
    ark(i) = lrLikelihood(y,X, b, s)  + logmvnpdf(b', zeros(1,p), eye(p)) +...
        loginvgampdf(s, 3,6) - log(mean(prod(K,2)));
end
arkStd = batchMeans(batches, ark);
arkMean = mean(ark);
fprintf('ARK mean, std: %.4f & %.4f\n', arkMean, arkStd);


