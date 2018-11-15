function [draw, G] = kowUpdateLatent(vecresids, ObsModel, StatePrecision, ObsModelPrecision, T)

[Nobseqns, Nstates] = size(ObsModel);
speyet = speye(T);
G = kron(speyet, ObsModel);
GtP = ObsModel'*spdiags(ObsModelPrecision,0, Nobseqns,Nobseqns);
KroneckerVariance = kron(speye(T),GtP*ObsModel);
x = kron(speyet,GtP) *vecresids;

P= StatePrecision + KroneckerVariance;
[mu, diagP, offdiagP] = solveSystem(P, x);
draw  = mvnrndPrecision(diagP, offdiagP) + mu;
end
