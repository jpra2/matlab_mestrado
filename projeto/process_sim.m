function process_sim()

global obj;
global gresp; % variavel onde serao armazenados os dados da simulacao

continue_global = true(1,1);
t_simulation = 0;
loop_global = 1;
n_volumes = obj.n;
n_internal_faces = length(obj.internal_faces);
vT = ones(n_internal_faces, 1).*5;
t_max = 20;

times_to_plot = [0, 5, 10, 15, 20, 30];
count_select = 2;
time_selected = times_to_plot(count_select);

gresp.centroids = obj.volumes_centroids(:, 1);
gresp.all_saturations(1,:) = obj.x0_sat; % campo de saturacao de agua
gresp.all_times(1) = t_simulation; % tempos de simulacao
gresp.all_dt(1) = 0; % passos de tempo
insert_data = false(1,1);

while continue_global
    
    sat_ant = obj.x0_sat;
    [obj.dt, obj.upwind] = update_params_sim(vT);
    if obj.dt + t_simulation > time_selected
        obj.dt = time_selected - t_simulation;
    end
    obj.x0_sat = calculate_explicit_sat(vT);
    if abs(obj.dt + t_simulation - time_selected) <= 0.00001
        count_select = count_select + 1;
        time_selected = times_to_plot(count_select);
        insert_data(:) = 1;
    end
    
    loop_global = loop_global + 1;
    t_simulation = t_simulation + obj.dt;
    
    if insert_data
        gresp.all_dt(count_select-1) = obj.dt;
        gresp.all_saturations(count_select-1,:) = obj.x0_sat;
        gresp.all_times(count_select-1) = t_simulation;
        insert_data(:) = 0;
    end
    
    disp('LOOP');
    disp(loop_global);
    disp('T_SIMULATION');
    disp(t_simulation);
    disp('DT');
    disp(obj.dt);
    
    if t_simulation >= t_max
        continue_global = 0;
    end
    
end

end