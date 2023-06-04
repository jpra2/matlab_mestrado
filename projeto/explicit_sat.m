function [new_saturation, recal] = explicit_sat(vT)
% define o residuo da saturacao
% vT = velocidade total

recal = false(1,1);
global presc_sat;
global obj;
n_volumes = length(obj.volumes);
adj_matrix_T = obj.adj_matrix';
upwind_internal_faces = obj.adjacencies(obj.upwind);
sat0 = obj.x0_sat;
x = sat0;

all_dists = sum(obj.h_dist')';
S_faces = x(obj.adjacencies(obj.upwind));
[krw, kro] = define_kr_corey(S_faces, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mob_w = krw./obj.mi_w;
mob_o = kro./obj.mi_o;
mob_t = mob_w + mob_o;
fw_faces = mob_w./mob_t;

qt = obj.internal_areas.*vT;
qw = qt.*fw_faces;

[krw_volumes, kro_volumes] = define_kr_corey(x, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mob_w_volumes = krw_volumes./obj.mi_w;
mob_o_volumes = kro_volumes./obj.mi_o;
mob_t_volumes = mob_w_volumes + mob_o_volumes;
fw_volumes = mob_w_volumes./mob_t_volumes;

qt_volumes = zeros(n_volumes, 1);
new_saturation = zeros(n_volumes, 1);

for face = obj.internal_faces'
    volumes_adj = obj.adjacencies(face, :);
    new_saturation(volumes_adj(1)) = new_saturation(volumes_adj(1)) + qw(face);
    new_saturation(volumes_adj(2)) = new_saturation(volumes_adj(2)) - qw(face);
    qt_volumes(volumes_adj(1)) = qt_volumes(volumes_adj(1)) + qt(face);
    qt_volumes(volumes_adj(2)) = qt_volumes(volumes_adj(2)) - qt(face);
end

% residuo(:) = residuo + obj.vol_volumes.*obj.porosity.*(x - sat0)./obj.dt;

for vol = obj.volumes
    new_saturation(vol) = new_saturation(vol) - fw_volumes(vol).*qt_volumes(vol);
end

new_saturation(:) = -1*new_saturation;
new_saturation(:) = new_saturation.*obj.dt./obj.vol_volumes./obj.porosity;
new_saturation(:) = new_saturation + sat0;

for i = presc_sat.volumes_saturation_defined
    local_id = presc_sat.volumes_saturation_defined == i;
    new_saturation(i) = presc_sat.saturation_defined_values(local_id);
end

ds = new_saturation - sat0;
ds_max = max(abs(ds));
if ds_max > obj.ds_max
    recal(:) = 1;
end

if test_sat_limits(new_saturation);
    recal(:) = 1;
end

end