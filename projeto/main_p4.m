clear all;
clc;

% obj: variavel onde estao armazenados os dados da simulacao, informacoes
% sobre a geometria, criterios de parada, criterios de convergencia e as
% variaveis de simulacao - pressao e saturacao da fase agua.

%presc: variavel onde esta armazenada a prescricao de pressao
%presc_sat: variavel onde esta armazenada a prescricao de saturacao de agua
global obj presc presc_sat;

global gresp; % variavel onde serao armazenados os dados da simulacao

%% carrega os dados do arquivo 'simulation_info.json', define a matriz de
% adjacencias, calcula a media harmonica da permeabilidade nas faces e
% carrega as informacoes de geometria da malha, adjacencias, campo de
% permeabilidade, campo de porosidade e condicoes de contorno
preprocess(); 

%% processamento da simulacao
process();

% dados que serao salvos no arquivo resp.mat: campo de pressao, campo de
% saturacao, tempos de simulacao, quantidade de iteracoes no calculo
% implicito da saturacao, passos de tempo, vpi, producao acumulada de oleo
% e razao agua oleo de producao
save('dados/resp.mat', '-struct', 'gresp');