function [] = ModuleTests()

TestDGP=0;
Test3=1;

if TestDGP == 1
clc
fprintf('Test DGP Funcitons\n')
T=100;
Gamma= [.2];
sigma2=1;
[F, H, Rs, vt] =StateSpaceDGP(Gamma, sigma2, T);
check=( H*F(:))- Rs*vt(:);
checksum = sum(check);
if abs(checksum) < 1e-10
    fprintf('\n\tDGP TEST 1, HF=v: TRUE \n')
end

T=100;
g1 = [.2,0; 0,.3];
g2 = [.1,0; 0, .2];
g3 = [.01, 0; 0,.02];
g4 = [.01,0; 0, .002];
Gamma = [g1,g2,g3,g4];

sigma2=[1;1];
[F, H, Rs, vt] =StateSpaceDGP(Gamma, sigma2, T);
check=(Rs \ H*F(:))-vt(:);
checksum = sum(check);
if abs(checksum) < 1e-10
    fprintf('\n\tDGP TEST 2, HF=v: TRUE \n')
end
end

% T=200;
% K = 20;
% gamma = .2;
% [P0] = initCovar(gamma, 1) ;
% Ki = FactorPrecision(gamma, P0, 1, T);
% Lk = chol(Ki,'lower')\eye(T);
% F = Lk'*normrnd(0,1,T,1);
% Xt = normrnd(0,1,T*K,1);
% beta = ones(1,1);
% Xbeta = Xt*beta;
% A = ones(K,1);
% AF = A*F';
% yt = reshape(Xbeta + AF(:) + normrnd(0,1,T*K,1), K,T);
% InfoCell = {[1,K]};
% [K,T] = size(yt);
% [~, dimX] = size(Xt);
% levels = size(InfoCell,2);
% nFactors =  sum(cellfun(@(x)size(x,1), InfoCell));
% lagState=1;
% v0= 6;
% r0 = .001;
% s0 = 6;
% d0 = .001;
% [Ey, Vy]=invGammaMoments(.5*v0, .5*r0);
% [Ey, Vy] =invGammaMoments(.5*s0, .5*d0);
% a0=1;
% A0inv = 5;
% g0 = zeros(1,lagState);
% G0 = eye(lagState);
% 
% beta0 = [mean(yt,2)'; zeros(dimX-1, K)];
% B0inv = 10.*eye(dimX);
% 
% 
% Sims = 50;
% burnin = 5;
% initFactor = zeros(1,T);
% initStateTransitions = zeros(1,size(gamma,2);
% initObsPrecision = ones(K,1);
% initFactorVar = 10;
% initobsmodel = zeros(K,levels);
% identification=2;
% estML=0;
% [storeFt, storeVAR, storeOM, storeStateTransitions,...
%     storeObsPrecision, storeFactorVar,varianceDecomp, ml] = Hdfvar(yt, Xt,  InfoCell, Sims,...
%     burnin, initFactor,  initobsmodel, initStateTransitions, initObsPrecision, initFactorVar,...
%     beta0, B0inv, v0, r0, s0, d0, a0,A0inv, g0, G0, identification, estML, 'Tests');
% Fhat = mean(storeFt,3);
% figure
% plot(F)
% hold on
% plot(Fhat)
% EstimatedVAR = mean(storeVAR,3)';
% Actual = ones(K,1);
% table(round(EstimatedVAR,3), Actual)
% EstimatedObsModel = mean(storeOM,3);
% Actual = A;
% table(EstimatedObsModel, Actual)
% EstimatedST = mean(storeStateTransitions,3)';
% Actual = gamma;
% size(EstimatedST)
% table(EstimatedST, Actual)
% EstimatedObsVar = 1./mean(storeObsPrecision,2);
% Actual = ones(K,1);
% size(EstimatedObsVar)
% table(EstimatedObsVar, Actual)
% EstimatedFactorVar = mean(storeFactorVar,2)';
% Actual = 1;
% table(EstimatedFactorVar, Actual)
% table(varianceDecomp)


if Test3 == 1
clear;

T=200;
lags =3;
% When making gamma, 
% the first element reaches back to the first time period, so
% remember that the small state transition will appear in the first
% columns. 


[yt,Xt, InfoCell, Factors, gammas, betas, A, fvar] = GenerateSimData([5,2], lags, T);

[K,T] =size(yt)
levels= length(InfoCell)
nFactors=size(gammas,1);
[~, dimX] = size(Xt);
v0= 6;
r0 = 8;
s0 = 6;
d0 =  9;
a0 = 1;
A0inv = 1;
[Ey, Vy]=invGammaMoments(.5*v0, .5*r0);
[Ey, Vy] =invGammaMoments(.5*s0, .5*d0);

g0 = zeros(1,lags);
G0=diag(fliplr(.5.^(0:lags-1)));


beta0 = zeros(dimX,K);
B0inv = .01.*eye(dimX);


Sims = 100;
burnin = 30;
initFactor = Factors;
initStateTransitions = gammas;
initObsPrecision = ones(K,1);
initFactorVar = ones(nFactors,1);
initobsmodel = A;
identification=2;
estML=1;
[storeFt, storeVAR, storeOM, storeStateTransitions,...
    storeObsPrecision, storeFactorVar,varianceDecomp, ml] = Hdfvar(yt, Xt,  InfoCell, Sims,...
    burnin, initFactor,  initobsmodel, initStateTransitions, initObsPrecision, initFactorVar,...
    beta0, B0inv, v0, r0, s0, d0, a0, A0inv, g0, G0, identification, estML, 'Tests');

EstimatedVAR = mean(storeVAR,3)';
Actual = betas;
table(round(EstimatedVAR,3), Actual)
EstimatedOM = round(mean(storeOM,3),2);
Actual = A;
table(EstimatedOM, Actual)
EstimatedST = mean(storeStateTransitions,3);
Actual = gammas;
table(round(EstimatedST,3), Actual)
EstimatedObsVar = round(1./mean(storeObsPrecision,2),3);
Actual = ones(K,1);
table(EstimatedObsVar, Actual)
EstFv = round(mean(storeFactorVar,2),3);
Actual = fvar;
table(EstFv, Actual)
vd = round(varianceDecomp,3);
table(vd)

Fhat = mean(storeFt,3);

for t = 1:size(Factors,1)
    figure
    plot(Factors(t,:))
    hold on
    plot(Fhat(t,:))
end
figure
hold on 
for t = 1:size(Factors)
    plot(Factors(t,:))
end
end




end