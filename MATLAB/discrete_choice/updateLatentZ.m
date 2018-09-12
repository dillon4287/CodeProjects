function [z, na] = updateLatentZ(y,mu,Sigma)
[r, c] = size(mu);
z = zeros(r,c);
A = zeros(r,c);
B = zeros(r,c);
for j = 1:c
    for i = 1:r
        if y(i,j) > 0
            A(i,j) = 0;
            B(i,j) = inf;
        else
            A(i,j) = -inf;
            B(i,j) = 0;
        end
    end
    [z(:,j), na] = ghkmvnrnd(A(:,j), B(:,j), mu(:,j), Sigma, 1);
    if na == 1
        fprintf('in latent z \n')
        [A(:,j), B(:,j), mu(:,j)]
        Sigma
        break
    end
end
end



