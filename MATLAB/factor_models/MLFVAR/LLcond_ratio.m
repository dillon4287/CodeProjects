function [pdfval] = LLcond_ratio(ObsModel,ydemut,ObsPriorMean,...
    ObsPriorPrecision, obsPrecision, factor,factorPrecision)
[nFactors, T ] = size(factor);
K = length(obsPrecision);
nFactorsT = nFactors*T;
nFactorsK = nFactors*K;
% A | F
OmegaI = diag(obsPrecision);
FtOF = kron(OmegaI, factor*factor');
Avariance = (ObsPriorPrecision + FtOF)\speye(nFactorsK, nFactorsK);
Term = ((factor*ydemut').*obsPrecision');
Amean = Avariance*(ObsPriorPrecision*ObsPriorMean' + Term(:));
pdfA = logmvnpdf(ObsModel'-Amean', zeros(1,nFactorsK), Avariance);
% F | A
OmegaI = diag(obsPrecision);
AOI = ObsModel'*OmegaI;
Fvariance = (factorPrecision + kron(speye(T),AOI*ObsModel))\eye(nFactorsT);
Fmean = Fvariance*(kron(speye(T), AOI)*ydemut(:));
pdfF = logmvnpdf(factor(:)'-Fmean', zeros(1,nFactorsT), Fvariance);
pdfval = pdfA- pdfF;
end

