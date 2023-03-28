clear all
clc

% 1 - Fundamentos
% 1
A = zeros(3,3);

for i = 1:3
    for j = 1:3
        A(i,j) = i+j;
    end
end


% 2
x = [ -1.2 sqrt(2) (1+2+3)*4/5 ]

% 3
cont = 1;
sinal = 1;
soma = 0;
for i = 1:12
    soma = soma + sinal*(1/cont);
    cont = cont + 1;
    sinal = -1*sinal;
end

% 4
x0 = 1/0;
x1 = 0/0;
x2 = nan/inf;
x3 = inf/inf;
% O codigo executa normalmente e os valores sao: x0 = Inf; x1, x2 e x3 = Nan

% 5
who;
whos;

% who mostra as variaveis utilizadas
% whos mostra as variaveis e seu tamanho, bytes, a classe e os seus
% atributos

% 6
A = ones(3,3);
A2 = A;
B = zeros(5,5);
C = eye(8);

% 7
save('variaveis_pratica1');
clear all
load('variaveis_pratica1');

% 8
x = [ -1.2 sqrt(2) (1+2+3)*4/5 ];
% a variavel x nao aparece no workspace


% 2 - Operacoes com matrizes
% 1
D = A'
E = A + D
F = A - D
G = A * A'

% 2
A = [1,2; 2,2];
B = [1;2]
X = A\B

C = 2*A
C(1,1) = 1
D = B + 1
Y = C\D

% 3
p = 2
A2^p

% 3 Operacoes com array
% 1
x = [1 10 -5]
y = [-10 -1 2]
z = dot(x,y)

% 2
x./y % x/y valor a valor
x.\y % y/x valor a valor

