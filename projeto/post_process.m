clear all;
clc;

path2 = 'dados/resp_p4.mat';
path3 = 'dados/resp_p5.mat';

resp2 = load(path2);
resp3 = load(path3);


% %% cumulative oil
% figure;
% plot(resp.all_vpi, -resp.cumulative_oil_prod);
% title('Producao acumulada de óleo x VPI')
% xlabel('VPI');
% ylabel('Oil m^3');
% 
% %% Wor
% figure;
% plot(resp.all_vpi, resp.all_wor_ratio);
% title('Razao água óleo x VPI')
% xlabel('VPI');
% ylabel('wor');

%% cumulative oil
figure;
plot(resp2.all_vpi, -resp2.cumulative_oil_prod);
hold on;
plot(resp3.all_vpi, -resp3.cumulative_oil_prod);
title('Producao acumulada de óleo x VPI');
xlabel('VPI');
ylabel('Oil m^3');
legend('cfl=1', 'cfl=4');

%% Wor
figure;
plot(resp2.all_vpi, resp2.all_wor_ratio);
hold on;
plot(resp3.all_vpi, resp3.all_wor_ratio);
title('Razao água óleo x VPI');
xlabel('VPI');
ylabel('wor');
legend('cfl=1', 'cfl=4');

%% sat iteration
figure;
plot(resp2.all_vpi(2:end), resp2.sat_iterations(2:end));
hold on;
plot(resp3.all_vpi(2:end), resp3.sat_iterations(2:end));
title('Iteracoes na saturacao x VPI');
xlabel('VPI');
ylabel('Iteracoes');
legend('cfl=1', 'cfl=4');

%% dt
figure;
plot(resp2.all_vpi(2:end), resp2.all_dt(2:end));
hold on;
plot(resp3.all_vpi(2:end), resp3.all_dt(2:end));
title('DT x VPI');
xlabel('VPI');
ylabel('DT');
legend('cfl=1', 'cfl=4');



