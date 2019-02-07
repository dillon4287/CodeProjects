function [] = mfvar(Sims, burnin, ReducedRuns, wb, DotMatFile)
if ischar(Sims)
    Sims = str2num(Sims);
end
if ischar(burnin)
    burnin = str2num(burnin);
end
if ischar(ReducedRuns)
    ReducedRuns = str2num(ReducedRuns);
end
if ischar(wb)
    wb = str2num(wb);
end
load(DotMatFile,  'DataCell')
yt = DataCell{1,1};
Xt = DataCell{1,2};
Factor = DataCell{1,3};
InfoCell = DataCell{1,4};


SeriesPerCountry = InfoCell{1,3};
Countries = length(InfoCell{1,1});
Regions = size(InfoCell{1,2},1);
K = SeriesPerCountry*Countries;
nFactors = 1 + Regions + Countries;
v0=3;
r0 =5;
initobsmodel = [.2,.2,.2].*ones(K,3);
initStateTransitions = ones(nFactors,1).*.5;
initBeta = ones(size(Xt,2),1);

[sumFt, sumFt2,sumOM, sumOM2, sumST, sumST2,...
    sumBeta, sumBeta2, sumObsVariance, sumObsVariance2] =...
    MultDyFacVar(yt, Xt,InfoCell, Sims, burnin, ReducedRuns,initBeta, initobsmodel, ...
    initStateTransitions,v0,r0, wb);
fname = createDateString('simulation_mfvar_');
save(fname)
fprintf('\n\t\t SIMULATION ENDED \n')
end

