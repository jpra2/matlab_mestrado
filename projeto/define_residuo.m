function residuo = define_residuo(x, residuo, presc)
% define o residuo da pressao

global obj;

n_volumes = length(obj.volumes);
adj_matrix_T = obj.adj_matrix';
% residuo = myAD(zeros(n_volumes, 1));
% residuo = zeros(n_volumes, 1);
saturation = obj.x0_sat;

upwind_internal_faces = obj.adjacencies(obj.upwind);

for i = 1:n_volumes
    
    if any(presc.volumes_pressure_defined == i)
        local_id = presc.volumes_pressure_defined == i;
        residuo(i) = x(i) - presc.pressure_defined_values(local_id);
        continue
    end
    
    faces_volume = obj.internal_faces(adj_matrix_T(i, :));    
    for face = faces_volume'
        S = saturation(upwind_internal_faces(face));
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
        grad_p = (x(vol2) - x(i))./dist;
        
        qt = -grad_p*mob_t*obj.internal_areas(face)*k_harm;
%         qw = qt*(mob_w./mob_t);
        
        residuo(i) = residuo(i) + qt;
%         residuo(n_volumes + i) = residuo(n_volumes + i) + qw;
           
    end
    
%     residuo(n_volumes+i) = residuo(n_volumes+i) + (x(n_volumes+i) - obj.initial_saturation(i))./obj.dt;
    
    
    
end





end