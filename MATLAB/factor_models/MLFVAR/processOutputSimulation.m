% clear;clc;
% simpath = 'TimeBreakSimulations/';
% files = dir(join([simpath,'*.mat']));
% x =natsortfiles({files.name});
%
% c = str2double(cell2mat(regexp(x{1}, '[0-9]','match')));
% N = floor(length(x)/2);
% beg = 1:N;
% G = length(beg);
% for g = 1:N
%     set1 = x{G+ g};
%     datapath = join([simpath,set1]);
%     ml1 = load(datapath, 'ml');
%     set2 = x{g};
%     datapath = join([simpath,set2]);
%     ml2 = load(datapath, 'ml');
%     sumMls(g,2) = ml1.ml + ml2.ml;
%     sumMls(g,1) = c;
%     c = c + 1;
% end
% hold on
% plot(sumMls(:,1), sumMls(:,2))
% plot(1:200, -1895.*ones(1,200), 'black')
% GreaterMls = sumMls(sumMls(:,2) > -1895, 1);

% clear;
% simpath = 'TimeBreakSimulations/';
% load(join([simpath, 'Result_totaltime.mat']))
% truefactor = DataCell{4};
% gamma = DataCell{6};
% G1 = DataCell{7};
% G2 = DataCell{8};
% residual = reshape(yt(:) - Xt*[.4;.4;.4], K, T);
% vector = [zeros(1,100), ones(1,100)];
% truefactor = vector.*truefactor;
% figure('Name', 'Using all timeperiods')
% hold on
% plot(truefactor, 'black')
% plot(sumFt(1,:), 'red')

% clear;
% simpath = 'TimeBreakSimulations/';
% load(join([simpath, 'Result_TimeBreakEnd100.mat']))
% truefactor = DataCell{4};
% gamma = DataCell{6};
% G1 = DataCell{7};
% G2 = DataCell{8};
% vector = [zeros(1,100), ones(1,100)];
% truefactor = vector.*truefactor;
% figure('Name', 'Split at t=100')
% hold on
% plot(truefactor, 'black')
% plot(sumFt(1,:), 'red')
% load(join([simpath, 'Result_TimeBreakBeg101.mat']))
% plot(101:200, sumFt(1,:), 'red')


% simpath = 'TimeBreakSimulations/';
% load(join([simpath, 'Result_totaltime.mat']))
% oneperiod = sumOM;
% oneperiodbeta = sumBeta;
% oneperiodst = sumST;
% load(join([simpath, 'Result_TimeBreakEnd100.mat']))
% firstperiod = sumOM;
% firstperiodbeta = sumBeta;
% firstperiodst = sumST;
% load(join([simpath, 'Result_TimeBreakBeg101.mat']))
% secondperiod= sumOM;
% secondperiodbeta = sumBeta;
% secondperiodst = sumST;
% trueG = DataCell{8};
% trueB = [.4;.4;4];
% trueST = 0.43;
% st = [oneperiodst, firstperiodst, secondperiodst, trueST];
% G = [oneperiod, firstperiod, secondperiod, trueG];
% Beta = [oneperiodbeta, firstperiodbeta, secondperiodbeta, trueB]
% matrix2latexmatrix(G, 'test.tex')
% matrix2latexmatrix(Beta, 'betamatrix.tex')
% matrix2latexmatrix(st,'st.tex')


% clear;clc;
% simpath = 'TBKOW/';
% files = dir(join([simpath,'*.mat']));
% x =natsortfiles({files.name});
%
% c = str2double(cell2mat(regexp(x{1}, '[0-9]','match')));
% N = floor(length(x)/2);
% beg = 1:N;
%
% c = str2double(cell2mat(regexp(x{1}, '[0-9]','match')));
% N = floor(length(x)/2);
% beg = 1:N;
% G = length(beg);
%
% for g = 1:N
%     set1 = x{G+ g};
%     datapath = join([simpath,set1]);
%     ml1 = load(datapath, 'ml');
%     set2 = x{g};
%     datapath = join([simpath,set2]);
%     ml2 = load(datapath, 'ml');
%     sumMls(g,2) = ml1.ml + ml2.ml;
%     sumMls(g,1) = c;
%     c = c + 1;
% end

clear;clc;
savepath = '~/GoogleDrive/statespace/'
load('TBKOW/Result_kowTimes100.mat')
xaxis = 1962:2014;
variance = sumFt2 - sumFt.^2;
sig = sqrt(variance);
upper = sumFt + 1.5.*sig;
lower = sumFt - 1.5.*sig;
LW = .75;
COLOR = [1,0,0];
facealpha = .3;
fillX = [xaxis, fliplr(xaxis)];
fillY = [upper, fliplr(lower)];
h = fill(fillX(1,:), fillY(1,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
world = plot(xaxis, sumFt(1,:), 'black')
saveas(world, join([savepath, 'world.jpeg']))

vdc = sumVarianceDecomp2 - sumVarianceDecomp.^2;
sdvardecomp = sqrt(vdc);
sdvd = 1.5.*sdvardecomp;
sdvdup = sumVarianceDecomp + sdvd;
sdvdlow = sumVarianceDecomp-sdvd;


% worldvd = round([sdvdlow(:,1), sumVarianceDecomp(:,1), sdvdup(:,1)], 4) 
% matrix2latexmatrix( worldvd, join( [savepath, 'worldvd.tex'] ) )
% 
% regionvd = round([sdvdlow(:,2) ,sumVarianceDecomp(:,2), sdvdup(:,2)], 4)
% matrix2latexmatrix(regionvd, join( [savepath, 'regionvd.tex'] ) )
%
% countryvd = round( [sdvdlow(:,3), sumVarianceDecomp(:,3), sdvdup(:,3)], 4)
% matrix2latexmatrix(countryvd, join( [savepath, 'countryvd.tex'] ) )

%% Europe
% figure
% europe = plot(xaxis, sumFt(5,:), 'black')
% shade([1974, 1980, 1992, 2008, 2011], [1975, 1982, 1993, 2009, 2013], 'black')
% saveas(europe, join([savepath, 'europefactor.jpeg']))
% hold off
% figure
% h = fill(fillX(1,:), fillY(5,:), COLOR);
% set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
% hold on 
% europeregion  = plot(xaxis, sumFt(5,:), 'black')
% saveas(europeregion, join([savepath, 'europeregionplot.jpeg']))

%% North America
% figure
% na = plot(xaxis, sumFt(2,:), 'black')
% shade([1970, 1973, 1980, 1982, 1990, 2001, 2008], [1971, 1975, 1981, 1983, 1991, 2002, 2009], 'black')
% saveas(na, join([savepath,'nafactorplot_recessions.jpeg']))
% hold off
% figure
% h = fill(fillX(1,:), fillY(2,:), COLOR);
% set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
% hold on 
% naregion  = plot(xaxis, sumFt(2,:), 'black')
% saveas(naregion, join([savepath, 'naregionplot.jpeg']))

%% Asia Developed
figure
h = fill(fillX(1,:), fillY(8,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
asia  = plot(xaxis, sumFt(8,:), 'black')
saveas(asia, join([savepath, 'asia.jpeg']))
%% Asia Developing
figure
h = fill(fillX(1,:), fillY(7,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
asiadev  = plot(xaxis, sumFt(7,:), 'black')
saveas(asiadev, join([savepath, 'asiadev.jpeg']))
%% Latin America
figure
h = fill(fillX(1,:), fillY(4,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
latinAmerica  = plot(xaxis, sumFt(4,:), 'black')
 saveas(latinAmerica, join([savepath, 'latinAmerica.jpeg']))
%% Africa
figure
h = fill(fillX(1,:), fillY(6,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
africa  = plot(xaxis, sumFt(6,:), 'black')
 saveas(africa, join([savepath, 'africa.jpeg']))
%% Oceania
figure
h = fill(fillX(1,:), fillY(3,:), COLOR);
set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
hold on 
oceania  = plot(xaxis, sumFt(3,:), 'black')
 saveas(oceania, join([savepath, 'oceania.jpeg']))
%% United States
% figure
% usa = plot(xaxis, sumFt(9,:), 'black')
% shade([1970, 1973, 1980, 1982, 1990, 2001, 2008], [1971, 1975, 1981, 1983, 1991, 2002, 2009], 'black')
% hold off
% figure
% h = fill(fillX(1,:), fillY(9,:), COLOR);
% set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
% hold on 
% usa  = plot(xaxis, sumFt(9,:), 'black')
% saveas(na, join([savepath,'usafactor.jpeg']))
%% Germany
% figure
% germ = plot(xaxis, sumFt(32,:), 'black')
% figure
% h = fill(fillX(1,:), fillY(32,:), COLOR);
% set(h, 'FaceAlpha', facealpha, 'LineStyle', 'none')
% hold on 
% germany  = plot(xaxis, sumFt(32,:), 'black')
% shade([1970, 1973, 1980, 1985, 1991, 2001, 2008, 2011], [1972, 1975, 1982, 1987, 1993,2005, 2009, 2013], 'black')
