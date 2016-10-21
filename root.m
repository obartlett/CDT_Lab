clear
clc
close all


%data = 'Other';
data = 'Sotonmet';

%% Import Data

if strcmp(data,'Sotonmet')
    [ time_raw, Tideheight_raw, TrueTideHeight_raw, start_time ] = ImportSotonmetData(strcat(pwd,'/sotonmet.txt')); %Imports important data into script
    
    x = time_raw; x(isnan(Tideheight_raw)) = [];%Populates, then removes empty rows from Time vector
    y = Tideheight_raw; y(isnan(Tideheight_raw)) = []; % Similarly for Tide Heights vector
    y_t = TrueTideHeight_raw;
    x_t = time_raw;
    x_s = time_raw; %linspace(time_raw(1), time_raw(end),500)'; %Discretises grid to calculate GP
    
else
    x = sort(randn(20, 1));                 % 20 training inputs
    y = sin(3*x) + 0.1*randn(length(x),1);  % 20 noisy training targets
    y_t = sin(3*x); x_t = x;
    x_s = linspace(-3, 3, 61)';                  % 61 test inputs
    
    start_time = 0;
    
end

%% Plot Raw data
if 1==1
    figure(1)
    title('Raw Data')
    plot(x+start_time,y,'kx')
    hold on;
    plot(x_t+start_time,y_t,'color',[0.5 0.5 0.5])
    datetick('x','keeplimits')
    xlabel('Date')
    ylabel('Tide Height')
    legend('Tide Height Measurements','Ground Truth')
end

%% Define GP and Hyperparameters

meanfunc = @meanConst;                    % empty: don't use a mean function
covfunc = @covSEiso; % Squared Exponental covariance function
likfunc = @likGauss;              % Gaussian likelihood

hyp = struct('mean', 3, 'lik', -1);

hyp.cov = [0 10];              

%c1 = {@covPeriodic}; cov1 = [0 0 0];
%c2 = {@covSEiso}; cov2 = [0 10];
%hyp.cov = [cov1 cov2], 

%covfunc = {'covProd',{c1, c2}};



%% Calculate and Plot Unoptimised GP

[mu, s2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, x_s);

figure(2)
title('Non-Optimal GP')

plotGP(x_s+start_time, mu, s2)
hold on
plot(x_t+start_time,y_t,'bx') %Plot true data
datetick('x','keeplimits')
hold off

disp(strcat('Unoptimised RMS Error: ',num2str(rms(mu-y_t))))

clear mu s2
%% Calculate and Plot Optimised GP

optimised_hyp = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y); % Optimise Hyperparameters

[mu, s2] = gp(optimised_hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, x_s);

figure(3)
title('Optimal GP')
plotGP(x_s+start_time, mu, s2)
hold on
plot(x_t+start_time,y_t,'bx') % Plot true data
datetick('x','keeplimits')
hold off
disp(strcat('Optimised RMS Error: ',num2str(rms(mu-y_t))))
%% RMSE

%a = rms(mu-y_t);
