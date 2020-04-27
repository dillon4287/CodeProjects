function [currobsmod, Ft, keepOmMeans, keepOmVariances, alpha] = ...
    LoadingsFactorsUpdate(yt, Xbeta, Ft, currobsmod, stateTransitions,...
    obsPrecision, factorVariance, Identities, InfoCell, keepOmMeans, keepOmVariances,...
    runningAverageMean, runningAverageVar, a0, A0inv)

options = optimoptions(@fminunc,'FiniteDifferenceType', 'forward',...
    'StepTolerance', 1e-8, 'Display', 'off', 'OptimalityTolerance', 1e-8);
df = 20;
[K,T] = size(yt);
w1 = sqrt(chi2rnd(df,1)/df);
fcount = 0;
levels = length(InfoCell);
nFactors = sum(cellfun(@(x)size(x,1), InfoCell));
alpha = zeros(nFactors,1);

for q = 1:levels
    COM = makeStateObsModel(currobsmod, Identities, q);
    mut = reshape(Xbeta, K,T) + COM*Ft;
    ydemut = yt - mut;
    Info = InfoCell{1,q};
    region = size(Info,1);
    for r=1:region
        fcount = fcount+1;
        gammas = stateTransitions(fcount,:);
        [L0, ssgam] = initCovar(diag(gammas), factorVariance(fcount));
        StatePrecision = FactorPrecision(ssgam, L0, 1./factorVariance(fcount), T);
        tempf = Ft(fcount,:);
        
        subset = Info(r,1):Info(r,2);
        s2 = (Info(r,1)+1):Info(r,2);
        
        %% Optimization step
        for k =s2
            ty = ydemut(k,:);
            top = obsPrecision(k);
            x0 = currobsmod(k,q);
            LL = @(guess) -LLcond_ratio(guess, ty, a0, A0inv, top, tempf,StatePrecision);
            [themean, ~,~,~,~, Covar] = fminunc(LL, x0, options);
            Covar = (1/Covar)';
            if  Covar < 0
                Covar = 1;
            end
            keepOmVariances(k,q)= Covar;
            keepOmMeans(k,q)=themean;
            
            proposal = themean + diag(sqrt(Covar))*normrnd(0,1,1, 1)./w1;
            proposalDistNum = @(prop) mvstudenttpdf(prop, themean', diag(Covar), df);
            proposalDistDen = @(prop) mvstudenttpdf(prop, runningAverageMean(k,q)', diag(runningAverageVar(k,q)), df);
            
            LogLikePositive = @(val) LLcond_ratio (val, ty, a0,A0inv, top, tempf, StatePrecision);
            
            Num = LogLikePositive(proposal) + proposalDistNum(x0);
            Den = LogLikePositive(x0) + proposalDistDen(proposal');
            alpha(fcount) = min(0,Num - Den);
            u = log(unifrnd(0,1,1,1));
            if u <= alpha(fcount)
                currobsmod(k,q) = proposal;
            end
        end
        
        
%                 %% MH step
%                 ty = ydemut(subset,:);
%                 ty = ty(2:end,:);
%                 top = obsPrecision(subset);
%                 top = top(2:end);
%                 omMuNum = keepOmMeans(subset,q);
%                 omVarNum = keepOmVariances(subset,q);
%                 omMuDen = runningAverageMean(subset,q);
%                 omVarDen = runningAverageVar(subset,q);
%                 omMuNum = omMuNum(2:end);
%                 omVarNum = omVarNum(2:end);
%                 omMuDen = omMuDen(2:end);
%                 omVarDen = omVarDen(2:end);
%                 proposal = omMuNum + diag(sqrt(omVarNum))*normrnd(0,1,length(subset)-1, 1)./w1;
%                 proposalDistNum = @(prop) mvstudenttpdf(prop, omMuNum', diag(omVarNum), df);
%                 proposalDistDen = @(prop) mvstudenttpdf(prop, omMuDen', diag(omVarDen), df);
%                 LogLikePositive = @(val) LLcond_ratio (val, ty, a0,A0, top, tempf, StatePrecision);
%                 x0 = currobsmod(subset,q);
%                 [LogLikePositive(proposal); proposalDistNum(x0(2:end)'); LogLikePositive(x0(2:end));proposalDistDen(proposal')]
%                 Num = LogLikePositive(proposal) + proposalDistNum(x0(2:end)');
%                 Den = LogLikePositive(x0(2:end)) + proposalDistDen(proposal');
%                 alpha(fcount) = min(0,Num - Den);
%                 u = log(unifrnd(0,1,1,1));
%                 if u <= alpha(fcount)
%                     currobsmod(subset,q) = [1;proposal];
%                 end
        %% Update Factor
        ty = ydemut(subset,:);
        top = obsPrecision(subset);
        Ft(fcount,:) =  kowUpdateLatent(ty(:), currobsmod(subset,q), StatePrecision, top);
    end
end

end