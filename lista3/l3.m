%% Lista 3 - Joao Paulo Rodrigues de Andrade
clear all;
clc;

E = 200*10^9; % modulo de elasticidade do aco = 200 GPa
raio = 0.05; % raio da secao transversal em m
A = pi*(raio^2);  % area 
L = 8; % comprimento m
rho = 7800; % massa especifica do aco
n_min = 2; % numero minimo de elementos
n_max = 6; % numero maximo de elementos
%
%
contador = 1;
for i=n_min:n_max
    n = i+1; % numero total de nos
    ngl = n-2; % graus de liberdade
    l = L/i; % comprimento do elemento
    K = zeros(ngl); % matriz rigidez global
    M = zeros(ngl); % matriz massa global
    
    k = E*A/l;
    m = rho*A*l/6;

    for j=1:ngl
        
        K(j,j) = 2*k;
        M(j,j) = 2*m;

        if j < ngl 
            K(j,j+1) = -k;
            M(j,j+1) = m;
        end
        if j > 1
            K(j,j-1) = -k;
            M(j,j-1) = m;
        end
    end
    [V, lambda] = eig(K,M);
    lambda = diag(lambda);
    w(contador) = sqrt(min(lambda));
    contador = contador + 1;
end

x = n_min:n_max;
plot(x,w)
title('Frequencia natural x Numero de elementos')
xlabel('Numero de elementos')
ylabel('Frequencia natural')