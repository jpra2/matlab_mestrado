clear all;
clc;

path = 'dados/resp_p1.mat';

resp = load(path);


%% cumulative oil
figure;
plot(resp.all_vpi, -resp.cumulative_oil_prod);
title('Producao acumulada de óleo x VPI')
xlabel('VPI');
ylabel('Oil m^3');

%% Wor
figure;
plot(resp.all_vpi, resp.all_wor_ratio);
title('Razao água óleo x VPI')
xlabel('VPI');
ylabel('wor');


