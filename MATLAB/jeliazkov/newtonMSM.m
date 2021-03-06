function [ X_0] = newtonMSM(X_0,F, J, epsilon,maxIterations,dispOn)
iterationCount = 0;
while iterationCount < maxIterations
    iterationCount = iterationCount + 1;
    if abs(det(J(X_0))) < 10^(-14) || abs(det(J(X_0))) > 10^14
        fprintf('Matrix singular. Iterations stopped.\n')
        return
    end
    if iterationCount == maxIterations
        fprintf('Maxed out.\n')
        return
    end
    H = -linsolve(J(X_0), F(X_0));
    X_Next = X_0 + H;
    X_0 = X_Next;
    if dispOn == 1
        fprintf('Value of function at iteration %i \n', iterationCount)
        disp(X_0)
%         disp(F(y,x,X_0))
    end
    if norm(F(X_0)) < epsilon
        return
    end
end
end