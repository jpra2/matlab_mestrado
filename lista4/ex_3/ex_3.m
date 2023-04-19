clear all;
clc;

j = 5;

for p = 1:4
    soma = 0;
    for i = 1:(p+1)
        soma = soma + j^(2*i);
    end
    fprintf('p = %d: %f\n', p, soma);
end