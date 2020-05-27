function [yt, Xt, InfoCell, Factors, gammas, betas, A, factorvar, omvar] = GenerateSimData(SizesClusters, lags, T)
levels = length(SizesClusters) ;
nFactors = CalcNumFacs(SizesClusters);
K = prod(SizesClusters);
gammas = fliplr(.5.^(1:lags));
gammas = repmat(gammas, nFactors,1);
factorvar = ones(nFactors,1);
P0 = initCovar(gammas, factorvar);
[C, H] = FactorPrecision(gammas, P0, factorvar, T);
Kinvlower = chol(C, 'lower')\eye(T*nFactors) ;
Factors = reshape(Kinvlower'*normrnd(0,1,nFactors*T,1), nFactors,T); % Transpose is important!
Xt = normrnd(0,1,T*K,1);
beta = 1;
betas = beta.*ones(K,1);
Xbeta = Xt*beta;
InfoCell = CreateInfoCell(SizesClusters, K, levels);
A = ones(K,levels);
% A = unifrnd(0,1,K,levels);
[Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);
OM = makeStateObsModel(A, Identities, 0);
AF = kron(eye(T),OM)*Factors(:);
sigma2= 1;
yt = reshape(Xbeta + AF + normrnd(0,sigma2,T*K,1), K,T);
omvar = sigma2.*ones(K,1);
end


function[s] = CalcNumFacs(SizesClusters)
    if SizesClusters(end) ==1
        error('Do not have 1 be last size of cluster')
    end
    if length(SizesClusters) == 1
        s= 1;
    else
        red = SizesClusters(2:end);
        s = CalcNumFacs(red) + prod(red);        
    end
end

function[InfoCell] = CreateInfoCell(SizesClusters, K, levels)
InfoCell = {[1,K]};
for t = 1:levels-1
    
    if t > 1
        j = prod(SizesClusters(1:t));
    else
        j = SizesClusters(t);
    end
    InfoCell{levels-t+1}= [(1:j:K)', (j:j:K)'];
end
end
    
    