function [dt, upwind] = update_params_sim(vT)
% atualiza a direcao upwind e o passo de tempo conforme o cfl fornecido
% vT = velocidade total

global obj;

%% define direcao upwind
upwind = false(size(obj.upwind));
[krw, kro] = define_kr_corey_vec(obj.x0_sat(obj.adjacencies(obj.upwind)), obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw = krw./obj.mi_w;
mobo = kro./obj.mi_o;
mobt = mobw + mobo;
vt = vT;
vw = (mobw./mobt).*vt;
vo = (mobo./mobt).*vt;
test = vw >= 0;
upwind(test,1) = 1;
upwind(~test, 2) = 1;

%% define o dt
phi1 = obj.porosity(obj.adjacencies(:,1));
phi1 = phi1./phi1;
phi2 = obj.porosity(obj.adjacencies(:,2));
phi2 = phi2./phi2;
vol1 = obj.vol_volumes(obj.adjacencies(:,1));
vol2 = obj.vol_volumes(obj.adjacencies(:,1));

[krw_volumes, kro_volumes] = define_kr_corey_vec(obj.x0_sat, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw_volumes = krw_volumes./obj.mi_w;
mobo_volumes = kro_volumes./obj.mi_o;
mobt_volumes = mobw_volumes + mobo_volumes;
fw_volumes = mobw_volumes./mobt_volumes;

dfw = abs(fw_volumes(obj.adjacencies(:, 2)) - fw_volumes(obj.adjacencies(:, 1)));
ds = abs(obj.x0_sat(obj.adjacencies(:, 2)) - obj.x0_sat(obj.adjacencies(:, 1)));
dfwds = dfw./ds;

vw_abs = abs(vw);
vt_abs = abs(vt);
hhdist = sum(obj.h_dist')';
dt1 = obj.cfl.*(phi1.*hhdist)./(vt_abs.*dfwds);
dt2 = obj.cfl.*(phi2.*hhdist)./(vt_abs.*dfwds);
mindt1 = min(dt1);
mindt2 = min(dt2);
dt = min([mindt1, mindt2]);
% all_dt = phi1.*hhdist./vt_abs;
% dt = min(all_dt);


end