function [betabar, stoB, R0bar, acceptrate, r0Elems, stoR0 ] = liu2006(y,X, b0, B0,...
    wishartDf, D0, R0, Sims, r0indxs, tz)
% y is expected as [y11,..., y1T; 
%                   y21,...,y2T]
% Dimension sizes needed
% X is longitudnal data
% subject Xij = [1, x(i,1,...J)]
if floor(.1*Sims) > 1
    burnin = floor(.1*Sims);
else
    burnin = 1;
end
[r,c] = size(X);
[CorrMatrixDimension,~]= size(R0);
SubjectNumber = r/CorrMatrixDimension;
% Prior initialization
B=b0;
B0inv = inv(B0);
BpriorsPre = B0inv*b0;
z = y;
R0avg = R0;

% Storage containers and intialize local vars. 
lu = log(unifrnd(0,1,Sims,1));
s1 = zeros(c,c);
s1eye = eye(c,c);
r0i = eye(CorrMatrixDimension);
s2= zeros(c,1);
tempSum1 = s1;
tempSum2=s2;
accept = 0;
stoB = zeros(Sims, c);
trackingNum = size(r0indxs,1);
r0Elems = zeros(Sims-burnin, trackingNum);
postDraws = 0;
accept = 0;
stoR0 = zeros(CorrMatrixDimension, CorrMatrixDimension, Sims-burnin);

B = ones(c,1)

for i = 1 : Sims
    mu = X*B;
    reshapedmu = reshape(mu, CorrMatrixDimension, SubjectNumber);
    z = updateLatentZ(y,reshapedmu, R0);
        mean(z,2)
    % Correlation Matrix Part
    ystar = D0*(z - reshapedmu);
    WishartParameter = ystar*ystar';
    dSi = diag(diag(WishartParameter).^(-.5));
    WishartParameter = dSi*WishartParameter*dSi;
    W = iwishrnd(WishartParameter, wishartDf);
    d0 = diag(W).^(.5);
    canD0 = diag(d0);
    canD0i = diag(d0.^(-1));
    canR = canD0i * W * canD0i;
    mhprob = min(0, .5*(CorrMatrixDimension + 1) *...
        (logdet(canR) - logdet(R0)) );
    if lu(i) < mhprob
        accept = accept + 1;
        R0 = canR;
        D0 = canD0;
    end
    if i > burnin
        postDraws = postDraws + 1;
        for k = 1:trackingNum
            r0Elems(postDraws,k) = R0(r0indxs(k,1), r0indxs(k,2));
        end
       R0avg = R0avg + R0;
       stoR0(:,:,postDraws) = R0;
    end
    R0i = R0\r0i;
    index =1:CorrMatrixDimension;
    for k = 1:SubjectNumber
        select = index + (k-1)*CorrMatrixDimension;
        tempSum1 = tempSum1 + X(select, :)'*R0i*X(select,:);
        tempSum2 = tempSum2 + X(select, :)'*R0i*z(:,k);
    end
    B0 = (tempSum1)\s1eye;
    L= chol(B0,'lower');
    b0 = B0*(tempSum2);
    B = b0 + L*normrnd(0,1,c,1);
    stoB(i,:) = B';
    tempSum1=s1;
    tempSum2=s2;
    fprintf('%i\n', i)
end
R0bar= R0avg/(Sims-burnin + 1);
acceptrate = accept/Sims;
betabar = mean(stoB(burnin:end,:),1);

end

