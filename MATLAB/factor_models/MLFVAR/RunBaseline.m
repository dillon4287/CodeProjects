function [] = RunBaseline(Sims, burnin, calcML, autoregressiveErrors, lagOM,...
    lagFac, DataPath,DotMatFile, Job_Name_In_Queue, OutputDirFullPath)
if ischar(Sims)
    Sims = str2num(Sims);
end
if ischar(burnin)
    burnin = str2num(burnin);
end
if ischar(calcML)
    calcML = str2num(calcML);
end
if ischar(autoregressiveErrors)
    autoregressiveErrors = str2num(autoregressiveErrors);
end
if ischar(lagOM)
    lagOM = str2num(lagOM);
end
if ischar(lagFac)
    lagFac = str2num(lagFac);
end

fprintf('Current Working Directory\n')
pwd
if (DataPath == "")
    load(DotMatFile)
    disp(DotMatFile)
else
    datalocation = join([DataPath,'/', DotMatFile]);
    disp(DotMatFile)
    load(datalocation, 'DataCell')
end
yt = DataCell{1,1};
yt = yt-mean(yt,2);
Xt = DataCell{1,2};
InfoCell = DataCell{1,3};
[K,T] = size(yt);

[~, dimX] = size(Xt);
levels = size(InfoCell,2);
nFactors =  sum(cellfun(@(x)size(x,1), InfoCell));
b0 = ones(1,dimX + levels);
b0(1) = 0;
b0
B0 =1.*eye(dimX + levels);
B0(1,1) = 10;
B0
v0=6
r0 = 4
s0 = 6
d0 = 4
[m,v]=invGammaMoments(v0/2, r0/2)
g0 = zeros(1,lagFac);
if lagFac == 3
    G0 = diag([.25, .5,1])*eye(lagFac);
else
    G0 = 1;
end

iBeta = [ones(K,dimX), ones(K,levels)];
idelta = zeros(K,lagOM);
igamma=zeros(nFactors, lagFac);
[Identities, ~, ~] = MakeObsModelIdentity(InfoCell);
% iFt = zeros(nFactors,T);
iFt = normrnd(0,1,nFactors,T);

[storeMean, storeLoadings, storeOmArTerms, storeStateArTerms,...
    storeFt, storeObsV, storeFactorVariance, varianceDecomp, ML] =...
    Baseline(InfoCell, yt,Xt, iFt, iBeta, idelta, igamma,...
    b0, B0, v0,r0, s0, d0, g0, G0, Sims, burnin, autoregressiveErrors, calcML);


StateObsModel = makeStateObsModel(mean(storeLoadings,3),Identities,0);

beta=mean(storeMean,3)';
beta = beta(:);
mu1 = surForm(Xt, K)*beta;
Ft = mean(storeFt,3);
mu2=StateObsModel*Ft;
yhat=reshape(mu1,K,T)+mu2;

period = strfind(DotMatFile, '.');
fname = join(['Result_', DotMatFile(1:period-1),]);
if OutputDirFullPath(end) ~= '/'
    OutputDirFullPath = join([OutputDirFullPath, '/']);
end
savedfile = join([OutputDirFullPath, fname,'_', Job_Name_In_Queue, '_', createDateString('')]);
fprintf('Saving file %s \n', savedfile)
save(savedfile)

end
