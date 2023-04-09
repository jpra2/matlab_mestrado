function residuo = define_residuo_sat(x ,residuo, obj, presc_sat, sat0, pressure)

n_volumes = length(obj.volumes);
adj_matrix_T = obj.adj_matrix';
upwind_internal_faces = obj.adjacencies(obj.upwind);

for i = 1:n_volumes
    
    if any(presc_sat.volumes_saturation_defined == i)
        local_id = presc_sat.volumes_saturation_defined == i;
        residuo(i) = x(i) - presc_sat.saturation_defined_values(local_id);
        continue
    end
    
    faces_volume = obj.internal_faces(adj_matrix_T(i, :));    
    for face = faces_volume'
        swnorm = (x(upwind_internal_faces(face)) - obj.Swr)./(obj.Swor - obj.Swr);
        vol2 = obj.adjacencies(face, :);
        vol2 = vol2(vol2 ~= i);
        
        krw = obj.k0w*(swnorm^obj.nw);
        kro = obj.k0o*((1 - swnorm)^obj.no);
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
    
    residuo(i) = residuo(i) + obj.porosity(i)*(x(i) - sat0(i))./obj.dt;
end


end