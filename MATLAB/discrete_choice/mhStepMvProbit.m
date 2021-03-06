function [ alpha ] = mhStepMvProbit(Wstar, Dstar, Rstar, W0, D0,...
    R0, wprior, wishartDf, latentData, meanLatentData)
K = size(Rstar,1);
JacNum = .5*(K-1)*sum(log(diag(Dstar)));
JacDen = .5*(K-1)*sum(log(diag(D0)));
% surLL computes by row for every column!
Num = logWishart(Wstar, wprior, wishartDf)+ JacNum+...
      surLL(latentData, meanLatentData, Rstar) + ...
      logWishart(W0, Wstar, wishartDf);
Den = logWishart(W0,wprior,wishartDf)+JacDen + ...
      surLL(latentData, meanLatentData, R0) + ...
      logWishart(Wstar, W0, wishartDf);
%    logWishart(Wstar./wishartDf, wprior, wishartDf)
%     logWishart(W0,wprior,wishartDf)
%   logWishart(W0, Wstar./wishartDf, wishartDf)
%   logWishart(Wstar./wishartDf, W0, wishartDf)
% Num
% Den
alpha = min(0, Num - Den);
end

