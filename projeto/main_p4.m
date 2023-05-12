clear all;
clc;


global obj presc presc_sat;
global gresp; % variavel onde serao armazenados os dados da simulacao
preprocess();
process();
save('dados/resp.mat', '-struct', 'gresp');