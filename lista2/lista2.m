clear all
clc

% 1

x = [1/15 3.1477e-6];
format short;
x
format short e;
x

format long;
x

format hex;
x

format +;
x

format short e;

% 2
A = magic(3);
B = rand(3);
% o comando magic cria uma matriz de inteiros predeterminada

C = A <= B;
C = A ~= B;

%3
A < 5;
% a comparacao eh feita valor a valor

all(A<5);
% verifica se todos os valores sao menores que 5 coluna a coluna

any(A < 5);
% verifica se existe algum valor menor que 5 coluna a coluna

% 4
% verificar manual matlab
