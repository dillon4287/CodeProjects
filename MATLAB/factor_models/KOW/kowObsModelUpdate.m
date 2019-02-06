function [ draw,themean,Hessian ] = kowObsModelUpdate(guess, precision, StatePrecision, oldMean,...
    oldHessian, Restricted, ObsPriorMean,ObsPriorVar, factor, yt, i, burnin)
MaxRecursionDepth = 1;
if i < burnin
    options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton',...
        'Display', 'iter', 'FiniteDifferenceType', 'central',...
         'MaxIterations', 100, 'MaxFunctionEvaluations', 600);
else
    options =  optimoptions(@fminunc, 'Algorithm', 'quasi-newton',...
        'Display', 'iter', 'FiniteDifferenceType', 'forward',...
         'MaxFunctionEvaluations', 600, 'MaxIterations', 30);
end
[themean,Hessian] = kowOptimize(guess, StatePrecision,  precision,oldMean,...
    oldHessian, options, MaxRecursionDepth,ObsPriorMean,ObsPriorVar, factor, yt);
if Restricted == 1
    draw = kowMHR(guess,themean,Hessian,yt,precision,...
        ObsPriorMean, ObsPriorVar, factor, StatePrecision);
else
    draw = kowMHUnRes(guess,themean,Hessian, yt,precision,...
        ObsPriorMean, ObsPriorVar, factor, StatePrecision);
end

end

