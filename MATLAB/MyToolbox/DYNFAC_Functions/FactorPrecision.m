function [P,H] = FactorPrecision(params, P0, precision, T)
% Factor precision is column
% Factors are assumed Ft = [ Fwt
 %                     Frt
 %                      Fct ]
 % F = Vectorized (F1, F2,...,FT)
[K,columns] = size(params);
lags =columns;
dees = -((0:lags)*K);
newp = [ones(K,1),-params];
H = spdiags(repmat(newp,T,1), dees, T*K, T*K);
full(H)
Sinv = spdiags(repmat(precision, T,1), 0, K*T, K*T);

Sinv(1:K*lags, 1:K*lags) = P0\eye(K*lags);
full(Sinv) 
P = H'*Sinv*H;
end

