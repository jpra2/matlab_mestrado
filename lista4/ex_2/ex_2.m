clear all;
clc;

a = 0;
b = 2.5*pi;

x = a:0.01:b;

raizes = [0, fzero('fun', 3), fzero('fun', 6)];

plot(x, fun(x));
hold on;
plot(raizes, fun(raizes), 'o');

global tolerance maxits

tolerance  = 1e-4;
maxits     = 30;

xlower     = 2;
xupper      = 4;
% chama funcao para calculo da raiz
[root1,iflag1] = bisect('fun',xlower,xupper);

xlower = 5.5;
xupper = 6.5;

[root2, iflag2] = bisect('fun',xlower,xupper);

raizes2 = [root1, root2];
hold on;
plot(raizes2, fun(raizes2), '*')
legend('funcao', 'fzero', 'bisect')



