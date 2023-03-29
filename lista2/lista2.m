clear all
clc

% 1
x = [1/15 3.1477e-6];
double(x);
uint8(x);
uint16(x);
uint32(x);
uint64(x);
int8(x);
int16(x);
int32(x);
int64(x);
num2str(x);

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
