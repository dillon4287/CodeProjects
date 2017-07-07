function [  ] = crtMLSimulations(N, Sims, batches)

crt= zeros(Sims, 1);
X = normrnd(1,1,N,2);
er = normrnd(0,1,N,1);
y = X*[.25;.45]  + er;
XpX = (X'*X);
XpXinv = (XpX)^(-1);
Xpy = X'*y;
bMLE = XpX^(-1) * Xpy;
e = y - X*bMLE;
sSqd = (e'*e)/N;
thetaMLE = [sSqd; bMLE];
invFisher = [(2*sSqd^2)/N, [0,0];...
    [0;0], sSqd*XpXinv];

for i = 1:Sims
    [K, z] = crtMarginalLikelihood(0, Inf, thetaMLE', invFisher, 1100, 100,...
        [0, 0, 0]);
    b = z(2:3)';
    s = z(1);
    crt(i) = lrLikelihood(y,X, b, s)...
        + logmvnpdf(b', [0,0], eye(2))...
        + loginvgampdf(s, 3,6)...
        - log(mean(prod(K,2)));  
end

crtStd = batchMeans(batches, crt);
crtMean = mean(crt);
fprintf('CRT mean, std: %f, %f\n', crtMean, crtStd);

WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
Audio = audioplayer(WarnWave, 22050);
play(Audio);

end

