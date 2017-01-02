function [ irf_mat ] = IRFlevel_var( periods, X, lags, shock, str, xlabels )
[coef] = var(X,lags);
f1 = fcastlevel_perturbed(periods, shock, X, lags);
f2 = fcastlevel(periods, X, lags);
irf_mat = f1-f2;
[r,c] = size(irf_mat);
figure

for i = 1:c
    y_dat = irf_mat(:, i);
    if i == 1
        subplot(3,1,i)
        plot(y_dat)
        xlabel(xlabels(i))
        ylabel('Response')
        title(str)
    else
        subplot(3,1,i)
        plot(y_dat)
        ylabel('Response')
        xlabel(xlabels(i))
    end
    
end

end

