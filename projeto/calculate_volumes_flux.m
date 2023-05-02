function [qt, qw, qo] = calculate_volumes_flux()
global obj;

sat_ant = obj.x0_sat;
p2 = obj.x0_press(obj.adjacencies(:, 2));
p1 = obj.x0_press(obj.adjacencies(:, 1));
hhdist = sum(obj.h_dist')';
grad_p = (p2 - p1)./hhdist;
[krw, kro] = define_kr_corey_vec(sat_ant(obj.adjacencies(obj.upwind)), obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw = krw./obj.mi_w;
mobo = kro./obj.mi_o;
mobt = mobw + mobo;
vt = -grad_p.*mobt.*obj.k_harm;
vw = (mobw./mobt).*vt;
vo = (mobo./mobt).*vt;

n_volumes = length(obj.volumes);
qt_volumes = zeros(n_volumes, 1);
qw_volumes_resp = zeros(n_volumes, 1);
qo_volumes = zeros(n_volumes, 1);
n_internal_faces = length(obj.internal_faces);
qt_internal_faces = vt.*obj.internal_areas;
qw_internal_faces = (mobw./mobt).*qt_internal_faces;
qo_internal_faces = (mobo./mobt).*qt_internal_faces;

for face = 1:n_internal_faces
   volumes_adj = obj.adjacencies(face,:);
   qt_face = qt_internal_faces(face,:);
   qw_face = qw_internal_faces(face,:);
   qo_face = qo_internal_faces(face,:);
   qt_volumes(volumes_adj(1)) = qt_volumes(volumes_adj(1)) + qt_face;
   qt_volumes(volumes_adj(2)) = qt_volumes(volumes_adj(2)) - qt_face;
   qw_volumes_resp(volumes_adj(1)) = qw_volumes_resp(volumes_adj(1)) + qw_face;
   qw_volumes_resp(volumes_adj(2)) = qw_volumes_resp(volumes_adj(2)) - qw_face;
   qo_volumes(volumes_adj(1)) = qo_volumes(volumes_adj(1)) + qo_face;
   qo_volumes(volumes_adj(2)) = qo_volumes(volumes_adj(2)) - qo_face;
   
end

qt = qt_volumes;
qw = qw_volumes_resp;
qo = qo_volumes;


end