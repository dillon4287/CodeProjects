

clear;clc;
rng(121)
SeriesPerCountry=3;
CountriesInRegion =10;
Regions = 3;
Countries = CountriesInRegion*Regions;
T = 100;
identification = 2;
beta = ones(1,SeriesPerCountry+1).*.4;
K = SeriesPerCountry*CountriesInRegion*Regions;
[DataCell] = ...
    MLFdata(T, Regions, CountriesInRegion,SeriesPerCountry,beta, identification);

% % load('Housing.mat')
% % load('StandardizedRealData.mat')
yt = DataCell{1,1};
Xt = DataCell{1,2};
InfoCell = DataCell{1,3};
Factor = DataCell{1,4};
Gamma = DataCell{1,6};
Gt = DataCell{1,7};
% 
[K,T] = size(yt);
[~, dimX] = size(Xt);
% sectorInfo = cellfun(@(x)size(x,1), InfoCell);
% Regions = sectorInfo(2);
% 
levels = size(InfoCell,2);
 
nFactors =  sum(cellfun(@(x)size(x,1), InfoCell));
v0=3;
r0 =5;
s0 = 3;
d0 = 5;
Sims = 20;
burnin = 0;
ReducedRuns = 10;
initBeta = ones(dimX,1);
obsPrecision = ones(K,1);
% initStateTransitions = .3.*ones(nFactors,1).*.1;
initStateTransitions = Gamma;
[Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);

% Simulation Version 
initobsmodel = unifrnd(0,1,K,3);
% initobsmodel = Gt

StateObsModel = makeStateObsModel(initobsmodel,Identities,0);
vecFt  =  kowUpdateLatent(yt(:),  StateObsModel, ...
    kowStatePrecision(diag(initStateTransitions),ones(nFactors,1),T), obsPrecision);
% Ft = reshape(vecFt, nFactors,T);
Ft = Factor;
initFactor = Ft;
identification = 2;
estML = 0;
[sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
    sumObsVariance, sumObsVariance2, sumVarianceDecomp,...
    sumVarianceDecomp2, ml] = MultDyFacVarSimVersion(yt,...
      InfoCell, Sims, burnin, ReducedRuns,  initFactor, initobsmodel,...
      initStateTransitions,v0,r0, s0,d0, identification,estML);

ml
[sumOM,Gt]
mean([sumOM,Gt])
% hold on
% plot(Factor(1,:))
% plot(sumFt(1,:))
A = makeStateObsModel(sumOM, Identities, 0);
yhat = A*sumFt;
hold on 
plot(yt(1,:))
plot(yhat(1,:))
rmse = mean(sqrt(sum((yt - yhat).^2,2)))
% plotFt(Factor, sumFt, sumFt2, InfoCell)
% 
% coverageProb(Factor,sumFt, sumFt2)


% Real Data Version
% [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
%     sumBeta, sumBeta2, sumObsVariance, sumObsVariance2,...
%     sumFactorVar, sumFactorVar2,sumVarianceDecomp,...
%    sumVarianceDecomp2] = ...
%     MultDyFacVar(yt, Xt, InfoCell, Sims, burnin,...
%     ReducedRuns,  initFactor, initBeta, initobsmodel, initStateTransitions,v0,r0, s0,d0, identification);
% xaxis = 1962:2014;

% plotSectorFactor(sumFt(1,:), sumFt2(1,:), xaxis)
% plotSectorFactor(sumFt(2,:), sumFt2(2,:), xaxis)
% plotSectorFactor(sumFt(3,:), sumFt2(3,:), xaxis)
% plotSectorFactor(sumFt(9,:), sumFt2(9,:), xaxis)
% plotSectorFactor(sumFt(10,:), sumFt2(10,:), xaxis)
% plotSectorFactor(sumFt(11,:), sumFt2(11,:), xaxis)
% 


% Spatial Version
% clear;clc;
% T = 200;
% SeriesPerY =3;
% gridX = 8;
% squaresSampled= 50;
% yPerSquare = 3;
% ploton= 1;
% levels = 2;
% nearest_neighbor = 1;
% euclidean_distance = 2;
% DataCell = SpatialMLFdata(SeriesPerY, gridX,...
%     squaresSampled, ploton, levels, T, euclidean_distance);
% 
% yt = DataCell{1,1};
% Xt = DataCell{1,2};
% InfoCell = DataCell{1,3};
% LocationCorrelation = DataCell{1,4};
% Factor = DataCell{1,5};
% p = size(LocationCorrelation,1);
% zp = zeros(1,p);
% zpp = zp;
% zp(1) = 1;
% zpp(end) = 1;
% cutpoints = 1./([zp;zpp]*eig(LocationCorrelation));
% 
% 
% [K,T] = size(yt);
% [~, dimX] = size(Xt);
% sectorInfo = cellfun(@(x)size(x,1), InfoCell);
% Regions = sectorInfo(2);
% levels = size(InfoCell,2);
% nFactors =  sum(cellfun(@(x)size(x,1), InfoCell));
% v0=3;
% r0 =5;
% s0 = 3;
% d0 = 5;
% Sims = 80;
% burnin = 10;
% ReducedRuns = 3;
% initBeta = ones(dimX,1);
% obsPrecision = ones(K,1);
% initobsmodel = unifrnd(0,1,K, levels);
% initStateTransitions = .3.*ones(nFactors,1).*.1;
% 
% [Identities, sectorInfo, factorInfo] = MakeObsModelIdentity( InfoCell);
% StateObsModel = makeStateObsModel(initobsmodel,Identities,0);
% vecFt  =  kowUpdateLatent(yt(:),  StateObsModel, ...
%     kowStatePrecision(diag(initStateTransitions),1,T), obsPrecision);
% Ft = reshape(vecFt, nFactors,T);
% initFactor = Ft;
% identification = 2;
% 
% [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
%     sumObsVariance, sumObsVariance2,...
%     sumFactorVar, sumFactorVar2,sumVarianceDecomp,...
%     sumVarianceDecomp2, parama] = ...
%     SMDFVAR_SimVersion(yt, InfoCell, euclidean_distance,...
%       LocationCorrelation, cutpoints, Sims, burnin,ReducedRuns,...
%       initFactor, initobsmodel, initStateTransitions,v0,r0, s0,d0, identification);
% figure
% plot(parama )
%  sigmaFt = sqrt(sumFt2 - sumFt.^2);
%  upper = sumFt + 2.*sigmaFt;
%  lower = sumFt - 2.*sigmaFt;
 
%   plotFt(Factor, sumFt, sumFt2, InfoCell)

