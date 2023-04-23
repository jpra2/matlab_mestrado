clear all;
clc;

%% definir os volumes
global obj;
variables_path = 'dados/variables_p2.mat';
obj = load(variables_path);
obj.internal_areas = obj.internal_areas';
obj.porosity = obj.porosity';
obj.internal_faces = obj.internal_faces';

% n = 10;
% obj.volumes = 1:n
% obj.vol_volumes = ones(n, 1);

%% definir centroide dos volumes
% obj.volumes_centroids = define_volumes_centroids(n, 1);

%% definir permeabilidade dos volumes
% obj.volumes_perm = define_volumes_perm(n);

%% definir viscosidade da agua e do oleo
% obj.mi_w = 1.0; % agua
% obj.mi_o = 1.5; % oleo
obj.mi_w = 1.0; % agua
obj.mi_o = 1.5; % oleo


%% definir no e nw

% obj.no = 2;
% obj.nw = 2;
obj.no = 2;
obj.nw = 2;

%% definir k0o e k0w

% obj.k0o = 1;
% obj.k0w = 1;
obj.k0o = 1;
obj.k0w = 1;

%% definir saturacao residual
% obj.Swr = 0.2;
% obj.Swor = 0.8;
obj.Swr = 0.2;
obj.Swor = 0.8;

%% definir as faces internas e as adjacencias

% [obj.internal_faces, obj.adjacencies, obj.adj_matrix, obj.h_dist] = define_internal_faces(n);
obj.adj_matrix = mount_adj_matrix(length(obj.internal_faces), length(obj.volumes), obj.adjacencies);
% adjacencies = matrix(n_internal_faces, 2)
% adj_matrix = bool matrix(n_internal_faces, n_volumes)

%% definir area das faces internas
% obj.internal_areas = define_internal_areas(obj.internal_faces);

%% definir vetor unitario das faces internas
% obj.unitary_vector_internal = define_unitary_vector_internal_faces(obj.internal_faces);

%% define porosity
% obj.porosity = 0.2*ones(n, 1);

%% definir direcao upwind inicial
% obj.upwind = initial_upwind(obj.adjacencies);

%% define k_harm
% obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal, obj.h_dist);
obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal, obj.h_dist);

%% definir as variaveis do problema: pressao e saturacao estao no mesmo vetor
% ou seja: com  n volumes tem se vetor x 1:n pressao e n:2n saturacao

% obj.x0_press = zeros(n, 1);
% obj.x0_sat = zeros(n, 1);
% obj.x0_sat(1:end) = obj.Swr;
n = length(obj.volumes);
obj.x0_press = zeros(n, 1);
obj.x0_sat = zeros(n, 1);
obj.x0_sat(1:end) = obj.Swr;

%% definir passo de tempo
% obj.dt = 0.3;
obj.dt = 1;

%% definir tolerancia na pressao e saturacao
% obj.p_tol = 1e-13;
% obj.sat_tol = 1e-7;
obj.p_tol = 1e-13;
obj.sat_tol = 1e-7;


%% definir maximo de iteracoes
% obj.max_it_pressure = 1000;
% obj.max_it_sat = 1000;
% obj.global_max_it = 1000;
obj.max_it_pressure = 10000;
obj.max_it_sat = 10000;
obj.global_max_it = 5;

%% definir tempo maximo de simulacao
% obj.t_max_simulation = 100;
obj.t_max_simulation = 100;

%% definir prescricao de pressao
global presc;
presc.volumes_pressure_defined = [1, n];
presc.pressure_defined_values = [1, 0];


%% definir prescricao de saturacao
global presc_sat;
presc_sat.volumes_saturation_defined = [1];
presc_sat.saturation_defined_values = [1];


%% simulacao

continue_global = true(1,1);
t_simulation = 0;
loop_global = 1;

resp.all_pressures(loop_global,:) = obj.x0_press;
resp.all_saturations(loop_global,:) = obj.x0_sat;
resp.all_times(loop_global) = t_simulation;
resp.pressure_iterations(loop_global) = 0;
resp.sat_iterations(loop_global) = 0;

while continue_global
    
    [obj.x0_press, pressure_it] = define_pressure_iteration;
    [obj.x0_sat, sat_it]  = define_sat_iteration;
    
    loop_global = loop_global + 1;
    t_simulation = t_simulation + obj.dt;
    
    resp.all_pressures(loop_global,:) = obj.x0_press;
    resp.all_saturations(loop_global,:) = obj.x0_sat;
    resp.all_times(loop_global) = t_simulation;
    resp.pressure_iterations(loop_global) = pressure_it;
    resp.sat_iterations(loop_global) = sat_it;
    
    if t_simulation > obj.t_max_simulation
        continue_global = 0;
    elseif loop_global > obj.global_max_it
        continue_global = 0;
    end
    
    disp(loop_global);
    
    
end

save('dados/resp_p1.mat', '-struct', 'resp');

