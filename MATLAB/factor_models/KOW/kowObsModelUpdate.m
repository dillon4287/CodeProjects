function [ draw,themean,Hessian ] = kowObsModelUpdate(vecy, precision, StatePrecision, oldMean,...
    oldHessian, Restricted, PriorPre, logdetPriorPre, guess,ObsPriorMean,ObsPriorVar, factor, yt)
MaxRecursionDepth = 1;
options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton',...
        'Display', 'iter', 'FiniteDifferenceType', 'central',...
        'OptimalityTolerance', 1e-6);

[themean,Hessian] = kowOptimize(guess, vecy, StatePrecision,  precision,oldMean,...
    oldHessian, options, MaxRecursionDepth,ObsPriorMean,ObsPriorVar, factor, yt);
if Restricted == 1
    draw = kowMHR(guess,themean,Hessian,vecy,StatePrecision,precision,...
        PriorPre,logdetPriorPre);
else
    draw = kowMHUnRes(guess,themean,Hessian,vecy,StatePrecision,precision,PriorPre,...
        logdetPriorPre);
end
end

