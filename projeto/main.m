clear all
clc

%% definir os volumes
n = 10;
obj.volumes = 1:n;

%% definir centroide dos volumes
obj.volumes_centroids = define_volumes_centroids(n, 1);

%% definir permeabilidade dos volumes
obj.volumes_perm = define_volumes_perm(n);

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

%% definir as faces internas e as adjacencias

[obj.internal_faces, obj.adjacencies, obj.adj_matrix] = define_internal_faces(n);

%% definir area das faces internas

obj.internal_areas = define_internal_areas(obj.internal_faces);

%% definir vetor unitario das faces internas
obj.unitary_vector_internal = define_unitary_vector_internal_faces(obj.internal_faces);

%% definir direcao upwind inicial

obj.upwind = initial_upwind(obj.adjacencies);

%% define k_harm

obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal);

%% define porosity
obj.porosity = 0.2*ones(n, 1);

%% definir as variaveis do problema: pressao e saturacao estao no mesmo vetor
% ou seja: com  n volumes tem se vetor x 1:n pressao e n:2n saturacao

x0_press = zeros(n, 1);
x0_sat = zeros(n, 1);
x0_sat(1:end) = obj.Swr;

%% definir prescricao de pressao
presc.volumes_pressure_defined = [1, n];
presc.pressure_defined_values = [1, 0];

%% definir prescricao de saturacao

presc_sat.volumes_saturation_defined = [1];
presc_sat.saturation_defined_values = [1];

%% definir passo de tempo
obj.dt = 1;

%% definir tolerancia na pressao e saturacao
p_tol = 0.0000001;
sat_tol = 0.00001;

%% definir maximo de iteracoes
max_it = 1000;

%% definir tempo maximo de simulacao
t_max_simulation = 100;

local_p_tol = 100;
loop_p = 0;

continue_global = true(1,1);
continue_pressure = true(1,1);
continue_sat = true(1,1);

x_press = myAD(x0_press);
while continue_pressure
    residuo = myAD(zeros(n, 1));
    result = define_residuo(x_press, obj, residuo, presc, x0_sat);
    J = getderivs(result);
    resp = -getvalue(result);
    dx = J\resp;
    x_press = x_press + dx;
    local_p_tol = norm(dx);
    
    if local_p_tol <= p_tol 
        continue_pressure = 0;
    elseif loop_p > max_it
        disp('Divergiu no calculo da pressao');
    end
    
    loop_p = loop_p + 1;
    
    
end

x0_press(:) = getvalue(x_press);
loop_sat = 0;
local_sat_tol = 100;
x_sat = myAD(x0_sat);

while continue_sat
    residuo = myAD(zeros(n, 1));
    result = define_residuo_sat(x_sat, residuo, obj, presc_sat, x0_sat, x0_press);
    J = getderivs(result);
    resp = -getvalue(result);
    ds = J\resp;
    x_sat = x_sat + ds;
    local_sat_tol = norm(ds);
    
    if local_sat_tol <= sat_tol
        continue_sat = 0;    
    elseif loop_sat > max_it
        continue_sat = 0;
        disp('Divergiu no calculo da saturacao');
    end
    loop_sat = loop_sat + 1;
    
end

x0_sat(:) = getvalue(x_sat);









