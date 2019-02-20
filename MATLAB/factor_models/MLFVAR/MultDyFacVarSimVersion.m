function [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
    sumBeta, sumBeta2, sumObsVariance, sumObsVariance2] = ...
    ...
    MultDyFacVarSimVersion(yt, Xt,  InfoCell, Sims,...
    burnin, ReducedRuns, initBeta, initobsmodel, initStateTransitions, v0, r0,...
    worldBlocks)

% InfoCell 1,1 has which country belongs to which Region
% InfoCell 1,2 has which equation starts a region and which
% ends a region in row pairs
% InfoCell 1,3 has SeriesPerCountry
% Number of rows is equal to countries in InfoCell 1,1
% yt is K x T
% Obs Model must be [World Region Country] and is K x 3

InfoMat = InfoCell{1,1};
SeriesPerCountry = InfoCell{1,3};
nFactors = length(initStateTransitions);
[K,T] = size(yt);
betaDim= size(Xt,2);
[IRegion, ICountry, Regions, Countries] = MakeObsModelIdentity( InfoMat, SeriesPerCountry);

backupMeanAndHessian  = setBackups(InfoCell, SeriesPerCountry, worldBlocks,2);
RegionIndicesFt = 2:(Regions+1);

CountryIndicesFt = 2+Regions:(1+Regions+Countries);

obsPrecision = ones(K,1);
stateTransitions = initStateTransitions;
beta = initBeta;
currobsmod = initobsmodel;

sumFt = zeros(nFactors, T);
sumFt2 = sumFt.^2;
zerooutregion = zeros(K, Regions);
zerooutcountry = zeros(K, Countries);
zerooutworld = zeros(K,1);
sumResiduals2 = zeros(K,1);
sumST = zeros(nFactors, 1);
sumST2 = zeros(nFactors, 1);
sumObsVariance = zeros(K,1);
sumObsVariance2 = sumObsVariance;
sumOM = zeros(K, 3);
sumOM2= sumOM ;
sumBeta = zeros(betaDim, 1);
sumBeta2 = sumBeta;
ydemut = yt;

Ft = ones(nFactors,T);

options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton',...
    'Display', 'off', 'FiniteDifferenceType', 'forward',...
    'MaxIterations', 100, 'MaxFunctionEvaluations', 5000,...
    'OptimalityTolerance', 1e-5, 'FunctionTolerance', 1e-5, 'StepTolerance', 1e-5);

DisplayHelpfulInfo(K,T,Regions,Countries,SeriesPerCountry,...
    nFactors, worldBlocks, Sims,burnin,ReducedRuns, options);

for i = 1 : Sims
    fprintf('\nSimulation %i\n',i)
    
        %% World
    FactorType = 1;
    NoWorld = makeStateObsModel([zerooutworld, currobsmod(:,2:3)],IRegion,ICountry);
    ty = ydemut - NoWorld*Ft;
    [currobsmod(:,1), backupMeanAndHessian,f] = AmarginalF(InfoCell, ...
        Ft(1, :), ty, currobsmod(:,1), stateTransitions(1), obsPrecision, ...
        backupMeanAndHessian, FactorType, worldBlocks, options);
    Ft(1,:) = f;
    
   
    %% Region
    FactorType = 2;
    NoRegion = makeStateObsModel(currobsmod, zerooutregion, ICountry);
    ty = ydemut - NoRegion*Ft;
    [currobsmod(:,2),backupMeanAndHessian,f] = AmarginalF(InfoCell, ...
        Ft(RegionIndicesFt, :), ty, currobsmod(:,2), stateTransitions(RegionIndicesFt), obsPrecision, ...
        backupMeanAndHessian,FactorType, worldBlocks, options);
    Ft(RegionIndicesFt,:) = f;
    

    %% Country
    FactorType = 3;
    NoCountry = makeStateObsModel(currobsmod, IRegion, zerooutcountry);
    ty = ydemut - NoCountry*Ft;
    [currobsmod(:,3), backupMeanAndHessian,f] = AmarginalF(InfoCell, ...
        Ft(CountryIndicesFt, :), ty, currobsmod(:,3), stateTransitions(CountryIndicesFt), obsPrecision, ...
        backupMeanAndHessian, FactorType, worldBlocks, options);
    Ft(CountryIndicesFt, :) = f;
   
    StateObsModel = makeStateObsModel(currobsmod,IRegion,ICountry);
    
    %% Variance
    residuals = ydemut - StateObsModel*Ft;
    [obsVariance,r2] = kowUpdateObsVariances(residuals, v0,r0,T);
    obsPrecision = 1./obsVariance;
    
    %% AR Parameters
    stateTransitions = kowUpdateArParameters(stateTransitions, Ft, 1);
    Si = kowStatePrecision( diag(stateTransitions), 1, T);

    %% Storage
    if i > burnin
        sumBeta = sumBeta + beta;
        sumBeta2 = sumBeta2 + beta.^2;
        sumFt = sumFt + Ft;
        sumFt2 = sumFt2 + Ft.^2;
        sumObsVariance = sumObsVariance +  obsVariance;
        sumObsVariance2 = sumObsVariance2 + obsVariance.^2;
        sumOM= sumOM + currobsmod;
        sumOM2 = sumOM2 + currobsmod.^2;
        sumST = sumST + stateTransitions;
        sumST2 = sumST2 + stateTransitions.^2;
        sumResiduals2 = sumResiduals2 + r2;
        
    end
    
end

Runs = Sims- burnin;
sumFt = sumFt./Runs;
sumFt2 = sumFt2./Runs;
sumBeta = sumBeta./Runs;
sumBeta2 = sumBeta2./Runs;
sumObsVariance = sumObsVariance./Runs;
sumObsVariance2 = sumObsVariance2 ./Runs;
sumOM= sumOM ./Runs;
sumOM2 = sumOM2 ./Runs;
sumST = sumST./Runs;
sumST2 = sumST2 ./Runs;
sumResiduals2 = sumResiduals2 ./Runs;

obsPrecisionStar = 1./sumObsVariance;

% MLFML(yt,Xt, sumST, sumObsVariance, nFactors)

end
