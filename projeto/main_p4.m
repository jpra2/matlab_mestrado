clear all;
clc;

%% definir os volumes
global obj;
variables_path = 'dados/variables_p3.mat';
obj = load(variables_path);
obj.internal_areas = obj.internal_areas';
obj.porosity = obj.porosity';
obj.internal_faces = obj.internal_faces';
obj.vol_volumes = obj.vol_volumes';

%% definir viscosidade da agua e do oleo
obj.mi_w = 1.0; % agua
obj.mi_o = 1.5; % oleo

%% definir no e nw
obj.no = 2;
obj.nw = 2;

%% definir k0o e k0w
obj.k0o = 1;
obj.k0w = 1;

%% definir saturacao residual
obj.Swr = 0.2;
obj.Swor = 0.8;

%% definir a matriz de adjacencias
obj.adj_matrix = mount_adj_matrix(length(obj.internal_faces), length(obj.volumes), obj.adjacencies);

%% define k_harm
obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal, obj.h_dist);

%% definir as variaveis do problema: pressao e saturacao

n = length(obj.volumes);
obj.x0_press = zeros(n, 1);
obj.x0_sat = zeros(n, 1);
obj.x0_sat(1:end) = obj.Swr;

%% definir passo de tempo
obj.dt = 0.5;

%% definir tolerancia na saturacao
obj.sat_tol = 1e-5;

%% definir maximo de iteracoes

obj.max_it_sat = 20000;
obj.max_vpi = 0.75;
obj.max_wor_ratio = 3;

%% definir tempo maximo de simulacao
% obj.t_max_simulation = 200000;

%% definir cfl
obj.cfl = 1;

%% definir tolerancia local para a variacao de saturacao
obj.delta_for_local_sat_tolerance = 100;
obj.max_it_for_local_loop_sat = 20;

%% definir prescricao de pressao: ja vem do pre-processamento
global presc;
presc.volumes_pressure_defined = obj.volumes_pressure_defined;
presc.pressure_defined_values = obj.pressure_defined_values;


%% definir prescricao de saturacao: ja vem do pre-processamento
global presc_sat;
presc_sat.volumes_saturation_defined = obj.volumes_saturation_defined;
presc_sat.saturation_defined_values = obj.saturation_defined_values;
presc_sat.saturation_defined_values(:) = obj.Swor;
obj.x0_sat(presc_sat.volumes_saturation_defined) = presc_sat.saturation_defined_values;


%% simulacao

continue_global = true(1,1);
t_simulation = 0;
loop_global = 1;
n_volumes = length(obj.volumes);

global gresp;
gresp.perm = obj.volumes_perm;

gresp.all_pressures(loop_global,:) = obj.x0_press;
gresp.all_saturations(loop_global,:) = obj.x0_sat;
gresp.all_times(loop_global) = t_simulation;
gresp.sat_iterations(loop_global) = 0;
gresp.all_dt(loop_global) = 0;
gresp.all_vpi(loop_global) = 0;
gresp.cumulative_oil_prod(loop_global) = 0;
gresp.all_wor_ratio(loop_global) = 0;
gresp.all_qo_flux(loop_global) = 0;
gresp.qt_volumes(loop_global,:) = zeros(n_volumes, 1);
gresp.qw_volumes(loop_global,:) = zeros(n_volumes, 1);

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
    gresp.all_qo_flux(loop_global) = qo_flux;
    gresp.qw_volumes(loop_global,:) = qw_volumes;
    
%     if t_simulation > obj.t_max_simulation
%         continue_global = 0;
%     elseif loop_global > obj.global_max_it
%         continue_global = 0;
    if gresp.all_vpi(loop_global) > obj.max_vpi
        continue_global = 0;
    elseif wor_ratio > obj.max_wor_ratio
        continue_global = 0;
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
    
    if mod(loop_global, 11) == 0
        save('dados/resp_p4.mat', '-struct', 'gresp');
    end
    
end

save('dados/resp_p4.mat', '-struct', 'gresp');