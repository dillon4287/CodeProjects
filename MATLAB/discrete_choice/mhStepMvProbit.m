function [ alpha ] = mhStepMvProbit(Wstar, Dstar, Rstar, W0, D0,...
    R0, wprior, wishartDf, latentData, meanLatentData)
K = size(Rstar,1);
JacNum = .5*(K-1)*sum(log(diag(D0)));
JacDen = .5*(K-1)*sum(log(diag(Dstar)));
% surLL computes by row for every column!
 
Num = logpxWishart(Dstar,Rstar,wishartDf, wprior)+ ...
      surLL(latentData, meanLatentData, Rstar) + ...
      logWishart(W0, Wstar, wishartDf) + JacNum;
Den = logpxWishart(D0,R0,wishartDf,wprior) + ...
      surLL(latentData, meanLatentData, R0) + ...
      logWishart(Wstar, W0, wishartDf) + JacDen;   
  
alpha = min(0, Num - Den);
end

