function [  ] = SimStudyZhang(Sims)
if ischar(Sims)
    Sims = str2num(Sims);
end
rng(14)
burnin = 0;
N = 600;
K = 4;
R = zeros(K);
rho = [.7, .2, .1];
for i = 1:K
    R(i, :) = [0, circshift(rho,i-1)];
end
R = (eye(K) + triu(R)) + triu(R)';
iR = inv(R);
beta = [.5, .5,1, 1]';

b0 = zeros(length(beta),1);
B0 = eye(length(b0))*10;
wishartDf = N;
wishartPrior = eye(K)*10;
D0 = ones(K,1);
R0 = eye(K);
timetrend = (1:K)';
timetrendsqd = timetrend.^2;
bi = round(unifrnd(0,1,N*K,1));
xi = normrnd(0,1,K*N, 1);
for i = 1:N
    select = timetrend + (i-1)*K;
    binary = bi(select);
    cont = xi(select);
    X(select, :) = [ones(K,1), timetrend, cont, binary ];
end

E=mvnrnd(zeros(K,1),R,N)';

vecz = X*beta + E(:);
vecy = double(vecz>0);
y = reshape(vecy, K,N);
z = reshape(vecz, K,N);
mu = reshape(X*beta, K,N);
Reps = 50;
posttrackingnums = [2,1;2,4; 1,4]; 
bbar = zeros(Reps,length(b0));
r0 = zeros(size(R,1), size(R,1), Reps);
stoB = zeros(Sims, length(beta),Reps);
stoR0 = zeros(K,K,Sims,Reps);
post = zeros(Sims,size(posttrackingnums,1), Reps);
ar = zeros(Reps,1);
loss = zeros(Reps,1);
for i =1:Reps
    i
    [bbar(i,:), r0(:,:, i),ar(i), post(:,:,i)] = mv_probit(y, X, beta, B0, wishartDf, diag(D0), R0,...
    [bbar(i,:), r0(:,:, i),ar(i), post(:,:,i)] = ...
        mv_probit(y, X, beta, B0, wishartDf, diag(D0), R0,...
        Sims, burnin, posttrackingnums);
    r0ir = r0(:,:,i)*iR;
    steinloss(i) = trace(r0ir) - logdet(r0ir) - size(r0,1);
end
fname = createDateString('zhang_')
save(fname)
