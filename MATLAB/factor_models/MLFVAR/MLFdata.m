function [DataCell] = MLFdata(T, Regions, CountriesInRegion,SeriesPerCountry,beta, gam)
Countries = Regions*CountriesInRegion;
K = Countries*SeriesPerCountry;
InfoMat = zeros(K,1);
nFactors = 1 + Regions + Countries;
rdex = 1:Regions;
InfoCell = cell(1,3);
InfoCell{1,1} = kron(rdex', ones(CountriesInRegion,1));
InfoCell{1,2} = [1:SeriesPerCountry*CountriesInRegion:K,;SeriesPerCountry*CountriesInRegion:SeriesPerCountry*CountriesInRegion:K]';
InfoCell{1,3} = SeriesPerCountry;

InfoMat = InfoCell{1,1};
% Xt = normrnd(0,1, K*T,(SeriesPerCountry+1));
% Xt(:,1) = ones(K*T,1);
% Xt = repmat(Xt,1,K);
% E = repmat(kron(eye(K),ones(1,(SeriesPerCountry+1))),T,1);
% Xt = E.*Xt;

% Parameter inits
beta = beta.*ones(K, (SeriesPerCountry+1));
beta= reshape(beta', (SeriesPerCountry+1)*K,1);


stateTransitionsAll = gam'.*eye(nFactors);
speyet = speye(T);
S = kowStatePrecision(stateTransitionsAll, 1, T)\speye(nFactors*T);
Factor = mvnrnd(zeros(nFactors*T,1), S);
Factor = reshape(Factor,nFactors,T);


[I1, I2] = MakeObsModelIdentity(InfoMat, SeriesPerCountry);
Gt = unifrnd(0,1,K,nFactors).*[ones(K,1), I1, I2]; 

mu = Gt*Factor;
yt = mu + normrnd(0,1,K,T);
% Xt = sparse(Xt);
Xt =0;
DataCell = cell(1,7);
DataCell{1,1} = yt;
DataCell{1,2} = Xt;
DataCell{1,3} = Factor;
DataCell{1,4} = InfoCell;
DataCell{1,5} = beta;
DataCell{1,6} = gam;
DataCell{1,7} = Gt;


end
