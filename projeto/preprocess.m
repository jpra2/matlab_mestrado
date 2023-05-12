function preprocess()
global obj;
load_simulation_info_from_json();

%% definir a matriz de adjacencias
obj.adj_matrix = mount_adj_matrix(length(obj.internal_faces), length(obj.volumes), obj.adjacencies);

%% define a media harmonica da permeabilidade nas faces
obj.k_harm = define_k_harm(obj.volumes_perm, obj.internal_faces, obj.adjacencies, obj.unitary_vector_internal, obj.h_dist);

end