function[] = testmatlabcode()
c = 1;
k = 1;
t = 1;
if exist('overwritethis.mat')
    load('overwritethis.mat')
    fprintf('load file')
    c = k
end
for k = c:1000
    k
    t = t + 1;
    pause(1)
    if mod(k, 5) == 0
	fprintf('saved file')
        save('overwritethis')
    end
end
end
