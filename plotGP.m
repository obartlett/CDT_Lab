function plotGP(x, mu, s2)
% Plots Gaussian Process, where
% x is x-axis sample points
% mu is calculated mean
% s2 is calculated variance

yupper = mu + sqrt(s2);
ylower = mu - sqrt(s2);

hold on
set(fill([x; flipud(x)],[yupper; flipud(ylower)],[0.9 0.9 0.9]),'EdgeColor',[0.9 0.9 0.9])
alpha(0.7)
plot(x,mu,'k-')
hold off




end