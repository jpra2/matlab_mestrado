clear all
clc
variables_path = 'dados/variables_p1.mat';

global obj;
obj = load(variables_path);

%% definir os volumes
n = length(obj.volumes);

%% definir viscosidade da agua e do oleo
obj.mi_w = 1.0; % agua
obj.mi_o = 1.5; % oleo

%% definir no e nw Corey equation
obj.no = 2;
obj.nw = 2;

%% definir k0o e k0w Corey equation
obj.k0o = 1;
obj.k0w = 1;

%% definir saturacao residual Corey equation
obj.Swr = 0.2;
obj.Swor = 0.8;

%% definir as adjacencias

obj.adj_matrix = mount_adj_matrix(length(obj.internal_faces), length(obj.volumes), obj.adjacencies);

%% define k_harm
obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal, obj.h_dist);

%% definir as variaveis do problema: pressao e saturacao estao no mesmo vetor
% ou seja: com  n volumes tem se vetor x 1:n pressao e n:2n saturacao

obj.x0_press = zeros(n, 1);
obj.x0_sat = zeros(n, 1);
obj.x0_sat(1:end) = obj.Swr;

%% definir passo de tempo
obj.dt = 0.3;

%% definir tolerancia na pressao e saturacao
obj.p_tol = 1e-13;
obj.sat_tol = 1e-7;

%% definir maximo de iteracoes
obj.max_it_pressure = 1000;
obj.max_it_sat = 1000;
obj.global_max_it = 1000;

%% definir tempo maximo de simulacao
obj.t_max_simulation = 100;

%% definir prescricao de pressao
global presc;
presc.volumes_pressure_defined = obj.volumes_pressure_defined;
presc.pressure_defined_values = obj.pressure_defined_values;

%% definir prescricao de saturacao
global presc_sat;
presc_sat.volumes_saturation_defined = obj.volumes_saturation_defined;
presc_sat.saturation_defined_values = obj.saturation_defined_values;

%% simulacao

continue_global = true(1,1);
t_simulation = 0;
loop_global = 1;

resp.all_pressures(loop_global,:) = obj.x0_press;
resp.all_saturations(loop_global,:) = obj.x0_sat;
resp.all_times(loop_global) = t_simulation;
resp.all_loops(loop_global) = loop_global;
resp.pressure_iterations(loop_global) = 0;
resp.sat_iterations(loop_global) = 0;

while continue_global
    
    [obj.x0_press, pressure_it] = define_pressure_iteration;
    [obj.x0_sat, sat_it] = define_sat_iteration;
    t_simulation = t_simulation + obj.dt;
    
    resp.all_pressures(loop_global,:) = obj.x0_press;
    resp.all_saturations(loop_global,:) = obj.x0_sat;
    resp.all_times(loop_global) = t_simulation;
    resp.all_loops(loop_global) = loop_global;
    resp.pressure_iterations(loop_global) = pressure_it;
    resp.sat_iterations(loop_global) = sat_it;
    
    if t_simulation > obj.t_max_simulation
        continue_global = 0;
    elseif loop_global > obj.global_max_it
        continue_global = 0;
    end
    
    loop_global = loop_global + 1;
    
end

save('resp.mat', '-struct', 'resp');

