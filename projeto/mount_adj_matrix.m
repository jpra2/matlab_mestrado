function adj_matrix = mount_adj_matrix(n_internal_faces, n_volumes, adjacencies)
% monta a matriz de ajacencias entre faces internas e volumes 

adj_matrix = false(n_internal_faces, n_volumes);

for i = 1:n_internal_faces
    adj_matrix(i, adjacencies(i,:)) = 1;
end

end