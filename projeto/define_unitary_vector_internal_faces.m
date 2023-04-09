function [unitary_vector_internal] = define_unitary_vector_internal_faces(internal_faces)

n = length(internal_faces);

unitary_vector_internal = zeros(n, 3);
unitary_vector_internal(:, 1) = 1;

end