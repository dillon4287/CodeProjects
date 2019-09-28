function [sumFt, sumFt2, sumOM, sumOM2, sumOtherOM, sumOtherOM2,...
    sumST, sumST2,sumBeta, sumBeta2, sumObsVariance, sumObsVariance2,...
    sumFactorVar, sumFactorVar2, varianceDecomp, ml]= Mldfvar(yt, Xt,  InfoCell, Sims,...
    burnin, ReducedRuns, initFactor, initobsmodel,...
    initStateTransitions, v0, r0, s0, d0, identification, estML, DotMatFile, varargin)

if nargin <= 17
   [sumFt, sumFt2, sumOM, sumOM2, sumOtherOM, sumOtherOM2,...
    sumST, sumST2,sumBeta, sumBeta2, sumObsVariance, sumObsVariance2,...
    sumFactorVar, sumFactorVar2, varianceDecomp, ml] = ...
        NoBlocks(yt, Xt,  InfoCell, Sims,...
        burnin, ReducedRuns, initFactor, initobsmodel,...
        initStateTransitions, v0, r0, s0, d0, identification, estML, DotMatFile);
else
    %      [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
    %     sumBeta, sumBeta2, sumObsVariance, sumObsVariance2,...
    %     sumFactorVar, sumFactorVar2,sumVarianceDecomp,...
    %     sumVarianceDecomp2, ml] =...
    %     Blocks(yt, Xt,  InfoCell, Sims,...
    %     burnin, ReducedRuns, initFactor, initBeta, initobsmodel,...
    %     initStateTransitions, v0, r0, s0, d0, identification, estML, varargin{1},...
    %     varargin{2});
    [sumFt, sumFt2, sumOM, sumOM2, sumST, sumST2,...
        sumObsVariance, sumObsVariance2,...
        sumFactorVar, sumFactorVar2,sumVarianceDecomp,...
        sumVarianceDecomp2, storeVarDecomp, ml] = ...
        MultDyFacVarSimVersion(yt, InfoCell, Sims,...
        burnin, ReducedRuns, initFactor, initobsmodel, initStateTransitions,...
        v0, r0, s0,d0, identification, estML);
    sumBeta =0;
    sumBeta2=0;
end
end

