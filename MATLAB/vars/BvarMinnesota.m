function [] = BvarMinnesota(yt,p, b0, B0, lambda0, ...
     totalShrinkage, otherShrinkage, sims)
 
[yt, xt] = lagYt(yt,p);
[r,K] = size(yt);
[Minn, SigmaU] = EqnBEqnMinnesotaPrior(yt,xt,p, lambda0, totalShrinkage, otherShrinkage);
B0inv = inv(B0);
alphaMat = zeros(sims, K*p + 1, K);
for i = 1:K
    Minv = inv(Minn(:,:,i));
    sigma2 = SigmaU(i,i);
    Vupbar = inv( ((xt'*xt)./sigma2) + Minv);
    alphaupbar = Vupbar * (B0inv*b0 + xt'*yt(:,i) );
    for j = 1:sims
        alphaMat(j, :, i) = mvnrnd(alphaupbar', Vupbar, 1);
    end
    
end

mean(alphaMat)
end

