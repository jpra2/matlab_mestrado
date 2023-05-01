function [k_harm] = define_k_harm(volumes_perm, internal_faces, adjacencies, unitary_vector_internal, h_dist)
% define o k harmonico nas faces internas
%  volumes_perm: permeabilidade dos volumes
%  internal_faces: faces internas
%  unitary_vector_internal: vetor unitario das faces internas
%  h_dist: distancia entre os volumes adjacentes das faces internas

ni = length(internal_faces);
k_harm = zeros(ni, 1);

for i = 1:ni
    perm1 = reshape(volumes_perm(adjacencies(i, 1), :, :), 3, 3);
    perm2 = reshape(volumes_perm(adjacencies(i, 2), :, :), 3, 3);
    
    vec_unit = unitary_vector_internal(i, :);
    
    k1 = vec_unit * perm1 * vec_unit';
    k2 = vec_unit * perm2 * vec_unit';
    h1 = h_dist(i, 1);
    h2 = h_dist(i, 2);
    k_harm(i) = (h1 + h2)/(h1/k1 + h2/k2);  

end