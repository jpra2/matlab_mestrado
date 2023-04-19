%% lista 4 - ex 6
clear all;
clc;

a = 1;  % Limite inferior de integração
b = 15;  % Limite superior de integração
ns = [11, 31, 51]; % numero de pontos de integracao
functions = {@(x) (log(x)./x), @(x) (log(x).^2), @(x) (x./(sqrt(1 + x.^2)))}; % funcoes para serem integradas
analytic = {@(x) (1/2*(log(x)^2)), @(x) (x*(log(x)^2) -2*x*log(x) + 2*x), @(x) (sqrt(1+x^2))}; %solucao analitica da integracao

n_functions = length(functions);

for i = 1:n_functions
    y = functions{i};
    matlab_resp = integral(y,a,b); % solucao nativa do matlab
    a_function = analytic{i}; 
    exact_resp = a_function(b) - a_function(a); % solucao exata
    erro_matlab = exact_resp - matlab_resp;
    for n = ns
        [h, Y] = Parametros(a, b, n, y);
        Trap = Trapezios(n, h, Y);       % metodo dos trapezios
        Simp = Simpson(n, h, Y);         % metodo de simpson
        erro_trap = exact_resp - Trap;
        erro_simp = exact_resp - Simp;

        fprintf('Resultados para n=%d:\nTrapézios: %f\nSimpson: %f\nMatlab: %f\nSolucao exata: %f\n', n, Trap, Simp, matlab_resp, exact_resp)
        fprintf('\n')
    end
    fprintf('\n')
    fprintf('\n')
end

%parametros das funcoes de integracao:
function [h, Y] = Parametros(a, b, n, y)
h = (b-a)/(n-1); % distancia entre os pontos
x = a:h:b;       % variavel independente
Y = zeros(n,1);  % valores da funcao

for i=1:n
    Y(i) = y(x(i));
end
end

% metodo dos trapezios:
function [resp] = Trapezios(n, h, y)
resp = h*(y(1)+y(n))/2;

for i=2:(n-1)
    resp = resp + h*y(i);
end
end

%metodo de simpson:
function [resp] = Simpson(n, h, y)
resp = h*(y(1)+y(n))/3;            

for i=2:(n-1)
    if mod(i, 2) == 0
        resp = resp + 4*h*y(i)/3;
    else
        resp = resp + 2*h*y(i)/3;
    end
end
end