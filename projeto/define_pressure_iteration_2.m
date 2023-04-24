function [pressure, loop_p] = define_pressure_iteration_2()
global obj;
global presc;

n_volumes = length(obj.volumes);
saturation = obj.x0_sat;
upwind_internal_faces = obj.adjacencies(obj.upwind);
transmissibility = zeros(n_volumes);
loop_p = 0;
source = zeros(n_volumes, 1);

for face = 1:length(obj.internal_faces)
    S = saturation(upwind_internal_faces(face));
    [krw, kro] = define_kr_corey(S, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
    mob_w = krw./obj.mi_w;
    mob_o = kro./obj.mi_o;
    mob_t = mob_w + mob_o;
    dist = obj.h_dist(face);
    k_harm = obj.k_harm(face);
    area = obj.internal_areas(face);
    value = mob_t*obj.internal_areas(face)*k_harm/dist;
    faces_adj = obj.adjacencies(face,:);
    transmissibility(faces_adj(1), faces_adj(2)) = -value;
    transmissibility(faces_adj(2), faces_adj(1)) = -value;

end

soma = -sum(transmissibility')';
transmissibility = transmissibility + diag(soma);
n_presc = length(presc.volumes_pressure_defined);

for i = 1:n_presc
    volume = presc.volumes_pressure_defined(i);
    transmissibility(volume,:) = 0;
    transmissibility(volume, volume) = 1;
    source(volume) = presc.pressure_defined_values(i)*100;
end

pressure = transmissibility\source;

end