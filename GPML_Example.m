% Requires latest GPML version
% http://www.gaussianprocess.org/gpml/code/matlab/doc/

clear
clc
close all

%% INPUT DATA

% Data Points
x = (1:10)';
y = sin(x) + 0.1* randn(10,1);

% Sample Points
x_s = (1:0.1:10)';

%plot(x,y,'kx')

%% DEFINE GP

meanfunc = [];
covfunc = @covSEiso; % Squared Exponental covariance function
likfunc = @likGauss; % Gaussian likelihood


% For different options, type 'doc meanFunctions' 'doc covFunctions' 'doc infMethods' 
%'doc likFunctions'

% Initial Hyper Parameters (log space)
hyp = struct('mean', [], 'cov', [0 1], 'lik', -1);

%% HOW TO OPTIMISE HYPERPARAMETERS IN GPML

optimised_hyp = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y); % Optimise Hyperparameters

%% HOW TO CALCULATE GP IN GPML

[mu, s2] = gp(optimised_hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, x_s);

%% PLOT GP

plotGP(x_s, mu, s2)
hold on;
plot(x,y,'bx')