function [priorAstar] = Apriors(InfoCell, Astar)
priorAstar=0;
levels= length(InfoCell);
fcount = 0;
for q=1:levels
    Info=InfoCell{q};
    Regions = size(Info,1);
    for r = 1:Regions
        fcount = fcount+1;
        subsetSelect = Info(r,1):Info(r,2);
        K = length(subsetSelect);
        astar = Astar(subsetSelect,q);
        astar = reshape(astar(2:end), 1, K-1);
        ObsPriorMean = zeros(1, K-1);
        ObsPriorVariance = eye(K-1);
        priorAstar = priorAstar + logmvnpdf(astar, ObsPriorMean, ObsPriorVariance);
    end
end
end

