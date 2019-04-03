function [ b, ydemut, Precision ] = kowBetaUpdate(vecy, SurX,...
    obsModelPrecision, StateObsModel, StatePrecision, T )
%% Validated.
fprintf('\nBeginning beta update...')
nEqns = length(obsModelPrecision);
nFactors = size(StateObsModel,2);
i = 1:nEqns;
j = 1:nFactors;
fullpre = spdiags(obsModelPrecision,0, nEqns, nEqns);
Inside = StatePrecision + kron(speye(T),...
    StateObsModel'* fullpre *StateObsModel);

Astar = StateObsModel'*fullpre;
cx = size(SurX,2);
addup = zeros(cx,cx);
sumup = zeros(cx,1);
Xstar = zeros(nFactors*T, cx);
ystar = zeros(nFactors*T,1);
for t = 1:T
    select = i + (t-1)*nEqns;
    pick = j + (t-1)*nFactors;
    tmpx = SurX(select,:);
    tmpy = vecy(select);
    tmpxTimesPrecision = tmpx' * fullpre;
    addup = addup +  tmpxTimesPrecision* tmpx;
    sumup = sumup + tmpxTimesPrecision*tmpy;
    Xstar(pick, :) = Astar*tmpx;
    ystar(pick, :) = Astar*tmpy;
end
B0 = speye(cx);
b0 = ones(cx,1);
XstarPinv = Xstar'*(Inside\speye(size(Inside,1)));
Precision = B0 + addup - (XstarPinv*Xstar);
NumeratorTerm = sumup - (XstarPinv*ystar);
Variance = Precision\speye(cx);
b = Variance*(NumeratorTerm + B0*ones(cx,1);
[c, p] =chol(Variance,'lower');
b = (b + c*normrnd(0,1,cx,1));

% b = mvnrnd(b',Variance)';
ydemut = reshape(vecy - SurX*b, nEqns, T);
fprintf('done...\n')
end
