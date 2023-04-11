clear all
clc

%% Funcoes de Matrizes
%1 
n = 10;
A = zeros(n);
for i = 2:n-1
   A(i, i) = 2;
   A(i, i-1) = -1;
   A(i, i+1) = -1;
end

A(1,1) = 1;
A(n,n) = 1;

b = zeros(n, 1);
b(1) = 1;

x = A\b;

[L, U, P] = lu(A);

y = L\(P*b);
x2 = U\y;

%2
[Q,R] = qr(A);

x3 = R\(Q\b);

%3
[V, D] = eig(A);

%4
cond(A); % retorna o numero de condicionamento da matriz
norm(A); % retorna a norma l2 da matriz
rank(A); % retorna o rank da matriz
rcond(A); % retorna uma estimativa para a condição recíproca de A em norma l1. Se A está bem condicionada, rcond(A) está próximo de 1. Se A estiver mal condicionada, rcond(A) está próximo de 0.

%% Controle de fluxo
%1
for i=1:n, x(i)=0;, end 
% zerando os elementos de x

for i=1:n
  for j=1:n
    A(i,j) = 1/(i+j-1);
  end
end
% o elemento (i,j) = 1/(i+j-1)

%2
n = 1;
while prod(1:n) < 1.e100, n=n+1; end
n;
% programa para incrementar o valor de n em 1 ate que o produto dos
% elementos do vetor 1:n seja menor que 1.e100

%% - M-files, scripts e Funções
%3
% what('fibno');
% type('fibno');

%4
echo on
n = 1;
while prod(1:n) < 1.e100, n=n+1; end
n;
echo off

%5
in = input('Defina um numero');
disp(in)
disp('pressine qualquer tecla')
pause