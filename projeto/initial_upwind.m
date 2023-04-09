function [upwind] = initial_upwind(adjacencies)

sz_adj = size(adjacencies);

upwind = false(sz_adj);

upwind(:, 1) = 1;

end