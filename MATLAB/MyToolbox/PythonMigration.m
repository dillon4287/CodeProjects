clear;clc;


ydata = import_python_data("/home/dillon/CodeProjects/Python/MultilevelModel/y_data.csv", [2, Inf]);
xdata = import_python_data("/home/dillon/CodeProjects/Python/MultilevelModel/x_data.csv", [2, Inf]);
fdata = import_python_data("/home/dillon/CodeProjects/Python/MultilevelModel/f_data.csv", [2, Inf]);
xdata = xdata(:,1:3);

[K,T]= size(ydata);
InfoCell = {[1,K], [1,6; 7,9]};
Id = MakeObsModelIdentity(InfoCell);
nFactors = sum(cellfun(@(x)size(x,2),Id));
A = makeStateObsModel(ones(K,nFactors), Id, 0);

gammas = repmat([.2,.2], 3,1);
P0 = initCovar(gammas, ones(1,nFactors));
factorPrecision = ones(nFactors,1);
FP = FactorPrecision(gammas, P0, factorPrecision, T);

surX = surForm(xdata, K);
KP = size(surX,2);
b0 = zeros(KP,1);
B0inv = (1./100).*eye(KP);
% betaDraw(ydata(:), surForm(xdata,K), ones(K,1), A, FP, b0', B0inv, T) 

A = ones(9,3);
A(7:end,2) = 0;
A(1:6,3) = 0;
Xbeta= reshape(surX*ones(KP,1), K,T);
resids = ydata - Xbeta - A*fdata;
fdata

sum(resids.*resids,2)
