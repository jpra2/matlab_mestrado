function [volumes_perm] = define_volumes_perm(n)

volumes_perm = zeros(n, 3, 3);

for i = 1:n
    for j = 1:3
        volumes_perm(i, j, j) = 1;
    end
end

end