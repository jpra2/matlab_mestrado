function [dt, upwind, wor_ratio, vpi, qo_flux] = calculate_cfl()
global obj;

%% define direcao upwind
upwind = false(size(obj.upwind));
p2 = obj.x0_press(obj.adjacencies(:, 2));
p1 = obj.x0_press(obj.adjacencies(:, 1));
hhdist = sum(obj.h_dist')';
grad_p = (p2 - p1)./hhdist;
[krw, kro] = define_kr_corey_vec(obj.x0_sat(obj.adjacencies(obj.upwind)), obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw = krw./obj.mi_w;
mobo = kro./obj.mi_o;
mobt = mobw + mobo;
vt = -grad_p.*mobt.*obj.k_harm;
vw = (mobw./mobt).*vt;
vo = (mobo./mobt).*vt;
test = vw >= 0;
upwind(test,1) = 1;
upwind(~test, 2) = 1;

%% define o dt
phi1 = obj.porosity(obj.adjacencies(:,1));
phi2 = obj.porosity(obj.adjacencies(:,2));

[krw_volumes, kro_volumes] = define_kr_corey_vec(obj.x0_sat, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw_volumes = krw_volumes./obj.mi_w;
mobo_volumes = kro_volumes./obj.mi_o;
mobt_volumes = mobw_volumes + mobo_volumes;
fw_volumes = mobw_volumes./mobt_volumes;

dfw = abs(fw_volumes(obj.adjacencies(:, 2)) - fw_volumes(obj.adjacencies(:, 1)));
ds = abs(obj.x0_sat(obj.adjacencies(:, 2)) - obj.x0_sat(obj.adjacencies(:, 1)));
dfwds = dfw./ds;
dt1 = obj.cfl.*(phi1.*hhdist)./(abs(vt).*dfwds);
dt2 = obj.cfl.*(phi2.*hhdist)./(abs(vt).*dfwds);
mindt1 = min(dt1);
mindt2 = min(dt2);
dt = min([mindt1, mindt2]);

%% define a razao agua oleo de producao
n_volumes = length(obj.volumes);
qt_volumes = zeros(n_volumes, 1);
n_internal_faces = length(obj.internal_faces);
qt_internal_faces = vt.*obj.internal_areas;

for face = 1:n_internal_faces
   volumes_adj = obj.adjacencies(face,:);
   qt_face = qt_internal_faces(face,:);
   qt_volumes(volumes_adj(1)) = qt_volumes(volumes_adj(1)) + qt_face;
   qt_volumes(volumes_adj(2)) = qt_volumes(volumes_adj(2)) - qt_face;
end

% [krw_volumes, kro_volumes] = define_kr_corey_vec(obj.x0_sat, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
% mobw_volumes = krw_volumes./obj.mi_w;
% mobo_volumes = kro_volumes./obj.mi_o;
% mobt_volumes = mobw_volumes + mobo_volumes;
% fw_volumes = mobw_volumes./mobt_volumes;
fo_volumes = mobo_volumes./mobt_volumes;
qw_volumes = qt_volumes.*fw_volumes;
qo_volumes = qt_volumes.*fo_volumes;

qw_producers = qw_volumes(obj.producers);
qo_producers = qo_volumes(obj.producers);
qw_sum_producers = sum(qw_producers);
qo_sum_producers = sum(qo_producers);
wor_ratio = qw_sum_producers/qo_sum_producers;
qo_flux = qo_sum_producers;

%% define o vpi
total_porous_volume = sum(obj.vol_volumes.*obj.porosity);
total_flux_injected = sum(qt_volumes(obj.injectors));
vpi = total_flux_injected*dt/total_porous_volume;





end