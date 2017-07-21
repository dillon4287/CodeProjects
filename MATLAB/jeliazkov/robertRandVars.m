function [ x ] = robertRandVars( a, b, N, p )
lambda = (a + sqrt(a^2 + 4)) / 2;
c = 0;
x = zeros(N,p);
while  c < N
    u = unifrnd(0,1,1);
    z = shiftexprnd(a,b, lambda, 1, p);
    if u <= exp( (z - lambda)^2  / 2)
        c = c + 1;
        x(c,:) = z;
    end
end
end
