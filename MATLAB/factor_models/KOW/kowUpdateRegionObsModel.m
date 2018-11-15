function [updatedobsmod] = kowUpdateRegionObsModel(ydemut,...
    obsEqnPrecision,regionobsmodel, RegionAr, Countries,...
    SeriesPerCountry, options, CountryObsModelPriorPrecision,...
    CountryObsModelPriorlogdet, regionIndices, T, oldHessian)

updatedobsmod = zeros(SeriesPerCountry*T, 1);
t = 1:SeriesPerCountry;
regioncount = 1;
regioncheck = 0;
for c = 1:Countries
    selectC = t + (c-1)*SeriesPerCountry;
    obsslice = regionobsmodel(selectC);
    yslice = ydemut(selectC, :);
    pslice = obsEqnPrecision(selectC, :);
    if c == regionIndices(regioncount) 
        regioncount = regioncount + 1;
        regioncheck = regioncheck + 1;
        [Sregionpre] = kowMakeVariance(RegionAr(regioncheck,:), 1, T);
        loglike = @(rg) -kowLL(rg, yslice(:),...
        Sregionpre, pslice, SeriesPerCountry,T); 
        [themean, ~,~,~,~, Hessian] = fminunc(loglike, obsslice, options);
        [~,p] = chol(Hessian);
        if p ~= 0
            Hessian = oldHessian(:,:,c);
        else
            oldHessian(:,:,c) = Hessian;
        end
        iHessian = Hessian\eye(size(Hessian,1));
        updatedobsmod(selectC) = kowMhRestricted(obsslice,themean,...
            iHessian, Hessian,yslice(:), Sregionpre,pslice,...
            CountryObsModelPriorPrecision, CountryObsModelPriorlogdet,...
             T);

    else
        [Sregionpre] = kowMakeVariance(RegionAr(regioncheck,:), 1, T);
        loglike = @(rg) -kowLL(rg, yslice(:),...
        Sregionpre, pslice, SeriesPerCountry,T); 
        [themean, ~,~,~,~, Hessian] = fminunc(loglike, obsslice, options);
        [~,p] = chol(Hessian);
        if p ~= 0
            Hessian = oldHessian(:,:,c);
        else
            oldHessian(:,:,c) = Hessian;
        end
        iHessian = Hessian\eye(size(Hessian,1));
        updatedobsmod(selectC) = kowMhUR(obsslice,themean,iHessian,...
            yslice(:), Sregionpre,pslice, CountryObsModelPriorPrecision,...
            CountryObsModelPriorlogdet, SeriesPerCountry, T);

    end   
 
end


end
