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
F = 2*N;

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
hold on;
plot(ones(n_points,1)*cent_global(2), linspace(sigma_min, sigma_max, n_points), ':r', 'LineWidth',1.5);

hold on;
y = cent_global(2)
y_def = cent_global(2) - y;
sigma_centroide = (M_x*y_def)/momento_global;
plot(y2, ones(n_points, 1)*sigma_centroide, '--k', 'LineWidth',1.5)


xlabel('Altura');
ylabel('Tensao');
title('Tensao x Altura');
legend({'Tensao x Altura','Posicao do centroide','Tensao no centroide'});
xlim([y_min, y_max]);
ylim([sigma_min, sigma_max]);