function [internal_faces, adjacencies, adj_matrix, h_dist] = define_internal_faces(n)
    
    adjacencies = zeros(n-1, 2);
    internal_faces = zeros(n-1, 1);
    adj_matrix = false(n-1, n);
    h_dist = zeros(n-1, 2);

    for i = 1:n-1
        adjacencies(i, 1) = i;
        adjacencies(i, 2) = i+1;
        internal_faces(i) = i;
        adj_matrix(i, [i, i+1]) = 1;
        h_dist(i,:) = [0.5, 0.5];
    end
    
    

end