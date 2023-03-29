clear all
clc

% viga T

% o eixo x de referencia esta na base inferior do retangulo de altura maior que a
% base (retangulo 2) e o eixo y de referencia esta na altura da esquerda do
% retangulo de base maior que a altura (retangulo 1)

% os centroides dos retangulos sao colineares

% as forcas N e o momento fletor sao aplicados na extremidade livre da viga
% que esta engastada em x = 0

% parametros do retangulo superior (retangulo 1)
% a base deve ser maior que a altura
% b1 = base , h1 = altura

b1 = 0.06;
h1 = 0.02;


% parametros do retangulo inferior (retangulo 2)
% a altura deve ser maior que a base
% b2 = base , h2 = altura

b2 = 0.02;
h2 = 0.06;

% parametros da forca aplicada (N [N]), momento fletor (M [Nm]) e comprimento (L [m])

N = 2000;
M = 150;
L = 6;
F = 2*N; % forca aplicada na extremidade livre (par de forcas)

% posicao x para o calculo da tensao
% x deve ser maior que 0 e menor que L
x = L/2;

% calculo dos centroides dos retangulos
%retangulo 1 

cent_1 = [b1/2, h2+h1/2];
cent_2 = [b1/2, h2/2];

% calculo das areas
area_1 = b1*h1;
area_2 = b2*h2;

%calculo dos momentos de inercia em relacao aos centroides dos retangulos
momento_1 = (b1*(h1^3))/12;
momento_2 = (b2*(h2^3))/12;

% calculo do centroide global
cent_global = (area_1*cent_1 + area_2*cent_2)/(area_1 + area_2);

% calculo do momento de inercia global
dist_1 = norm(cent_global - cent_1);
dist_2 = norm(cent_global - cent_2);
momento_global = momento_1 + area_1*(dist_1^2) + momento_2 + area_2*(dist_2^2);

% Momento resistente (M_x) em funcao da distancia em relacao ao ponto de
% engaste (x)

M_x = -1*(M + F*L -F*x);

% Valores de tracao e compressao
% y deve ser maior que 0 e menor que h1+h2

n_points = 20;
y = linspace(0, h1+h2, n_points);
y2 = y;
y_def = cent_global(2) - y;

% valor da tensao ao longo da secao
sigma = (M_x*y_def)/momento_global;
sigma_min = min(sigma);
sigma_max = max(sigma);
y_min = min(y);
y_max = max(y);


plot(y, sigma);
xlabel('Altura');
ylabel('Tensao');
title('Tensao x Altura');
xlim([y_min, y_max]);
ylim([sigma_min, sigma_max]);