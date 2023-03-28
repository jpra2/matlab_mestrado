clear all
clc

% viga T

% o eixo x de referencia esta na base inferior do retangulo de altura maior que a
% base (retangulo 2) e o eixo y de referencia esta na altura da esquerda do
% retangulo de base maior que a altura (retangulo 1)

% os centroides dos retangulos sao colineares

% as forcas N e o momento fletor sao aplicados na extremidade livre da viga
% que esta engastada em z = 0

% parametros do retangulo superior (retangulo 1)
% a base deve ser maior que a altura
% b1 = base , h1 = altura

b1 = 250;
h1 = 20;


% parametros do retangulo inferior (retangulo 2)
% a altura deve ser maior que a base
% b2 = base , h2 = altura

b2 = 20;
h2 = 250;

% parametros da forca aplicada (N), momento fletor (M) e comprimento (L)

N = 10;
M = 100;
L = 10;

% calculo dos centroides dos retangulos
%retangulo 1 

cent_1 = [b1/2, h2+h1/2];
cent_2 = [b1/2, h2/2];

% calculo das areas
area_1 = b1*h1;
area_2 = b2*h2;

%calculo dos momentos de inercia em relacao aos centroides dos retangulos
momento_1 = momento_inercia(b1, h1);
momento_2 = momento_inercia(b2, h2);

% calculo do centroide global
cent_global = (area_1*cent_1 + area_2*cent_2)/(area_1 + area_2);

% calculo do momento de inercia global
dist_1 = norm(cent_global - cent_1);
dist_2 = norm(cent_global - cent_2);
momento_global = momento_1 + area_1*(dist_1^2) + momento_2 + area_2*(dist_2^2);







function y = momento_inercia(b, h)
    y = (b*(h^3))/12;
end
