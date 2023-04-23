function [dt, upwind] = calculate_cfl()
global obj;

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
vw = (mobt./mobw).*vt;
test = vw >= 0;
upwind(test,1) = 1;
upwind(~test, 2) = 1;
phi1 = obj.porosity(obj.adjacencies(:,1));
phi2 = obj.porosity(obj.adjacencies(:,2));

[krw, kro] = define_kr_corey_vec(obj.x0_sat, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
mobw = krw./obj.mi_w;
mobo = kro./obj.mi_o;
mobt = mobw + mobo;
fw = mobw./mobt;

dfw = abs(fw(obj.adjacencies(:, 2)) - fw(obj.adjacencies(:, 1)));
ds = abs(obj.x0_sat(obj.adjacencies(:, 2)) - obj.x0_sat(obj.adjacencies(:, 1)));
dfwds = dfw./ds;

dt1 = obj.cfl.*(phi1.*hhdist)./(abs(vt).*dfwds);
dt2 = obj.cfl.*(phi2.*hhdist)./(abs(vt).*dfwds);
mindt1 = min(dt1);
mindt2 = min(dt2);
dt = min([mindt1, mindt2]);

end