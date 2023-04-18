%% lista 4 - ex 6
% Dados de Entrada

a = 1;  % Limite inferior de integração
b = 9;  % Limite superior de integração
ns = [3, 9, 15]; % numero de pontos
functions = {@(x)(log(x)./x), @(x) x.^3 - x + 2}; % funcoes para serem integradas
analitic = {@(x) (1/2.*(log(x).^2))}; %solucao analitica



n_functions = length(functions);

for i = 1:n_functions
    y = functions{i};
    for n = ns
        [h, Y] = Parametros(a, b, n, y);
        Trap = Trapezios(n, h, Y);       % Método dos Trapézios
        Simp = Simpson(n, h, Y);         % Método de Simpson
        Matlab = integral(y,a,b);        % Método Nativo do Matlab

        fprintf('Resultados para n=%d:\nTrapézios: %f\nSimpson: %f\nMatlab: %f\n', n, Trap, Simp, Matlab)
        fprintf('\n')
    end
    fprintf('\n\n')
%     fprintf('\n')
end

%Função Parametros:
function [h, Y] = Parametros(a, b, n, y)
h = (b-a)/(n-1);                % Distância entre os pontos
x = a:h:b;                      % Vetor abscissa
Y = zeros(n,1);                 % Armazena os valores da função

for i=1:n
    Y(i) = feval(y, x(i));
end
end

%Função Trapezios:
function [Itrap] = Trapezios(n, h, Y)
Itrap = h*(Y(1)+Y(n))/2;             % Variável que armazena o valor da integral

for i=2:(n-1)
    Itrap = Itrap + h*Y(i);
end
end

%Função Simpson:
function [Isimp] = Simpson(n, h, Y)
Isimp = h*(Y(1)+Y(n))/3;              % Variável que armazena o valor da integral

for i=2:(n-1)
    if mod(i, 2) == 0                  % Testa se i é par
        Isimp = Isimp + 4*h*Y(i)/3;
    else                               % Quando i ímpar
        Isimp = Isimp + 2*h*Y(i)/3;
    end
end
end