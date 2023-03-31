clear all
clc

m = 10;
N = 100;
intervalo = [1, 20];

% a)
delta = intervalo(2) - intervalo(1);
test = rand(1, m);
areas = intervalo(1) + sort(delta*test);

% b)
tensoes = N./areas;

% c)
% plot(areas, tensoes);

% d) e)
n = 5;
randomic = sort(randperm(m, n));
areas_rand = areas(randomic);
tensoes2 = N./areas_rand;
% plot(areas_rand, tensoes2);

% f)
X = areas;
Y = tensoes;

lenx = length(X)
newl = 3*lenx
min_X = min(X);
max_X = max(X);
delta_X = max_X - min_X;
test = rand(1, newl);
areas_interp = min_X + sort(delta_X*test);
tensoes_interp = interp1(areas,tensoes,areas_interp);
plot(areas_interp, tensoes_interp);
hold on
plot(areas, tensoes)
legend({'grafico1', 'grafico interpolado'});