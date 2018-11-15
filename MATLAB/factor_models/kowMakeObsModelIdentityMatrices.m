function [obsr, obsc] = kowMakeObsModelIdentityMatrices(Neqns, RegionIndices, SeriesPerCountry, Regions,Countries)

obsr = zeros(Neqns, Regions);
for i = 1:Regions
    obsr(RegionIndices(i,1):RegionIndices(i,2), i) = 1;
end
obsr = sparse(obsr);
obsc = sparse(kron(eye(Countries), ones(SeriesPerCountry,1)));

end
