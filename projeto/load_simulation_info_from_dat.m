function load_simulation_info_from_dat()
% carrega os dados de entrada do arquivo 'simulation_info.json' e os dados
% de geometria da malha, adjacencias, porosidade, campo de permeabilidade e
% condicoes de contorno. Esses dados sao armazenados na variavel global obj

global obj;
global presc; % prescricao de pressao
global presc_sat; % prescricao de saturacao

variables_path = '';
info_path = 'simulation_info.dat';
delimiter = ';';
my_string = 'obj.';

fid = fopen(info_path, 'r');
line = fgetl(fid); % cabecalho
line = fgetl(fid); % primeira linha informa o caminho das variaveis iniciais
line_data = split(line, delimiter);
data_name = line_data{2};
value = line_data{1};

variables_path = value;

obj = load(variables_path);
obj.internal_areas = obj.internal_areas';
obj.porosity = obj.porosity';
obj.internal_faces = obj.internal_faces';
obj.vol_volumes = obj.vol_volumes';
n = length(obj.volumes);
obj.n = n;

line = fgetl(fid); %segunda linha em diante
while line ~= -1
    line_data = split(line, delimiter);
    data_name = line_data{2};
    value = line_data{1};
    eval([my_string data_name '=str2double(value);']);
    
    line = fgetl(fid);
end
fclose(fid);

obj.max_it_for_local_loop_sat = int64(obj.max_it_for_local_loop_sat);
obj.max_it_sat = int64(obj.max_it_sat);
obj.loops_for_save = int64(obj.loops_for_save);

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