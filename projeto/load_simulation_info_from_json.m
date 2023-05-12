function load_simulation_info_from_json()
% carrega os dados de entrada do arquivo 'simulation_info.json' e os dados
% de geometria da malha, adjacencias, porosidade, campo de permeabilidade e
% condicoes de contorno. Esses dados sao armazenados na variavel global obj

global obj;
global presc; % prescricao de pressao
global presc_sat; % prescricao de saturacao

fname = 'simulation_info.json'; 
fid = fopen(fname);
raw = fread(fid,inf); 
str_data = char(raw');
fclose(fid); 
val = jsondecode(str_data);

variables_path = val.variables_path.value;
obj = load(variables_path);
obj.internal_areas = obj.internal_areas';
obj.porosity = obj.porosity';
obj.internal_faces = obj.internal_faces';
obj.vol_volumes = obj.vol_volumes';

obj.mi_w = val.mi_w.value;
obj.mi_o = val.mi_o.value;
obj.no = val.no.value;
obj.nw = val.nw.value;
obj.k0o = val.k0o.value;
obj.k0w = val.k0w.value;
obj.Swr = val.Swr.value;
obj.Swor = val.Swor.value;
obj.sat_tol = val.sat_tol.value;
obj.max_it_sat = val.max_it_sat.value;
obj.max_vpi = val.max_vpi.value;
obj.max_wor_ratio = val.max_wor_ratio.value;
obj.cfl = val.cfl.value;
obj.delta_for_local_sat_tolerance = val.delta_for_local_sat_tolerance.value;
obj.max_it_for_local_loop_sat = val.max_it_for_local_loop_sat.value;

n = length(obj.volumes);
obj.n = n;

% definir as variaveis do problema: pressao e saturacao
obj.x0_press = zeros(n, 1);
obj.x0_sat = zeros(n, 1);
obj.x0_sat(1:end) = obj.Swr;

% prescricao da pressao
presc.volumes_pressure_defined = obj.volumes_pressure_defined;
presc.pressure_defined_values = obj.pressure_defined_values;

%prescricao da saturacao
presc_sat.volumes_saturation_defined = obj.volumes_saturation_defined;
presc_sat.saturation_defined_values = obj.saturation_defined_values;
presc_sat.saturation_defined_values(:) = obj.Swor;
obj.x0_sat(presc_sat.volumes_saturation_defined) = presc_sat.saturation_defined_values;



end