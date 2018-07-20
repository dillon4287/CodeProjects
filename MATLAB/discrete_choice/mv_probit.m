function [] = mv_probit(y,surX, Sigma0,Sims, LikelihoodSims)
[r,c] = size(surX);
[neqns,~]= size(Sigma0);
N = r/neqns;
IT = eye(N);
b0= zeros(c,1);
B=b0;
B0 = eye(c)*10;
B0inv = inv(B0);
BpriorsPre = B0inv*b0;
Sinv = inv(Sigma0);
stoB = zeros(Sims, c);

WishartPrior = createSigma(.5, neqns);
D0 = eye(neqns)*.5;
R0 = WishartPrior;
W0 = D0*R0*D0;
w0 = 2;
lu = log(unifrnd(0,1,Sims,1));
s1 = zeros(c,c);
s2= zeros(c,1);
s1a = s1;
s2a=s2;
z = double(y);
accept = 0;
R0avg = R0;
for i = 1 : Sims
    fprintf("%i\n", i);
    mu = surX*B;
    reshapedmu = reshape(mu, neqns,N);
    z = updateLatentZ(y',reshapedmu', R0, z)';
    R0i = inv(R0);
    t=1;
    for k = 1:N
        tend = t + neqns - 1;
        s1a = s1a + surX(t:tend, :)'*R0i*surX(t:tend,:);
        s2a = s2a + surX(t:tend, :)'*R0i*z(:,k);
        t = tend + 1;
    end
    B0 = inv(B0inv + s1a);
    b0 = B0*BpriorsPre +  (B0 * s2a);
    s1a=s1;
    s2a=s2;
    B = mvnrnd(b0, B0)';
    stoB(i,:) = B';
    [W, D, R] = mhstep_mvprobit(W0,w0);
    Num = logpxWishart(D,R,w0,WishartPrior) + ...
         surLL(z,reshapedmu,R) + ...
        logWishart(W0, W, w0);
    Den = logpxWishart(D0,R0,w0,WishartPrior) + ...
        surLL(z,reshapedmu,R0) + ...
        logWishart(W, W0, w0);
    alpha = min(0, Num - Den);
    if lu(i) < alpha
        accept = accept + 1;
        D0 = D;
        R0 = R;
        R0avg = R0avg + R0;
    end
    
end
R0avg/(accept+1)
accept/Sims
% mean(stoB(floor(.1*Sims):end,:))
end