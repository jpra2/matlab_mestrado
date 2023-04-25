function residuo = define_residuo_sat_2(x ,residuo, presc_sat)
% define o residuo da saturacao

global obj;

n_volumes = length(obj.volumes);
adj_matrix_T = obj.adj_matrix';
upwind_internal_faces = obj.adjacencies(obj.upwind);
sat0 = obj.x0_sat;
pressure = obj.x0_press;
all_dists = sum(obj.h_dist')';
S_faces = x(obj.adjacencies(obj.upwind));
[krw, kro] = define_kr_corey(S_faces, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mob_w = krw./obj.mi_w;
mob_o = kro./obj.mi_o;
mob_t = mob_w + mob_o;
p2 = pressure(obj.adjacencies(:, 2));
p1 = pressure(obj.adjacencies(:, 1));
grad_p = (p2 - p1)./all_dists;
qt = -grad_p.*mob_t.*obj.internal_areas.*obj.k_harm;
qw = qt.*(mob_w./mob_t);

[krw_volumes, kro_volumes] = define_kr_corey(x, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mob_w_volumes = krw_volumes./obj.mi_w;
mob_o_volumes = kro_volumes./obj.mi_o;
mob_t_volumes = mob_w_volumes + mob_o_volumes;
fw_volumes = mob_w_volumes./mob_t_volumes;

qt_volumes = myAD(zeros(n_volumes, 1));

for face = obj.internal_faces'
    volumes_adj = obj.adjacencies(face, :);
    residuo(volumes_adj(1)) = residuo(volumes_adj(1)) + qw(face);
    residuo(volumes_adj(2)) = residuo(volumes_adj(2)) - qw(face);
    qt_volumes(volumes_adj(1)) = qt_volumes(volumes_adj(1)) + qt(face);
    qt_volumes(volumes_adj(2)) = qt_volumes(volumes_adj(2)) - qt(face);
end

residuo(:) = residuo -fw_volumes.*qt_volumes + obj.vol_volumes.*obj.porosity.*(x - sat0)./obj.dt;

for i = presc_sat.volumes_saturation_defined
    if length(i) > 1
        error('Transpor o iterador');
    end
    local_id = presc_sat.volumes_saturation_defined == i;
    residuo(i) = x(i) - presc_sat.saturation_defined_values(local_id);
end


end