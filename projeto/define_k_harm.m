function [k_harm] = define_k_harm(volumes_perm, internal_faces, adjacencies, unitary_vector_internal)

ni = length(internal_faces);
k_harm = zeros(ni, 1);

for i = 1:ni
    perm1 = reshape(volumes_perm(adjacencies(i, 1), :, :), 3, 3);
    perm2 = reshape(volumes_perm(adjacencies(i, 2), :, :), 3, 3);
    
    vec_unit = unitary_vector_internal(i, :);
    
    k1 = vec_unit * perm1 * vec_unit';
    k2 = vec_unit * perm2 * vec_unit';
    
    k_harm(i) = (2*k1*k2)/(k1 + k2);  

end