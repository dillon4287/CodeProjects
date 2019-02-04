function [yt, Xt, Factor, InfoMat, beta ] =...
    kowGenSimData(T, Regions, CountriesInRegion,SeriesPerCountry,beta, G, gamma)
Countries = Regions*CountriesInRegion;
K = Countries*SeriesPerCountry;
InfoMat = zeros(K,1);
nFactors = 1 + Regions + Countries;
rdex = 1:Regions;
InfoMat = kron(rdex', ones(CountriesInRegion,1));
Xt = normrnd(0,1, K*T,(SeriesPerCountry+1));
Xt(:,1) = ones(K*T,1);
Xt = repmat(Xt,1,K);
E = repmat(kron(eye(K),ones(1,(SeriesPerCountry+1))),T,1);
Xt = E.*Xt;

% Parameter inits
beta = beta.*ones(K, (SeriesPerCountry+1));
beta= reshape(beta', (SeriesPerCountry+1)*K,1);


stateTransitionsAll = gamma'.*eye(nFactors);

Si = kowStatePrecision(stateTransitionsAll, 1, T);
S = Si\eye(size(stateTransitionsAll,1)*T);
Factor = mvnrnd(zeros(1,nFactors*T), S);
Factor = reshape(Factor,nFactors,T);
[I1, I2] = MakeObsModelIdentity(InfoMat, SeriesPerCountry);

Gt = [ones(K,1).*G(1), I1.*G(2), I2.*G(3)];

mu = reshape(Xt*beta, K,T) + Gt*Factor;
yt = mu + normrnd(0,1,K,T);
Xt = sparse(Xt);

end

