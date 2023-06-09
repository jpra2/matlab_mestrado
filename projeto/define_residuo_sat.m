function residuo = define_residuo_sat(x ,residuo, presc_sat)
% define o residuo da saturacao
global obj;

n_volumes = length(obj.volumes);
adj_matrix_T = obj.adj_matrix';
upwind_internal_faces = obj.adjacencies(obj.upwind);
sat0 = obj.x0_sat;
pressure = obj.x0_press;

for i = 1:n_volumes
    
    if any(presc_sat.volumes_saturation_defined == i)
        local_id = presc_sat.volumes_saturation_defined == i;
        residuo(i) = x(i) - presc_sat.saturation_defined_values(local_id);
        continue
    end
    
    faces_volume = obj.internal_faces(adj_matrix_T(i, :));    
    for face = faces_volume'
        S = x(upwind_internal_faces(face));
        vol2 = obj.adjacencies(face, :);
        vol2 = vol2(vol2 ~= i);
        
        [krw, kro] = define_kr_corey(S, obj.Swr, obj.Swor, obj.nw, obj.no, obj.k0w, obj.k0o);
        mob_w = krw./obj.mi_w;
        mob_o = kro./obj.mi_o;
        mob_t = mob_w + mob_o;
        c1 = obj.volumes_centroids(obj.adjacencies(face, 1));
        c2 = obj.volumes_centroids(obj.adjacencies(face, 2));
        dist = norm(c2 - c1);
        k_harm = obj.k_harm(face);
        grad_p = (pressure(vol2) - pressure(i))./dist;
        
        qt = -grad_p*mob_t*obj.internal_areas(face)*k_harm;
        qw = qt*(mob_w./mob_t);
        
        residuo(i) = residuo(i) + qw;
           
    end
    
    residuo(i) = residuo(i) + obj.vol_volumes(i)*obj.porosity(i)*(x(i) - sat0(i))./obj.dt;
end


end