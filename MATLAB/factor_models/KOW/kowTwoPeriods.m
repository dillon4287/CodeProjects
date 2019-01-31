clear;clc;
load('kow.mat');
rng(1);
K = size(kowy,1);
r0 = 10.*ones(K,1);
v0 = 5;
b0 = 1;
B0 = 1;
kowp1y = kowy(:,1:46);
kowp1x = kowx(1:46*180,:);
kowp2y = kowy(:, 47:end);
kowp2x = kowx((46*180)+1:end,:);
CountriesThatStartRegions = [1,4,6,24,42,49,55, -1];
RegionIndices = [1,9;10,15;16,69;70,123;124,144;145,162;163,180];
Countries=60;
Regions = 7;
SeriesPerCountry=3;
nFactors = Countries + Regions + 1;
save('kow2p.mat')
