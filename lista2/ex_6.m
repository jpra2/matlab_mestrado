clear all
clc

m = 10;
N = 100;
intervalo = [1, 20];

% a)
delta = intervalo(2) - intervalo(1);
test = rand(1, m);
areas = intervalo(1) + delta*test;

% b)
tensoes = N./areas;

% c)
plot(areas, tensoes)


