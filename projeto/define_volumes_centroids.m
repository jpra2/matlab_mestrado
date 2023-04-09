function [volumes_centroids] = define_volumes_centroids(n, deltax)

volumes_centroids = zeros(n, 3);
delta_ini = deltax/2;

for i = 1:n
    volumes_centroids(i, 1) = delta_ini + (i-1)*deltax;
end

end