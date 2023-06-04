clear all;
clc;

% obj: variavel onde estao armazenados os dados da simulacao, informacoes
% sobre a geometria, criterios de parada, criterios de convergencia e as
% variaveis de simulacao - pressao e saturacao da fase agua.

%presc: variavel onde esta armazenada a prescricao de pressao
%presc_sat: variavel onde esta armazenada a prescricao de saturacao de agua
% global obj presc presc_sat;

global gresp; % variavel onde serao armazenados os dados da simulacao

%% carrega os dados do arquivo 'simulation_info.dat', define a matriz de
preprocess(); 

%% processamento da simulacao
process_sim();

%% salvar os dados
save('dados/resp3_sim.mat', '-struct', 'gresp');