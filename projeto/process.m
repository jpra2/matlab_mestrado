function process()
% simulacao propriamente dita

global obj presc prescsat;

global gresp; % variavel onde serao armazenados os dados da simulacao

continue_global = true(1,1);
t_simulation = 0;
loop_global = 1;
n_volumes = obj.n;

gresp.perm = obj.volumes_perm; % campo de permeabilidade

gresp.all_pressures(loop_global,:) = obj.x0_press; % campo de pressao
gresp.all_saturations(loop_global,:) = obj.x0_sat; % campo de saturacao de agua
gresp.all_times(loop_global) = t_simulation; % tempos de simulacao
gresp.sat_iterations(loop_global) = 0; % quantidade de iteracoes no calculo implicito da saturacao
gresp.all_dt(loop_global) = 0; % passos de tempo
gresp.all_vpi(loop_global) = 0; % vpi
gresp.cumulative_oil_prod(loop_global) = 0; % producao acumulada de oleo
gresp.all_wor_ratio(loop_global) = 0; % razao agua oleo de producao

while continue_global
    
    sat_ant = obj.x0_sat;
    obj.x0_press = define_pressure();    
    [obj.dt, obj.upwind] = update_params();
    [obj.x0_sat, sat_it] = define_sat_iteration();
    mean_sat = (sat_ant + obj.x0_sat)./2;
    [wor_ratio, vpi, qo_flux, qw_volumes] = update_vpi(sat_ant);
    
    loop_global = loop_global + 1;
    t_simulation = t_simulation + obj.dt;
    
    gresp.all_dt(loop_global) = obj.dt;
    gresp.all_pressures(loop_global-1,:) = obj.x0_press;
    gresp.all_saturations(loop_global,:) = obj.x0_sat;
    gresp.all_times(loop_global) = t_simulation;
    gresp.sat_iterations(loop_global) = sat_it;
    gresp.all_vpi(loop_global) = gresp.all_vpi(loop_global-1) + vpi;
    gresp.cumulative_oil_prod(loop_global) = gresp.cumulative_oil_prod(loop_global-1) + qo_flux*obj.dt;
    gresp.all_wor_ratio(loop_global) = wor_ratio;
    
    if gresp.all_vpi(loop_global) > obj.max_vpi
        continue_global = 0;
        % se atingir o maximo valor do vpi a simulacao acaba
    elseif wor_ratio > obj.max_wor_ratio
        continue_global = 0;
        % se atingir a maxima razao agua oleo a simulacao acaba
    end
    
    disp('LOOP');
    disp(loop_global);
    disp('VPI');
    disp(gresp.all_vpi(loop_global));
    disp('T_SIMULATION');
    disp(t_simulation);
    disp('DT');
    disp(obj.dt);
    disp('DVPI');
    disp(vpi);
    
    if mod(loop_global, obj.loops_for_save) == 0
        save('dados/resp.mat', '-struct', 'gresp');
    end
    
end

end